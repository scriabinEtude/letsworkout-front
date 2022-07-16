import 'package:flutter/material.dart';

class TestButton extends StatelessWidget {
  const TestButton({Key? key, this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.blueGrey,
        height: 100,
        width: 100,
        child: const Center(
            child: Text(
          'test',
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
