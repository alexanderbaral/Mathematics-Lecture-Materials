# AGENTS.md — Mathematics Lecture Script

## 1. Purpose and core rules
This repository contains a bilingual LaTeX mathematics lecture script maintained in VS Code with Codex. Read this file before making changes.

- German is the authoritative master for content and structure.
- English is a Codex-maintained translation, not an independent authoring branch.
- Keep the project simple, readable, modular, and manually editable.
- Prefer semantic LaTeX and maintainability over clever abstractions.
- Do not overengineer or create speculative content structures.

## 2. Content structure and mandatory filename consultation
The author decides content filenames and folder names interactively.

Before creating or renaming any chapter, section, subsection, or other content file/folder under `chapters/`:
1. propose a concise English `snake_case` name;
2. if several names are reasonable, propose 2–4 alternatives briefly;
3. wait for explicit approval;
4. only then create the path.

Do not pre-create future chapters, sections, subsections, or placeholder content files. `chapters/de/` and `chapters/en/` may start empty and grow incrementally, subsection by subsection.

Technical content paths are English, lowercase, `snake_case`, semantic, and never numbered for ordering. Order is controlled by `\input`, not filenames. German and English trees use exactly the same technical paths and filenames.

Preferred hierarchy:
```text
chapters/de/<chapter>/chapter.tex
chapters/de/<chapter>/<section>/section.tex
chapters/de/<chapter>/<section>/<content_unit>.tex
```
with an identical tree under `chapters/en/`.

A content file represents one coherent mathematical unit and will often compile to roughly 1–2 pages; conceptual coherence is more important than page count. Do not create separate files for every equation or paragraph. `chapter.tex` and `section.tex` may contain short introductions.

## 3. German master and English synchronization
`chapters/de/` is the single source of truth. Normal authoring primarily changes German content. Do not automatically update English unless explicitly requested.

When asked to synchronize English:
- compare German master and existing English;
- update affected English content and structure;
- preserve good unchanged English wording;
- keep equations, numbers, examples, assumptions, labels, references, and mathematical meaning equivalent;
- write idiomatic scientific English;
- mirror approved German structural changes;
- report genuine ambiguities;
- compile relevant English variants.

### Translation glossary
Use author-established terminology consistently.

| German | English | Notes |
|---|---|---|
| Ortsvektor | position vector | Do not use “location vector”. |

Add entries when the author explicitly establishes a preferred translation. Do not fill this table with trivial translations unnecessarily.

## 4. Shared project infrastructure
Keep shared infrastructure compact:
```text
common/
  config.tex
  preamble.tex
  layout.tex
  commands.tex
```

- `config.tex`: author-facing metadata, branding paths, mode definitions/defaults.
- `preamble.tex`: packages and technical LaTeX setup.
- `layout.tex`: page geometry, typography/layout, title page, header/footer, branding, semantic box styling.
- `commands.tex`: stable author-facing commands, language helper, cloze interface, mathematical shortcuts.

Do not create a general-purpose `header.tex`. The old header in `legacy/` is reference material only. Avoid splitting infrastructure into many tiny files unless later complexity clearly justifies it.

`config.tex` contains at least one language-dependent script-title variable, exactly one shared semester variable, author, one language-dependent institution variable, one language-dependent faculty variable, branding paths, and mode defaults/definitions.

The semester exists once, e.g. `\newcommand{\Semester}{WS 27/28}` or `\newcommand{\Semester}{SS 28}`. Never create `SemesterDE`/`SemesterEN`.

`Vorlesungsskript`/`Lecture Notes`, `Seite`/`Page`, and similar fixed interface strings are language logic, not author metadata. Store the script title, institution, and faculty as one command each whose value uses the central `\Lang{de}{en}` helper.

## 5. Build architecture
There is exactly one real document body:
```text
main.tex
```

There are four minimal build entry points:
```text
build-de.tex
build-de-cloze.tex
build-en.tex
build-en-cloze.tex
```
They only select language/cloze mode and load `main.tex`; never duplicate the document body.

Direct compilation of `main.tex` uses the safe default: German, complete (`cloze=false`).

Also maintain `build-all.ps1`. It builds all four variants with `latexmk`, clearly reports success/failure per variant, and returns a non-zero exit status if any build fails. Use the locally installed TeX Live distribution. Generated outputs should live under `build/` where practical.

After shared-infrastructure changes, run `build-all.ps1` and require all four variants to compile.

## 6. Language, shared resources, labels
Provide one central helper for short shared language-dependent text, e.g. `\Lang{deutscher Text}{English text}`. Use it for TikZ labels, title-page interface text, box titles, header/footer text, and shared tables. Long prose stays in separate DE/EN content trees.

Shared TikZ figures, images, layout, commands, bibliography, and branding normally exist only once. Do not duplicate TikZ solely for translated labels.

Use language-independent English technical labels, e.g.:
```latex
\label{sec:vector_addition}
\label{eq:derivative_definition}
\label{fig:vector_components}
\label{def:linear_independence}
```

## 7. Cloze system
Semantics:
- `cloze=false` → complete lecture script
- `cloze=true` → cloze/student version

