import 'package:webview_flutter/webview_flutter.dart';

import '../../../app.dart';

class AddIFramePage extends StatefulWidget {
  final String url;

  final String inAppTitle;

  AddIFramePage({
    this.url = "https://actionmap.fridaysforfuture.de/iframe.html",
    this.inAppTitle,
  });

  @override
  _AddIFramePageState createState() => _AddIFramePageState();
}

class _AddIFramePageState extends State<AddIFramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.inAppTitle ?? "Aktion")),
        body: Container(
            child: WebView(
          initialUrl: widget.url,
          //initialUrl: Uri.dataFromString('<html><body><iframe src="https://actionmap.fridaysforfuture.de/iframe.html"></iframe></body></html>', mimeType: 'text/html').toString(),
          javascriptMode: JavascriptMode.unrestricted,
        )));
  }
}
