import 'package:webview_flutter/webview_flutter.dart';

import '../../../app.dart';

class AddIFramePage extends StatefulWidget {
  @override
  _AddIFramePageState createState() => _AddIFramePageState();
}

class _AddIFramePageState extends State<AddIFramePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mitstreiken!")),
        body: Container(
            child: WebView(
          initialUrl: "https://actionmap.fridaysforfuture.de/iframe.html",
          //initialUrl: Uri.dataFromString('<html><body><iframe src="https://actionmap.fridaysforfuture.de/iframe.html"></iframe></body></html>', mimeType: 'text/html').toString(),
          javascriptMode: JavascriptMode.unrestricted,
        )));
  }
}
