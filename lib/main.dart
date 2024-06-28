import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/screens/login_screen/components/login_content.dart';
import 'package:login_screen/screens/login_screen/components/reset_password_content.dart';
import 'package:login_screen/screens/login_screen/components/signup_content.dart';
import 'package:login_screen/screens/main_screen/components/add_business_screen.dart';
import 'package:login_screen/screens/main_screen/components/calendar_screen.dart';
import 'package:login_screen/screens/main_screen/components/home_screen.dart';
import 'package:login_screen/screens/main_screen/components/notification_screen.dart';
import 'package:login_screen/screens/main_screen/profile_screen.dart';
import 'screens/login_screen/components/login_screen_background.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: SignupScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/resetpassword': (context) => const ResetPasswordScreen(),
        '/homescreen': (context) => HomeScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/profile': (context) => ProfileScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/add-business': (context) => AddBusinessScreen(),
      },
    );
  }
}