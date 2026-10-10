# AGENTS.md — Mathematics Lecture Script

## 1. Purpose and core rules
This repository contains a bilingual LaTeX mathematics lecture script maintained in VS Code with Codex. Read this file before making changes.

- German is the authoritative master for content and structure.
- English is a Codex-maintained translation, not an independent authoring branch.
- Keep the project simple, readable, modular, and manually editable.
- Prefer semantic LaTeX and maintainability over clever abstractions.
- Do not overengineer or create speculative content structures.
- Write in a concise lecture-script style, not in long prose. Make the essential
  content immediately scannable and let formulas, diagrams, and figures carry
  the explanation wherever possible. Communicate each idea with as little text
  as clarity permits, and clarify complex relationships through deliberate
  spatial arrangement of formulas, labels, and graphics.

### Local task workflow
- Treat current, unchanged project rules already present in the task context as
  read; do not reopen the full `AGENTS.md` or unchanged build infrastructure.
- Work directly from the current chat request and the relevant semantic labels
  and source paths. Read the smallest relevant source excerpts first.
- Do not maintain or recreate a TODO file in the repository. If a temporary
  checklist is genuinely needed for a complex task, keep it only under
  `AppData/Local/Temp/Mathematik1-Skript/updates/`, remove obsolete entries,
  and never treat an old checklist as fresh authorization for unrelated work.
- Broaden searches only when a dependency is unknown, a shared command or
  resource is involved, or the user asks for a project-wide audit. Batch
  independent searches and keep their output focused on the requested files.
- Before editing a file that may be shared with another agent, check that
  specific file for intervening changes and preserve them.
- For visual changes, inspect the standalone figure first and the affected
  complete and cloze pages after the final edit. Build the variants currently
  enabled for the project; a local preview complements, but does not replace,
  those final checks.
- Reuse the persistent cache under the real user profile's
  `AppData/Local/Temp/Mathematik1-Skript`, including after long pauses. Never
  silently switch to a redirected sandbox cache or discard the entire cache
  for body-only layout changes. If no usable cache exists or relevant shared
  dependencies genuinely require a complete rebuild, warn the author before
  starting that longer build. Do not clear caches unless explicitly requested.
- The coordinator automatically records preview/full build durations in
  `AppData/Local/Temp/Mathematik1-Skript/updates/timings.csv`, outside the
  repository. Keep terminal duration reports, but do not repeat every timing
  in chat. Summarize on request or after approximately five substantive edits;
  alert promptly to failures, cold builds or unexpectedly slow builds.
  Editing time is not measured by the build script: report it separately only
  when actually measured, excluding build/visual verification time. Never
  equate time between builds with editing time or invent missing measurements.
- After edits use `tools/build-update.ps1`: first update both stable preview
  PDFs in `build/`, then let the full build finish in the background. The preview
  collects affected sections since the last successfully published full source
  snapshot, in document order. Global layout, chapter-order or front-matter
  changes require a full-document preview and may take longer. Preview numbering
  and external references are provisional; it never replaces final full checks.
- Exactly one full worker may run, with only the latest follow-up request kept.
  Never abort a cold build for a new edit. The worker freezes sources/resources,
  reuses persistent caches, converges with `latexmk` and publishes both variants.
  Use `tools/build-all.ps1` for a blocking full build through the same queue;
  never call the internal `tools/build-engine.ps1` directly. No implicit watcher:
  submit another update after the next batch of edits.
- The Codex process sandbox may stop ordinary detached children. Use the approved
  independent process execution for `python tools/build_coordinator.py update`
  (or `full`/`resume`) when needed; the Windows worker uses a hidden breakaway
  process. Confirm status, not merely a returned process ID. The minute-based
  thread follow-up "Mathematikskript: PDF-Bau nachprüfen" was disabled at the
  author's request on 2026-10-09 to avoid idle AI usage. Do not reactivate it
  without explicit approval. Check completion/errors at the next user-requested
  work session and acknowledge reported results with the `ack` command.
