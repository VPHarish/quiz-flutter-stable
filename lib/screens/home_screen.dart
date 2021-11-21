import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:quiz_flutter_stable/modules/google_sign_in.dart';

import 'package:sizer/sizer.dart';

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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Welcome to QUIZ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Audiowide',
                        color: Colors.white),
                  ),
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
    return Sizer(builder: (context, orientation, devicetype) {
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
                padding: EdgeInsets.all(0.5.h),
                child: Text(
                  "PROFILE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.w,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0.1.h, 5, 0.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
                      tag: "icon",
                      child: Image.asset(
                        "images/quiz_icon.png",
                        width: 30.w,
                      ),
                    ),
                    Icon(Icons.arrow_right_alt_rounded,
                        color: Colors.white, size: 15.w),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                  ],
                ),
              ),
              FittedBox(
                child: Text(
                  " Welcome, " + user.displayName! + "! ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 6.5.w,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                child: Text(
                  " Email: " + user.email! + " ",
                  style: TextStyle(color: Colors.white, fontSize: 5.5.w),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0.5.h),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/context');
                    },
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size(45.w, 3.h),
                        primary: Colors.black,
                        backgroundColor: Colors.white),
                    child: Text("Get Started")),
              ),
              Padding(
                padding: EdgeInsets.all(0.5.h),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size(45.w, 3.h),
                        primary: Colors.black,
                        backgroundColor: Colors.white),
                    child: Text("About the App")),
              ),
              // TextButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/test_area');
              //     },
              //     child: Text("Test Area")),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(1.h),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(70.w)),
                      child: Lottie.asset(
                        'images/new.json',
                        width: 30.h,
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
    });
  }
}
