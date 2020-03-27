# FFF App DE Frontend

Dies ist das Frontend bzw. die Mobile App der FFF App DE.

## Setup

1. Flutter [installieren und einrichten](https://flutter.dev/docs/get-started/install)
2. Unterstützte IDE installieren und einrichten (z.B. [VS Code](https://flutter.dev/docs/get-started/editor?tab=vscode))
3. Dieses Repo lokal clonen
4. Ins Verzeichnis wechseln
5. `assets/config.base.yaml` kopieren und konfigurieren
6. `flutter run` ausführen

## Code neu generieren (JSON-Serialisierung)

`flutter pub run build_runner build` ausführen.

## App-Icons neu generieren

`flutter pub run flutter_launcher_icons:main`

Die Android Icons werden aus den Bildern in `assets/icon` generiert.

## Ghost CMS Beiträge in App anzeigen

1. Ghost Server starten (Siehe [Backend Anleitung](https://github.com/AppFridaysForFutureDE/backend/blob/master/README.md) oder [Offizielle Doku](https://ghost.org/docs/install/local/)
2. [CMS Einrichten](https://github.com/AppFridaysForFutureDE/backend/blob/master/README.md#einrichten-des-cms)
3. [Content API Key erstellen](https://ghost.org/docs/api/v3/content/#key)
4. API Key in der Datei `lib/service/api.dart` in die Variable `ghostApiKey` eintragen
5. Falls ein echtes Android Device per USB-Debugging verwendet wird (Dieser Schritt ist NICHT notwendig, wenn man einen Android Emulator verwendet)
   * Weil es kompliziert ist, eine direkte Verbindung zwischen Smartphone und localhost herzustellen, verwenden wir einen Ngrok Tunnel.
   * [Ngrok Account erstellen und Ngrok herunterladen](https://ngrok.com/) 
   * Ngrok starten: `ngrok http 2368`
   * URL in der Datei `lib/service/api.dart` in die Variable `baseUrl` eintragen:
   * Beispiel: ```final baseUrl = 'http://82a26a90.ngrok.io/ghost/api/v3/content';```

## Tests ausführen

`flutter test` ausführen.

## About Us Page mit Inhalten füllen

Damit die Seiten Forderungen, Selbstverständnis, Verhalten auf Demos und Impressum angezeigt werden müssen diese im Ghost CMS angelegt werden.
Dafür einfach die Seiten anlegen (Titel ist egal) und unter Post Settings als Post Url die entpsrechenden slugs eintragen. Die Slugs sind:
`forderungen`, `selbstverstaendnis`, `verhalten-auf-demos`, `impressum`