import 'package:flutter/material.dart';

class CommentInputField extends StatelessWidget {
  const CommentInputField({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.onChanged,
    required this.onPressed,
    this.display = true,
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String) onChanged;
  final void Function() onPressed;
  final bool display;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (!display) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: null,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: "댓글 달기",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                color: controller.text.isEmpty ? Colors.black : Colors.blue,
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      );
    });
  }
}
