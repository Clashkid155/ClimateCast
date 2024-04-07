import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.search});
  final void Function(String location) search;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showSearch = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      // reverseDuration: Duration(milliseconds: 2000),
      switchOutCurve: Curves.easeOut,
      child: showSearch
          ? IconButton(
              icon: const Icon(
                Icons.search,
                size: 28,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  showSearch = !showSearch;
                });
              },
            )
          : SizedBox(
              height: 80,
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 10),
                      borderRadius: BorderRadius.circular(50)),
                  /* enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),*/
                  enabled: true,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) widget.search(value);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () => setState(() {
                      showSearch = !showSearch;
                    }),
                  );
                },
              ),
            ),
      // crossFadeState:
      //     showSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
