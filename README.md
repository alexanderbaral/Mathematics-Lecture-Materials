# Mathematics Lecture Notes

Technical foundation for a bilingual (German/English) mathematics lecture script. German is the content master; English is synchronized only when explicitly requested.

## Build

The project uses LuaLaTeX via `latexmk` (TeX Live 2026). `main.tex` is the sole document body and defaults to the complete German version when compiled directly.

```powershell
.\tools\build-all.ps1
```

This creates all four variants under `build/`: German complete, German cloze, English complete, and English cloze. The four `tools/build-*.tex` files only select the mode and load `main.tex`.

## Structure and configuration

- `common/config.tex`: titles, shared semester, author, institutions, branding paths, and build defaults
- `common/preamble.tex`: package and font setup
- `common/layout.tex`: page layout, title page, page style, and semantic boxes
- `common/commands.tex`: language helper, cloze interfaces, and mathematics commands
- `content/chapters_de/` and `content/chapters_en/`: mirrored German and English content trees
- `content/usage_notes.tex` and `content/recommended_reading.tex`: shared bilingual front matter
- `content/resources/shared/`: visual files used across multiple chapters
- `content/resources/chapters/`: chapter-specific `images/` and `tikz/` folders
- `tools/`: build script and the four minimal build entry points
- `legacy/notes/handwritten/`: temporary inbox for handwritten source material

Before any content path is created or renamed under `content/chapters_de/` or `content/chapters_en/`, its English `snake_case` technical name must be proposed and explicitly approved. German content is authoritative. Handwritten notes are removed only after approved transfer and successful verification.

Author-facing metadata is edited in `common/config.tex`. Global branding files live in `content/resources/shared/` (PDF preferred, PNG supported); set `\BrandLogoPath` and `\BrandDotPath` there. Each chapter may keep its own visual material in `content/resources/chapters/<chapter>/images/` and `content/resources/chapters/<chapter>/tikz/`, mirroring the approved chapter name under `content/chapters_de/` and `content/chapters_en/`. Missing branding files automatically produce restrained placeholders.

## Cloze authoring

Use `\Cloze{<width>}{<content>}` for a short writing gap. For longer calculations use:

```latex
\begin{ClozeArea}[\linewidth]{5cm}
  \begin{align*}
    % complete solution
  \end{align*}
\end{ClozeArea}
```

Complete builds show the content; cloze builds replace it with a 5 mm grid.
