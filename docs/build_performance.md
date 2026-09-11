# Build-Laufzeiten

Messung vom 11. September 2026 auf Snapdragon X X1E80100 (12 CPU-Kerne). Ein serieller vollständiger Build mit vorhandenen Font-Caches, aber neuen TeX-Arbeitsverzeichnissen; kein Mittelwert mehrerer Läufe und kein Kaltstartbenchmark. Laufzeiten sind Wandzeiten einschließlich der jeweiligen Ausgabeübernahme. Währenddessen kein zweiter Build gestartet.

Befehl: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/build-all.ps1 -Language de -Solutions both`

| Schritt | Sekunden |
| --- | ---: |
| Vorbereitung | 0.47 |
| Sieben Aufgaben-PDFs | 132.65 |
| Sieben Lösungs-PDFs | 173.82 |
| Gesamt-PDF Aufgaben | 0.78 |
| Gesamt-PDF Lösungen | 10.57 |
| Gesamtdauer einschließlich übriger Steuerung | 318.74 |

| Blatt | Ohne Lösungen (s) | Mit Lösungen (s) |
| --- | ---: | ---: |
| fundamentals | 18.84 | 23.29 |
| linear_systems | 19.04 | 23.33 |
| vector_algebra | 19.05 | 24.11 |
| functions | 18.04 | 27.42 |
| differential_calculus | 19.12 | 27.10 |
| integral_calculus | 19.98 | 24.81 |
| complex_numbers | 18.58 | 23.76 |

## Empfehlung

Zunächst vier gleichzeitige LuaLaTeX/latexmk-Jobs erproben. Rund 96 % der gemessenen Gesamtzeit entfallen auf die unabhängig baubaren Einzelvarianten. Die vorhandenen getrennten Arbeitsverzeichnisse sind dafür geeignet. Arbeitskopie und Font-Cache vor den parallelen Jobs vorbereiten; Ergebnisse und Gesamt-PDFs erst nach Abschluss der Jobs zentral verarbeiten. Nicht mehrere vollständige Aufrufe des bisherigen Buildskripts gleichzeitig starten: Sie würden dieselbe Arbeitskopie, Ergebnis-PDFs und Statusdateien bearbeiten.

Eine Beschleunigung wurde noch nicht parallel gemessen; vier Prozesse garantieren keinen Faktor vier. CPU-Auslastung, Speicherbedarf und gemeinsame Datenträgerzugriffe müssen im Vergleichslauf geprüft werden. Stand dieser ersten Messung: Parallelisierung war noch nicht implementiert; der spätere Vergleich folgt unten.

Zusätzlich könnte die Wiederverwendung gültiger Hilfsdateien im externen Cache Entwicklungsbuilds beschleunigen. Der ursprüngliche Build ohne `-Warm` erzeugt pro Aufruf neue Laufverzeichnisse; damit kann latexmk unveränderte Dokumente nicht überspringen. Eine solche Änderung müsste die bisherige Trennung der Varianten und den zuverlässigen Umgang mit fehlgeschlagenen Builds erhalten.

## Fortlaufende Messung

`tools/build-all.ps1` schreibt bei jedem Lauf `build_timing.json` im externen Projektcache mit Vorbereitung, Einzelzeiten, Zusammenführungszeiten und Gesamtzeit. `build_status.json` enthält ebenfalls die Einzelzeiten. Die Rohdaten werden mit dem nächsten Lauf ersetzt; diese dokumentierte Messung bleibt erhalten. Im Projekt entstehen keine zusätzlichen Messartefakte.

## Warm-Build vom 11. September 2026

Befehl: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/build-all.ps1 -Language de -Solutions both -Warm`

Serieller Build derselben 14 Varianten mit unveränderten TeX-Inhalten: **29.279 Sekunden** gegenüber 318,742 Sekunden zuvor (90.8 % weniger Zeit). Ein einzelner Vergleichslauf.

| Schritt | Sekunden |
| --- | ---: |
| Vorbereitung | 0.483 |
| 14 latexmk-Prüfungen und Ausgabeübernahmen | 16.710 |
| Gesamt-PDF Aufgaben | 0.849 |
| Gesamt-PDF Lösungen | 10.782 |

Bei allen 14 Varianten wurden bestehende Arbeitsverzeichnisse wiederverwendet; die Buildlogs weisen **null neue LuaLaTeX-Durchläufe** aus. Dies misst die Abhängigkeitsprüfung bei unveränderten Quellen, keinen erneuten vollständigen Satz und keinen Build nach Inhaltsänderungen. Beide Gesamt-PDFs wurden erneut zusammengefügt.

Der neue optionale Schalter `-Warm` ermöglicht diese Wiederverwendung dauerhaft. Fehlender Cache führt zum normalen Build; geänderte Abhängigkeiten werden von latexmk ausgewertet. Stand dieser Warm-Messung: noch keine Parallelisierung. Für unveränderte Entwicklungsstände bringt Warm-Build bereits den größten gemessenen Nutzen; die Empfehlung zu vier parallelen Prozessen betrifft weiterhin erforderliche vollständige Neubuilds.

