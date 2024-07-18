import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';
import 'helpers/Constants.dart';

class EditFoodScreen extends StatefulWidget {
  const EditFoodScreen({super.key});

  @override
  _EditFoodScreenState createState() {
    return _EditFoodScreenState();
  }
}

class _EditFoodScreenState extends State<EditFoodScreen> {

  DateTime selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {

    final topBar = Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 5,
          child: TextButton(
            onPressed: null,
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

    final takePictureButton = SizedBox(
      width: 250,
      height: 60,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: Text(
          'Take Picture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );

    final foodNameRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Food Name:',
          style: centerBarHintTextStyle,
        ),
        SizedBox(
          width: 170,
          height: 30,
          child: TextField(
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
          width: 205,
          height: 30,
          child: TextField(
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
          'Expiration Date',
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

    final centerBar = Container(
      width: 340,
      height: 380,
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
          space10,
          quantityRow,
          space10,
          expiratinDateRow,
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
          space80,
          takePictureButton,
          space80,
          centerBar,
        ]
      )
    );
  }
}