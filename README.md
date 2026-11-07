# Mathematics Lecture Materials

Gemeinsames Repository: [alexanderbaral/Mathematics-Lecture-Materials](https://github.com/alexanderbaral/Mathematics-Lecture-Materials).

Dieser Ordner bündelt Skript, Exercise Sheets und den gemeinsamen Bereich _Shared.

- Skript: Vorlesungsskript mit deutscher Voll- und Lückenversion.
- Exercise Sheets: Aufgabenblätter und Musterlösungen.
- _Shared/style: vorgesehen für gemeinsame Stildefinitionen.
- _Shared/commands: vorgesehen für gemeinsame mathematische, Sprach- und Codebefehle.
- _Shared/resources: vorgesehen für gemeinsame Grafiken, Symbole und Schriften.
- _Shared/tools: gemeinsame Bausteuerung und Tests.
- _Shared/legacy: gemeinsame Ablage für unverändert erhaltene Altmaterialien.

## VS Code

Strg+Shift+B startet in diesem Hauptordner sowie in `Skript` und `Exercise Sheets` denselben
gemeinsamen Bau. Die feste Datei `build/Vorschau.pdf` im Hauptordner enthält geänderte
Abschnitte des deutschen Vollskripts und betroffene Übungsblätter, jeweils ohne und mit
Lösungen direkt hintereinander. Beim nächsten Auftrag werden die Änderungen seit der letzten
erfolgreichen gemeinsamen Vorschau betrachtet. Ohne Inhaltsänderung bleibt die Vorschau erhalten.

Die zusätzliche VS-Code-Aufgabe „Lecture Materials: Vorschau zusätzlich mit Lückenfassung“
ergänzt die deutsche Lückenfassung direkt nach dem jeweiligen Vollskriptabschnitt.
PDF-Lesezeichen und die Seitenbezeichnungen im Viewer kennzeichnen Herkunft und Variante.
Es werden keine Deckblätter, Kopfzeilen oder sonstigen Inhalte in die Seiten eingefügt.
Die Zusammenführung bewahrt Inhalt, Seitenmaße und Seitenumbrüche der Ausgangs-PDFs.
Die isolierte Skript-Abschnittsvorschau kann dennoch vom Gesamt-PDF abweichende Umbrüche,
Nummerierungen und Verweise haben. Für die abschließende Layoutkontrolle gilt das Gesamt-PDF.

Nach Veröffentlichung der Vorschau starten die Vollbauten im Hintergrund. Unveränderte
Ergebnisse und bestehende TikZ- und LaTeX-Caches werden weiterverwendet. Skript und Blätter
haben jeweils einen gegen parallele Vollbauten gesperrten Worker. Während er arbeitet,
ersetzt ein neuer Auftrag den zuvor wartenden Auftrag. Ein laufender Vollbau wird beendet.
Vorschau und Vollbau teilen bei Übungsblättern den geschützten Blatt-Cache. Ein gerade
laufender Blattbau kann deshalb die Blattvorschau kurz verzögern.

## Stand der Umstellung

Beide Projekte gehören zu einem gemeinsamen Git-Repository in diesem Hauptordner.
Die ursprünglichen Historien von Mathematics-LectureNotes und Mathematics-ExerciseSheets
sind über Import-Merge-Commits vollständig erhalten. Es gibt keine verschachtelten Git-Repositories.

_Shared ist als gemeinsamer Bereich vorbereitet. Die aktiven Makros und Gestaltungsdateien
liegen derzeit weiterhin in den jeweiligen common-Verzeichnissen. Ihre Auslagerung muss
mit der Abhängigkeitserkennung der beiden Bauabläufe abgestimmt werden.

Die bisherigen persistenten Caches außerhalb des Projektordners werden weiterverwendet.
Beide Produkte verwenden die gemeinsame Steuerung in `_Shared/tools/build_runtime.py`: unveränderliche
Quellstände, unabhängige Warteschlangen, Prozesssperren, sichere PDF-Veröffentlichung und fortlaufende
Zeitprotokolle. Ein laufender Bau wird beendet; anschließend folgt nur der neueste vorgemerkte Stand.
Bei Fehlern bleiben die letzten erfolgreichen PDFs erhalten. Ein identischer fehlerhafter Stand
wird ohne ausdrücklichen neuen Auftrag nicht wiederholt gebaut.

`python _Shared/tools/build.py status --product all` zeigt beide Bauzustände. Mit
`python _Shared/tools/build.py full --product all` wird bis zum Abschluss beider Produkte gewartet.
Aktive Änderungen unter `_Shared` werden bei beiden Dokumenttypen berücksichtigt. `_Shared/legacy`
ist ausgenommen: Dort abgelegte Altmaterialien lösen keine Bauten aus. Die gemeinsame
Abhängigkeitsprüfung für TikZ liegt in `_Shared/tools/build-cache.ps1`; bestehende Grafik-Caches bleiben gültig.
Die lokale Speicherüberwachung der Blätter bleibt als zusätzliche Aufgabe verfügbar.

Zeitprotokolle liegen außerhalb des Projekts: für das Skript unter
`%USERPROFILE%/AppData/Local/Temp/Mathematik1-Skript/updates/timings.csv`, für die Blätter unter
`%USERPROFILE%/AppData/Local/_tmp_LatexCache/mathematics_exercise_sheets/updates/timings.csv`.
Deutsch bleibt die Masterfassung, Englisch folgt auf ausdrücklichen Auftrag.

`_Shared/tools/build_variants.json` hält die freigegebenen Sprachen fest. Für das Skript
aktiviert jeder Eintrag in `script_languages` Voll- und Lückenfassung. Für Übungsblätter
aktiviert `sheet_languages` beide Lösungsmodi pro Blatt-ID; `*` bedeutet alle registrierten
Blätter. Aktuell ist Deutsch freigegeben, Englisch noch nicht. Eine englische Datei allein
gilt nicht als Freigabe. Eine freigegebene, aber fehlende Übersetzung meldet einen Fehler.

Gemeinsame Bedienung im Terminal:

```powershell
python _Shared/tools/build.py update
python _Shared/tools/build.py update --cloze
python _Shared/tools/build.py update --wait
python _Shared/tools/build.py status
```

Das zusätzliche Vorschau-Zeitprotokoll liegt unter
`%USERPROFILE%/AppData/Local/Temp/Mathematik1-Skript/updates/joint-preview/timings.csv`.

