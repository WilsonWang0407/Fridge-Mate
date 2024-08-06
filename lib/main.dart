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
  FridgeMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
      routes: {
        editRecipeScreenTag: (context) => const EditRecipeScreen(),
        homeScreenTag: (context) => const HomeScreen(),
        loginScreenTag: (context) => const LoginScreen(),
        myRecipesScreenTag: (context) => const MyRecipesScreen(),
        profileScreenTag: (context) => const ProfileScreen(),
        recipesScreenTag: (context) => const RecipesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == fridgeDetailScreenTag) {
          final args = settings.arguments as Map<String, dynamic>;

          final fridgeName = args['fridgeName'] as String?;
          final fridgeId = args['fridgeId'] as String?;

          if (fridgeName == null || fridgeId == null) {
            throw Exception("fridgeName or fridgeId not provided!");
          }

          return MaterialPageRoute(
            builder: (context) => FridgeDetailScreen(
              fridgeName: fridgeName,
              fridgeId: fridgeId,
            ),
          );
        }

        if (settings.name == editFoodScreenTag) {
          final args = settings.arguments as Map<String, dynamic>;
          final fridgeId = args['fridgeId'] as String?;

          if (fridgeId == null) {
            throw Exception("fridgeId not provided!");
          }

          return MaterialPageRoute(
            builder: (context) => EditFoodScreen(
              fridgeId: fridgeId,
            ),
          );
        }

        return null;
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
