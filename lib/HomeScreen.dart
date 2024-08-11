import 'helpers/Constants.dart';
import 'widgets/FridgeButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> fridgeButtonList = [];
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await _fetchUserName();
    await _loadFridgeButtons();
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

  Future<void> _loadFridgeButtons() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fridgeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridges');

    final fridgeDocs = await fridgeCollection.get();

    setState(() {
      fridgeButtonList = [
        for (var doc in fridgeDocs.docs) ...[
          FutureBuilder<QuerySnapshot>(
            future: fridgeCollection.doc(doc.id).collection('food').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildFridgeButton(doc.id, doc.data(), []);
              }
              List<Map<String, String>> foodItems = snapshot.data!.docs.map((foodDoc) {
                Map<String, dynamic> foodData = foodDoc.data() as Map<String, dynamic>;
                return {
                  'name': (foodData['foodName'] ?? 'Unknown').toString(),
                  'quantity': (foodData['quantity'] ?? '0').toString(),
                };
              }).toList();

              return _buildFridgeButton(doc.id, doc.data(), foodItems);
            },
          ),
          space10,
        ],
        addNewFridge(),
      ];
    });
  }

  Widget _buildFridgeButton(String fridgeId, Map<String, dynamic> fridgeData, List<Map<String, String>> foodItems) {
    return Container(
      width: double.infinity,
      child: Dismissible(
        key: Key(fridgeId),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          await _deleteFridge(fridgeId);
        },
        confirmDismiss: (direction) async {
          return await _showDeleteConfirmationDialog(context);
        },
        child: FridgeButton(
          fridgeName: fridgeData['fridgeName'],
          userName: userName,
          fridgeId: fridgeId,
          foodItems: foodItems,
          onPressed: () {
            navigateToFridgeDetail(fridgeId, fridgeData['fridgeName']);
          },
        ),
      ),
    );
  }

  Future<void> _deleteFridge(String fridgeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fridges')
          .doc(fridgeId)
          .delete();
      await _loadFridgeButtons();
    } catch (e) {
      print('Error deleting fridge: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete fridge: $e')),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this fridge?'),
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

  Future<void> _addFridgeToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fridgeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridges');

    final newDocRef = fridgeCollection.doc();

    await newDocRef.set({
      'fridgeName': 'My Fridge',
    });

    await _loadFridgeButtons();
  }

  Widget addNewFridge() {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        onPressed: () async {
          await _addFridgeToFirestore();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: cambridgeBlue,
          shape: CircleBorder(),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '+',
            style: listTitleTextStyle,
          ),
        ),
      ),
    );
  }

  Widget fridgeList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 20, right: 20),
      children: <Widget>[
        ...fridgeButtonList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final topBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(recipesScreenTag);
          },
          child: Text(
            'Recipes',
            style: bigButtonTextStyle,
          ),
        ),
        Text(
          '|',
          style: bigButtonTextStyle,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(myRecipesScreenTag);
          },
          child: Text(
            'My Recipes',
            style: bigButtonTextStyle,
          ),
        ),
        Text(
          '|',
          style: bigButtonTextStyle,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(profileScreenTag);
          },
          child: Text(
            'Profile',
            style: bigButtonTextStyle,
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
      padding: const EdgeInsets.only(right: 180),
      child: Text(
        'List of Fridges',
        style: listTitleTextStyle,
      ),
    );

    return Scaffold(
      backgroundColor: eggShell,
      body: Column(
        children: <Widget>[
          space80,
          topBar,
          underline,
          space30,
          listTitle,
          space20,
          Expanded(
            child: fridgeList(),
          ),
        ],
      ),
    );
  }

  void navigateToFridgeDetail(String fridgeId, String fridgeName) async {
    final result = await Navigator.pushNamed(
      context,
      fridgeDetailScreenTag,
      arguments: {
        'fridgeName': fridgeName,
        'fridgeId': fridgeId,
      },
    );

    if (result == true) {
      await _loadFridgeButtons();
    }
  }
}