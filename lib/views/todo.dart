import 'package:flutter/material.dart';
class Todo_screen extends StatefulWidget {
  const Todo_screen({
    super.key,
    required this.title,
    required this.toggleTheme,
    required this.isDarkTheme,
  });
  final String title;
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  @override
  State<Todo_screen> createState() => _Todo_screenState();
}

class _Todo_screenState extends State<Todo_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.toggleTheme,
              tooltip: 'Toggle Theme',
              icon: Icon(
                widget.isDarkTheme ? Icons.wb_sunny : Icons.mode_night,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}