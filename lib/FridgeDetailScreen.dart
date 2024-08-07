import 'dart:ui';
import 'helpers/FoodButton.dart';
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
  bool _hasChanges = false;

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
      if(user == null) return;

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

      _hasChanges = true;
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
              Navigator.of(context).pop(_hasChanges);
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
            padding: EdgeInsets.only(left: 150),
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
        onPressed:() {
          Navigator.pushNamed(
            context,
            editFoodScreenTag,
            arguments: {
              'fridgeId': widget.fridgeId
            },
          );
        },
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
      padding: const EdgeInsets.only(right: 210),
      child: Text(
        'List of Food',
        style: listTitleTextStyle,
      ),
    );

    return Scaffold(
        backgroundColor: eggShell,
        body: Column(
          children: <Widget>[
          SizedBox(height: 77),
          topBar,
          underline,
          space50,
          addNewFoodButton,
          space50,
          listTitle,
          space10,
          Expanded(
            child: _buildFoodList(),
          ),
        ]));
  }

Widget _buildFoodList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('fridges')
          .doc(widget.fridgeId)
          .collection('food')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) return Text('No food data available');

        return ListView.builder(
          padding: const EdgeInsets.only(left: 23),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> food = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FoodButton(
                imageUrl: food['foodPictureUrl']?.isNotEmpty == true
                  ? food['foodPictureUrl']
                  : 'https://firebasestorage.googleapis.com/v0/b/wilsons-fridge-mate.appspot.com/o/default_image.jpeg?alt=media&token=03eab702-aa2b-4fc7-a23b-d16477a1ba12',
                foodName: food['foodName'] ?? 'No Name',
                quantity: food['quantity'] ?? '0 units',
                isOpened: food['isOpened'] ?? false,
                expirationDate: food['expirationDate'] ?? 'N/A',
              ),
            );
          },
        );
      },
    );
  }
}