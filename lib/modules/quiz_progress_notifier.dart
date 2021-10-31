import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateofQuiz with ChangeNotifier {
  double _progress = 0;
  bool _answerclicked = false;
  late var currentq;
  double get progress => _progress;
  var _askedquestions = Set();
  int _currentqno = 1;
  late int i2;
  int get currentqno => _currentqno;
  bool get answerclicked => _answerclicked;

  int tempscore = 20;
  int totalscore = 0;

  int currentquiestionno() {
    if (_askedquestions.isEmpty) {
      newquestionno();
    }
    return _askedquestions.last;
  }

  Color getanswer(answer, option) {
    if (answer == option) {
      _answerclicked = true;
      totalscore += tempscore;
      tempscore = 20;
      notifyListeners();
      return Colors.green;
    } else {
      tempscore -= 5;
      return Colors.red;
    }
  }

  int newquestionno() {
    _answerclicked = false;
    int min = 1;
    while (_askedquestions.length <= 15 - min) {
      print(_askedquestions.length);
      var i = min + Random().nextInt(16 - min);
      if (!_askedquestions.contains(i)) {
        _askedquestions.add(i);
        i2 = i;
        _progress += 1;
        break;
      }
    }
    _currentqno = i2;
    return i2;
  }

  void resetprovidervar() {
    _progress = 0;
    _askedquestions = Set();
    _currentqno = 1;
    totalscore = 0;
    tempscore = 20;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getnextq(questionno) {
    print("Now: " + questionno.toString());
    var instance = FirebaseFirestore.instance
        .collection("geography")
        .doc(questionno.toString())
        .get();
    return instance;
  }
}
