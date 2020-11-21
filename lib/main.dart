import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unscript_hackathon/chatPage.dart';

import 'screens/login_screen/login_screen.dart';
import 'screens/otp_screen/otp_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('init');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter OTP Authentication',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 253, 188, 51),
      ),
      home: ChatPage(),
      routes: <String, WidgetBuilder>{
        '/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => ChatPage(),
      },
    );
  }
}
