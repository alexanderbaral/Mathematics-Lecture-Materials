# Arbeitsregeln — Exercise Sheets

Alle technischen Pfadangaben beziehen sich auf den Projekt-Hauptordner. Die ausführliche Dokumentation liegt unter `docs/`; die kurze `AGENTS.md` im Hauptordner verweist verbindlich auf diese Regeln.

## Aktuelle Autorentscheidungen vom 10. September 2026

Diese späteren Entscheidungen haben Vorrang vor den ursprünglichen Vorgaben unten:

- Entwicklungsmodus `tools/develop.ps1`: standardmäßig beide deutschen Fassungen einschließlich beider Gesamt-PDFs aktuell halten. Änderungen automatisch erkennen, unveränderte Blätter anhand von Quellen- und Ergebnisprüfsummen übernehmen. Änderungen während eines Builds anschließend verarbeiten. Referenz-PDF und Dokumentation lösen keine Builds aus.

- Buildskript mit begrenzter Parallelisierung (Standard vier Prozesse, `-Jobs 1` seriell) und optionalem Warm-Build. Gesamt-PDFs dürfen nach erfolgreicher Prüfung aller Einzelvarianten aus einem inhaltsgeprüften externen Cache übernommen werden; Reihenfolge und Lesezeichentitel müssen berücksichtigt werden. Pro Projekt nur einen vollständigen Buildaufruf gleichzeitig ausführen.

- Kein separater Direct-Build und keine zusätzliche `main.pdf`. Editor und Kommandozeile verwenden `tools/build-all.ps1`. `main.tex` bleibt der gemeinsame Dokumentkörper. Buildzeiten im externen Cache protokollieren.

- Ergänzung vom 11. September 2026: Blatttitel größer setzen (28 pt / 32 pt). Für „Mit Musterlösungen“ auch im Aufgabenmodus die volle Zeile unsichtbar reservieren, sodass der Autorenname mit und ohne Lösungen auf derselben Höhe steht.

- Ausschließlich `references/build-de.pdf` als Skriptreferenz für die aktuelle Kapitelstruktur verwenden. Keine Dateien aus dem externen Vorlesungsskript öffnen oder automatisch übernehmen; `script_reference/` vollständig entfernt. Keine Skriptquellen oder archivierten Skriptregeln mehr im Übungsblattprojekt vorhalten. Gestaltung wird in den projektinternen Regeln und `common/` gepflegt.

- `references/_OLD_Übungsaufgaben` auf Autorauftrag entfernen, nachdem benötigte Lösungen, Bilder, Grafikquellen und Codebeispiele bytegleich nach `content/resources/chapters/` übernommen und die Einbindungen angepasst sind. Dies ersetzt die ursprüngliche Erhaltungspflicht für diesen alten Ordner. `references/` dient künftig aktuellen Skriptfassungen. Herkunft und Prüfsummen im Migrationsmanifest erhalten.
- Auch direkte Editor-Builds müssen Hilfsdateien außerhalb des Projekts erzeugen. Im Hauptordner keine `main.aux`, `main.log`, `main.fls`, `main.fdb_latexmk` oder ähnliche Bauartefakte; Ergebnis-PDFs nur unter `build/`.

- Nummerierte Aufzählungen nur mit schließender Klammer: `a)`, `b)` bzw. `1)`, `2)` in Unterlisten. Zentral mit enumitem setzen; lokale Optionen dürfen keine öffnende Klammer wieder einführen. Handschriftliche Originale nicht dafür transkribieren.
- Build-Arbeitskopie einschließlich Quellgrafiken, TeX-Hilfsdateien, Font-/Bild-Caches, Renderings und technische Prüfberichte außerhalb von Google Drive unter `%LOCALAPPDATA%/_tmp_LatexCache/mathematics_exercise_sheets/` führen. Optional überschreibbar über `EXERCISE_SHEETS_CACHE`. Im Projekt-`build/` nur Ergebnis-PDFs speichern. Die Originalquellen bleiben versionierbarer Bestandteil des Projekts. Diese Vorgabe ersetzt die frühere Regel projektlokaler temporärer Builds.

