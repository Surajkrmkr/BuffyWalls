import 'package:flutter/material.dart';

class BuffyTextField extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function() onClear;
  final void Function(String)? onSubmitted;
  final TextEditingController controller;
  const BuffyTextField({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorWidth: 2,
        cursorRadius: const Radius.circular(10),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: false,
          hintText: 'Search wallpapers...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    size: 20,
                  ),
                ),
          prefixIcon: IconButton(
            onPressed: () => Navigator.pop(context),
            iconSize: 22,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
