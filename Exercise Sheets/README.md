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

Voraussetzungen: TeX Live mit LuaLaTeX und latexmk; Fira Sans und Libertinus Math (hier über TeX Live verfügbar). Für die Gesamt-PDF Python mit `pypdf`; für Renderübersichten zusätzlich Poppler und Pillow. Python-Pakete bei Bedarf mit `python -m pip install -r tools/requirements.txt` installieren. Das Buildskript sucht Python im PATH und alternativ in der vorhandenen Codex-Laufzeit; `-Python <Pfad>` wählt ausdrücklich einen Interpreter. Vom Projektordner in PowerShell:

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

Jede Variante erhält einen eigenen Buildstatus und Hilfsdateien unter `%LOCALAPPDATA%/_tmp_LatexCache/mathematics_exercise_sheets/latex_runs/<variante>/<blatt>/<lauf>/`. Getrennte Läufe vermeiden das Überschreiben von Hilfsdateien, die ein Synchronisierungsdienst vorübergehend sperrt. Fehlende Inhalte oder Fehler liefern Exitcode 1; am betroffenen Ausgabepfad verbleibt keine alte PDF. Andere Varianten werden weiter bearbeitet. Der letzte Aufruf schreibt `build_status.json` im lokalen Cache. Ein Build führt keine Übersetzung durch. `-Force` erzwingt einen Neubuild. `-Warm` verwendet das jüngste vorhandene Arbeitsverzeichnis je Blatt/Variante mit PDF und latexmk-Zustand; latexmk prüft dort die Abhängigkeiten und baut bei Änderungen neu. Ohne passenden Cache erfolgt ein normaler Build. Die Optionen `-Warm` und `-Force` sind nicht kombinierbar. Ohne `-Warm` bleiben die bisherigen isolierten Neubuilds bestehen.

Bei vollständiger Blattauswahl erzeugt derselbe Aufruf automatisch `_Übungsblatt Alle.pdf` bzw. `_Übungsblatt Alle (mit Lösungen).pdf` je gewählter Sprache/Lösungsvariante. Nur erfolgreiche Einzel-PDFs aus diesem Lauf werden zusammengefügt; die Gesamt-PDF hat einen eigenen Buildstatus. Ein Teilbuild entfernt die betroffene alte Gesamt-PDF, damit sie nicht einen veralteten Entwicklungsstand zeigt. Für eine neue Gesamtübersicht den Befehl ohne `-Sheet` ausführen. Gedruckte Seitenzahlen bleiben blattweise; Lesezeichen erleichtern die Navigation.

Die Editor-Buildaktion ruft ebenfalls `tools/build-all.ps1` für alle deutschen Blätter und beide Lösungsmodi auf. Es gibt keinen separaten Direct-Build. `main.tex` bleibt der gemeinsame Dokumentkörper. Laufzeiten pro Blatt/Variante, PDF-Zusammenführung und Gesamtbuild stehen im lokalen Cache in `build_timing.json`; `build_status.json` enthält zusätzlich die Dauer jeder Ausgabe.

## Dokumentation

Die ausführlichen Unterlagen liegen in `docs/`: [Arbeitsregeln](docs/AGENTS.md), [Gestaltungsregeln](docs/DESIGN_GUIDE.md), [Projektstruktur](docs/PROJECT_STRUCTURE.md), [didaktischer Abgleich](docs/didactic_review.md) und [Migrationsstatus](docs/migration_status.md). Die kurze `AGENTS.md` im Hauptordner verweist auf die verbindlichen Regeln.

Einzige Skriptreferenz ist `references/build-de.pdf`. Neue Fassungen dort ablegen; es gibt keinen automatischen Zugriff auf das externe Skriptprojekt.

## Bearbeiten

- `common/config.tex`: Semester, Branding, geordnete Blattliste und aktive Lösung pro Aufgabe. Blatt-ID, Kapitelzuordnung und Einstiegspfad sind getrennt gespeichert; spätere Unterteilungen sind möglich.
- `common/preamble.tex`, `common/commands.tex`, `common/layout.tex`: Pakete, Befehle und Gestaltung. Der untere Rand beträgt wie in der aktuellen Skriptimplementierung 1 cm.
- `main.tex`: einziger Dokumentkörper; vier Einstiege unter `tools/` wählen Sprache und Lösungsmodus.
- `content/chapters_de/<chapter>/_chapter.tex`: geordnete Aufgabendateien. Pro Sprache wird jede Aufgabe einmal gepflegt. Keine leeren EN-Kapitel angelegt.
- `content/resources/chapters/`: Lösungen, Bilder, bearbeitbare Grafikquellen und Codebeispiele; bytegleich aus dem früheren Archiv übernommen.
- `references/build-de.pdf`: aktuelle verfügbare Skript-PDF als reine Strukturreferenz. Skriptquellen gehören nicht zu diesem Projekt.
- [Migrationsstatus](docs/migration_status.md): Quellen, Teilpunkte, Lösungsstand, Korrekturen, offene Fragen und Prüfung.
- [Didaktischer Abgleich](docs/didactic_review.md): erhaltene Zuordnung; spätere Skriptsynchronisierung offen.