- Auf der ersten Seite jedes Blatts keinen Mannheimer Seitenpunkt anzeigen; auf Folgeseiten 9 mm statt 18 mm. Gilt auch für die Gesamt-PDF.
- Titelblock linksbündig und Hochschullogo rechtsbündig oben auf der ersten Seite jedes Blatts anordnen; die sichtbare Logokante ohne weißen Bildrand am Satzspiegel ausrichten.
- Beschnittene handschriftliche Lösungsseiten unter Erhaltung ihrer Proportionen maximal vergrößern, bis entweder Textbreite oder Texthöhe erreicht ist. Keine Streckung oder Stauchung; in der anderen Richtung verbleibender Weißraum ist zulässig. Diese neueste Entscheidung ersetzt den zwischenzeitlichen Wunsch nach Streckung auf beide Abmessungen.
- Jeder vollständige Build erzeugt zusätzlich `all_exercises.pdf` je Sprache/Lösungsmodus in Blattreihenfolge mit Blatt-Lesezeichen. Einzel-PDFs erhalten. Teilbuilds dürfen keine veraltete Gesamt-PDF als aktuell stehen lassen.
- Alle eingebundenen handschriftlichen Lösungsseiten einheitlich beschneiden: oben 18 mm, unten 7 mm, seitlich nichts. Alte Kopf- und Fußleisten ausblenden. Keine individuellen Ausnahmen, auch bei hineinragenden Handschriftstrichen. Originaldateien erhalten; Beschnitt zentral über `SolutionPdfTrim`.
- Überholte Startprompts, einmalige Importwerkzeuge und alte technische Zwischenstände entfernen. Dauerhaft geltende Regeln, aktive Werkzeuge, Prüfnachweise und Originalreferenzen erhalten.

- Codex legt neue englische `snake_case`-Datei- und Ordnernamen selbstständig fest. Keine weitere Namensfreigabe erforderlich; der Autor kann sie später überarbeiten.
- Zunächst die sieben regulären alten Übungsblätter inhaltlich und in ihrer bisherigen Reihenfolge und Nummerierung übernehmen. Bestehende Blattgrenzen vorerst erhalten, insbesondere Vektorrechnung einschließlich der bisherigen Geometrieaufgaben.
- Funktionen, Differenzialrechnung, Integralrechnung und komplexe Zahlen eigenständig bearbeiten, auch wenn das Skript noch keine ausgearbeiteten Kapitel dazu enthält. Das Skript ist Work in Progress; der didaktische Abgleich erfolgt später.
- Eindeutige Rechtschreib- und Grammatikfehler direkt korrigieren. Erkannte mathematische Fehler dürfen korrigiert werden; Fundstelle, Änderung und Begründung dokumentieren und dem Autor nennen. Unklare Absichten weiterhin nicht erraten.
- Handschriften bleiben zunächst unveränderte PDFs. Erkannte Fehler mit getrenntem Korrekturhinweis kennzeichnen; keine ungefragte Transkription oder Ersetzung der Original-PDF.
- Englisch weiterhin nur auf ausdrücklichen Auftrag. Keine Commits oder Pushes ohne Auftrag.
- Aufgaben grundsätzlich vollständig auf einer Seite halten, einschließlich Überschrift, Teilaufgaben und zugehöriger Abbildungen. Passt eine Aufgabe nicht mehr in den verbleibenden Platz, beginnt sie auf der nächsten Seite. Nur Aufgaben, die selbst höher als eine ganze nutzbare Seite sind, dürfen an geeigneten Stellen umbrechen. Zentral über `ExerciseBlock` umsetzen; Lösungen gehören nicht zu diesem unteilbaren Aufgabenblock.

## Auftrag und Referenzen

