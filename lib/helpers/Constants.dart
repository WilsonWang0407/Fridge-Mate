import 'package:flutter/material.dart';

// Pages
const loginScreenTag = 'Login Screen';
const homeScreenTag = 'Home Screen';
const fridgeDetailScreenTag = 'Fridge Detail Screen';
const editFoodScreenTag = 'Edit Food Screen';
const myRecipesScreenTag = 'My Recipes Screen';
const recipeDetailScreenTag = 'Recipe Detail Screen';

// Color
Color eggShell = const Color.fromARGB(255, 244, 241, 222);
Color burstSienna = const Color.fromARGB(255, 224, 122, 95);
Color delftBlue = const Color.fromARGB(255, 15, 37, 78);
Color cambridgeBlue = const Color.fromARGB(255, 129, 178, 154);
Color sunset = const Color.fromARGB(255, 242, 204, 143);

// Text Style
TextStyle bigButtonTextStyle = const TextStyle(fontSize: 23.5, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle centerBarHintTextStyle = const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle centerBarInputTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
TextStyle listTitleTextStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle backButtonTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54);

// SizedBox
SizedBox space10 = const SizedBox(height: 10);
SizedBox space80 = const SizedBox(height: 80);

// Decoration
InputDecoration centerBarInputDecoration = InputDecoration(filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.only(left: 6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)));

// Image
Image appLogo = Image.asset('assets/images/FridgeMate_Logo.png');