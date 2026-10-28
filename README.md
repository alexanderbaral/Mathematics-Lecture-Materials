# Mathematics Lecture Notes

Technical foundation for a bilingual (German/English) mathematics lecture script. German is the content master; English is synchronized only when explicitly requested.

## Build

The project uses LuaLaTeX via `latexmk` (TeX Live 2026). `main.tex` is the sole document body and defaults to the complete German version when compiled directly.

```powershell
.\tools\build-update.ps1         # preview first; full build continues in background
.\tools\build-update.ps1 -Status # published, running and latest requested state
.\tools\build-all.ps1            # wait for a converged full build
```

In this workspace, **Ctrl+Shift+B** runs the default VS Code task
**LaTeX: Vorschau und Gesamt-PDFs aktualisieren** (`tools/build-update.ps1`).
Save your edits first. Both previews are published before the full build is
queued in the background; the terminal task can finish while that worker is
still running. Repeating the shortcut uses the same single-worker queue.

This creates the active PDF variants under `build/`. Until English translation begins, these are the German complete and German cloze PDFs; the two English entry points remain available for later. The folder contains the final PDFs and their `.synctex.gz` source maps, which let the PDF viewer jump from a PDF position to the corresponding TeX source. All other auxiliary files, logs, and cached TikZ figures use the persistent `%USERPROFILE%\AppData\Local\Temp\Mathematik1-Skript\` folder, not a redirected sandbox folder. Existing figures are checked against their actual source dependencies and reused across sessions; body-only layout changes do not discard them. The build reports how many figures are reused and warns before a complete rebuild. Normal builds preserve caches; the coordinator deliberately refuses broad `-CleanCache` deletion while this workflow is in use. The four `tools/build-*.tex` files only select the mode and load `main.tex`.

Open `build/build-de-preview.pdf` and `build/build-de-cloze-preview.pdf` in
VS Code once: their fixed filenames are replaced after each successful preview.
They contain all affected sections since the **last successful full snapshot**,
in script order, not just the last edited section. Unchanged sections are omitted.
The first setup establishes section counters with a full build. Shared layout,
chapter-order or front-matter changes instead need a full-document preview.
Previews use one pass: numbering and external references may temporarily reflect
the preceding full build. Their header identifies them explicitly as previews.
After a full build finishes, the open preview is retained until the next update.

`tools/build_coordinator.py` (Python standard library) freezes all project inputs
and allows exactly one complete build plus one replaceable latest request. New
updates do not abort an in-progress build, even a long cold build. The worker
publishes its successful snapshot, then takes the newest pending request. It stops
when caught up; it does not poll source files or build continuously when idle.
Call the update command after each batch of edits. Failed unchanged requests are
not retried automatically (`build-all.ps1 -Force` explicitly retries).

Both full variants run in parallel through the internal `tools/build-engine.ps1`;
`build-all.ps1 -Serial` remains available. Existing TikZ/font/LaTeX caches are
reused. Preview auxiliaries and immutable published figure copies are separate
from the full engine's writable cache. Changed preview graphics render inline.
PDFs are replaced atomically per file; SyncTeX points back to editable sources.
The header and status show the source revision; full PDFs are only exact for that
revision until the next build finishes. Each build reports seconds separately
from editing and inspection. Status/logs/snapshots live in the persistent cache's
`updates/` folder, never in the viewer-facing `build/` directory.

In a regular VS Code terminal the hidden worker survives the command. Codex may
require approved independent execution to escape its process sandbox; a blocked
launch leaves the request saved and reports this explicitly. `python
tools/build_coordinator.py resume` resumes a saved request without taking a newer
snapshot. The minute-based chat follow-up **Mathematikskript: PDF-Bau nachprüfen**
is disabled at the author's request (2026-10-09), avoiding idle AI calls. The local
worker still finishes builds and pending follow-ups without an active chat.
Codex checks completion/errors during the next user-requested work session;
there is no unsolicited completion/error notification or AI recovery in between.

Regression checks: `python tools/test_build_coordinator.py` (isolated temporary
fixtures; no teaching-source edits). English remains disabled. No commits or
remote publication are part of building.

## Structure and configuration

- `common/config.tex`: titles, shared semester, author, institutions, branding paths, and build defaults
- `common/preamble.tex`: package and font setup
- `common/layout.tex`: page layout, title page, page style, and semantic boxes
- `common/commands.tex`: language helper, cloze interfaces, and mathematics commands
- `content/chapters_de/` and `content/chapters_en/`: mirrored German and English content trees
- `content/front_matter/`: shared bilingual usage notes, Greek alphabet, and recommended reading
- `content/resources/shared/`: visual files used across multiple chapters
- `content/resources/chapters/`: chapter-specific `images/` and `tikz/` folders
- `tools/`: build script and the four minimal build entry points (only the two German variants are currently enabled)
- `legacy/notes/handwritten/`: temporary inbox for handwritten source material

Before any content path is created or renamed under `content/chapters_de/` or `content/chapters_en/`, its English `snake_case` technical name must be proposed and explicitly approved. German content is authoritative. Handwritten notes are removed only after approved transfer and successful verification.

Text and diagram labels use Plus Jakarta Sans; formulas retain Libertinus Math. The four required text font files and their SIL Open Font License are bundled in `content/resources/shared/fonts/plus_jakarta_sans/`; no separate installation of Plus Jakarta Sans is needed.

Short `\Cloze` answer fields use the subtle CD-greige background `#E5E4D8`, chosen to remain unobtrusive and suitable for pencil writing.

Author-facing metadata is edited in `common/config.tex`. Global branding files live in `content/resources/shared/` (PDF preferred, PNG supported); set `\BrandLogoPath` and `\BrandDotPath` there. Each chapter may keep its own visual material in `content/resources/chapters/<chapter>/images/` and `content/resources/chapters/<chapter>/tikz/`, mirroring the approved chapter name under `content/chapters_de/` and `content/chapters_en/`. Missing branding files automatically produce restrained placeholders.

This mathematics lecture script uses exclusively the official TH Mannheim/Maschinenbau logo and the corresponding faculty metadata. The vector PDF is derived from the accompanying original RGB SVG from the TH Mannheim brand portal, preserving its shapes and colour.
The title page uses the official point pattern in RGB blue on a white background.
The header uses the official Mannheimer Punkt as a vector PDF in RGB blue.