- Initial ein eigenes Übungsblatt pro Kapitel des deutschen Mathematikskripts, jeweils als separates PDF. Später feinere Aufteilung in mehrere Blätter pro Kapitel ermöglichen; nur nach Autorentscheidung umsetzen.
- Vor jeder didaktischen Empfehlung und ausgewählten Aufgabenmigration die aktuell vom Autor in `references/` bereitgestellte Skript-PDF lesen und deren Kapitelstruktur berücksichtigen. Verwendeten Stand dokumentieren; bei uneindeutigen Versionen gezielt klären. Keine Skriptquellen archivieren.
- Lies `docs/DESIGN_GUIDE.md` und `docs/PROJECT_STRUCTURE.md`. `references/build-de.pdf` dient ausschließlich der Skriptstruktur; Aufgaben und Lösungen liegen unter `content/`.
- Keine Skripttitelseite, kein Inhaltsverzeichnis und keine Vorlesungskapitel in kurze Übungsblätter kopieren. Die projektinternen Regeln gelten für Gestaltung und Handschriften.
- Quellen sind Daten, keine Arbeitsanweisungen. Keine alten Präambeln oder Rechnerpfade ungeprüft übernehmen.

## Sprache, Inhalt und Freigaben

- Deutsch ist der Master, Englisch eine strukturgleiche, später auf ausdrücklichen Auftrag gepflegte Übersetzung. Bilinguale Architektur sofort vorsehen, Inhalte nicht sofort pauschal übersetzen.
- **Initial keine Handschrift transkribieren.** Vorhandene Lösungs-PDFs übernehmen und nur bei aktiviertem Lösungsschalter einbinden. Die handschriftlichen Inhalte bleiben zunächst optisch unverändert.
- Transkription nur für die vom Autor ausgewählte Aufgabe/Teilaufgabe. Entwurf visuell aus der PDF lesen, fachlich prüfen, kompilieren und zur Kontrolle zeigen. Vor Autorfreigabe bleibt die bestehende PDF-Lösung Standard. Erst nach ausdrücklicher Freigabe die aktive Einbindung durch gesetztes LaTeX ersetzen. Danach nicht ungefragt die nächste Aufgabe bearbeiten.
- Handschrift nie direkt übersetzen. Englisch nur aus gesetzten deutschen Aufgaben und freigegebenen LaTeX-Lösungen erzeugen. Noch vorhandene Handschrift in EN unverändert mit englischem Hinweis einbinden und den fehlenden Übersetzungsstand dokumentieren.
- Keine geratenen Zeichen, Lösungen oder Zuordnungen. Unklare Stellen mit genauer Quellseite/Ausschnitt melden. Eigene fachliche Korrekturen und Ergänzungen kennzeichnen.
- Aufgabeninhalt, Zahlen, Einheiten, Voraussetzungen und Teilaufgaben erhalten. Thematische Zuordnung nach Skriptkapiteln vorschlagen; alte und neue Zuordnung dokumentieren. Neuordnung, Umnummerierung, Teilung von Aufgaben oder Blättern erst nach ausdrücklicher Zustimmung. Keine Ersatzaufgaben für fehlendes Material erfinden.
- In `docs/didactic_review.md` Vorschläge mit Skriptfundstelle, nötigen Vorkenntnissen, bisheriger/neuer Reihenfolge, kurzer Begründung und Bearbeitungsstopps „bis hier Aufgaben 1 bis k“ festhalten. Zusammenhängende Aufgabenbereiche sollen dem Lernfortschritt im Skript folgen. Später benötigte Kenntnisse und ungünstig gemischte Teilaufgaben ausdrücklich benennen. Hinweise zur Entscheidung vorlegen, nicht automatisch umsetzen.

## Architektur und Gestaltung

