import 'helpers/Constants.dart';
import 'helpers/SignInButton.dart';
import 'helpers/SignUpButton.dart';
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

    const forgetPasswordButton = TextButton(
      onPressed: null,
      child: Text(
        'Forget Password?',
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
              email: emailController.text,
              password: passwordController.text,
            )
            : SignInButton(
              email: emailController.text,
              password: passwordController.text,
            ),
          const SizedBox(height: 30),
          forgetPasswordButton,
        ]));

    return Scaffold(
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
}
