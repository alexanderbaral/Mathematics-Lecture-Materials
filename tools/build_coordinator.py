"""Preview first, then a single snapshot-based, coalescing full-build worker.

Only the standard library is required. State, sources and auxiliary files live
in the established local cache; build/ contains viewer-facing PDFs and SyncTeX.
The LaTeX engine remains build-engine.ps1, with main.tex as the sole body.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
from contextlib import contextmanager, ExitStack
from datetime import datetime
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]
CACHE = Path(os.environ.get('USERPROFILE', str(Path.home()))) / 'AppData/Local/Temp/Mathematik1-Skript'
UPDATE_CACHE = CACHE / 'updates'
VARIANTS = ('build-de', 'build-de-cloze')
INPUT = re.compile(r'\\(?:input|include|CachedTikzFigure)\{([^{}]+)\}')


def now():
    return datetime.now().astimezone().isoformat(timespec='seconds')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read_json(path, default=None):
    return json.loads(path.read_text(encoding='utf-8')) if path.exists() else default


def atomic(path, data):
    """Same-volume replacement: viewers never see a partially written PDF."""
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + '.' + uuid.uuid4().hex + '.tmp')
    temporary.write_bytes(data)
    try:
        for attempt in range(20):
            try:
                os.replace(temporary, path)
                return
            except PermissionError:
                if attempt == 19:
                    raise
                time.sleep(.1)
    finally:
        temporary.unlink(missing_ok=True)


def save_json(path, value):
    atomic(path, (json.dumps(value, ensure_ascii=False, indent=2) + '\n').encode('utf-8'))


@contextmanager
def lock(path, blocking=True):
    """Process-lifetime OS lock; automatically released after a crash."""
    path.parent.mkdir(parents=True, exist_ok=True)
    stream = path.open('a+b')
    acquired = False
    try:
        while True:
            try:
                stream.seek(0)
                if os.name == 'nt':
                    import msvcrt
                    msvcrt.locking(stream.fileno(), msvcrt.LK_NBLCK, 1)
                else:
                    import fcntl
                    fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
                acquired = True
                break
            except OSError:
                if not blocking:
                    break
                time.sleep(.1)
        yield acquired
    finally:
        if acquired:
            stream.seek(0)
            if os.name == 'nt':
                import msvcrt
                msvcrt.locking(stream.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                import fcntl
                fcntl.flock(stream, fcntl.LOCK_UN)
        stream.close()


@contextmanager
def state_transaction():
    with lock(UPDATE_CACHE / 'state.lock'):
        state = read_json(UPDATE_CACHE / 'state.json', {})
        yield state
        save_json(UPDATE_CACHE / 'state.json', state)


def source_paths(root):
    paths = [p for folder in ('common', 'content') for p in (root / folder).rglob('*') if p.is_file()]
    paths += [root / name for name in ('main.tex', 'latexmkrc')]
    paths += [p for p in (root / 'tools').glob('build*') if p.is_file() and p.suffix in ('.tex', '.ps1', '.py')]
    return sorted(paths)


def capture(root=ROOT):
    """Read, store, then recheck the entire input set before accepting a snapshot."""
    for attempt in range(4):
        files = {}
        for path in source_paths(root):
            data = path.read_bytes()
            sha = digest(data)
            files[path.relative_to(root).as_posix()] = sha
            blob = UPDATE_CACHE / 'objects' / sha
            if not blob.exists():
                atomic(blob, data)
        verified = {p.relative_to(root).as_posix(): digest(p.read_bytes()) for p in source_paths(root)}
        if files == verified:
            revision = digest(json.dumps(files, sort_keys=True).encode())
            manifest = {'revision': revision, 'created': now(), 'files': files}
            location = UPDATE_CACHE / 'manifests' / (revision + '.json')
            if location.exists():
                return read_json(location)
            save_json(location, manifest)
            return manifest
        time.sleep(.2)
    raise RuntimeError('Quellen ändern sich während der Aufnahme. Bitte nach dem Speichern erneut aufrufen.')


def manifest(revision):
    return read_json(UPDATE_CACHE / 'manifests' / (revision + '.json'))


def content(snapshot, path):
    sha = snapshot['files'].get(path)
    return (UPDATE_CACHE / 'objects' / sha).read_text(encoding='utf-8-sig') if sha else ''


def materialize(snapshot, destination):
    """Stable paths and unchanged mtimes preserve the existing latexmk cache."""
    destination.mkdir(parents=True, exist_ok=True)
    previous = read_json(destination / '.snapshot.json', {'files': {}})
    for relative in previous['files'].keys() - snapshot['files'].keys():
        target = (destination / relative).resolve()
        if not target.is_relative_to(destination.resolve()):
            raise ValueError(relative)
        target.unlink(missing_ok=True)  # Only generated snapshot files, never user sources.
    for relative, sha in snapshot['files'].items():
        target = destination / relative
        if not target.exists() or digest(target.read_bytes()) != sha:
            atomic(target, (UPDATE_CACHE / 'objects' / sha).read_bytes())
    save_json(destination / '.snapshot.json', snapshot)


def sections(snapshot):
    """Resolve the actual input order, not alphabetical names or Git status."""
    result, seen = [], set()
    texts = {}

    def get_text(path):
        if path not in texts:
            texts[path] = content(snapshot, path)
        return texts[path]

    def visit(path, chapter=0):
        if path in seen:
            return
        seen.add(path)
        text = re.sub(r'(?<!\\)%[^\n]*', '', get_text(path))
        if path.endswith('/_chapter.tex'):
            chapter = len({item['chapter'] for item in result}) + 1
        if re.search(r'\\section\s*\{', text):
            dependencies = set()

            def gather(p):
                if p in dependencies:
                    return
                dependencies.add(p)
                current = get_text(p)
                for match in INPUT.finditer(current):
                    child = match[1].replace('\\ScriptLanguage', 'de')
                    if not Path(child).suffix:
                        child += '.tex'
                    if child in snapshot['files']:
                        gather(child)
                # Raster/PDF assets and caller-provided resources are covered as well.
                for candidate in snapshot['files']:
                    if candidate.startswith('content/resources/') and candidate in current:
                        gather(candidate) if candidate.endswith('.tex') else dependencies.add(candidate)

            gather(path)
            result.append({'path': path, 'chapter': chapter,
                           'section': sum(x['chapter'] == chapter for x in result) + 1,
                           'dependencies': sorted(dependencies)})
            return
        for match in INPUT.finditer(text):
            child = match[1].replace('\\ScriptLanguage', 'de')
            if child in snapshot['files'] and not child.startswith('content/resources/'):
                visit(child, chapter)

    visit('main.tex')
    return result


def affected(snapshot, baseline):
    order = sections(snapshot)
    if not baseline:
        return order, True
    changed = {p for p in snapshot['files'].keys() | baseline['files'].keys()
               if snapshot['files'].get(p) != baseline['files'].get(p)}
    # Technical orchestration changes do not alter mathematical section contents.
    changed = {p for p in changed if not (p.startswith('tools/') and not p.endswith('.tex'))}
    global_change = any(p.startswith(('common/', 'content/front_matter/')) or p in ('main.tex', 'latexmkrc')
                        or p.endswith('/_chapter.tex') for p in changed)
    owned = set().union(*(set(s['dependencies']) for s in order)) if order else set()
    # Unknown shared input: do not silently omit an affected part of the document.
    unowned = {p for p in changed if p.startswith('content/resources/') and p not in owned}
    global_change |= bool(unowned)
    return ([s for s in order if global_change or changed.intersection(s['dependencies'])], global_change)


def context_text(snapshot, preview=False):
    label = ('Vorschau' if preview else 'Stand') + ' ' + snapshot['revision'][:8]
    if preview:
        label += ' -- Nummerierung/Verweise vorläufig'
    if preview:
        text = '\\AtBeginDocument{\\ihead*{}\\chead*{\\scriptsize\\color{black!55}' + label + '}\\global\\BrandPageDotVisibletrue}\n'
    else:
        text = '\\AtBeginDocument{\\cfoot*{\\scriptsize\\color{black!55}' + label + '}}\n'
    text += '\\hypersetup{pdfsubject={Quellstand ' + snapshot['revision'] + ', ' + snapshot['created'] + '}}\n'
    if not preview:
        text += r'''
\makeatletter
\newwrite\BuildSectionStream
\immediate\openout\BuildSectionStream=\jobname.sections
\newcommand{\BuildRecordSection}[1]{%
  \begingroup
  \def\@elt##1{\string\setcounter{##1}{\number\value{##1}}}%
  \immediate\write\BuildSectionStream{\string\BuildCheckpoint{#1}{\cl@@ckpt}}%
  \endgroup
}
\makeatother
'''
        for section in sections(snapshot):
            path = section['path']
            text += '\\expandafter\\def\\csname BuildTrack@' + path + '\\endcsname{\\BuildRecordSection{' + path + '}}\n'
        text += r'''
\AddToHook{file/before}{%
  \ifcsname BuildTrack@\CurrentFilePath/\CurrentFile\endcsname
    \csname BuildTrack@\CurrentFilePath/\CurrentFile\endcsname
  \fi}
'''
    return text


def executable(name):
    found = shutil.which(name)
    if not found and name == 'pwsh':
        found = shutil.which('powershell')
    if not found:
        raise RuntimeError('Programm fehlt: ' + name)
    return found


def subprocess_flags(background=False):
    if os.name != 'nt':
        return {}
    return {'creationflags': subprocess.CREATE_NO_WINDOW | (subprocess.BELOW_NORMAL_PRIORITY_CLASS if background else 0)}


def rebase_synctex(data, source):
    text = gzip.decompress(data).decode('utf-8')
    text = text.replace(source.as_posix(), ROOT.as_posix()).replace(str(source), str(ROOT))
    return gzip.compress(text.encode('utf-8'), mtime=0)


def publish_pair(source_directory, source_root, preview_mode=False):
    """Validate the entire pair first and restore old outputs on publication errors."""
    prepared = {}
    for variant in VARIANTS:
        name = variant + ('-preview' if preview_mode else '')
        source = source_directory / name
        pdf = source.with_suffix('.pdf').read_bytes()
        if not pdf.startswith(b'%PDF-') or b'%%EOF' not in pdf[-1024:]:
            raise RuntimeError('Unvollständige PDF: ' + str(source))
        prepared[ROOT / 'build' / (name + '.synctex.gz')] = rebase_synctex(source.with_suffix('.synctex.gz').read_bytes(), source_root)
        prepared[ROOT / 'build' / (name + '.pdf')] = pdf
    old = {path: path.read_bytes() if path.exists() else None for path in prepared}
    written = []
    try:
        for path, data in prepared.items():
            atomic(path, data)
            written.append(path)
    except Exception:
        for path in reversed(written):
            if old[path] is None:
                path.unlink(missing_ok=True)
            else:
                atomic(path, old[path])
        raise


def run_full(snapshot, request):
    started = time.monotonic()
    source = UPDATE_CACHE / 'full-source'
    materialize(snapshot, source)
    atomic(source / 'build-context.tex', context_text(snapshot).encode('utf-8'))
    logfile = UPDATE_CACHE / 'logs' / (request['id'] + '-full.log')
    logfile.parent.mkdir(parents=True, exist_ok=True)
    command = [executable('pwsh'), '-NoProfile', '-File', str(source / 'tools/build-engine.ps1'),
               '-SourceRoot', str(source), '-CanonicalRoot', str(ROOT)]
    command += [flag for flag, enabled in (('-Force', request.get('force')), ('-Serial', request.get('serial'))) if enabled]
    with logfile.open('wb') as log:
        result = subprocess.run(command, cwd=source, stdout=log, stderr=subprocess.STDOUT, **subprocess_flags(True))
    seconds = round(time.monotonic() - started, 2)
    if result.returncode:
        return {'ok': False, 'seconds': seconds, 'log': str(logfile)}
    # Archive the successful reference state and figure PDFs before publishing.
    # Previews only read this immutable cache, never the full engine's live cache.
    published = UPDATE_CACHE / 'published' / request['id']
    for variant in VARIANTS:
        folder = published / variant
        folder.mkdir(parents=True, exist_ok=True)
        for extension in ('.aux', '.sections'):
            shutil.copy2(CACHE / 'latex-aux' / (variant + extension), folder / (variant + extension))
        checkpoints = (folder / (variant + '.sections')).read_text(encoding='utf-8')
        if checkpoints.count('\\BuildCheckpoint') != len(sections(snapshot)):
            raise RuntimeError('Abschnittszähler fehlen; Gesamt-PDFs nicht veröffentlicht: ' + variant)
        cached = CACHE / 'tikz' / variant
        for path in cached.iterdir():
            if path.suffix in ('.pdf', '.deps', '.sha256'):
                shutil.copy2(path, folder / path.name)
        # Validate both outputs before either user-facing PDF is changed.
        pdf = (source / 'build' / (variant + '.pdf')).read_bytes()
        if not pdf.startswith(b'%PDF-') or b'%%EOF' not in pdf[-1024:]:
            raise RuntimeError('Ungültige vollständige PDF: ' + variant)
    publish_pair(source / 'build', source)
    return {'ok': True, 'seconds': seconds, 'log': str(logfile), 'published': str(published)}


def should_build(state):
    desired = state.get('desired')
    return desired and desired['id'] not in (state.get('completed', {}).get('id'), state.get('failed', {}).get('id'))


def worker():
    # Keep the idle/exit decision under the same lock as new requests. A request
    # arriving during worker shutdown cannot be lost between check and unlock.
    with ExitStack() as locks:
        acquired = locks.enter_context(lock(UPDATE_CACHE / 'worker.lock', blocking=False))
        if not acquired:
            return
        while True:
            with state_transaction() as state:
                if not should_build(state):
                    state['running'] = None
                    locks.close()
                    return
                request = state['desired'].copy()
                state['running'] = dict(request, pid=os.getpid(), started=now())
            started = time.monotonic()
            try:
                result = run_full(manifest(request['revision']), request)
            except Exception as error:
                result = {'ok': False, 'error': str(error), 'seconds': round(time.monotonic() - started, 2)}
            with state_transaction() as state:
                record = dict(request, **result, finished=now())
                state['completed' if result['ok'] else 'failed'] = record
                state['running'] = None
                state.setdefault('history', []).append(record)
                state['history'] = state['history'][-20:]


def start_worker():
    # Short-lived competing starters exit at the OS lock, never launch engines.
    with lock(UPDATE_CACHE / 'worker.lock', blocking=False) as available:
        if not available:
            return
    command = [sys.executable, str(ROOT / 'tools/build_coordinator.py'), 'worker']
    logfile = UPDATE_CACHE / 'worker.log'
    with logfile.open('ab') as log:
        options = subprocess_flags(True)
        if os.name == 'nt':
            options['creationflags'] |= (subprocess.DETACHED_PROCESS | subprocess.CREATE_NEW_PROCESS_GROUP
                                         | subprocess.CREATE_BREAKAWAY_FROM_JOB)
        else:
            options['start_new_session'] = True
        try:
            subprocess.Popen(command, cwd=ROOT, stdin=subprocess.DEVNULL, stdout=log, stderr=log, **options)
        except PermissionError as error:
            raise RuntimeError('Auftrag gespeichert, aber unabhängiger Hintergrundstart durch die Prozessisolation blockiert. '
                               'In Codex den Aufruf mit freigegebener unabhängiger Prozessausführung wiederholen; '
                               'alternativ tools/build-update.ps1 im normalen VS-Code-Terminal starten.') from error


def cached_figure_valid(snapshot, directory, figure):
    name = Path(figure).stem
    try:
        dependencies = (directory / (name + '.deps')).read_text(encoding='utf-8-sig').splitlines()
        records = []
        for path in dependencies:
            relative = Path(path).relative_to(ROOT).as_posix()
            sha = snapshot['files'].get(relative)
            if not sha:
                return False
            records.append(path + ':' + sha.upper())
        fingerprint = ':'.join((snapshot['files'][figure].upper(), 'de',
                                'true' if directory.name.endswith('cloze') else 'false',
                                digest('\n'.join(records).encode('utf-8'))))
        stored = (directory / (name + '.sha256')).read_text(encoding='utf-8-sig').strip()
        return bool(records) and stored.endswith(fingerprint) and (directory / (name + '.pdf')).exists()
    except (OSError, ValueError, KeyError):
        return False


def preview(snapshot, selection, baseline_record, sequence=0, whole_document=False):
    started = time.monotonic()
    with lock(UPDATE_CACHE / 'preview.lock'):
        source = UPDATE_CACHE / 'preview-source'
        materialize(snapshot, source)
        atomic(source / 'build-context.tex', context_text(snapshot, True).encode('utf-8'))
        source.joinpath('build').mkdir(exist_ok=True)
        atomic(source / 'build/tikz-cache-path.tex', b'\\def\\BuildContextFile{build-context.tex}\n')
        output = UPDATE_CACHE / 'preview-output'
        output.mkdir(exist_ok=True)
        baseline_dir = Path(baseline_record['published']) if baseline_record else None

        def run(variant):
            full_aux = baseline_dir / variant / (variant + '.aux') if baseline_dir else None
            refs = '' if not full_aux else '\n'.join(line for line in full_aux.read_text(encoding='utf-8').splitlines() if line.startswith('\\newlabel'))
            references = source / (variant + '-references.tex')
            atomic(references, refs.encode('utf-8'))
            checkpoints = {}
            if baseline_dir:
                for line in (baseline_dir / variant / (variant + '.sections')).read_text(encoding='utf-8').splitlines():
                    match = re.fullmatch(r'\\BuildCheckpoint\{([^{}]+)\}\{(.*)\}', line)
                    if match:
                        checkpoints[match[1]] = match[2]
            body = ['\\StartMainMatter']
            for section in selection:
                counters = checkpoints.get(section['path'], '\\setcounter{chapter}{' + str(section['chapter']) + '}\\setcounter{section}{' + str(section['section'] - 1) + '}')
                body += ['\\clearpage', counters, '\\input{' + section['path'] + '}']
            bodyfile = source / (variant + '-preview-body.tex')
            atomic(bodyfile, ('\n'.join(body) + '\n').encode('utf-8'))
            # Only verified immutable figure PDFs are reused. Changed graphics
            # render inline during this single fast pass, with current inputs.
            reuse = []
            if baseline_dir:
                dependencies = snapshot['files'] if whole_document else {p for section in selection for p in section['dependencies']}
                for figure in sorted(p for p in dependencies if '/tikz/' in p and p.endswith('.tex')):
                    if cached_figure_valid(snapshot, baseline_dir / variant, figure):
                        reuse.append('\\expandafter\\def\\csname PreviewCached@' + figure + '\\endcsname{' + (baseline_dir / variant / (Path(figure).stem + '.pdf')).as_posix() + '}')
            reuse += [r'''\RenewDocumentCommand{\CachedTikzFigure}{m}{%
\begingroup
\ifcsname PreviewCached@#1\endcsname
  \includegraphics{\csname PreviewCached@#1\endcsname}%
\else\input{#1}\fi\endgroup}''']
            setup = source / (variant + '-preview-setup.tex')
            atomic(setup, ('\n'.join(reuse) + '\n\\input{' + references.as_posix() + '}\n').encode('utf-8'))
            wrapper = ('\\def\\ScriptLanguage{de}\n\\def\\ClozeMode{' + ('true' if variant.endswith('cloze') else 'false') + '}\n'
                       + ('' if whole_document else '\\def\\ScriptPreviewBody{' + bodyfile.as_posix() + '}\n') +
                       '\\AddToHook{begindocument/before}{\\input{' + setup.as_posix() + '}}\n\\input{main.tex}\n')
            name = variant + '-preview'
            atomic(source / (name + '.tex'), wrapper.encode('utf-8'))
            env = dict(os.environ, TEXMFVAR=str(CACHE / 'texmf-cache'), TEXMFCACHE=str(CACHE / 'texmf-cache'))
            log = output / (name + '.build.log')
            command = [executable('lualatex'), '-halt-on-error', '-interaction=nonstopmode', '-recorder', '-synctex=1',
                       '-output-directory=' + str(output), name + '.tex']
            with log.open('wb') as stream:
                result = subprocess.run(command, cwd=source, env=env, stdout=stream, stderr=subprocess.STDOUT, **subprocess_flags())
            return result.returncode, log

        with ThreadPoolExecutor(max_workers=2) as pool:
            results = list(pool.map(run, VARIANTS))
        seconds = round(time.monotonic() - started, 2)
        if any(code for code, _ in results):
            raise RuntimeError(f'Vorschau fehlgeschlagen. Baudauer: {seconds} Sekunden. Logs: ' + ', '.join(str(log) for _, log in results))
        with state_transaction() as state:
            if sequence >= state.get('preview', {}).get('sequence', 0):
                publish_pair(output, source, preview_mode=True)
                state['preview'] = {'revision': snapshot['revision'], 'sections': [s['path'] for s in selection],
                                    'seconds': seconds, 'finished': now(), 'sequence': sequence,
                                    'whole_document': whole_document,
                                    'baseline': baseline_record['revision'] if baseline_record else None}
        print(f'Vorschau: {len(selection)} Abschnitte. Baudauer: {seconds} Sekunden.', flush=True)


def request_build(args):
    snapshot = capture()
    with state_transaction() as state:
        baseline_record = state.get('completed')
        sequence = state.get('sequence', 0) + 1
        state['sequence'] = sequence
    if args.command == 'update':
        selection, global_change = affected(snapshot, manifest(baseline_record['revision']) if baseline_record else None)
        if not baseline_record:
            print('Noch kein überprüfter Vollstand mit Abschnittszählern. Einmaliger Abgleich im Gesamtbau; vorhandene Grafik-Caches bleiben erhalten.', flush=True)
        elif selection:
            if global_change:
                print('Übergreifende Änderung: ausnahmsweise vollständige Vorschau einschließlich Kapitelanfängen/Vorspann; längere Laufzeit.', flush=True)
            preview(snapshot, selection, baseline_record, sequence, global_change)
        else:
            print('Keine neuen Abschnittsänderungen seit dem erfolgreichen Gesamtbau; offene Vorschau bleibt erhalten.', flush=True)
    with state_transaction() as state:
        request = {'id': str(sequence) + '-' + snapshot['revision'][:12], 'revision': snapshot['revision'],
                   'sequence': sequence, 'requested': now(), 'force': args.force, 'serial': args.serial}
        # Do not retry a failed identical revision on every poll or repeat call.
        known = next((state.get(key) for key in ('completed', 'failed', 'desired')
                      if state.get(key, {}).get('revision') == snapshot['revision']), None)
        if known and not args.force:
            request = known
        if sequence >= state.get('desired_sequence', 0):
            state['desired'] = request
            state['desired_sequence'] = sequence
        needed = should_build(state)
    if needed:
        for variant in VARIANTS:
            if not any((CACHE / 'tikz' / variant).glob('*.pdf')):
                print('ACHTUNG: Kein Grafik-Cache für ' + variant + '. Der Gesamt-Kaltbau kann mehrere Minuten dauern.', flush=True)
        start_worker()
        print('Gesamtbau vorgemerkt: ' + snapshot['revision'][:8] + ' (Status: tools/build-update.ps1 -Status).', flush=True)
    else:
        print('Gesamtstand bereits abgeschlossen; kein weiterer Bau gestartet.', flush=True)
    if args.wait:
        while True:
            with state_transaction() as state:
                record = next((state.get(key) for key in ('completed', 'failed') if state.get(key, {}).get('id') == request['id']), None)
                superseded = (state.get('desired', {}).get('id') != request['id']
                              and (state.get('running') or {}).get('id') != request['id'])
            if record:
                print('Baudauer: ' + str(record.get('seconds', 'nicht verfügbar')) + ' Sekunden.', flush=True)
                print(json.dumps(record, ensure_ascii=False, indent=2), flush=True)
                return 0 if record['ok'] else 1
            if superseded:
                print('Auftrag durch neueren vorgemerkten Stand ersetzt.', flush=True)
                return 0
            time.sleep(.5)
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=('update', 'full', 'worker', 'status', 'clean', 'ack', 'resume'))
    parser.add_argument('--wait', action='store_true')
    parser.add_argument('--force', action='store_true')
    parser.add_argument('--serial', action='store_true')
    args = parser.parse_args()
    UPDATE_CACHE.mkdir(parents=True, exist_ok=True)
    if args.command == 'worker':
        worker()
    elif args.command == 'status':
        with state_transaction() as state:
            report = dict(state)
        report['source_matches_full'] = bool(report.get('completed') and capture()['revision'] == report['completed']['revision'])
        report['cache'] = str(CACHE)
        with lock(UPDATE_CACHE / 'worker.lock', blocking=False) as available:
            report['worker_active'] = not available
        print(json.dumps(report, ensure_ascii=False, indent=2))
    elif args.command == 'ack':
        with state_transaction() as state:
            state['notified'] = {key: state.get(key, {}).get('id') for key in ('completed', 'failed')}
    elif args.command == 'resume':
        start_worker()
    elif args.command == 'clean':
        raise RuntimeError('Cache-Löschung im Hintergrundbetrieb deaktiviert. Erst laufende Bauten abschließen; Cache nur gezielt nach ausdrücklicher Freigabe löschen.')
    else:
        return request_build(args)
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception as exc:
        print(str(exc), file=sys.stderr, flush=True)
        sys.exit(1)