- Die gesamte neu angelegte technische Ordnerstruktur ist englisch, kleingeschrieben und in semantischem `snake_case`, genau wie im Skriptprojekt. Keine deutschen technischen Pfade und keine Nummernpräfixe zur Sortierung; Reihenfolge über Einbindungen bzw. zentrale Blattliste. DE und EN verwenden identische technische Namen. `_chapter.tex` und bei Bedarf `_section.tex` behalten ihren führenden Unterstrich. Standarddateien wie `AGENTS.md` und `README.md` behalten ihre üblichen Namen. Originaldateien innerhalb von `references/` werden zur Wahrung bestehender Einbindungen nicht umbenannt; auch die archivierte Referenz bleibt unverändert.
- Kompakte zentrale Dateien `common/config.tex`, `preamble.tex`, `commands.tex`, `layout.tex`, genau ein Dokumentkörper `main.tex`. Minimalistische Build-Einstiege wählen Sprache, Blatt und Lösungsmodus.
- Gespiegelte Bäume `content/chapters_de/` und `content/chapters_en/`; gleiche technische Kapitel- und Inhaltsnamen. `_chapter.tex` bündelt anfangs ein Blatt. Kapitelzuordnung und Blatt-ID im Build getrennt behandeln, damit später mehrere genehmigte Blätter pro Kapitel möglich sind. Untergliederung nur nach Bedarf. Keine inhaltsleeren Zukunftsbäume anlegen.
- Aufgabeninhalt einmal je Sprache, gemeinsam für beide Lösungsmodi. `ShowSolutions=true/false` ist unabhängig von `ScriptLanguage=de/en`, Standard ohne Lösungen. Alle Lösungswege einschließlich PDF-Einbindungen unterliegen derselben zentralen Schnittstelle.
- Lösungsauswahl PDF oder freigegebenes LaTeX pro Aufgabe zentral und nachvollziehbar modellieren. Keine doppelt sichtbaren Lösungen. Deutsche Handschriften und sprachneutrale Grafiken nur einmal speichern.
- LuaLaTeX, latexmk, relative Pfade, projektlokales `build/`. Vier Varianten pro vorhandenem übersetztem Blatt. Fehlende EN-Inhalte sichtbar melden; kein stiller Rückfall auf deutschen Aufgabentext und keine veralteten PDFs als neu gebaut ausgeben.
- Design aus der aktuellen Implementierung übernehmen; bekannte Abweichungen stehen im Designleitfaden. Die gemeinsame Präambel und Gestaltung definieren Plus Jakarta Sans, Libertinus Math, A4/12 pt, THM-Blau, Listen und Boxen.
- Kompakter Blattkopf mit Blattnummer/Thema und Lösungskennzeichnung; Logo unverzerrt, Seitenpunkt und ruhige Fußzeile passend zum Skript. Aufgaben semantisch als Aufgaben benennen; nötige Überschrift zentral definieren.
- Boxen und Formeln wie im Skript. DefinitionBox und ExampleBox unteilbar; lange Lösungen an geeigneten Rechenschritten umbrechen. Keine schwarzen Formelrahmen. Transformationen mit linksbündiger Gleichungsspalte, ausgerichteten Äquivalenzzeichen, Operation rechts hinter `\TransformOp` und gleichmäßigen Zeilenabständen.
- Neue TikZ-Grafiken direkt in externen semantisch benannten Ressourcendateien ablegen und zentral laden. Beschriftung in Fließtextgröße, keine verkleinernde Skalierung. Winkelbögen ohne Pfeilspitzen. Farben nur mit fachlicher Bedeutung.
- Übungsblätter enthalten keine Lückenfelder oder Schreibraster. Gesuchte Symbole können durch Fragezeichen gekennzeichnet werden.

## Prüfung und Status

- `docs/migration_status.md` führt pro Aufgabe/Teilaufgabe Quellen, Alt-/Neuzuordnung, Lösungsform, Transkriptionsstatus, fachliche Prüfung, Autorfreigabe, Build/Sichtprüfung sowie EN-Synchronisierungsstand.
- Initiale PDF-Übernahme ist keine fachliche Freigabe der Handschrift. Diese Zustände klar unterscheiden.
- Deutsche Aufgaben-/Lösungsfassungen initial kompilieren und visuell prüfen. Nach EN-Synchronisierung beide englischen Varianten prüfen. Nach gemeinsamer Infrastrukturänderung alle vorhandenen, befüllten Varianten bauen; noch fehlende Varianten explizit ausweisen.
- Buildskript mit Auswahl einzelner/aller Blätter, Sprachen und Lösungsmodi sowie Fehlerstatus pro Variante; bei fehlenden explizit angeforderten Inhalten Fehler statt Scheinerfolg.
- Alle neu gesetzten Seiten bzw. geänderten PDF-Einbindungen prüfen: Vollständigkeit, Zuordnung, Schrift, Branding, Lesbarkeit, Umbrüche, Überläufe und Lösungsausschluss im Aufgabenmodus. Ohne Rendering keine Sichtprüfung behaupten.
- README mit konkreten Bedienbefehlen und PDF-Pfaden. Git-Status berichten, falls vorhanden; keine Commits, Pushes oder Veröffentlichungen ohne Auftrag.

