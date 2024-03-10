import 'package:flutter/material.dart';

class BuffyTextField extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function() onClear;
  final TextEditingController controller;
  const BuffyTextField(
      {super.key,
      required this.onChanged,
      required this.controller,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onBackground,
      cursorWidth: 3,
      cursorRadius: const Radius.circular(10),
      onTap: () {},
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        hintText: 'Search for ...',
        hintStyle: const TextStyle(fontSize: 14),
        suffixIcon: IconButton(
            onPressed: controller.text.isNotEmpty ? onClear : null,
            icon: Icon(controller.text.isNotEmpty
                ? Icons.cancel
                : Icons.search_rounded)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onBackground),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}
