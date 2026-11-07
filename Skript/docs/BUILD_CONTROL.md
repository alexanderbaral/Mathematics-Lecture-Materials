# Gemeinsame Bausteuerung

Bauaufträge laufen über tools/build-update.ps1 im jeweiligen Produktordner. -Status zeigt veröffentlichten Stand und Warteschlange, -Wait wartet zusätzlich auf den vollständigen Abschluss.

Beide Produkte verwenden ../../_shared/tools/build_runtime.py für Quellsnapshots, Warteschlangen, Prozesssperren, Zeitprotokolle und sichere Veröffentlichung. Die Warteschlangen bleiben unabhängig. Bei Fehlern bleiben die zuletzt erfolgreichen PDFs erhalten.

Skript: betroffene Abschnitte als Vorschau, danach Gesamtskript im Hintergrund. Exercise Sheets: betroffene Aufgaben- und Lösungsblätter zuerst, Sammel-PDFs anschließend im Hintergrund. Vorhandene Caches und Blatt-PDFs werden wiederverwendet.

Aktive Quellen aus _shared/style, _shared/commands und _shared/resources werden berücksichtigt. _shared/legacy ist ausdrücklich ausgenommen.

Beide Produktordner besitzen .vscode, build, common, content/chapters_de, content/chapters_en, content/front_matter, content/resources, docs und tools. Aufgaben und Skriptabschnitte haben weiterhin ihre passenden Inhaltsdateien.

