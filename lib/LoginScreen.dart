import 'helpers/Constants.dart';
import 'widgets/SignInButton.dart';
import 'widgets/SignUpButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;
  bool signUpButtonSelected = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 60,
      child: appLogo,
    );

    final signInUpButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          child: TextButton(
            onPressed: () {
              setState(() {
                signUpButtonSelected = false;
              });
            },
            child: Text(
              'SIGN IN',
              style: signUpButtonSelected
                  ? bigButtonTextStyle.copyWith(color: Colors.grey)
                  : bigButtonTextStyle,
            ),
          ),
        ),
        Text(
          '|',
          style: bigButtonTextStyle,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              signUpButtonSelected = true;
            });
          },
          child: Text(
            'SIGN UP',
            style: signUpButtonSelected
                ? bigButtonTextStyle
                : bigButtonTextStyle.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );

    final emailRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Email:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 230,
          height: 30,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(64)],
            decoration: centerBarInputDecoration,
          ),
        )
      ],
    );

    final passwordRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Password:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 180,
          height: 30,
          child: TextField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(128)],
            obscureText: signUpButtonSelected ? false : passwordVisible,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 6),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              suffixIcon: signUpButtonSelected
                  ? null
                  : IconButton(
                      padding: const EdgeInsets.only(left: 10, top: 1),
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
            ),
          ),
        ),
      ],
    );

    final forgetPasswordButton = TextButton(
      onPressed:() => _showForgotPasswordDialog(context),
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
    );

    final centerBar = Container(
        width: 340,
        height: 380,
        decoration: BoxDecoration(
          color: cambridgeBlue,
          border: Border.all(
            width: 2.5,
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(Radius.circular((30))),
        ),
        child: Column(children: <Widget>[
          space10,
          signInUpButtonRow,
          const SizedBox(height: 50),
          emailRow,
          const SizedBox(height: 15),
          passwordRow,
          const SizedBox(height: 40),
          signUpButtonSelected
            ? SignUpButton(
              emailProvider: () => emailController.text,
              passwordProvider: () => passwordController.text,
            )
            : SignInButton(
              emailProvider: () => emailController.text,
              passwordProvider: () => passwordController.text,
            ),
          const SizedBox(height: 30),
          forgetPasswordButton,
        ]));

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: eggShell,
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 90),
            logo,
            const SizedBox(height: 40),
            centerBar,
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailResetController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Enter your registered email:'),
              space10,
              TextField(
                controller: emailResetController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                final email = emailResetController.text.trim();
                if (email.isNotEmpty) {
                  sendPasswordResetEmail(email);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
