import 'EditFoodScreen.dart';
import 'EditRecipeScreen.dart';
import 'FridgeDetailScreen.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'MyRecipesScreen.dart';
import 'ProfileScreen.dart';
import 'RecipesScreen.dart';
import 'firebase_options.dart';
import 'helpers/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FridgeMate());
}

class FridgeMate extends StatelessWidget {
  final routes = <String, WidgetBuilder> {
    editFoodScreenTag: (context) => const EditFoodScreen(),
    editRecipeScreenTag: (context) => const EditRecipeScreen(),
    fridgeDetailScreenTag: (context) => const FridgeDetailScreen(),
    homeScreenTag: (context) => const HomeScreen(),
    loginScreenTag: (context) => const LoginScreen(),
    myRecipesScreenTag: (context) => const MyRecipesScreen(),
    profileScreenTag: (context) => const ProfileScreen(),
    recipesScreenTag: (context) => const RecipesScreen(),
  };

  FridgeMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
      routes: routes,
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasData) {
          return const HomeScreen();
        }
        else {
          return const LoginScreen();
        }
      },
    );
  }
}