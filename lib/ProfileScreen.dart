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
  String _userName = '';
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _passwordError = '';

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
    if (_imageFile == null) return;

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

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profilePictureUrl': downloadUrl,
        'userName': _nameController.text,
      }, SetOptions(merge: true));
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
          _userName = userDoc.data()?['userName'] as String? ?? '';
          _nameController.text = _userName;
        });
      }
    } catch (e) {
      print('Error loading profile picture: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userName': _nameController.text,
      }, SetOptions(merge: true));

      setState(() {
        _userName = _nameController.text;
      });
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  Future<void> _updatePassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if(newPassword == confirmPassword) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if(user == null) return;

        await user.updatePassword(newPassword);

        setState(() {
          _passwordError = 'Password updated successfully';
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      } catch (e) {
        print('Error updating password: $e');
        setState(() {
          _passwordError = 'Error updating password';
        });

         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
      }
    } else {
      setState(() {
        _passwordError = 'Passwords do not match';
      });

       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
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
          color: Colors.grey[500],
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          backgroundImage:
              _imageUrl != null ? NetworkImage(_imageUrl!) : null,
          child: _imageUrl == null
              ? Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[600],
                )
              : null,
        ),
      ),
    );

    final userName = SizedBox(
      width: 200,
      child: TextField(
        controller: _nameController,
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
        onChanged: (text) async {
          await _saveProfile();
        },
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
        controller: _newPasswordController,
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
        controller: _confirmPasswordController,
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

    final passwordErrorText = _passwordError.isNotEmpty
        ? Text(
            _passwordError,
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          )
        : SizedBox.shrink();

    final saveButton = SizedBox(
      width: 90,
      height: 30,
      child: OutlinedButton(
        onPressed: _updatePassword,
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
          Navigator.of(context).pushNamed(loginScreenTag);
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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          ],
        ),
      ),
    );
  }
}