- After handing over a preview, report that the complete PDFs may still represent
  an older successful snapshot. Status/revisions/timings are available through
  `tools/build-update.ps1 -Status`. Never claim the full PDFs are current while a
  newer request is pending. Keep the open preview when a full build finishes.
- Compare timings only for reasonably similar tasks; distinguish editing,
  preview, full build and visual correction passes. No periodic AI monitor
  is needed for the timing log.
- This focused workflow never relaxes the mathematical, pedagogical,
  typography, figure, cloze, translation, or verification requirements below.

### 1.1 Evolving chapter design principles
The completed and author-revised chapters define the target style for new
content. Treat the following principles as a provisional, binding design
standard. After each completed chapter, review and refine them with the author
so that future drafts increasingly match the style of the revised material.

#### Content order and orientation
- Arrange topics according to their mathematical dependencies. Introduce a
  concept only after the prerequisites needed to understand it, and progress
  from elementary concepts through rules and procedures to more demanding
  applications.
- Begin each section with a short orientation of only a few sentences. State
  the topic's significance, connect it to prior knowledge, announce its later
  use, or identify the section's central problem. Do not front-load detailed
  explanations into this opening.

#### Concise mathematical presentation
- Before a displayed equation, write a meaningful introductory sentence whose
  first line fills at least approximately half the available text width.
  Avoid isolated one- or two-word introductions such as "Für" or "Gegeben".
  Move useful context from after the equation into its introduction when
  needed; do not add filler merely to lengthen the line. Check this visually,
  especially in examples and minipages.
- Use prose mainly for orientation, transitions, and interpretation. Let
  formulas, tables, diagrams, and deliberate spatial arrangement carry the
  explanation whenever they express the relationship more directly.
- Avoid extended prose when a precise visual or mathematical representation
  makes the same relationship easier to scan.
- Prefer the shortest wording that preserves the mathematical reasoning.
  State assumptions beside the formula or step where they become necessary;
  avoid separate explanatory sentences when compact notation makes the point
  clear. The script should read as concise teaching notes, not as a textbook.
- Do not emphasize equations with black frames such as `\boxed`. Use the
  surrounding semantic box, spatial arrangement, or restrained typography to
  communicate their role instead.
- Keep a list visually grouped: the vertical gap from its final item to a
  following independent paragraph must be at least as large as the gaps
  between its items. Reduce internal spacing where appropriate and provide
  sufficient space after the list. Check the rendered result, including lists
  containing displayed equations and lists inside minipages.

#### Semantic roles
- Give each semantic box one clear purpose; do not mix several roles in one
  box:
  - `DefinitionBox` introduces a term together with its notation and necessary
    assumptions.
  - `TheoremBox` states a durable mathematical result or formula.
  - `KeyPointBox` emphasizes an especially important rule, consequence, or
    relationship.
  - `ExampleBox` applies the material concretely or checks understanding.
  - `RemarkBox` records pitfalls, technical guidance, interpretations, or a
    supplementary viewpoint.
- Keep formal definitions compact and self-contained. Include the emphasized
  term, the author-established English translation where required, the
  mathematical statement, all necessary assumptions, and the associated
  notation. Put applications, longer explanations, and consequences after the
  definition or in separate semantic elements.
- Add a technical term's translation exactly once per language version: place
  it immediately after the term when that term is explicitly introduced for
  the first time, using the central language command:
  German uses `\EnglishTerm{...}` and English uses `\GermanTerm{...}`. This
  applies both to formal definitions and to explicitly introduced technical or
  procedural terms outside a definition box. Do not repeat the translation at
  ordinary later uses of the same term.

#### Examples
- Make every example perform a genuine learning step rather than merely
  substitute numbers into a finished formula. Appropriate steps include
  choosing a representation, recognizing a rule, determining a quantity,
  justifying a statement, interpreting a result, or comparing useful solution
  methods.
