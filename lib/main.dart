import 'EditFoodScreen.dart';
import 'EditRecipeScreen.dart';
import 'FridgeDetailScreen.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'MyRecipesScreen.dart';
import 'ProfileScreen.dart';
import 'firebase_options.dart';
import 'helpers/Constants.dart';
import 'notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await NotificationService().init();
  await NotificationService().requestIOSPermissions();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FridgeMate(notificationService: notificationService));
}

class FridgeMate extends StatelessWidget {
  final NotificationService notificationService;

  FridgeMate({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: notificationService.navigatorKey,
      home: AuthenticationWrapper(),
      routes: {
        homeScreenTag: (context) => const HomeScreen(),
        loginScreenTag: (context) => const LoginScreen(),
        myRecipesScreenTag: (context) => const MyRecipesScreen(),
        profileScreenTag: (context) => const ProfileScreen(),
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
          final foodId = args['foodId'] as String?;

          if (fridgeId == null) {
            throw Exception("fridgeId not provided!");
          }

          return MaterialPageRoute(
            builder: (context) => EditFoodScreen(
              fridgeId: fridgeId,
              foodId: foodId,
            ),
          );
        }

        if (settings.name == editRecipeScreenTag) {
          final args = settings.arguments as Map<String, dynamic>;

          final recipeName = args['recipeName'] as String?;
          final recipeId = args['recipeId'] as String?;

          if (recipeName == null || recipeId == null) {
            throw Exception("recipeName or recipeId not provided!");
          }

          return MaterialPageRoute(
            builder: (context) => EditRecipeScreen(
              recipeName: recipeName,
              recipeId: recipeId,
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
