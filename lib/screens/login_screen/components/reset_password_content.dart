import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'login_screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with TickerProviderStateMixin {
  late final List<Widget> resetPasswordContent;
  final TextEditingController _emailController = TextEditingController();
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

  Widget resetButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _auth.sendPasswordResetEmail(email: _emailController.text);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Password Reset'),
                content: Text('Link has been sent to your email.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } catch (e) {
            setState(() {
              errorMessage = 'An error occurred. Please try again.';
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

  @override
  void initState() {
    resetPasswordContent = [
      inputField('Email', Ionicons.mail_outline, _emailController,false),
      resetButton('Reset'),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: resetPasswordContent.length,
      loginItems: 0,
    );

    for (var i = 0; i < resetPasswordContent.length && i < ChangeScreenAnimation.createAccountAnimations.length; i++) {
      resetPasswordContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: resetPasswordContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget topText() {
    return const Text(
      'Reset\nPassword',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget bottomText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
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
                text: 'Remember your password? ',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Log In',
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
          Positioned(
            top: 136,
            left: 24,
            child: topText(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: resetPasswordContent,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: bottomText(),
            ),
          ),
        ],
      ),
    );
  }
}
