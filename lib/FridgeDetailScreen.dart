import 'dart:ui';
import 'helpers/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FridgeDetailScreen extends StatefulWidget {
  final String fridgeName;
  final String fridgeId;

  const FridgeDetailScreen({
    Key? key,
    required this.fridgeName,
    required this.fridgeId,
  }) : super(key: key);

  @override
  _FridgeDetailScreenState createState() {
    return _FridgeDetailScreenState();
  }
}

class _FridgeDetailScreenState extends State<FridgeDetailScreen> {
  late TextEditingController _fridgeNameController;
  bool _isLoading = true;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  void initState() {
    super.initState();
    _fridgeNameController = TextEditingController();
    _fetchFridgeName();
  }

  Future<void> _fetchFridgeName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fridges')
          .doc(widget.fridgeId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _fridgeNameController.text =
              snapshot['fridgeName'] ?? widget.fridgeName;
          _isLoading = false;
        });
      } else {
        _fridgeNameController.text = widget.fridgeName;
      }
    } catch (e) {
      print('Error fetching fridge name: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveFridgeName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fridges')
          .doc(widget.fridgeId)
          .set(
        {
          'fridgeName': _fridgeNameController.text,
        },
        SetOptions(merge: true),
      );

      await _fetchFridgeName();
    } catch (e) {
      print('Error saving fridge name: $e');
    }
  }

  double _calculateIconPosition(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 250);

    return textPainter.width;
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
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: SizedBox(
              width: 250,
              child: Stack(
                children: [
                  TextField(
                    controller: _fridgeNameController,
                    focusNode: _focusNode,
                    readOnly: !_isEditing,
                    inputFormatters: [LengthLimitingTextInputFormatter(12)],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: bigButtonTextStyle,
                    textAlign: TextAlign.start,
                    onChanged: (text) {
                      setState(() {});
                    },
                    onSubmitted: (text) async {
                      await _saveFridgeName();
                      setState(() {
                        _isEditing = false;
                      });
                    },
                  ),
                  if (!_isEditing)
                    Positioned(
                      left: _calculateIconPosition(
                        _fridgeNameController.text, bigButtonTextStyle),
                      bottom: 1,
                      child: IconButton(
                        onPressed: () async {
                          setState(() {
                            _isEditing = true;
                          });
                          _focusNode.requestFocus();
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
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

    final addNewFoodButton = SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: cambridgeBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child: Text(
          '+  Add New Food',
          style: bigButtonTextStyle,
        ),
      ),
    );

    final listTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'List of Food',
        style: listTitleTextStyle,
      ),
    );

    return Scaffold(
        backgroundColor: eggShell,
        body: Column(children: <Widget>[
          space80,
          topBar,
          underline,
          space80,
          addNewFoodButton,
          space80,
          listTitle,
        ]));
  }
}
