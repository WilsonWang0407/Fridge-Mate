import 'package:fridge_mate/EditRecipeScreen.dart';

import 'EditFoodScreen.dart';
import 'FridgeDetailScreen.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'MyRecipesScreen.dart';
import 'ProfileScreen.dart';
import 'firebase_options.dart';
import 'helpers/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
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
  };

  FridgeMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditRecipeScreen(),
      routes: routes,
    );
  }
}