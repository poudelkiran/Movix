import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Utilities/extensions/colors.dart';


class SeachBar extends StatefulWidget {

final TextEditingController controller;

  const SeachBar({Key key, this.controller}) : super(key: key);
  @override
  _SeachBarState createState() => _SeachBarState();
}

class _SeachBarState extends State<SeachBar> {
  
  bool hideCrossButton;
  @override
  void initState() {
    hideCrossButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        onChanged: (text) {
          _handleEditing(text);
        },
        autofocus: false,
        decoration: InputDecoration(
          hoverColor: Colors.black,
          hintText: Constant.search,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
          fillColor: AppColor.searchBackgroundColor,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(15.0)),
          prefixIcon: Icon(
            CupertinoIcons.search,
            size: 25,
            color: Colors.black,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              widget.controller.clear();
              _handleEditing("");
            },
            child: hideCrossButton
                ? SizedBox(
                    height: 0,
                  )
                : Icon(
                    CupertinoIcons.clear_circled,
                    size: 25,
                    color: Colors.black,
                  ),
          ),
        ),
      ),
    );
  }

  /// when cross button is clicked. 
  void _handleEditing(String text) {

    setState(() {
      hideCrossButton = text.isEmpty;
    });
  }
}
