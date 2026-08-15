import 'package:flutter/material.dart';

class NewsSearchField extends StatelessWidget {
  const NewsSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        onChanged: onChanged,
        cursorColor: const Color(0xFF252525),
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          color: Color(0xFF252525),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          hintText: 'Search here...',
          hintStyle: TextStyle(
            color: Color(0xFFB7B7B7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Color(0xFFF1F1F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 11),
            child: Icon(Icons.search, size: 27, color: Color(0xFF8C8C8C)),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ),
    );
  }
}
