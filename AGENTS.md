# Mathematik – gemeinsame Arbeitsregeln

- Dieses Repository umfasst das Mathematikskript und die zugehörigen Übungsblätter. Die Regeln in den Produktordnern ergänzen diese Vorgaben.
- Deutsch ist Master für Inhalt und Struktur. Englisch folgt auf ausdrücklichen Auftrag. Technische Inhaltsnamen sind englisch und in snake_case. Die Reihenfolge ergibt sich aus den TeX-Einbindungen oder dem Blattregister. Neue Namen selbstständig wählen.
- Formuliere knapp und fachlich korrekt. Nutze semantische Umgebungen, zentrale Formatierung und automatische Nummerierung. Bewahre Nutzeränderungen.
- Vorlesungsdaten stehen in _shared/lecture_metadata.tex, Gestaltung in _shared/style, LaTeX-Befehle in _shared/commands, Grafiken und Schriften in _shared/resources. Fachliche Abschnitte, Blattregister und Lösungsquellen gehören in den jeweiligen Produktordner.
- Schrift, Listen, Grundmaße und Boxen verwenden eine gemeinsame Gestaltung. Die Skript-Titelseite und der Aufgabenblattkopf haben eigene Layoutregeln. Lückenfelder und Schreibraster gehören zum Lückenskript. Übungsblätter verwenden Aufgaben und Lösungen ohne diese Felder.
- Fokussiert lesen und arbeiten. Kein TODO.md im Repository. Änderungen nur auf ausdrücklichen Auftrag committen, pushen oder veröffentlichen.
- Nach Änderungen die gemeinsame Vorschau mit Strg+Shift+B oder python _shared/tools/build.py update erzeugen. Die Lückenfassung ist bei Bedarf mit --cloze verfügbar. Sichtbare Änderungen an den betroffenen PDF-Seiten prüfen.
- Vollbauten laufen in den getrennten Warteschlangen der Produkte. Laufende Builds fertigstellen lassen und den neuesten Stand vormerken. Die letzten erfolgreichen PDFs bleiben bei Fehlern erhalten.
- Die persistenten lokalen Cache-Pfade stehen in _shared/tools/cache_paths.json. Caches wiederverwenden und nur auf ausdrücklichen Auftrag löschen. Vor einer notwendigen Neuberechnung aller Figuren auf die längere Bauzeit hinweisen. Zeiten werden automatisch protokolliert. Keine periodische KI-Nachkontrolle einrichten.
- Die freigegebenen Varianten stehen in _shared/tools/build_variants.json. Gemeinsame Infrastruktur bei beiden Produkten prüfen. Einen Vollbau erst als aktuell melden, wenn die Warteschlange den Stand als erfolgreich bestätigt.
