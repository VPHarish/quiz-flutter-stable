import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:quiz_flutter_stable/modules/google_sign_in.dart';

import 'package:sign_button/sign_button.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Do you want to exit?"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          SystemNavigator.pop();
                        },
                        child: Text("Yes"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade800),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text("No", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapShot.hasData) {
          return LoggedInWidget();
        } else if (snapShot.hasError) {
          return Center(
            child: Text("went wrong!@%"),
          );
        } else {
          return SignInScreen();
        }
      },
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];

  int index = 0;
  Color bottomColor = Colors.green;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedContainer(
          duration: Duration(seconds: 2),
          onEnd: () {
            setState(() {
              index = index + 1;
              // animate the color
              bottomColor = colorList[index % colorList.length];
              topColor = colorList[(index + 1) % colorList.length];
            });
          },
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, colors: [bottomColor, topColor])),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Welcome to QUIZ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Audiowide',
                      color: Colors.white),
                ),
              ),
              Hero(
                tag: "icon",
                child: Image.asset("images/quiz_icon.png",
                    width: MediaQuery.of(context).size.width * 0.7),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SignInButton(
                    buttonSize: ButtonSize.large,
                    buttonType: ButtonType.google,
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin().then((value) =>
                          Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 2),
                                  pageBuilder: (_, __, ___) =>
                                      LoggedInWidget())));
                    }),
              )
            ],
          ),
        ));
  }
}

class LoggedInWidget extends StatefulWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hello = FirebaseAuth.instance.currentUser != null ? true : false;
    print(hello);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          TextButton(
              child: Text(
                "Log out!",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.logout();
                await Navigator.of(context).pushReplacement(PageRouteBuilder(
                    transitionDuration: Duration(seconds: 2),
                    pageBuilder: (_, __, ___) => SignInScreen()));
              })
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "PROFILE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: "icon",
                    child: Image.asset(
                      "images/quiz_icon.png",
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                  ),
                  Icon(Icons.arrow_right_alt_rounded,
                      color: Colors.white, size: 50),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.18,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ],
              ),
            ),
            Text(
              "Welcome, " + user.displayName! + "!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              user.email!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/context');
                },
                child: Text("Get Started")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: Text("About the App")),
            // TextButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/test_area');
            //     },
            //     child: Text("Test Area")),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(MediaQuery.of(context).size.width)),
                    child: Lottie.asset(
                      'images/new.json',
                      width: MediaQuery.of(context).size.width * 0.7,
                      repeat: true,
                      reverse: false,
                      animate: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
