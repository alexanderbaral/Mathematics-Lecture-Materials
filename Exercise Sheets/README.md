# Mathematik – Übungsblätter

Eigenständiges LuaLaTeX-Projekt für sieben Übungsblätter der TH Mannheim, Fakultät für Maschinenbau. Deutsch ist der Master. 101 Aufgaben wurden zunächst aus den sieben regulären alten Blättern in bisheriger Reihenfolge übernommen; derzeit sind 100 Aufgaben aktiv, weil Aufgabe 10 zur vollständigen Induktion für dieses Semester auskommentiert ist. Schreibfehler und dokumentierte mathematische Fehler wurden korrigiert. Die 164 referenzierten Lösungsseiten werden einheitlich oben um 18 mm und unten um 7 mm beschnitten und proportional bis zur verfügbaren Textbreite oder Texthöhe maximal vergrößert eingebunden; die Originaldateien bleiben unverändert.

## PDFs

Für den Überblick während der Entwicklung: **[Alle Aufgaben](build/de/_%C3%9Cbungsblatt%20Alle.pdf)** und **[Alle Aufgaben mit Lösungen](build/de_solutions/_%C3%9Cbungsblatt%20Alle%20%28mit%20L%C3%B6sungen%29.pdf)**. Beide Gesamt-PDFs enthalten Blatt-Lesezeichen und die Einzelblätter in der festgelegten Reihenfolge.

| Blatt | Aufgaben | Mit Musterlösungen |
| --- | --- | --- |
| 1 Grundlagen | [PDF](build/de/%C3%9Cbungsblatt%201%20-%20Grundlagen.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%201%20-%20Grundlagen%20%28mit%20L%C3%B6sungen%29.pdf) |
| 2 Lineare Gleichungssysteme | [PDF](build/de/%C3%9Cbungsblatt%202%20-%20Lineare%20Gleichungssysteme.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%202%20-%20Lineare%20Gleichungssysteme%20%28mit%20L%C3%B6sungen%29.pdf) |
| 3 Vektorrechnung | [PDF](build/de/%C3%9Cbungsblatt%203%20-%20Vektorrechnung.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%203%20-%20Vektorrechnung%20%28mit%20L%C3%B6sungen%29.pdf) |
| 4 Funktionen | [PDF](build/de/%C3%9Cbungsblatt%204%20-%20Funktionen.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%204%20-%20Funktionen%20%28mit%20L%C3%B6sungen%29.pdf) |
| 5 Differenzialrechnung | [PDF](build/de/%C3%9Cbungsblatt%205%20-%20Differenzialrechnung.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%205%20-%20Differenzialrechnung%20%28mit%20L%C3%B6sungen%29.pdf) |
| 6 Integralrechnung | [PDF](build/de/%C3%9Cbungsblatt%206%20-%20Integralrechnung.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%206%20-%20Integralrechnung%20%28mit%20L%C3%B6sungen%29.pdf) |
| 7 Komplexe Zahlen | [PDF](build/de/%C3%9Cbungsblatt%207%20-%20Komplexe%20Zahlen.pdf) | [PDF](build/de_solutions/%C3%9Cbungsblatt%207%20-%20Komplexe%20Zahlen%20%28mit%20L%C3%B6sungen%29.pdf) |

Die PDF-Links gelten nach lokalem Build. `build/` wird nicht versioniert. Englisch ist vorbereitet, aber noch nicht übersetzt; derzeit gibt es keine englischen PDFs.

## Schnelle Weiterentwicklung

Einmal im Projektordner starten:

```powershell
.\tools\develop.ps1
```

Der Entwicklungsmodus aktualisiert **immer beide deutschen Fassungen**: ohne und mit Musterlösungen, einschließlich beider Gesamt-PDFs. Er läuft bis `Strg+C`. Nach dem Speichern wartet er kurz, bis die Schreibvorgänge abgeschlossen sind, und baut nur betroffene Blätter mit bis zu vier Prozessen. Änderungen während eines Builds werden anschließend verarbeitet. Bei Fehlern bleibt die Überwachung aktiv; nach der nächsten Korrektur wird erneut gebaut.

Die beiden Gesamt-PDFs unter `build/de/_Übungsblatt Alle.pdf` und `build/de_solutions/_Übungsblatt Alle (mit Lösungen).pdf` in VS Code mit dem integrierten LaTeX-Workshop-PDF-Betrachter öffnen. Die Projektkonfiguration lädt ein geöffnetes PDF nach jedem Build automatisch neu und behält dabei die aktuelle Ansicht; das Skript selbst steuert den Betrachter nicht.

Für eine einzelne Aktualisierung ohne laufende Überwachung:

