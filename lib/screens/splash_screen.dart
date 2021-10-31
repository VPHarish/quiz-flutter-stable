import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:quiz_flutter_stable/modules/google_sign_in.dart';

import 'home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     Timer(Duration(seconds: 100), () {
//       // Navigator.of(context).push(PageRouteBuilder(
//       //     transitionDuration: Duration(seconds: 2),
//       //     pageBuilder: (_, __, ___) => HomePage()));
//       Navigator.of(context).pushReplacement(PageRouteBuilder(
//           transitionDuration: Duration(seconds: 5),
//           pageBuilder: (_, __, ___) => HomePage()));
//     });
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushReplacement(PageRouteBuilder(
//                       transitionDuration: Duration(seconds: 5),
//                       pageBuilder: (_, __, ___) => HomePage()));
//                 },
//                 child: Hero(
//                   tag: "icon",
//                   child: Image.asset(
//                     "images/quiz_icon.png",
//                     width: MediaQuery.of(context).size.width * 0.3,
//                   ),
//                 ),
//               ),
//             ),
//             Text("QUIZ", style: TextStyle(fontSize: 30, color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    bool isusersignedin =
        FirebaseAuth.instance.currentUser != null ? true : false;
    Timer(Duration(seconds: 3), () {
      if (isusersignedin == true) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (_, __, ___) => LoggedInWidget()));
      } else {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (_, __, ___) => SignInScreen()));
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {},
                child: Hero(
                  tag: "icon",
                  child: Image.asset(
                    "images/quiz_icon.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(35)),
            Text("quiz",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Audiowide')),
            Padding(padding: EdgeInsets.all(10)),
            Text("by HARISH V P",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Audiowide')),
          ],
        ),
      ),
    );
  }
}