Provide a simple short-gap interface such as `\Cloze{<width>}{<content>}`: complete mode shows content; cloze mode shows a writing line.

Also provide a robust long-calculation interface: complete mode shows the solution; cloze mode shows an approximately 5 mm grid. Prefer default width `\linewidth`, allow optional explicit width, make height easy to specify, and support multi-line/`align`-style mathematics robustly. The internal implementation may be a command or environment, whichever is safer. Do not use local ad-hoc solution switches in chapter files.

## 8. Layout, typography, branding
Use modern KOMA-Script, preferably `scrreprt`, A4, 12 pt unless a strong technical reason requires otherwise.

Mandatory geometry:
```latex
left=1.5cm
right=1.5cm
top=1.0cm
bottom=1.5cm
includeheadfoot
```
Do not enlarge these margins for conventional print-layout reasons. The script is primarily for digital tablet use and handwritten annotation.

Use Fira Sans as primary text typeface. Choose a high-quality readable mathematics font compatible with Fira Sans; do not force sans-serif mathematics if readability suffers. The exact mathematics font may be refined after visual testing.

Define TH Mannheim blue centrally as RGB `(0,0,255)` and use it sparingly. Body text remains black; otherwise prefer black/grayscale. Style: modern, technical, minimal, calm, tablet-friendly. Do not reproduce the legacy TH Mannheim layout.

Branding assets live in `assets/branding/`. The author will provide the official TH Mannheim/faculty logo and Mannheimer Punkt. Prefer PDF vector assets; PNG is acceptable; support EPS only if actually needed. If assets are missing, compilation must still succeed with unobtrusive placeholders and README guidance.

Title page includes logo, language-dependent script title, `Vorlesungsskript`/`Lecture Notes`, author, language-dependent institution/faculty, and semester. Keep the first design restrained and modular.

Keep the header quiet and show the Mannheimer Punkt discreetly at upper right on regular content pages via the central page style.

Footer concept:
- DE: `Mathematik · Semester WS 27/28                     Seite 13`
- EN: `Mathematics · Semester WS 27/28                    Page 13`

Values come from central configuration/language logic. Institution/faculty belong primarily on the title page. Prefer KOMA-compatible page-style mechanisms such as `scrlayer-scrpage`.

## 9. Mathematics conventions
Use modern mathematical LaTeX, a clean package set, and no duplicate package loads. Use suitable tools such as `amsmath`/`mathtools`, TikZ, `tcolorbox`, `microtype`, `booktabs`, `tabularx`, `hyperref` only as needed. Avoid obsolete `\rm`, `\bf`, `\it` definitions.

Provide robust central shortcuts where useful, e.g. `\R`, `\N`, `\Q`, `\Z`, `\C`. `siunitx` may be available but is not a core requirement.

Provide calm semantic styling at least for Definition, Merke/Key Point, Beispiel/Example; Satz/Theorem and Hinweis/Remark are also reasonable. Proofs remain visually restrained initially.

Prefer chapter/section/subsection numbering. Do not introduce `1.1.1.1`-style visible numbering without a concrete need.

## 10. Handwritten notes
`notes/handwritten/` is a temporary inbox only.

Workflow:
1. read/interpret the note;
2. if a new content path is needed, consult the author first;
3. transfer content into approved German LaTeX source;
4. compile and verify;
5. ensure transfer is complete;
6. only then remove the corresponding handwritten source.

Do not permanently retain redundant handwritten material and never delete it before successful transfer/verification.

## 11. Compilation, Git, and generated files
Validate proportionally to the change.

For shared infrastructure changes (`common/*.tex`, language/cloze logic, page style, title page, boxes, shared TikZ infrastructure), run:
```powershell
.\build-all.ps1
```
and require all four builds to succeed.

If only German prose changes, compile at least affected German variant(s); do not synchronize English unless requested. After English sync, compile relevant English variants.

After visual/layout/TikZ/cloze/title-page changes, visually inspect affected PDF pages when tooling permits. Fix LaTeX errors and meaningful warnings before completion.

Codex may inspect `git status`, `git diff`, and `git log`. Do not commit, push, or publish changes unless explicitly asked. Before handing back substantial work, summarize meaningful changes and `git status`.

Keep generated LaTeX artifacts, logs, auxiliary files, and generated PDFs under `build/` out of source control unless explicitly requested. Source, configuration, documentation, and required branding assets belong in the repository.

## 12. Legacy, README, and scope discipline
Files under `legacy/` are historical references only. Do not include them in normal builds or copy their package setup wholesale. They may inform fonts, colors, and prior author conventions.

Keep `README.md` concise and human-facing. Explain project structure, four build variants plus `build-all.ps1`, German-master/English-sync workflow, `common/config.tex`, branding, cloze usage, handwritten-note workflow, and mandatory filename consultation.

When initializing/extending the repository:
- create only needed infrastructure;
- do not invent a future syllabus;
- do not pre-create chapter trees or speculative content files;
- ask before author-facing content path/name decisions.

When multiple technical solutions are valid, prefer the simpler, more maintainable one. If a decision materially affects author-facing filenames, folder names, or long-term content structure, ask before implementing it.