```powershell
.\tools\develop.ps1 -Once
```

In VS Code startet **Strg+Shift+B** ohne Aufgabenauswahl denselben einmaligen inkrementellen Build (`powershell -NoProfile -ExecutionPolicy Bypass -File "${workspaceFolder}/tools/develop.ps1" -Once`). Er verwendet vorhandene Zwischendateien, baut nur betroffene Blätter mit bis zu vier parallelen Prozessen und hält beide deutschen Fassungen einschließlich beider Gesamt-PDFs aktuell. Ausgaben und Fehler erscheinen im integrierten Terminal; anschließend endet die Aufgabe ohne dauerhafte Dateiüberwachung.

Alternativ in VS Code **Terminal → Aufgabe ausführen → Übungsblätter beim Speichern aktualisieren** wählen. Die normale LaTeX-Buildaktion führt eine einmalige inkrementelle Aktualisierung beider Fassungen aus. Für die Überwachung nur eine Instanz starten; gleichzeitige Builds werden durch eine Cache-Sperre verhindert.

Aufgabenänderungen betreffen das zugehörige Blatt in beiden Varianten; gemeinsame Layout- oder Builddateien betreffen alle Blätter. Fehlende oder veränderte Ergebnis-PDFs werden erneuert. Der erste Aufruf baut einen verlässlichen Vergleichsstand auf (mit vorhandenen TeX-Caches). Unveränderte Blätter und Gesamt-PDFs bleiben danach ohne erneuten latexmk-Aufruf erhalten. Dokumentation und `references/` lösen keine Builds aus.

`-Jobs 1` arbeitet seriell. `-Solutions on` oder `-Solutions off` beschränkt die Ausgabe nur auf ausdrückliche Auswahl; Standard ist `both`. Der reguläre vollständige Build bleibt zur Abschlusskontrolle verfügbar.

## Bauen

