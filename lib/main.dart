import 'package:flutter/material.dart';
import 'package:login_screen/screens/login_screen/components/login_content.dart';
import 'package:login_screen/screens/login_screen/components/reset_password_content.dart';
import 'package:login_screen/screens/login_screen/components/signup_content.dart';

import 'screens/login_screen/components/login_screen_background.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: kPrimaryColor,
              fontFamily: 'Montserrat',
            ),
      ),
      home: const ResetPasswordScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/resetpassword': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
