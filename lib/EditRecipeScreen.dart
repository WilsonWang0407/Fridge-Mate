import 'dart:io';
import 'widgets/IngredientBar.dart';
import 'helpers/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipeScreen extends StatefulWidget {
  final String recipeName;
  final String recipeId;
  final String? ingredientId;

  const EditRecipeScreen({
    Key? key,
    required this.recipeName,
    required this.recipeId,
    this.ingredientId,
  }) : super(key: key);

  @override
  _EditRecipeScreenState createState() {
    return _EditRecipeScreenState();
  }
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  List<IngredientBar> ingredientBarList = [];
  late TextEditingController _recipeNameController;
  bool _isLoading = true;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  bool _hasChanges = false;
  File? _image;
  String? _dishPictureUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipeNameController = TextEditingController();
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot recipeSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(widget.recipeId)
          .get();

      if (recipeSnapshot.exists) {
        final data = recipeSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _recipeNameController.text = data['recipeName'] ?? widget.recipeName;
          _descriptionController.text = data.containsKey('description') ? data['description'] : '';
          _dishPictureUrl = data.containsKey('dishPictureUrl') ? data['dishPictureUrl'] : null;
          _isLoading = false;
        });
      } else {
        _recipeNameController.text = widget.recipeName;
      }

      QuerySnapshot ingredientSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(widget.recipeId)
          .collection('ingredients')
          .get();

      List<IngredientBar> loadedIngredients = [];
      for (var doc in ingredientSnapshot.docs) {
        loadedIngredients.add(
          IngredientBar(
            initialName: doc['name'],
            initialQuantity: doc['quantity'],
          ),
        );
      }

      setState(() {
        ingredientBarList = loadedIngredients;
      });
    } catch (e) {
      print('Error loading recipe data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipeName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(widget.recipeId)
          .set(
        {
          'recipeName': _recipeNameController.text,
        },
        SetOptions(merge: true),
      );

      _hasChanges = true;
    } catch (e) {
      print('Error saving recipe name: $e');
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('dish_images/${DateTime.now().toIso8601String()}_${_image!.path.split('/').last}');
    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      _dishPictureUrl = urlDownload;
    });
  }

  Widget addNewIngredient() {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        onPressed: () {
          setState(() {


            ingredientBarList.add(IngredientBar());
          });
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

  Widget ingredientList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 40, right: 40),
      children: [
        for (var i = 0; i < ingredientBarList.length; i++) ...[
          Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                ingredientBarList.removeAt(i);
              });
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ingredientBarList[i],
          ),
          space10,
        ],
        addNewIngredient(),
      ],
    );
  }

  Future<bool> _validateIngredients() async {
    for (var ingredientBar in ingredientBarList) {
      if (ingredientBar.nameController.text.trim().isEmpty ||
          ingredientBar.quantityController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All ingredient fields must be filled out.')),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _saveIngredients() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ingredientCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(widget.recipeId)
        .collection('ingredients');

    final existingIngredients = await ingredientCollection.get();
    for (var doc in existingIngredients.docs) {
      await doc.reference.delete();
    }

    for (var ingredientBar in ingredientBarList) {
      final name = ingredientBar.nameController.text.trim();
      final quantity = ingredientBar.quantityController.text.trim();
      if (name.isNotEmpty && quantity.isNotEmpty) {
        await ingredientCollection.add({
          'name': name,
          'quantity': quantity,
        });
      }
    }
  }

  Future<void> _saveRecipeDetails() async {
    if (!await _validateIngredients()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(widget.recipeId)
          .set({
        'dishPictureUrl': _dishPictureUrl,
        'description': _descriptionController.text,
      }, SetOptions(merge: true));

      await _saveIngredients();

      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving recipe details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recipe details: $e')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_hasChanges);
    return false;
  }

  Widget _buildTakePictureButton() {
    return SizedBox(
      width: 250,
      height: 60,
      child: OutlinedButton(
        onPressed: () {
          _pickImage(ImageSource.camera);
        },
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
                    controller: _recipeNameController,
                    focusNode: _focusNode,
                    readOnly: !_isEditing,
                    inputFormatters: [LengthLimitingTextInputFormatter(12)],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: bigButtonTextStyle,
                    textAlign: TextAlign.start,
                    onChanged: (text) {},
                    onSubmitted: (text) async {
                      await _saveRecipeName();
                      setState(() {
                        _isEditing = false;
                      });
                    },
                  ),
                  if (!_isEditing)
                    Positioned(
                      left: _calculateIconPosition(
                          _recipeNameController.text, bigButtonTextStyle),
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

    final dishImage = (_dishPictureUrl != null || _image != null)
        ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (_image != null)
                    ? Image.file(_image!,
                        width: 150, height: 150, fit: BoxFit.cover)
                    : Image.network(_dishPictureUrl!,
                        width: 150, height: 150, fit: BoxFit.cover),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          )
        : _buildTakePictureButton();

    final ingredientTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'Ingredients',
        style: listTitleTextStyle,
      ),
    );

    final descriptionTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'Description',
        style: listTitleTextStyle,
      ),
    );

    final descriptionField = Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: centerBarInputTextStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );

    final saveButton = SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        onPressed: _saveRecipeDetails,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: eggShell,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 57),
                topBar,
                underline,
                space20,
                dishImage,
                space20,
                ingredientTitle,
                space5,
                SizedBox(
                  height: 200,
                  child: ingredientList(),
                ),
                space30,
                descriptionTitle,
                space5,
                descriptionField,
                space30,
                saveButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