- Structure each example as a recognizable learning path where appropriate:
  choose or construct a representation, identify and carry out the relevant
  operation or method, name the resulting mathematical state, and interpret
  the result. Show the essential reasoning steps and compress routine algebra
  when it is not itself the learning objective.
- For calculations, make the given information, the quantity sought, the
  calculation, and the result recognizable where appropriate. Carry units
  consistently throughout.
- Before concrete numerical vectors are used in a calculation, identify their
  mathematical role through a preceding general formula, concise prose, or
  explicit annotations. Do not apply an operation to unexplained numerical
  vectors; make clear, for example, whether a vector is a support vector, a
  direction vector, a normal vector, or a projection.
- Prefer technical or mechanical-engineering quantities when they arise
  naturally from the topic; do not force an artificial application context.

#### Figures and color
- In coordinate diagrams for concrete numerical examples, show a subtle
  background grid at integer coordinate values and label the integer axis
  ticks (for example 1, 2, 3, 4). Grid spacing and tick values must match the
  numerical coordinates, including when drawing units are enlarged. Keep
  the grid visually subordinate to vectors and labels.
- Place a figure directly beside or immediately after the thought that needs
  it. Use side-by-side text, formulas, tables, and figures when this makes their
  correspondence visible without page turning or unnecessary eye movement.
- A figure may be repeated deliberately when it serves again as the immediate
  working basis of a later theorem, derivation, or example.
- Keep black and grayscale as the visual foundation, with TH Mannheim blue for
  semantic structure. Use additional colors only as local carriers of meaning,
  such as linking corresponding quantities, expressions, or geometric areas.
  Within one representation, a color must retain one meaning and must never be
  added merely for decoration.
- Give recurring mathematical roles a stable visual grammar throughout the
  script. Use the same arrow type, alignment, annotation position, color, and
  final-state labeling whenever the same kind of relationship recurs. In
  multi-step procedures, align successive states vertically where practical,
  place an operation beside the state to which it is applied, and explicitly
  name a mathematically significant final state. Use `\Longleftrightarrow` only
  for equivalent statements or states and `\Longrightarrow` for one-way
  consequences.
- Before completing any TikZ figure, visually check every label and
  mathematical expression: it must not cross, touch, or be obscured by an axis,
  geometric object, arrow, line, or another label. Use transparent label
  backgrounds unless the author explicitly requests an exception.

#### Cloze design
- Preserve the complete reasoning context in the cloze version: prompts,
  assumptions, diagrams, and the surrounding mathematical structure remain
  visible. Hide specifically the learning steps students should reproduce.
- Use a gray `\Cloze` field for a short result, symbol, or single-line response,
  and a `ClozeArea` grid for multi-line calculations, derivations, drawings, or
  constructions. Size every response area for the handwriting realistically
  required.
- The complete and cloze variants must contain the same material in the same
  order, but they need not have identical pagination. In the complete variant,
  show solutions at their natural size without preserving the cloze field's
  artificial width.

## 2. Content structure and mandatory filename consultation
The author decides content filenames and folder names interactively.

Before creating or renaming any chapter, section, subsection, or other content file/folder under `content/chapters_de/` or `content/chapters_en/`:
1. propose a concise English `snake_case` name;
2. if several names are reasonable, propose 2–4 alternatives briefly;
3. wait for explicit approval;
4. only then create the path.

Do not pre-create future chapters, sections, subsections, or placeholder content files. `content/chapters_de/` and `content/chapters_en/` may start empty and grow incrementally, subsection by subsection.

Technical content paths are English, lowercase, `snake_case`, semantic, and never numbered for ordering. Order is controlled by `\input`, not filenames. German and English trees use exactly the same technical paths and filenames.

Preferred hierarchy:
```text
content/chapters_de/<chapter>/_chapter.tex
content/chapters_de/<chapter>/<section>/_section.tex
content/chapters_de/<chapter>/<section>/<content_unit>.tex
```
with an identical tree under `content/chapters_en/`.

