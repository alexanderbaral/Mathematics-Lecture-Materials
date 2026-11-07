# Gestaltungsregeln

## Aktuelles Blattlayout

- Blatttitel im Kopf mit 28 pt und 32 pt Zeilenabstand setzen. Die Zeile „Mit Musterlösungen“ bleibt in beiden Varianten gleich hoch; im Aufgabenmodus unsichtbar mit `\phantom`. Dadurch steht der Autorenname in beiden Fassungen auf derselben Höhe.

- LuaLaTeX, KOMA-Script, A4 und 12 pt; Plus Jakarta Sans für Text, Libertinus Math für Mathematik.
- Seitenränder: links/rechts 15 mm, oben/unten 10 mm einschließlich Kopf- und Fußbereich. Die tatsächlich implementierten 10 mm unten aus der Designreferenz bleiben maßgeblich.
- `THMBlue` ist RGB (0,0,255). Text schwarz, ergänzende Angaben grau.
- Erste Seite jedes Blatts: Titelblock linksbündig, Hochschullogo rechtsbündig, beide oben unter Wahrung des Seitenrands. Kein Mannheimer Punkt. Keine separate Skripttitelseite und kein Inhaltsverzeichnis.
- Folgeseiten: Mannheimer Punkt 9 mm, rechts oben mit 7,5 mm horizontalem und 4,5 mm vertikalem Abstand. Kopfzeile mit Blattnummer/Thema, bei Lösungen zusätzlich Aufgabenbezug. Gemeinsame Fußzeile mit Semester und blattweiser Seitennummer.
- Brandingdateien unverzerrt laden. Brandingpfade stehen in `../_shared/style/branding.tex`, das Semester in `../_shared/lecture_metadata.tex` (relativ zum Produktordner). Das Layout steht in `common/layout.tex`.
- Jede Aufgabe einschließlich Überschrift, Teilaufgaben und Abbildungen bleibt in `ExerciseBlock` vollständig auf einer Seite. Bei fehlendem Restplatz nächste Seite; nur Aufgaben über einer ganzen nutzbaren Seite dürfen intern umbrechen. Lösungen gehören nicht in den Aufgabenblock.

## Lösungen und Beschnitt

Handschriftliche Lösungen bleiben als Original-PDFs gespeichert. Bei jeder Einbindung gelten dieselben Beschnittmaße: links 0 mm, unten 7 mm, rechts 0 mm, oben 18 mm. `SolutionPdfTrim` in `common/config.tex` steuert den Beschnitt zentral; `clip` blendet die alten farbigen Kopf- und grauen Fußleisten aus. Keine individuellen Ausnahmen, auch wenn einzelne Handschriftstriche hineinragen. Die beschnittene Fläche wird proportional maximal vergrößert, bis entweder die verfügbare Textbreite oder Texthöhe erreicht ist. Keine Streckung oder Stauchung; in der anderen Richtung darf Weißraum verbleiben. Kopf- und Fußzeile bleiben außerhalb der Lösungsfläche. Keine Transkription oder Übersetzung durch diesen Layoutschritt.

PDF-Einbindungen und gesetzte Lösungen verwenden denselben Lösungsschalter. Gesetzte Lösungen erst nach aufgabenbezogenem Auftrag und ausdrücklicher Freigabe aktivieren. Fachliche Korrekturhinweise klar von den Originalen trennen.

## Mathematik, Boxen und Grafiken

Boxgrundlage: hellgrau (`black!2`), eckige Ecken, keine umlaufende Kontur, linke semantische Linie; Innenabstände links 2,5 mm, rechts 2 mm, oben/unten 1,5 mm. Definitionen und Beispiele unteilbar; lange Lösungen dürfen an geeigneten Rechenschritten umbrechen. Keine schwarzen Formelrahmen.

Transformationen mit linksbündiger Gleichungsspalte, ausgerichteten Äquivalenzzeichen und Operation rechts hinter `\TransformOp`. Neue TikZ-Grafiken in semantisch benannten Ressourcendateien, Beschriftung in Fließtextgröße, keine verkleinernde Skalierung und keine Pfeilspitzen auf Winkelbögen. Farbe nur mit fachlicher Bedeutung. Optionale Schreibraster erst auf Auftrag.

## Fortlaufende Referenznutzung

Die Gestaltung wird eigenständig in diesem Leitfaden und `common/` gepflegt. `references/build-de.pdf` dient ausschließlich dazu, die aktuelle Skriptstruktur zu entnehmen. Der frühere Ordner `script_reference/` wurde auf Autorauftrag vollständig entfernt; es besteht keine Abhängigkeit zu den Skriptquellen.

Vor inhaltlicher Zuordnung und didaktischen Empfehlungen nach einer aktuelleren Skriptfassung in `references/` suchen. Sie hat für Voraussetzungen, Inhalte und Reihenfolge Vorrang. Verwendeten Stand im Migrations-/Didaktikbericht dokumentieren; uneindeutige Fassungen klären. Keine neuen Übungen allein aus der Designreferenz erzeugen.

Nach zentralen Layoutänderungen alle befüllten Varianten bauen und rendern. Die Gesamt-PDF übernimmt die Einzelblätter unverändert in ihrer festgelegten Reihenfolge; die ersten Seiten aller enthaltenen Blätter bleiben ohne Punkt.

Nummerierte Aufzählungen: ausschließlich schließende Klammer, also a), b) und in nummerischen Unterlisten 1), 2). Globale Vorgaben stehen in common/layout.tex. Handschriftliche Abbildungen bleiben davon ausgenommen.

Temporäre Renderings und Build-Arbeitsdateien einschließlich der lokalen Quellenkopie liegen außerhalb der Synchronisierung im projektbezogenen Ordner unter %LOCALAPPDATA%/_tmp_LatexCache/. Im Projekt-build/ ausschließlich fertige PDFs ablegen.

Kurze handschriftliche Antworten: `\Cloze` erzeugt ein leeres hellgraues Feld (18 mm breit, 5 mm hoch; Breite optional über `\Cloze[<Länge>]`). In Formeln auf der mathematischen Achse zentriert. Die Aufgabenfelder bleiben in beiden Lösungsmodi leer.
