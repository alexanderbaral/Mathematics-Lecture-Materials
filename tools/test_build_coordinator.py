"""Isolated regression tests; never modifies teaching sources or real PDFs."""
import argparse
import importlib.util
import json
import gzip
from pathlib import Path
import tempfile
import threading
from concurrent.futures import ThreadPoolExecutor
import time
import unittest
from unittest.mock import patch

import build_coordinator as build


class CoordinatorTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='script-build-test-', dir=build.CACHE)
        self.root = Path(self.temporary.name)
        self.patches = [patch.object(build, 'UPDATE_CACHE', self.root / 'cache'),
                        patch.object(build, 'ROOT', self.root / 'project')]
        for item in self.patches:
            item.start()
        build.ROOT.mkdir()

    def tearDown(self):
        for item in reversed(self.patches):
            item.stop()
        self.temporary.cleanup()

    def snapshot(self, **overrides):
        contents = {
            'main.tex': r'\input{content/chapters_de/test/_chapter.tex}',
            'content/chapters_de/test/_chapter.tex': r'\chapter{Test}\input{content/chapters_de/test/a/_section.tex}\input{content/chapters_de/test/b/_section.tex}',
            'content/chapters_de/test/a/_section.tex': r'\section{A}\CachedTikzFigure{content/resources/test/tikz/figure.tex}',
            'content/chapters_de/test/b/_section.tex': r'\section{B} Original',
            'content/resources/test/tikz/figure.tex': 'original figure',
            'latexmkrc': '',
        }
        contents.update(overrides)
        for relative, text in contents.items():
            target = build.ROOT / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text, encoding='utf-8')
        return build.capture(build.ROOT)

    def test_multi_section_changes_and_figure_mapping(self):
        baseline = self.snapshot()
        first = self.snapshot(**{'content/resources/test/tikz/figure.tex': 'changed figure'})
        self.assertEqual([s['section'] for s in build.affected(first, baseline)[0]], [1])
        latest = self.snapshot(**{'content/resources/test/tikz/figure.tex': 'changed figure',
                                  'content/chapters_de/test/b/_section.tex': r'\section{B} changed'})
        self.assertEqual([s['section'] for s in build.affected(latest, baseline)[0]], [1, 2])
        self.assertEqual([s['section'] for s in build.affected(latest, first)[0]], [2])
        self.assertEqual(build.affected(latest, latest)[0], [])

    def test_snapshot_keeps_original_bytes(self):
        frozen = self.snapshot()
        self.snapshot(**{'content/resources/test/tikz/figure.tex': 'newer'})
        destination = self.root / 'frozen'
        build.materialize(frozen, destination)
        self.assertEqual((destination / 'content/resources/test/tikz/figure.tex').read_text(), 'original figure')
        before = (destination / 'main.tex').stat().st_mtime_ns
        build.materialize(frozen, destination)
        self.assertEqual((destination / 'main.tex').stat().st_mtime_ns, before)

    def test_global_change_selects_all(self):
        baseline = self.snapshot()
        latest = self.snapshot(**{'common/config.tex': 'shared change'})
        selected, broad = build.affected(latest, baseline)
        self.assertTrue(broad)
        self.assertEqual(len(selected), 2)

    def test_worker_coalesces_and_does_not_overlap(self):
        frozen = self.snapshot()
        started, release = threading.Event(), threading.Event()
        calls, active = [], []

        def fake_full(snapshot, request):
            active.append(request['id'])
            self.assertEqual(len(active), 1)
            calls.append(request['id'])
            if request['id'] == 'A':
                started.set()
                self.assertTrue(release.wait(5))
            active.pop()
            return {'ok': True, 'seconds': .01, 'published': 'test'}

        def put(identifier):
            with build.state_transaction() as state:
                state['desired'] = {'id': identifier, 'revision': frozen['revision']}

        put('A')
        with patch.object(build, 'run_full', fake_full):
            worker = threading.Thread(target=build.worker)
            worker.start()
            self.assertTrue(started.wait(5))
            put('B')
            put('C')
            # A second process/thread cannot launch a competing full engine.
            with ThreadPoolExecutor(max_workers=1) as pool:
                pool.submit(build.worker).result(timeout=2)
            release.set()
            worker.join(5)
            self.assertFalse(worker.is_alive())
        self.assertEqual(calls, ['A', 'C'])
        with build.state_transaction() as state:
            self.assertEqual(state['completed']['id'], 'C')
            self.assertIsNone(state['running'])

    def test_failure_is_not_retried_and_preserves_baseline(self):
        frozen = self.snapshot()
        with build.state_transaction() as state:
            state.update(completed={'id': 'good'}, desired={'id': 'bad', 'revision': frozen['revision']})
        with patch.object(build, 'run_full', return_value={'ok': False, 'seconds': .01}) as runner:
            build.worker()
            build.worker()
            self.assertEqual(runner.call_count, 1)
        with build.state_transaction() as state:
            self.assertEqual(state['completed']['id'], 'good')
            self.assertEqual(state['failed']['id'], 'bad')

    def test_atomic_replacement(self):
        target = self.root / 'output.pdf'
        build.atomic(target, b'old')
        build.atomic(target, b'new')
        self.assertEqual(target.read_bytes(), b'new')
        self.assertEqual(list(self.root.glob('*.tmp')), [])

    def test_pair_publication_rolls_back_on_error(self):
        outputs = build.ROOT / 'build'
        outputs.mkdir()
        source = self.root / 'staging'
        source.mkdir()
        for variant in build.VARIANTS:
            (outputs / (variant + '.pdf')).write_bytes(b'old PDF')
            (outputs / (variant + '.synctex.gz')).write_bytes(b'old map')
            (source / (variant + '.pdf')).write_bytes(b'%PDF-1.5\nnew\n%%EOF')
            (source / (variant + '.synctex.gz')).write_bytes(gzip.compress(b'new map'))
        original_atomic = build.atomic
        def fail_once(path, data):
            if path.name == 'build-de-cloze.pdf' and data.startswith(b'%PDF'):
                raise PermissionError('simulated locked viewer')
            original_atomic(path, data)
        with patch.object(build, 'atomic', fail_once):
            with self.assertRaises(PermissionError):
                build.publish_pair(source, source)
        for variant in build.VARIANTS:
            self.assertEqual((outputs / (variant + '.pdf')).read_bytes(), b'old PDF')
            self.assertEqual((outputs / (variant + '.synctex.gz')).read_bytes(), b'old map')


if __name__ == '__main__':
    unittest.main(verbosity=2)
