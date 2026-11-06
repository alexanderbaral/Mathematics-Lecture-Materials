# Mathematics Lecture Materials

Gemeinsames Repository: [alexanderbaral/Mathematics-Lecture-Materials](https://github.com/alexanderbaral/Mathematics-Lecture-Materials).

Dieser Ordner bündelt Skript, Exercise Sheets und den vorbereiteten gemeinsamen Bereich Shared.

- Skript: Vorlesungsskript mit deutscher Voll- und Lückenversion.
- Exercise Sheets: Aufgabenblätter und Musterlösungen.
- Shared/style: vorgesehen für gemeinsame Stildefinitionen.
- Shared/commands: vorgesehen für gemeinsame mathematische, Sprach- und Codebefehle.
- Shared/resources: vorgesehen für gemeinsame Grafiken, Symbole und Schriften.

## VS Code

Lecture Materials als Ordner öffnen. Strg+Shift+B bietet die Auswahl Skript, Übungsblätter oder Beides.
Der Skriptbau erzeugt zunächst die Vorschau und aktualisiert danach die Vollversionen im Hintergrund.
Der Übungsblattbau aktualisiert die geänderten Aufgaben- und Lösungsversionen.
Die beiden Unterordner können weiterhin einzeln in VS Code geöffnet werden; ihre bisherigen
Standardaufgaben bleiben verfügbar.

## Stand der Umstellung

Beide Projekte gehören zu einem gemeinsamen Git-Repository in diesem Hauptordner.
Die ursprünglichen Historien von Mathematics-LectureNotes und Mathematics-ExerciseSheets
sind über Import-Merge-Commits vollständig erhalten. Es gibt keine verschachtelten Git-Repositories.

Shared ist als gemeinsamer Bereich vorbereitet. Die aktiven Makros und Gestaltungsdateien
liegen derzeit weiterhin in den jeweiligen common-Verzeichnissen. Ihre Auslagerung muss
mit der Abhängigkeitserkennung der beiden Bauabläufe abgestimmt werden.

Die bisherigen persistenten Caches außerhalb des Projektordners werden weiterverwendet.
Deutsch bleibt die Masterfassung, Englisch folgt auf ausdrücklichen Auftrag.