A content file represents one coherent mathematical unit and will often compile to roughly 1–2 pages; conceptual coherence is more important than page count. Do not create separate files for every equation or paragraph. `_chapter.tex` and `_section.tex` may contain short introductions. Always prefix these two structural filenames with `_` so they sort first in their folders.

Each `\section` starts on a new PDF page. The first section may follow the chapter heading on the chapter's opening page; place `\clearpage` between subsequent section inputs in `_chapter.tex`.

## 3. German master and English synchronization
`content/chapters_de/` is the single source of truth. Normal authoring primarily changes German content. Do not automatically update English unless explicitly requested.

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
Use author-established terminology consistently. Follow the first-use and
formatting rules in §1.1; record only explicitly established preferences here.

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

There are four minimal build entry points under `tools/`:
```text
tools/build-de.tex
tools/build-de-cloze.tex
tools/build-en.tex
tools/build-en-cloze.tex
```
They only select language/cloze mode and load `main.tex`; never duplicate the document body.

Direct compilation of `main.tex` uses the safe default: German, complete (`cloze=false`).

Also maintain `tools/build-all.ps1`. It builds the currently enabled variants
with `latexmk`, clearly reports success or failure per variant, and returns a
non-zero exit status if any build fails. Until English translation begins,
enable only the German complete and German cloze variants. When translation
begins, enable both English variants as well. Use the locally installed TeX
Live distribution; generated outputs should live under `build/` where practical.

## 6. Language, shared resources, labels
Provide one central helper for shared language-dependent text, e.g. `\Lang{deutscher Text}{English text}`. Use it for TikZ labels, title-page interface text, box titles, header/footer text, shared tables, and the bilingual files under `content/front_matter/`. Long chapter prose stays in separate DE/EN content trees.

Shared TikZ figures, images, layout, commands, bibliography, and branding normally exist only once. Do not duplicate TikZ solely for translated labels.

Use language-independent English technical labels, e.g.:
```latex
\label{chap:fundamentals}
\label{sec:fundamentals_vector_addition}
\label{eq:fundamentals_derivative_definition}
\label{fig:fundamentals_vector_components}
\label{def:fundamentals_linear_independence}
```
Every label below a chapter uses the approved technical chapter name as its
namespace immediately after the type prefix. Apply the same namespace to labels
generated through semantic-box arguments, references, equations, figures, and
tables.

## 7. Cloze system
Semantics:
- `cloze=false` → complete lecture script
- `cloze=true` → cloze/student version

Provide a simple short-gap interface such as `\Cloze{<width>}{<content>}`: complete mode shows content; cloze mode shows a writing line.

Also provide a robust long-calculation interface: complete mode shows the
solution; cloze mode shows an exact 5 mm grid. Specify every `ClozeArea` by an
integer number of grid columns and rows,
`\begin{ClozeArea}[<columns>]{<rows>}`; never pass lengths such as `\linewidth`
or `3cm`. The default is 34 columns. Choose the row count from the handwritten
space actually needed, so width and height always contain complete squares.
Support multi-line/`align`-style mathematics robustly. Do not use local ad-hoc
solution switches in chapter files.

Use the gray `\Cloze` box for every short, single-line inline answer. Use the
5 mm grid (`ClozeArea`) whenever a larger response area or multiple handwritten
lines are needed, especially for longer calculations and derivations.
When adapting an existing grid, preserve its approximate physical area while
rounding both dimensions to whole 5 mm squares.
The width argument of `\Cloze` controls only the gray field in cloze mode. In
the complete version, render the solution at its natural width without
reserving the width of the cloze field.

Definition and example boxes must never break across PDF pages. Keep
`DefinitionBox` and `ExampleBox` unbreakable so that a box which no longer fits
is moved as a whole to the next page.

