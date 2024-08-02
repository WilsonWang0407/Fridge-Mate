import 'Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String Function() emailProvider;
  final String Function() passwordProvider;

  const SignInButton({
    super.key,
    required this.emailProvider,
    required this.passwordProvider,
  });

  Future<void> _signIn(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailProvider(),
        password: passwordProvider(),
      );
      Navigator.of(context).pushNamed(homeScreenTag);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in successful! Welcome back, ${userCredential.user?.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child:OutlinedButton(
        onPressed: () => _signIn(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: burstSienna,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: const BorderSide(
            width: 2,
            color: Colors.black,
          )
        ),
        child: Text(
          'SIGN IN',
          style: bigButtonTextStyle,
        ),
      ),
    );
  }
}