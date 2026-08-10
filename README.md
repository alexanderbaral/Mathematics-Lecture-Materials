# Mathematics Lecture Notes

Technical foundation for a bilingual (German/English) mathematics lecture script. German is the content master; English is synchronized only when explicitly requested.

## Build

The project uses LuaLaTeX via `latexmk` (TeX Live 2026). `main.tex` is the sole document body and defaults to the complete German version when compiled directly.

```powershell
.\build-all.ps1
```

This creates all four variants under `build/`: German complete, German cloze, English complete, and English cloze. The four `build-*.tex` files only select the mode and load `main.tex`.

## Structure and configuration

- `common/config.tex`: titles, shared semester, author, institutions, branding paths, and build defaults
- `common/preamble.tex`: package and font setup
- `common/layout.tex`: page layout, title page, page style, and semantic boxes
- `common/commands.tex`: language helper, cloze interfaces, and mathematics commands
- `chapters/de/` and `chapters/en/`: mirrored content trees (initially empty)
- `figures/`: shared TikZ sources and images
- `notes/handwritten/`: temporary inbox for handwritten source material

Before any content path is created or renamed under `chapters/`, its English `snake_case` technical name must be proposed and explicitly approved. German content is authoritative. Handwritten notes are removed only after approved transfer and successful verification.

Author-facing metadata is edited in `common/config.tex`. Branding files live in `assets/branding/` (PDF preferred, PNG supported); set `\BrandLogoPath` and `\BrandDotPath` there. The existing TH Mannheim logo and `TH_Mannheim_Favicon.png` are configured initially. Missing files automatically produce restrained placeholders.

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
