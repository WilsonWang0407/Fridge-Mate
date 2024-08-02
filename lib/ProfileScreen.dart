import 'dart:io';
import 'helpers/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _imageUrl;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

   Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if(_imageFile == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_imageFile!);

      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'profilePictureUrl': downloadUrl}, SetOptions(merge: true));
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _loadProfilePicture() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if(userDoc.exists) {
        setState(() {
          _imageUrl = userDoc.data()?['profilePictureUrl'] as String?;
        });
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userEmail = user?.email ?? 'Email not available';

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
              'Profile',
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

    final profilePicture = GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          backgroundImage:
              _imageUrl != null ? NetworkImage(_imageUrl!) : null,
          child: _imageUrl == null
              ? Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey[400],
                )
              : null,
        ),
      ),
    );

    final userName = SizedBox(
      width: 200,
      child: TextField(
        style: listTitleTextStyle,
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'User Name',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );

    final email = Center(
      child: Text(
        'Email: $userEmail',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );

    final changePasswordTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'Reset Password',
        style: listTitleTextStyle,
      ),
    );

    final enterNewPassword = SizedBox(
      width: 310,
      height: 40,
      child: TextField(
        keyboardType: TextInputType.text,
        style: centerBarInputTextStyle,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(128)],
        decoration: InputDecoration(
          hintText: 'Enter new password',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

    final confirmNewPassword = SizedBox(
      width: 310,
      height: 40,
      child: TextField(
        keyboardType: TextInputType.text,
        style: centerBarInputTextStyle,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(128)],
        decoration: InputDecoration(
          hintText: 'Confirm new password',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

    final saveButton = SizedBox(
      width: 90,
      height: 30,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );

    final logoutButton = SizedBox(
      width: 150,
      height: 50,
      child:OutlinedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacementNamed(loginScreenTag);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: burstSienna,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: const BorderSide(
            width: 2,
            color: Colors.black,
          )
        ),
        child: Text(
          'Log Out',
          style: bigButtonTextStyle,
        ),
      ),
    );

    final resetPasswordBar = Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: cambridgeBlue,
        borderRadius: const BorderRadius.all(Radius.circular((30))),
      ),
      child: Column(
        children: [
          space10,
          changePasswordTitle,
          space10,
          enterNewPassword,
          space5,
          confirmNewPassword,
          space20,
          saveButton,
        ],
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
          profilePicture,
          space5,
          userName,
          email,
          SizedBox(height: 60),
          resetPasswordBar,
          space80,
          logoutButton,
        ]
      )
    );
  }
}