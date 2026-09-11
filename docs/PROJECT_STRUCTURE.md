# Projektstruktur

Die verbindlichen Arbeitsregeln stehen in `docs/AGENTS.md`, die Bedienbefehle in `README.md` und die Gestaltung in `docs/DESIGN_GUIDE.md`.

## Aktiver Aufbau

```text
AGENTS.md                      kurzer Einstieg in die projektweiten Arbeitsregeln
docs/                          Arbeitsregeln, Design, Struktur, Didaktik und Migrationsstatus
common/                        zentrale Konfiguration, Befehle und Gestaltung
main.tex                       einziger LaTeX-Dokumentkörper
content/chapters_de/            sieben Kapitel mit _chapter.tex und Aufgabendateien
content/resources/shared/      gemeinsam verwendete Brandingdateien
content/resources/chapters/    Lösungen, Bilder, Code und ergänzende Ressourcen
tools/                         Build, PDF-Zusammenführung, Inventar und Prüfung
references/build-de.pdf        aktuelle Skript-PDF, ausschließlich Strukturreferenz
build/de/                      deutsche Aufgaben-PDFs und all_exercises.pdf
build/de_solutions/             deutsche Lösungs-PDFs und all_exercises.pdf
Lokaler Cache/latex_runs/      isolierte Buildläufe und Zusammenführungslisten
Lokaler Cache/visual_review/   aktuelle Renderings zur Sichtprüfung
```

Neue Inhaltsnamen sind englisch, kleingeschrieben und in `snake_case`. Die Reihenfolge ergibt sich aus den Einbindungen und `\DeclareSheet` in `common/config.tex`, nicht aus Dateinummern. Originalnamen in den Referenzordnern bleiben erhalten.

## Inhalte und Varianten

Die sieben IDs lauten `fundamentals`, `linear_systems`, `vector_algebra`, `functions`, `differential_calculus`, `integral_calculus`, `complex_numbers`. Die ursprüngliche Reihenfolge und Nummerierung bleiben bestehen. Kapitelzuordnung und Blatt-ID werden getrennt geführt, damit nach Autorentscheidung mehrere Blätter je Kapitel möglich sind.

Jede Aufgabendatei enthält einen `ExerciseBlock` und anschließend die zentral geschaltete Lösung. `ShowSolutions` und `ScriptLanguage` sind unabhängig. Die Lösungsauswahl PDF/freigegebenes LaTeX/fehlend steht pro Aufgabe in `common/config.tex`.

Englisch wird erst auf ausdrücklichen Auftrag unter `content/chapters_en/` mit denselben technischen Namen ergänzt; bis dahin keine leeren Zukunftsordner. Englische Ausgaben werden später unter `build/en/` und `build/en_solutions/` erzeugt. Fehlende Inhalte sind Buildfehler, kein Anlass für einen deutschen Rückfall.

## Gesamt-PDF und Prüfunterlagen

Ein vollständiger Build fügt die frisch erzeugten Einzel-PDFs pro Variante in Registry-Reihenfolge zu `all_exercises.pdf` zusammen. Lesezeichen springen zum jeweiligen Blatt; die gedruckten Seitennummern bleiben blattweise erhalten. Ein Teilbuild entfernt die betroffene veraltete Gesamt-PDF; zum Aktualisieren alle Blätter bauen.

`docs/migration_status.md` hält Quellen, Korrekturen, Lösungsstand und Prüfstatus fest. `docs/didactic_review.md` hält den späteren Abgleich mit dem wachsenden Skript offen. `tools/migration_manifest.json` bleibt die Vergleichsgrundlage für die unveränderten Aufgabenressourcen und ihre Übernahme. Die Skriptreferenz wird ausschließlich unter `references/build-de.pdf` gelesen und auf Lesbarkeit geprüft; sie darf durch eine neue Autorversion ersetzt werden. Das Quellinventar und die Prüfwerkzeuge bleiben zur weiteren Entwicklung erhalten; der einmalige Startprompt und Importgenerator wurden entfernt.

Der lokale Cache liegt außerhalb von Google Drive unter %LOCALAPPDATA%/_tmp_LatexCache/mathematics_exercise_sheets/ (überschreibbar mit EXERCISE_SHEETS_CACHE). Eine aktualisierte Arbeitskopie der Buildquellen einschließlich Grafiken liegt dort unter workspace/. Im Projekt-build/ verbleiben nur Ergebnis-PDFs.

Editor und Kommandozeile verwenden ausschließlich `tools/build-all.ps1`; kein separater Direct-Ausgabeordner. Die zentrale `main.tex` dient allen Varianten als gemeinsamer Dokumentkörper. `build_timing.json` im lokalen Cache protokolliert Vorbereitung, Einzelbuilds, PDF-Zusammenführung und Gesamtdauer.

`tools/build_sheet.ps1` führt genau einen Blatt-/Variantenbuild aus; `tools/build-all.ps1` steuert bis zu `-Jobs` parallele Prozesse (Standard 4). Gesamt-PDFs werden zentral nach Abschluss aller Jobs erstellt oder aus dem inhaltsgeprüften lokalen Cache übernommen. `-Warm` ist mit Parallelisierung kombinierbar.

`tools/develop.ps1` startet `tools/watch_build.py` zur Überwachung; `-Once` aktualisiert einmalig. Beide deutschen Varianten sind Standard. `tools/incremental_build.py` verwaltet Quellen-/Ergebnisprüfsummen ausschließlich im externen Cache. Der Entwicklungsbuild umfasst logisch immer alle registrierten Blätter, startet aber nur Jobs für veränderte oder fehlende Ausgaben. Unveränderte Gesamtausgaben bleiben bestehen. Reguläre explizite Teilbuilds behalten ihre bisherige Semantik.
