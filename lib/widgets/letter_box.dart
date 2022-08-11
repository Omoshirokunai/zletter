import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LetterBox extends StatelessWidget {
  final Color borderColor;
  final double fontsize;
  final TextEditingController mycontrol;
  const LetterBox({Key key, this.borderColor, this.fontsize, this.mycontrol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 55,
      child: TextFormField(
        controller: mycontrol,
        enableInteractiveSelection: true,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            gapPadding: 5.0,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            gapPadding: 5.0,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(
            color: Colors.white, fontFamily: "RobotoSlabB", fontSize: 25),
        keyboardType: TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
        ],
        onEditingComplete: () {},
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
