"""Shared location for disposable build and image files outside cloud sync."""
import os
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CACHE_ROOT = Path(os.environ.get('EXERCISE_SHEETS_CACHE') or
                  Path(os.environ.get('LOCALAPPDATA', tempfile.gettempdir())) /
                  '_tmp_LatexCache' / 'mathematics_exercise_sheets')
