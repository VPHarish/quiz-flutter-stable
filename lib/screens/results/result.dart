import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:quiz_flutter_stable/modules/quiz_progress_notifier.dart';

Widget resultsPage(context) {
  var state = Provider.of<StateofQuiz>(context);
  if (state.totalscore >= 250) {
    return HighScoreCelebration();
  } else if (state.totalscore >= 150) {
    return MediumScoreCelebration();
  } else {
    return LowScoreCelebration();
  }
}

class HighScoreCelebration extends StatefulWidget {
  const HighScoreCelebration({Key? key}) : super(key: key);

  @override
  _HighScoreCelebrationState createState() => _HighScoreCelebrationState();
}

class _HighScoreCelebrationState extends State<HighScoreCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));

    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 4;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<StateofQuiz>(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 158, 152),
              Color.fromARGB(255, 0, 158, 152),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
          )),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Total Score : " + state.totalscore.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Audiowide',
                          color: Colors.white),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: Text(
                      "Good Job!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Audiowide',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                  "images/winners-animation.json",
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 300,
                  animate: true,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop: false,
                  numberOfParticles: 5,
                  emissionFrequency: 0.04,
                  gravity: 0.3,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.brown,
                    Colors.indigo
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          elevation: 10,
                          primary: Colors.black,
                          backgroundColor: Colors.white),
                      onPressed: () {
                        state.resetprovidervar();
                        Navigator.pop(context);
                      },
                      child: Text("Go Back")),
                ),
              ),
            ],
          )),
    );
  }
}

class MediumScoreCelebration extends StatefulWidget {
  const MediumScoreCelebration({Key? key}) : super(key: key);

  @override
  _MediumScoreCelebrationState createState() => _MediumScoreCelebrationState();
}

class _MediumScoreCelebrationState extends State<MediumScoreCelebration> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<StateofQuiz>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.indigo,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            )),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Total Score : " + state.totalscore.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Audiowide',
                            color: Colors.white),
                      )),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Good job! \n Keep it up!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Audiowide',
                          color: Colors.white),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              elevation: 10,
                              primary: Colors.black,
                              backgroundColor: Colors.white),
                          onPressed: () {
                            state.resetprovidervar();
                            Navigator.pop(context);
                          },
                          child: Text("Go Back")),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LowScoreCelebration extends StatefulWidget {
  const LowScoreCelebration({Key? key}) : super(key: key);

  @override
  _LowScoreCelebrationState createState() => _LowScoreCelebrationState();
}

class _LowScoreCelebrationState extends State<LowScoreCelebration> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<StateofQuiz>(context);
    return Scaffold(
      body: Container(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.green,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
          )),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Total Score : " + state.totalscore.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Audiowide',
                          color: Colors.white),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: Text(
                      "You need to practice!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Audiowide',
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                  'images/iq-practice.json',
                  width: MediaQuery.of(context).size.width,
                  animate: true,
                  repeat: true,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            elevation: 10,
                            primary: Colors.black,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          state.resetprovidervar();
                          Navigator.pop(context);
                        },
                        child: Text("Go Back")),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
