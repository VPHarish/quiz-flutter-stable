import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}
