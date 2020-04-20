import 'package:app/app.dart';
import 'package:app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://cdn.app.fffutu.re/img/fff-app-intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      if (!_showButton) {
        if (_controller.value.position >
            Duration(seconds: 7, milliseconds: 700)) {
          setState(() {
            _showButton = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: InkWell(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Center(
            child: _controller.value.initialized
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      if (_showButton)
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RaisedButton(
                                color: Color(0xff1da64a),
                                child: Text('LOS GEHT\'S!'),
                                onPressed: () {
                                  Hive.box('data').put('intro_done', true);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: RichText(
                                  text: new TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Mit einem Klick auf "LOS GEHT\'S!" stimmst du der ',
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      TextSpan(
                                        text: 'Datenschutzerklärung ',
                                        style: new TextStyle(
                                            color: Colors.blue.shade400,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launch(
                                                'https://app.fffutu.re/privacy.html');
                                          },
                                      ),
                                      TextSpan(
                                        text: ' zu.',
                                        style: new TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
