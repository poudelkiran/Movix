//* Error Widget

import 'package:flutter/material.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Utilities/styles.dart';

class ErrorCellWidget extends StatelessWidget {
  final ValueOrError value;
  ErrorCellWidget(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value.title,
              textAlign: TextAlign.center,
              style: Style.titleStyle,
            ),
            Text(
              value.error,
              textAlign: TextAlign.center,
              style: Style.subHeaderStyle,
            ),
          ],
        ),
      ),
    );
  }
}