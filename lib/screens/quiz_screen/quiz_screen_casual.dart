import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:quiz_flutter_stable/modules/quiz_progress_notifier.dart';
import 'package:quiz_flutter_stable/screens/results/result.dart';

import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class QuizScreenCasual extends StatefulWidget {
  const QuizScreenCasual({Key? key}) : super(key: key);

  @override
  _QuizScreenCasualState createState() => _QuizScreenCasualState();
}

class _QuizScreenCasualState extends State<QuizScreenCasual>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  late AnimationController _animationController4;
  late Tween _colorTween1;
  late Tween _colorTween2;
  late Tween _colorTween3;
  late Tween _colorTween4;
  late Animation _animation1;
  late Animation _animation2;
  late Animation _animation3;
  late Animation _animation4;

  @override
  void initState() {
    _animationController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController4 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween1 = ColorTween(begin: Colors.white, end: Colors.red);
    _colorTween2 = ColorTween(begin: Colors.white, end: Colors.red);
    _colorTween3 = ColorTween(begin: Colors.white, end: Colors.red);
    _colorTween4 = ColorTween(begin: Colors.white, end: Colors.red);
    _animation1 = _colorTween1.animate(_animationController1);
    _animation2 = _colorTween2.animate(_animationController2);
    _animation3 = _colorTween3.animate(_animationController3);
    _animation4 = _colorTween4.animate(_animationController4);

    super.initState();
  }

  void resetcontrollers() {
    _animationController1.reset();
    _animationController2.reset();
    _animationController3.reset();
    _animationController4.reset();
  }

  void setNewPosition(option, answer) {
    var state = Provider.of<StateofQuiz>(context, listen: false);
    if (option == "A") {
      _colorTween1.end = state.getanswer(answer, option);
    } else if (option == "B") {
      _colorTween2.end = state.getanswer(answer, option);
    } else if (option == "C") {
      _colorTween3.end = state.getanswer(answer, option);
    } else if (option == "D") {
      _colorTween4.end = state.getanswer(answer, option);
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<StateofQuiz>(context);
    var questiondata = state.getnextq(state.currentquiestionno());
    if (state.progress < 15) {
      return Scaffold(
        body: SafeArea(
          child: Container(
              alignment: Alignment.center,
              child: Stack(children: [
                WaveWidget(
                  config: CustomConfig(
                    durations: [12000, 9440, 6800, 5000],
                    heightPercentages: [0.80, 0.83, 0.86, 0.9],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                    colors: [
                      Colors.white70,
                      Colors.white54,
                      Colors.white24,
                      Colors.white,
                    ],
                  ),
                  waveAmplitude: 0,
                  backgroundColor: Color.fromARGB(160, 204, 51, 255),
                  size: Size(double.infinity, double.infinity),
                ),
                Consumer<StateofQuiz>(
                  builder: (context, counter, child) {
                    return Column(
                      children: [
                        Text("Progress: " + state.progress.toString()),
                        Text("Current question number: " +
                            state.currentqno.toString()),
                        Text("Total Score: " + state.totalscore.toString()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: FAProgressBar(
                            size: 20,
                            progressColor: Colors.lightGreen,
                            maxValue: 15,
                            currentValue: state.progress.toInt(),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                      context, '/results')
                                  .then((completion) {
                                state.resetprovidervar();
                              });
                            },
                            child: Text("Results!")),
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: questiondata,
                            builder: (_, snapshot) {
                              if (snapshot.hasError)
                                return Text('Error = ${snapshot.error}');
                              if (snapshot.hasData) {
                                var data = snapshot.data!.data();
                                var value = data!;
                                return Container(
                                  child: Column(
                                    children: [
                                      Text('Question: ' + value["question"]),
                                      Text('Answer: ' + value["answer"]),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              var qno = state.newquestionno();
                                              resetcontrollers();
                                              questiondata =
                                                  state.getnextq(qno);
                                            });
                                          },
                                          child: Text("Next Question!")),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 200,
                                          height: 80,
                                          child: AnimatedBuilder(
                                            animation: _animation1,
                                            builder: (context, child) =>
                                                IgnorePointer(
                                              ignoring: state.answerclicked,
                                              child: OutlinedButton(
                                                child: Text(value["A"]),
                                                style: OutlinedButton.styleFrom(
                                                    primary: Colors.black,
                                                    backgroundColor:
                                                        _animation1.value),
                                                onPressed: () {
                                                  setState(
                                                      () {}); //Remove this.
                                                  if (_animationController1
                                                          .status ==
                                                      AnimationStatus
                                                          .completed) {
                                                    // _animationController1.reverse();
                                                  } else {
                                                    setNewPosition(
                                                        "A", value["answer"]);
                                                    _animationController1
                                                        .forward();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 200,
                                          height: 80,
                                          child: AnimatedBuilder(
                                            animation: _animation2,
                                            builder: (context, child) =>
                                                IgnorePointer(
                                              ignoring: state.answerclicked,
                                              child: OutlinedButton(
                                                child: Text(value["B"]),
                                                style: OutlinedButton.styleFrom(
                                                    primary: Colors.black,
                                                    backgroundColor:
                                                        _animation2.value),
                                                onPressed: () {
                                                  setState(
                                                      () {}); //Remove this.
                                                  if (_animationController2
                                                          .status ==
                                                      AnimationStatus
                                                          .completed) {
                                                    // _animationController2.reverse();
                                                  } else {
                                                    setNewPosition(
                                                        "B", value["answer"]);
                                                    _animationController2
                                                        .forward();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 200,
                                          height: 80,
                                          child: AnimatedBuilder(
                                            animation: _animation3,
                                            builder: (context, child) =>
                                                IgnorePointer(
                                              ignoring: state.answerclicked,
                                              child: OutlinedButton(
                                                child: Text(value["C"]),
                                                style: OutlinedButton.styleFrom(
                                                    primary: Colors.black,
                                                    backgroundColor:
                                                        _animation3.value),
                                                onPressed: () {
                                                  setState(
                                                      () {}); //Remove this.
                                                  if (_animationController3
                                                          .status ==
                                                      AnimationStatus
                                                          .completed) {
                                                    // _animationController3.reverse();
                                                  } else {
                                                    setNewPosition(
                                                        "C", value["answer"]);
                                                    _animationController3
                                                        .forward();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 200,
                                          height: 80,
                                          child: AnimatedBuilder(
                                            animation: _animation4,
                                            builder: (context, child) =>
                                                IgnorePointer(
                                              ignoring: state.answerclicked,
                                              child: OutlinedButton(
                                                child: Text(value["D"]),
                                                style: OutlinedButton.styleFrom(
                                                    primary: Colors.black,
                                                    backgroundColor:
                                                        _animation4.value),
                                                onPressed: () {
                                                  setState(
                                                      () {}); //Remove this.
                                                  if (_animationController4
                                                          .status ==
                                                      AnimationStatus
                                                          .completed) {
                                                    // _animationController4.reverse();
                                                  } else {
                                                    setNewPosition(
                                                        "D", value["answer"]);
                                                    _animationController4
                                                        .forward();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                      ],
                    );
                  },
                ),
              ])),
        ),
      );
    } else {
      return ResultsPage(context);
    }
  }
}
