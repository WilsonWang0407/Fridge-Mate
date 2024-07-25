import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fridge_mate/MyRecipesScreen.dart';
import 'package:fridge_mate/firebase_options.dart';
import 'EditFoodScreen.dart';
import 'FridgeDetailScreen.dart';
import 'helpers/Constants.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FridgeMate());
}

class FridgeMate extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
    loginScreenTag: (context) => const LoginScreen(),
    homeScreenTag: (context) => const HomeScreen(),
    fridgeDetailScreenTag: (context) => const FridgeDetailScreen(),
    editFoodScreenTag: (context) => const EditFoodScreen(),
    myRecipesScreenTag: (context) => const MyRecipesScreen(),
  };

  FridgeMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: routes,
    );
  }
}