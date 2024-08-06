import 'helpers/Constants.dart';
import 'helpers/FridgeButton.dart';
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
  int fridgeNumCounter = 1;
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
    if(user == null) return;

    final fridgeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridges');

    final fridgeDocs = await fridgeCollection.get();

    setState(() {
      fridgeButtonList = [
        for(var doc in fridgeDocs.docs)
          ...[
            FridgeButton(
              fridgeNum: doc.data()['fridgeNum'],
              fridgeName: doc.data()['fridgeName'],
              userName: userName,
              fridgeId: doc.id,
              onPressed: () {
                navigateToFridgeDetail(doc.id, doc.data()['fridgeName']);
              }
            ),
            space10,
          ],
        addNewFridge(),
      ];
      fridgeNumCounter = fridgeDocs.size + 1;
    });
  }

  Future<void> _addFridgeToFirestore(int fridgeNum) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final fridgeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridges');

    final newDocRef = fridgeCollection.doc();

    await newDocRef.set({
      'fridgeNum': fridgeNum,
      'fridgeName': 'Fridge $fridgeNum',
    });

    await _loadFridgeButtons();
  }

  Widget addNewFridge() {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        onPressed: () async {
          await _addFridgeToFirestore(fridgeNumCounter);
        },
        style: OutlinedButton.styleFrom(
            backgroundColor: cambridgeBlue,
          shape: CircleBorder(),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child:Align(
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
      padding: const EdgeInsets.only(left:20, right: 20),
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
      padding: const EdgeInsets.only(right: 200),
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
          space10,
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