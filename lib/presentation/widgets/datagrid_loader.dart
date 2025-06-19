import 'package:flutter/material.dart';

import '../../core/constants.dart';

class DataGridLoader extends StatelessWidget {
  const DataGridLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: loaderHeight,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderDirectional(
          top: BorderSide(width: 1.0, color: loaderColor),
        ),
      ),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
      ),
    );
  }
}
