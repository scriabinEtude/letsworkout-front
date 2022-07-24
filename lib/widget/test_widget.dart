import 'package:flutter/material.dart';

class TestValuePrintContainer extends StatelessWidget {
  const TestValuePrintContainer({Key? key, required this.value})
      : super(key: key);
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      color: Colors.amber[50],
      child: Center(
        child: Text(value.toString()),
      ),
    );
  }
}

class TestBorderContainer extends StatelessWidget {
  const TestBorderContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: child,
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
