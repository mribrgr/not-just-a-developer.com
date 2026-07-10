# n8n-Workflows (GitOps / deklarativ)

Diese `*.json`-Dateien sind die **Single Source of Truth** für ausgewählte n8n-Workflows.

## Wie es funktioniert
1. Die JSONs werden per Helm (`.Files.Glob`) in die ConfigMap `n8n-workflows` gerendert
   (siehe `../../templates/n8n-workflows-configmap.yaml`).
2. Ein **initContainer** im n8n-Deployment (`../../templates/n8n.yaml`) führt bei jedem
   Pod-Start `n8n import:workflow --separate --input=/workflows-src` aus und importiert
   die Workflows in die n8n-DB.
3. Eine Checksumme der JSONs steckt als Pod-Annotation im Deployment → bei jeder
   Workflow-Änderung rollt ArgoCD den Pod automatisch neu aus und importiert erneut.

## Wichtig
- **Git gewinnt.** Änderungen, die du in der n8n-UI an *diesen* Workflows machst, werden
  beim nächsten Pod-Neustart überschrieben. Editiere sie hier im Repo.
- Andere, in der UI erstellte Workflows bleiben unberührt (der Import macht ein Upsert
  nur für die hier definierten Workflow-IDs).
- Die Workflow-`id` ist fix gesetzt (`signalSend000001`, `signalRecv000001`), damit der
  Import ein Update statt eines Duplikats macht.

## Workflows
- **signal-send** (`signalSend000001`, inaktiv): Sub-Workflow mit
  „Execute-Workflow"-Trigger. Aus anderen Workflows via **Execute Sub-workflow**-Node
  aufrufen und `message` (optional `recipient`) übergeben → sendet via
  `POST http://signal-api:8080/v2/send`. Default-Empfänger: `+491605048727`.
- **signal-receive** (`signalRecv000001`, aktiv): pollt alle 30 s
  `GET http://signal-api:8080/v1/receive/+4935125988971`, parst eingehende
  Nachrichten und reicht sie an einen Platzhalter-Node weiter. Hier die eigene
  Verarbeitung anschließen (im JSON, nicht in der UI).

## Nummern
- Bot/Absender (Festnetz): `+4935125988971`
- Standard-Empfänger (privat): `+491605048727`
