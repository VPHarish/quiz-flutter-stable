import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  var _opacity = 0.0;
  late Timer _timer;
  AppLifecycleState _notification = AppLifecycleState.resumed;

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _controller = VideoPlayerController.asset("images/test_audio.mp4",
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false))
      ..initialize().then((value) {
        _timer = Timer.periodic(Duration(seconds: 7), (timer) {
          _controller.setVolume(0.20);
          _animationController.forward();
          if (_notification == AppLifecycleState.paused) {
            print("Yup! Its in background!");
          } else if (_notification == AppLifecycleState.resumed) {
            _controller.play();
            setState(() {
              _opacity = 1;
            });
          }
        });
        setState(() {});
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      print(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(30.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: VideoPlayer(_controller),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "QUIZ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "This is the Experimental Branch of my QUIZ app, developed in Flutter, "
                  " to further develop and provide new features to the app. ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: _opacity,
                          duration: Duration(seconds: 2),
                          child: Text(
                            "Created By: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ColorFiltered(
                          colorFilter: ColorFilter.matrix([
                            -1, //RED
                            0,
                            0,
                            0,
                            255, //GREEN
                            0,
                            -1,
                            0,
                            0,
                            255, //BLUE
                            0,
                            0,
                            -1,
                            0,
                            255, //ALPHA
                            0,
                            0,
                            0,
                            1,
                            0,
                          ]),
                          child: Lottie.asset(
                            'images/harish-signature.json',
                            controller: _animationController,
                            width: 260,
                            height: 80,
                            animate: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