`\UseExerciseSolution{<id>}` verwendet die zentrale Registrierung. `pdf` bindet Originalseiten ein, `none` kennzeichnet fehlende referenzierte Lösungen. `latex` ist nur mit Status `approved` zulässig. Getrennte fachliche Hinweise unterliegen über die Umgebung `Solution` demselben Lösungsschalter. Noch keine Handschrift wurde transkribiert oder ersetzt.

Die Original-Codebeispiele liegen unter `content/resources/chapters/<chapter>/code/`. Sie werden nicht ausgeführt oder als geprüfte Musterlösungen ausgegeben. Bekannte Auffälligkeiten stehen im Migrationsstatus.

Jede Aufgabe mit Überschrift, Teilaufgaben und Bildern steht in `ExerciseBlock`. Diese zentrale Umgebung hält sie auf einer Seite. Reicht der Restplatz nicht, beginnt sie auf der nächsten Seite. Nur bei Aufgaben, die selbst höher als eine ganze nutzbare Seite sind, sind interne Umbrüche erlaubt. Lösungen stehen außerhalb dieses Blocks. `tools/verify.py` kontrolliert die gemessene Aufgabenhöhe und die Anfangs-/Endseite in beiden deutschen Varianten.

## Prüfung und Weiterarbeit

`tools/inventory.py` erfasst Referenzdateien mit Prüfsummen und LaTeX-Abhängigkeiten. `tools/verify.py` prüft anhand der dauerhaft gespeicherten `tools/migration_manifest.json` die anfängliche Übernahme auf Vollständigkeit, Zahlen, Teilpunkte, Reihenfolge und Lösungsausschluss sowie die Gesamt-PDFs. Beide benötigen Python mit `pypdf`; Prüfergebnisse und Vorschaubilder liegen im lokalen Cache. `tools/render_review.py` rendert die Einzelblätter mit Poppler und erstellt Übersichten mit Pillow; die Gesamt-PDFs enthalten dieselben Seiten. Spätere Änderungen direkt in den gesetzten Quellen vornehmen; das Manifest beschreibt den initialen Vergleichsstand. Der überholte Startprompt und das einmalige Importskript sind entfernt.

Die früheren Zusatzvarianten wurden bei der Erstübernahme inventarisiert, aber nicht in die regulären Blätter gemischt. Der alte Übungsaufgabenordner ist auf Autorauftrag nach Sicherung der Ressourcen entfernt; Herkunft und Vergleichsdaten stehen im Migrationsmanifest. Das Skript ist Work in Progress; zusätzliche Kapitel und späterer didaktischer Abgleich bleiben möglich. Aktuelle Autorentscheidungen stehen oben in [Arbeitsregeln](docs/AGENTS.md).

Git-Remote: [alexanderbaral/Mathematics-ExerciseSheets](https://github.com/alexanderbaral/Mathematics-ExerciseSheets). Lokal verknüpft; noch keine Commits und kein Push.

## Lokaler Cache außerhalb von Google Drive

Der Cache liegt standardmäßig unter `%LOCALAPPDATA%/_tmp_LatexCache/mathematics_exercise_sheets/`. `EXERCISE_SHEETS_CACHE` kann einen anderen absoluten Cachepfad festlegen. Dort liegen `workspace/` (aktuelle Arbeitskopie der benötigten Quellen einschließlich aller Grafiken und Lösungs-PDFs), `latex_runs/`, `texmf/`, `visual_review/` und die technischen JSON-Prüfberichte.

Das Buildskript aktualisiert die Arbeitskopie vor jedem Lauf und baut aus diesem lokalen Verzeichnis. Die Dateien im Projekt bleiben die maßgeblichen Quellen. Im synchronisierten `build/` liegen ausschließlich Ergebnis-PDFs; Renderings und Hilfsdateien gehören nicht dorthin. Die Gesamt-PDF wird automatisch aus den fertigen Einzelblättern erstellt.

Der Titelblock steht oben links, das unverzerrte Hochschullogo oben rechts. Erste Blattseiten haben keinen Punkt; auf Folgeseiten ist er 9 mm groß. Nummerierte Aufzählungen verwenden ausschließlich die schließende Klammer (`a)`, `b)`, Unterlisten `1)`, `2)`).
Die gemessenen Buildzeiten und die Empfehlung zur Parallelisierung stehen in [Build-Laufzeiten](docs/build_performance.md).

Bis zu vier Blattvarianten werden standardmäßig parallel gebaut. `-Jobs 1` baut seriell, `-Jobs 2` bis `-Jobs 16` begrenzen die Parallelität entsprechend. Die Arbeitskopie wird vor den Jobs vorbereitet; jeder Job verwendet ein eigenes Variantenverzeichnis. Pro Projekt weiterhin nur einen vollständigen Buildskript-Aufruf gleichzeitig starten.

Die Gesamt-PDFs werden im externen Cache anhand der Prüfsummen der geordneten Einzel-PDFs, Lesezeichentitel und des Zusammenführungsprogramms wiederverwendet. Bei Änderungen werden sie neu erstellt. Die Prüfung der Einzelvarianten läuft vorher immer; ein fehlgeschlagener oder unvollständiger Build darf keine veraltete Gesamt-PDF liefern.
