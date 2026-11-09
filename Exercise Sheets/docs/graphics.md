# Grafiken der Übungsblätter

Alle zwölf TikZ-Abbildungen sind freigegeben. Sechs sind in den Aufgaben eingebunden, sechs stehen als Zusatzressourcen bereit.

| Kapitel | TikZ-Datei | Verwendung |
| --- | --- | --- |
| vector_algebra | triangle_projection.tex | Blatt 3, Aufgabe 10 |
| vector_algebra | thales_theorem.tex | Blatt 3, Aufgabe 11 |
| functions | squeeze_theorem.tex | Blatt 4, Aufgabe 9 |
| differential_calculus | alley_transport.tex | Blatt 5, Aufgabe 12 |
| differential_calculus | distance_optimization.tex | Blatt 5, Aufgabe 13 |
| integral_calculus | area_between_functions.tex | Blatt 6, Aufgabe 7 |
| integral_calculus | cone_rotation.tex | Zusatzressource, nicht eingebunden |
| integral_calculus | fall_equation.tex | Zusatzressource, nicht eingebunden |
| integral_calculus | semicircle.tex | Zusatzressource, nicht eingebunden |
| integral_calculus | integration_differentiation.tex | Zusatzressource, nicht eingebunden |
| supplementary | vector_geometry.tex | Zusatzressource, nicht eingebunden |
| supplementary | zoo_enclosures.tex | Zusatzressource, nicht eingebunden |

Die Grafikquellen liegen in `content/resources/chapters/<Kapitel>/tikz/`.
Aufgaben binden die Dateien mit `\CachedTikzFigure{content/resources/chapters/<Kapitel>/tikz/<Datei>.tex}` ein.

Das Migrationsmanifest dokumentiert unter `superseded_assets` die ersetzten PNG- und PowerPoint-Quellen,
ihre Prüfsummen und die jeweiligen TikZ-Dateien.
