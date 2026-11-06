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

Lecture Materials als Ordner öffnen. Strg+Shift+B bietet die Auswahl Skript, Übungsblätter oder Beides.
Der Skriptbau erzeugt zunächst die Vorschau und aktualisiert danach die Vollversionen im Hintergrund.
Der Übungsblattbau aktualisiert die geänderten Aufgaben- und Lösungsversionen.
Die fertigen Einzelblätter werden zuerst veröffentlicht, die Sammel-PDFs folgen im Hintergrund.
Die beiden Unterordner können weiterhin einzeln in VS Code geöffnet werden; ihre bisherigen
Standardaufgaben bleiben verfügbar.

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
Die bisherige Standardbedienung per Strg+Shift+B und die lokale Speicherüberwachung der Blätter bleiben verfügbar.

Zeitprotokolle liegen außerhalb des Projekts: für das Skript unter
`%USERPROFILE%/AppData/Local/Temp/Mathematik1-Skript/updates/timings.csv`, für die Blätter unter
`%USERPROFILE%/AppData/Local/_tmp_LatexCache/mathematics_exercise_sheets/updates/timings.csv`.
Deutsch bleibt die Masterfassung, Englisch folgt auf ausdrücklichen Auftrag.