## Parallelisierung und Gesamt-PDF-Cache

Messung vom 11. September 2026, gleicher Rechner und gleiche 14 Varianten. Standard jetzt vier getrennte Prozesse; steuerbar mit `-Jobs`, serieller Betrieb mit `-Jobs 1`. Keine Parallelisierung innerhalb einer einzelnen TeX-Datei.

| Vergleich | Seriell vorher | Vier Prozesse und Gesamt-PDF-Cache |
| --- | ---: | ---: |
| Vollständiger Neubuild | 318,742 s | 119,291 s |
| Warm-Build, unveränderte Inhalte | 29,278 s | 10,052 s |

Der Neubuild benötigte weiterhin 28 LuaLaTeX-Durchläufe und dauerte rund 63 % kürzer. Im anschließenden Warm-Build waren alle 14 Varianten aktuell (null neue LuaLaTeX-Durchläufe); beide Gesamt-PDFs wurden aus dem neuen Cache übernommen. Dessen Nutzen ist in den 10,052 Sekunden enthalten und wurde nicht getrennt von der Parallelisierung gemessen. Einzelmessungen, keine garantierten Laufzeiten.

Der Gesamt-PDF-Cache berücksichtigt die Bytes aller Einzel-PDFs, ihre Reihenfolge, Pfade und Lesezeichentitel sowie die Version des Zusammenführungsprogramms anhand dessen Quelltextes. Die gespeicherte Ausgabe wird vor Wiederverwendung gegen ihre SHA-256-Prüfsumme geprüft. Alle Varianten müssen zuvor erfolgreich durch latexmk geprüft oder gebaut worden sein. Die bisherige Entfernung veralteter Gesamtausgaben bei Teilbuilds oder Fehlern bleibt bestehen.

Gezielte Prüfungen: Cache-Treffer ohne erneutes Zusammenfügen; neue Zusammenführung nach Änderung von Titel, Reihenfolge oder Quelldatei; Wiederherstellung bei beschädigter Cache-PDF; fehlende englische Aufgaben werden als Fehler gemeldet. Die reguläre Projektprüfung kontrolliert weiterhin Originalerhalt, 101 Aufgaben, alle deutschen Einzel-PDFs und beide Gesamt-PDFs.

Empfohlener Entwicklungsaufruf: `./tools/build-all.ps1 -Language de -Solutions both -Warm`. Vier parallele Prozesse sind Standard. Mehr Prozesse erst nach erneutem Vergleich empfehlen; der Rechner soll während der Arbeit bedienbar bleiben. Nur eine Instanz des vollständigen Buildskripts gleichzeitig ausführen, da Arbeitskopie und Berichte gemeinsam verwendet werden.

## Automatischer Entwicklungsmodus

`tools/develop.ps1` überwacht die Quellen und aktualisiert standardmäßig beide deutschen Varianten. `-Once` führt dieselbe inkrementelle Auswahl einmalig aus. Die Auswahl verwendet Quellenprüfsummen einschließlich aufgezeichneter zusätzlicher LaTeX-Abhängigkeiten sowie die Prüfsummen der erzeugten PDFs. Bereits berechnete Prüfsummen werden bei unveränderten Dateizeiten und Dateigrößen aus einem externen Index übernommen.

Integrationstest: Ein vorübergehender Kommentar in einer Grundlagen-Aufgabe löste automatisch genau zwei Blattjobs aus (ohne/mit Musterlösungen). Alle zwölf anderen Einzel-PDFs behielten ihren Änderungszeitpunkt. Beide Gesamt-PDFs wurden aktualisiert. Auch das Entfernen des Kommentars wurde automatisch verarbeitet; die Originaldatei wurde vollständig wiederhergestellt. Der Watcher wurde nach dem Test beendet.

Unveränderter Kontrolllauf mit der abschließenden Implementierung: 5,3 Sekunden im Buildskript, 9,53 Sekunden für den gesamten `develop.ps1 -Once`-Aufruf einschließlich Start, Beruhigungszeit und Zustandsverwaltung. Alle 16 PDFs wurden übernommen; null Blattjobs und keine erneute Zusammenführung. Eine einzelne Aufgabenänderung benötigte im Integrationstest vor der abschließenden Prüfsummenoptimierung 40,67 Sekunden einschließlich automatischer Erkennung, beider Varianten und Gesamt-PDFs. Diese Messungen sind Einzelwerte und nicht mit einem vollständigen Neubuild gleichzusetzen.

Acht Regressionstests in `tools/test_development.py` prüfen lokale und globale Änderungen, fehlende Übersetzungen, gelöschte Quellen, beschädigte Ausgaben, kapitelübergreifende Abhängigkeiten, fehlgeschlagene Builds, ignorierte Ausgaben und Änderungen während eines Builds. Die Sperre gegen gleichzeitige Build-Aufrufe wurde ebenfalls praktisch geprüft.
