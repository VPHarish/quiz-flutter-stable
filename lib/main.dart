import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_flutter_stable/screens/splash_screen.dart';
import 'modules/quiz_progress_notifier.dart';
import 'modules/google_sign_in.dart';
import 'screens/all_export.dart';
import 'screens/quiz_screen/quiz_screen_casual.dart';
import 'screens/results/result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'modules/push_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  runApp(ChangeNotifierProvider(
    create: (context) => StateofQuiz(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomePage(),
          '/signin': (context) => SignInScreen(),
          '/context': (context) => Context(),
          '/quiz_screen_casual': (context) => QuizScreenCasual(),
          '/about': (context) => AboutScreen(),
          // '/test_area': (context) => TestArea(),
          '/results': (context) => resultsPage(context),
        },
      ),
    );
  }
}