When an example directly illustrates the preceding definition, keep the
definition and example together on the same PDF page. Use a smaller vertical
gap within this pair while retaining the normal box spacing before the next
content block.

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

All text inside figures and diagrams must use the same font size as the
surrounding body text. This applies equally to prose, mathematical expressions
and symbols, axis labels, annotations, and vector labels. Do not shrink a
figure with `\resizebox`, `\scalebox`, or a similar mechanism when this would
make its labels smaller than the adjacent text; adapt the figure geometry or
surrounding layout instead.

Draw angle arcs in figures and diagrams without arrowheads. Place the angle
symbol or angle measure inside the corresponding angle sector; enlarge the arc
when necessary so the label remains legible and is clearly assigned to that
angle.
Mark every right angle with a quarter-circle arc and a dot inside its angle
sector, never with a square corner.

Define TH Mannheim blue centrally as RGB `(0,0,255)` and use it sparingly. Body text remains black; otherwise prefer black/grayscale. Style: modern, technical, minimal, calm, tablet-friendly. Do not reproduce the legacy TH Mannheim layout.

Shared visual resources live under `content/resources/`. Global files used across chapters, such as branding assets, live in `content/resources/shared/`; its `images/` and `tikz/` subfolders hold other shared visual resources. Chapter-specific resources mirror the approved chapter name and use `content/resources/chapters/<chapter>/images/` for raster or vector illustrations and `content/resources/chapters/<chapter>/tikz/` for TikZ sources. Do not create resource folders for future chapters. The author will provide the official TH Mannheim/faculty logo and Mannheimer Punkt. Prefer PDF vector assets; PNG is acceptable; support EPS only if actually needed. If assets are missing, compilation must still succeed with unobtrusive placeholders and README guidance.

Always place every new TikZ graphic immediately in its own semantically named
file in the appropriate `content/resources/**/tikz/` folder. Do not leave new
`tikzpicture` environments inline in chapter or section content files; include
the external resource through the project's central TikZ-loading command.

Title page includes logo, language-dependent script title, `Vorlesungsskript`/`Lecture Notes`, author, language-dependent institution/faculty, and semester. Keep the first design restrained and modular.

Keep the header quiet and show the Mannheimer Punkt discreetly at upper right on regular content pages via the central page style.

Footer concept:
- DE: `Mathematik · Semester WS 27/28                     Seite 13`
- EN: `Mathematics · Semester WS 27/28                    Page 13`

Values come from central configuration/language logic. Institution/faculty belong primarily on the title page. Prefer KOMA-compatible page-style mechanisms such as `scrlayer-scrpage`.

## 9. Mathematics conventions
Use modern mathematical LaTeX, a clean package set, and no duplicate package loads. Use suitable tools such as `amsmath`/`mathtools`, TikZ, `tcolorbox`, `microtype`, `booktabs`, `tabularx`, `hyperref` only as needed. Avoid obsolete `\rm`, `\bf`, `\it` definitions.

- When a quantity or expression is deliberately set equal to zero as a
  condition to solve (for example, finding a zero of a function), mark the
  target equality with `\overset{!}{=}`. Do not use this notation for ordinary
  identities or for results that merely happen to equal zero.
- Write function limits as `\lim_{x\to a}f(x)=L`, including the analogous
  notation at infinity. Do not introduce the alternative `f(x)\to L`.

### Analytic-geometry notation
- Name distinct points with distinct uppercase letters such as $P$, $Q$, and
  $R$. Use their direct connecting vectors such as $\overrightarrow{PQ}$ and
  $\overrightarrow{OP}$ unless separate position-vector symbols are needed
  later in a calculation.
- Write vector components with exactly one index, for example
  $\vec p=(p_1,p_2,p_3)^{\mathsf T}$ and
  $\vec q=(q_1,q_2,q_3)^{\mathsf T}$. Avoid double indices such as
  $x_{i,j}$ in introductory analytic geometry.