Die [gemeinsamen Voraussetzungen](../README.md#voraussetzungen) gelten auch für die Übungsblätter. Das Buildskript sucht Python im PATH und alternativ in der vorhandenen Codex-Laufzeit; `-Python <Pfad>` wählt ausdrücklich einen Interpreter. Vom Projektordner in PowerShell:

```powershell
# Standard: alle deutschen Aufgabenblätter ohne Lösungen
.\tools\build-all.ps1

# Alle sieben deutschen Blätter und beide Gesamt-PDFs
.\tools\build-all.ps1 -Language de -Solutions both

# Warm-Build: vorhandene Zwischendateien wiederverwenden (standardmäßig 4 Jobs)
.\tools\build-all.ps1 -Language de -Solutions both -Warm

# Serieller Vergleichslauf
.\tools\build-all.ps1 -Language de -Solutions both -Warm -Jobs 1

# Ein Blatt
.\tools\build-all.ps1 -Language de -Sheet vector_algebra -Solutions off
.\tools\build-all.ps1 -Language de -Sheet vector_algebra -Solutions on

# Erst nach ausdrücklich beauftragter Übersetzung
.\tools\build-all.ps1 -Language all -Solutions both
```

Bei lokal gesperrten PowerShell-Skripten ist ein einzelner Aufruf mit `powershell -NoProfile -ExecutionPolicy Bypass -File tools/build-all.ps1 -Language de -Solutions both` möglich; keine globale Ausführungsrichtlinie wird geändert.

Beide Dokumenttypen verwenden die gemeinsame Steuerung in ../_shared/tools/build_runtime.py.
Der gemeinsame Befehl zum Einbinden von Python-Dateien und Notebooks ist im
[Skript-README](../Skript/README.md#python-code-einbinden) dokumentiert.
Jeder Auftrag erhält einen eingefrorenen Quellstand. Es läuft höchstens ein Blattbau;
weitere Anforderungen werden zusammengefasst und der neueste Stand folgt nach dem laufenden Auftrag.
Die getrennte Warteschlange des Skripts blockiert die Blätter nicht.

Zuerst werden die betroffenen Aufgaben- und Lösungsblätter geprüft und veröffentlicht.
Anschließend entstehen die Sammel-PDFs im Hintergrund. Unveränderte Einzelblätter bleiben
einschließlich ihrer Dateizeit erhalten. Bei einem Fehler bleiben die letzten erfolgreichen
Einzel- und Sammel-PDFs verfügbar. Der Status nennt den fehlgeschlagenen Stand und das Log.
Ein identischer Fehler wird nicht automatisch erneut ausgeführt.

tools/build-all.ps1 bleibt als kompatibler Einstieg erhalten. Vorhandene Arbeitsverzeichnisse
unter %USERPROFILE%/AppData/Local/_tmp_LatexCache/mathematics_exercise_sheets/latex_runs/
werden standardmäßig wiederverwendet. -Warm und -Incremental bleiben als Kompatibilitätsoptionen
verfügbar; -Force erzwingt den Neubau. -Wait wartet zusätzlich auf die Sammel-PDFs.
Ein Teilauftrag aktualisiert eine Sammlung nur, wenn alle übrigen Blätter zum angeforderten
Quellstand passen; andernfalls bleibt die letzte erfolgreiche Sammlung erhalten.

tools/build-update.ps1 -Status zeigt veröffentlichten Stand, laufenden Auftrag und Warteschlange.
tools/build-update.ps1 -Wait aktualisiert beide deutschen Varianten und wartet bis zum Abschluss.
Die gemeinsame Sprachhierarchie bleibt unverändert: Deutsch ist Master, Englisch wird nur auf Auftrag nachgeführt.

build_timing.json und build_status.json bleiben im bestehenden lokalen Cache erhalten.
Das fortlaufende updates/timings.csv protokolliert zusätzlich Blattphase, Zusammenführung und Gesamtlauf.
Die Abhängigkeitserkennung berücksichtigt ../_shared. Die gemeinsame TikZ-Cache-Prüfung steht
über tools/build-cache.ps1 bereit; zurzeit enthalten die Blätter keine eigenständigen TikZ-Inhaltsgrafiken.

## Dokumentation

Die ausführlichen Unterlagen liegen in `docs/`: [Arbeitsregeln](docs/AGENTS.md), [Gestaltungsregeln](docs/DESIGN_GUIDE.md), [Projektstruktur](docs/PROJECT_STRUCTURE.md), [didaktischer Abgleich](docs/didactic_review.md) und [Migrationsstatus](docs/migration_status.md). Die kurze `AGENTS.md` im Hauptordner verweist auf die verbindlichen Regeln.

Einzige Skriptreferenz ist `../_shared/legacy/Exercise Sheets/build-de.pdf`. Neue Fassungen dort ablegen; es gibt keinen automatischen Zugriff auf das externe Skriptprojekt.

## Bearbeiten

- `../_shared/lecture_metadata.tex`: gemeinsamer Vorlesungstitel, Semester, Autor, Hochschule und Fakultät.
- `../_shared/style/branding_colors.tex`: gemeinsame Hochschulfarbe.
- `common/config.tex`: Beschnitt der Lösungs-PDFs, geordnete Blattliste und aktive Lösung pro Aufgabe. Blatt-ID, Kapitelzuordnung und Einstiegspfad sind getrennt gespeichert; spätere Unterteilungen sind möglich.
- `common/preamble.tex`, `common/commands.tex`, `common/layout.tex`: Pakete, Befehle und Gestaltung. Der untere Rand beträgt wie in der aktuellen Skriptimplementierung 1 cm.
- `main.tex`: einziger Dokumentkörper; vier Einstiege unter `tools/` wählen Sprache und Lösungsmodus.
- `content/chapters_de/<chapter>/_chapter.tex`: geordnete Aufgabendateien. Pro Sprache wird jede Aufgabe einmal gepflegt. Keine leeren EN-Kapitel angelegt.
- `content/resources/chapters/`: Lösungen, Bilder, bearbeitbare Grafikquellen und Codebeispiele; bytegleich aus dem früheren Archiv übernommen.
- `../_shared/legacy/Exercise Sheets/build-de.pdf`: aktuelle verfügbare Skript-PDF als reine Strukturreferenz. Skriptquellen gehören nicht zu diesem Projekt.
- [Migrationsstatus](docs/migration_status.md): Quellen, Teilpunkte, Lösungsstand, Korrekturen, offene Fragen und Prüfung.
- [Didaktischer Abgleich](docs/didactic_review.md): erhaltene Zuordnung; spätere Skriptsynchronisierung offen.

`\UseExerciseSolution{<id>}` verwendet die zentrale Registrierung. `pdf` bindet Originalseiten ein, `none` kennzeichnet fehlende referenzierte Lösungen. `latex` ist nur mit Status `approved` zulässig. Getrennte fachliche Hinweise unterliegen über die Umgebung `Solution` demselben Lösungsschalter. Noch keine Handschrift wurde transkribiert oder ersetzt.

Die Original-Codebeispiele liegen unter `content/resources/chapters/<chapter>/code/`. Sie werden nicht ausgeführt oder als geprüfte Musterlösungen ausgegeben. Bekannte Auffälligkeiten stehen im Migrationsstatus.

Jede Aufgabe mit Überschrift, Teilaufgaben und Bildern steht in `ExerciseBlock`. Diese zentrale Umgebung hält sie auf einer Seite. Reicht der Restplatz nicht, beginnt sie auf der nächsten Seite. Nur bei Aufgaben, die selbst höher als eine ganze nutzbare Seite sind, sind interne Umbrüche erlaubt. Lösungen stehen außerhalb dieses Blocks. `tools/verify.py` kontrolliert die gemessene Aufgabenhöhe und die Anfangs-/Endseite in beiden deutschen Varianten.

## Prüfung und Weiterarbeit

`tools/inventory.py` erfasst Referenzdateien mit Prüfsummen und LaTeX-Abhängigkeiten. `tools/verify.py` prüft anhand der dauerhaft gespeicherten `tools/migration_manifest.json` die anfängliche Übernahme auf Vollständigkeit, Zahlen, Teilpunkte, Reihenfolge und Lösungsausschluss sowie die Gesamt-PDFs. Beide benötigen Python mit `pypdf`; Prüfergebnisse und Vorschaubilder liegen im lokalen Cache. `tools/render_review.py` rendert die Einzelblätter mit Poppler und erstellt Übersichten mit Pillow; die Gesamt-PDFs enthalten dieselben Seiten. Spätere Änderungen direkt in den gesetzten Quellen vornehmen; das Manifest beschreibt den initialen Vergleichsstand. Der überholte Startprompt und das einmalige Importskript sind entfernt.

Die früheren Zusatzvarianten wurden bei der Erstübernahme inventarisiert, aber nicht in die regulären Blätter gemischt. Der alte Übungsaufgabenordner ist auf Autorauftrag nach Sicherung der Ressourcen entfernt; Herkunft und Vergleichsdaten stehen im Migrationsmanifest. Das Skript ist Work in Progress; zusätzliche Kapitel und späterer didaktischer Abgleich bleiben möglich. Aktuelle Autorentscheidungen stehen oben in [Arbeitsregeln](docs/AGENTS.md).

Git-Remote: [alexanderbaral/Mathematics-Lecture-Materials](https://github.com/alexanderbaral/Mathematics-Lecture-Materials). Die Übungsblätter und das Skript gehören zum gemeinsamen Repository im übergeordneten Ordner `Lecture Materials`; beide ursprünglichen Historien sind erhalten.

## Lokaler Cache außerhalb von Google Drive

Die gemeinsame Datei `../_shared/tools/cache_paths.json` legt den Standardpfad unter %USERPROFILE% fest. `EXERCISE_SHEETS_CACHE` kann einen anderen absoluten Cachepfad festlegen. Dort liegen `workspace/` (aktuelle Arbeitskopie der benötigten Quellen einschließlich aller Grafiken und Lösungs-PDFs), `latex_runs/`, `texmf/`, `visual_review/` und die technischen JSON-Prüfberichte.

Das Buildskript aktualisiert die Arbeitskopie vor jedem Lauf und baut aus diesem lokalen Verzeichnis. Die Dateien im Projekt bleiben die maßgeblichen Quellen. Im synchronisierten `build/` liegen ausschließlich Ergebnis-PDFs; Renderings und Hilfsdateien gehören nicht dorthin. Die Gesamt-PDF wird automatisch aus den fertigen Einzelblättern erstellt.

Der Titelblock steht oben links, das unverzerrte Hochschullogo oben rechts. Erste Blattseiten haben keinen Punkt; auf Folgeseiten ist er 9 mm groß. Nummerierte Aufzählungen verwenden ausschließlich die schließende Klammer (`a)`, `b)`, Unterlisten `1)`, `2)`).
Die gemessenen Buildzeiten und die Empfehlung zur Parallelisierung stehen in [Build-Laufzeiten](docs/build_performance.md).

Bis zu vier Blattvarianten werden standardmäßig parallel gebaut. `-Jobs 1` baut seriell, `-Jobs 2` bis `-Jobs 16` begrenzen die Parallelität entsprechend. Die Arbeitskopie wird vor den Jobs vorbereitet; jeder Job verwendet ein eigenes Variantenverzeichnis. Pro Projekt weiterhin nur einen vollständigen Buildskript-Aufruf gleichzeitig starten.

Die Gesamt-PDFs werden im externen Cache anhand der Prüfsummen der geordneten Einzel-PDFs, Lesezeichentitel und des Zusammenführungsprogramms wiederverwendet. Bei Änderungen werden sie neu erstellt. Die Prüfung der Einzelvarianten läuft vorher immer; ein fehlgeschlagener oder unvollständiger Build darf keine veraltete Gesamt-PDF liefern.
