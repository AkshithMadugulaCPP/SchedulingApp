import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_screen/screens/login_screen/animations/change_screen_animation.dart';
import 'package:login_screen/screens/login_screen/components/signup_content.dart';
import 'package:login_screen/utils/constants.dart';
import 'package:login_screen/utils/helper_functions.dart';

import 'login_screen_background.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late final List<Widget> loginContent;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Widget inputField(String hint, IconData iconData, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _auth.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
            Navigator.pushNamed(context, '/homescreen');
          } catch (e) {
            setState(() {
              errorMessage = 'Incorrect email or password.';
            });
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget forgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/resetpassword');
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    loginContent = [
      if (errorMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
      inputField('Email', Ionicons.mail_outline, _emailController,false),
      inputField('Password', Ionicons.lock_closed_outline, _passwordController,true),
      loginButton('Log In'),
      forgotPassword(context),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: 0,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < loginContent.length && i < ChangeScreenAnimation.loginAnimations.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget topText() {
    return const Text(
      'Welcome\nBack',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget bottomText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/signup');
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
            ),
            children: [
              TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: topText(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: loginContent,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: bottomText(),
            ),
          ),
        ],
      ),
    );
  }
}
