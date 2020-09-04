import 'package:app/app.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' show rootBundle;

class HtmlStrikePage extends StatefulWidget {
  @override
  _HtmlStrikePageState createState() => _HtmlStrikePageState();
}

class _HtmlStrikePageState extends State<HtmlStrikePage> {
  final String startPage = "https://app.fffutu.re/webinar";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = true;
  String _startUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aktionen"),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: startPage,

            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
            // ignore: prefer_collection_literals
            javascriptChannels: <JavascriptChannel>[
              //_toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                _isLoading = false;
              });
            },
            gestureNavigationEnabled: true,
          ),
          if (_isLoading) LinearProgressIndicator()
        ],
      ),
      //floatingActionButton: favoriteButton(),
    );
  }
}
