import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
      child: buildSearchField(),
    );
  }

  TextFormField buildSearchField() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF254EDB)),
        ),
        hintText: 'Search for doctors...',
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(6.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 194, 194, 194),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
