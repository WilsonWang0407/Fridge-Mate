import 'dart:io';
import 'helpers/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodScreen extends StatefulWidget {
  final String fridgeId;

  const EditFoodScreen({
    Key? key,
    required this.fridgeId,
  }) : super(key: key);

  @override
  _EditFoodScreenState createState() {
    return _EditFoodScreenState();
  }
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  bool? isChecked = false;
  DateTime selectedDate = DateTime.now();
  File? _image;
  String? _foodPictureUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    final storageRef = FirebaseStorage.instance.ref().child('food_images/${DateTime.now().toIso8601String()}_${_image!.path.split('/').last}');
    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      _foodPictureUrl = urlDownload;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildTakePictureButton() {
    return SizedBox(
      width: 250,
      height: 60,
      child: OutlinedButton(
        onPressed: _pickImage,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: const Text(
          'Take Picture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _saveFoodDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    final foodCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('fridges')
        .doc(widget.fridgeId)
        .collection('food');

    await foodCollection.add({
      'foodPictureUrl': _foodPictureUrl,
      'foodName': _foodNameController.text,
      'quantity': _quantityController.text,
      'expirationDate': formatDate(selectedDate.toLocal(), [dd, '-', mm, '-', yyyy]),
      'isOpened': isChecked ?? false,
    });

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {

    final topBar = Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 5,
          child: TextButton(
            onPressed:() {
              Navigator.of(context).pop();
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
              'Edit Food',
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

    final foodImage = _image != null
      ? Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: _pickImage,
              ),
            ],
          ),
        )
      : _buildTakePictureButton();

    final foodNameRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Food Name:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 180,
          height: 30,
          child: TextField(
            controller: _foodNameController,
            keyboardType: TextInputType.text,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(175)],
            decoration: centerBarInputDecoration,
          ),
        )
      ],
    );

    final quantityRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Quantity:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 210,
          height: 30,
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.text,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(24)],
            decoration: centerBarInputDecoration,
          ),
        )
      ],
    );

    final expiratinDateRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Expiration Date:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 135,
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text(
              formatDate(selectedDate.toLocal(), [dd, '-', mm, '-', yyyy]),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );

    final isOpenedRow = Row(
      children: <Widget>[
        SizedBox(width: 10),
        Text(
          'Is Opened:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(width: 5),
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: Transform.scale(
            scale: 1.8,
            child:Checkbox(
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
              checkColor: Colors.black,
              side: BorderSide(
                color: Colors.transparent,
              ),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value;
                });
              },
            ),
          ),
        ),
      ]
    );

    final saveButton = SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        onPressed: _saveFoodDetails,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
          side: BorderSide(
            width: 3,
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );

    final centerBar = Container(
      width: 340,
      height: 360,
      decoration: BoxDecoration(
        color: cambridgeBlue,
        border: Border.all(
          width: 2.5,
          color: Colors.black,
        ),
        borderRadius: const BorderRadius.all(Radius.circular((30))),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          foodNameRow,
          space20,
          quantityRow,
          space20,
          expiratinDateRow,
          space10,
          isOpenedRow,
          SizedBox(height: 40),
          saveButton,
        ]
      )
    );

    return Scaffold(
      backgroundColor: eggShell,
      body: Column(
        children: <Widget>[
          space80,
          topBar,
          underline,
          space50,
          foodImage,
          space50,
          centerBar,
        ]
      )
    );
  }
}