- Use $x_1,x_2,x_3$ for coordinate axes and the components of a general
  position vector $\vec x$. Choose other vector letters from their
  mathematical role rather than using $\vec x,\vec y,\vec z$ merely to
  distinguish several vectors.

For displayed transformation chains, align successive equivalence signs
vertically. Each line represents one complete equation; place the operation
that produces the following line in a separate right-hand column after a tall
vertical bar. For a continuing calculation of one expression, align at the
equals signs instead. Do not force simultaneous alignment at equivalence and
equals signs when this creates excessive horizontal gaps.

Use a separate left-aligned equation column in transformation chains so that
the first mathematical expression of every line starts at the same horizontal
position. Keep an introductory sentence that directly announces or explains a
longer transformation on the same PDF page as the transformation itself.

Choose one uniform row spacing for each complete transformation chain. Base it
on the tallest or most crowded line in that chain, increasing the spacing when
fractions, roots, stacked indices, or similar constructions need more room.
Never vary the row spacing within one transformation chain. For chains with
tall mathematical expressions, add the same explicit vertical space after
every row; changing only an array strut or `\arraystretch` may not create
visible clearance where fractions and roots already determine the row height.

Provide robust central shortcuts where useful, e.g. `\R`, `\N`, `\Q`, `\Z`, `\C`. `siunitx` may be available but is not a core requirement.

Provide calm semantic styling at least for Definition, Merke/Key Point, Beispiel/Example; Satz/Theorem and Hinweis/Remark are also reasonable. Proofs remain visually restrained initially.

Number `KeyPointBox` and `TheoremBox` independently within each chapter, so
their numbering starts with 1.1, 1.2, and so on in the first chapter.
Number `RemarkBox` independently within each chapter as well. Every remark
box also receives a concise descriptive heading through the `remark title`
option, so the automatic number remains visible. Preserve existing titles.

Prefer chapter/section/subsection numbering. Do not introduce `1.1.1.1`-style visible numbering without a concrete need.

## 10. Handwritten notes
`legacy/notes/handwritten/` is a temporary inbox only.

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
.\tools\build-all.ps1
```
and require all currently enabled builds to succeed.

If only German prose changes, compile at least affected German variant(s); do not synchronize English unless requested. After English sync, compile relevant English variants.

After visual/layout/TikZ/cloze/title-page changes, visually inspect affected PDF pages when tooling permits. Fix LaTeX errors and meaningful warnings before completion.

Codex may inspect `git status`, `git diff`, and `git log`. Do not commit, push, or publish changes unless explicitly asked. Before handing back substantial work, summarize meaningful changes and `git status`.

Keep generated LaTeX artifacts, logs, and auxiliary files out of source control.
The `build/` folder may contain the final PDFs and their `.synctex.gz` source
maps; the source maps are needed by the PDF viewer to jump from a PDF position
to the corresponding TeX location. Store all other auxiliary files, logs, and
caches under the user's local temporary folder. As an explicit project
exception, version exactly the four deliverables `build-de.pdf`,
`build-de-cloze.pdf`, `build-en.pdf`, and `build-en-cloze.pdf` from `build/`;
ignore all `.synctex.gz` files and every other generated PDF. Source,
configuration, documentation, and required branding assets belong in the
repository.

## 12. Legacy, README, and scope discipline
Except for the temporary inbox under `legacy/notes/handwritten/`, files under `legacy/` are historical references only. Do not include them in normal builds or copy their package setup wholesale. They may inform fonts, colors, and prior author conventions.

Keep `README.md` concise and human-facing. Explain project structure, the four
supported build variants and which are currently enabled, `tools/build-all.ps1`,
German-master/English-sync workflow, `common/config.tex`, branding, cloze usage,
handwritten-note workflow, and mandatory filename consultation.

When multiple technical solutions are valid, prefer the simpler, more maintainable one. If a decision materially affects author-facing filenames, folder names, or long-term content structure, ask before implementing it.
