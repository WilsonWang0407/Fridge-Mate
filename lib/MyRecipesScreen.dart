import 'helpers/Constants.dart';
import 'widgets/RecipeButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  _MyRecipesScreenState createState() {
    return _MyRecipesScreenState();
  }
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  List<Widget> recipeButtonList = [];
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await _fetchUserName();
    await _loadRecipeButtons();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['userName'] ?? '';
        });
      }
    }
  }

  Future<void> _loadRecipeButtons() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes');

    final recipeDocs = await recipeCollection.get();

    setState(() {
      recipeButtonList = [
        for (var doc in recipeDocs.docs) ...[
          FutureBuilder<QuerySnapshot>(
            future: recipeCollection.doc(doc.id).collection('ingredients').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildRecipeButton(doc.id, doc.data(), []);
              }
              List<String> ingredients = snapshot.data!.docs.map((ingredientDoc) {
                Map<String, dynamic> ingredientData = ingredientDoc.data() as Map<String, dynamic>;
                return (ingredientData['name'] ?? 'Unknown').toString();
              }).toList();

              return _buildRecipeButton(doc.id, doc.data(), ingredients);
            },
          ),
          space10,
        ],
      ];
    });
  }

  Widget _buildRecipeButton(String recipeId, Map<String, dynamic> recipeData, List<String> ingredients) {
    final imageUrl = recipeData['dishPictureUrl'] ??
        'https://firebasestorage.googleapis.com/v0/b/wilsons-fridge-mate.appspot.com/o/default_image.jpeg?alt=media&token=03eab702-aa2b-4fc7-a23b-d16477a1ba12';

    final recipeName = recipeData['recipeName'] ?? 'No Name';

    return Dismissible(
      key: Key(recipeId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await _deleteRecipe(recipeId);
      },
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      child: RecipeButton(
        imageUrl: imageUrl,
        recipeName: recipeName,
        userName: userName,
        ingredients: ingredients.join(', '),
        onPressed: () {
          navigateToEditRecipe(recipeId, recipeName);
        },
      ),
    );
  }

  Future<void> _deleteRecipe(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .delete();
      await _loadRecipeButtons();
    } catch (e) {
      print('Error deleting recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addRecipeToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes');

    final newDocRef = recipeCollection.doc();

    await newDocRef.set({
      'recipeName': 'My Recipe',
    });

    await _loadRecipeButtons();
  }

  Widget addNewRecipe() {
    return SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: () async {
          await _addRecipeToFirestore();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: burstSienna,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child: Text(
          '+  Add New Recipe',
          style: bigButtonTextStyle,
        ),
      ),
    );
  }

  Widget recipeList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 20, right: 20),
      children: <Widget>[
        ...recipeButtonList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final topBar = Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 5,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(homeScreenTag);
            },
            child: Text(
              '<Back',
              style: backButtonTextStyle,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: null,
            child: Text(
              'My Recipes',
              style: bigButtonTextStyle,
            ),
          ),
        ),
      ],
    );

    final underline = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.5, color: Colors.black),
        ),
      ),
    );

    final listTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'List of Recipes',
        style: listTitleTextStyle,
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: eggShell,
        body: Column(
          children: <Widget>[
            space80,
            topBar,
            underline,
            space50,
            addNewRecipe(),
            space50,
            listTitle,
            space10,
            Expanded(
              child: recipeList(),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToEditRecipe(String recipeId, String recipeName) async {
    final result = await Navigator.pushNamed(
      context,
      editRecipeScreenTag,
      arguments: {
        'recipeName': recipeName,
        'recipeId': recipeId,
      },
    );

    if (result == true) {
      await _loadRecipeButtons();
    }
  }
}
