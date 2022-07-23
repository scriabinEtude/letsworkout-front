import 'package:flutter/material.dart';

class TestBorderContainer extends StatelessWidget {
  const TestBorderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
    );
  }
}

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
