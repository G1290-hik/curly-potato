import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/modals/modal.dart';

class TodoScreen extends StatefulWidget {
  final String title;
  final bool isDarkTheme;
  final Map? task;

  const TodoScreen({
    required this.title,
    required this.isDarkTheme,
    this.task,
    super.key,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool completed = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title.text = widget.task!['title'] ?? '';
      _desc.text = widget.task!['description'] ?? '';
      completed = widget.task!['status'] == 'true';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context, widget.isDarkTheme); // Pass back the isDarkTheme value
          },
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                minLines: 5,
                maxLines: 8,
                controller: _desc,
                decoration: InputDecoration(
                  hintText: 'Enter Description...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24.0, 0, 24.0),
                child: Row(
                  children: [
                    const Text(
                      "Completed:",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                      value: completed,
                      onChanged: (bool value) {
                        setState(() {
                          completed = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.15,
              ),
              MaterialButton(
                color: Theme.of(context).iconTheme.color,
                minWidth: MediaQuery.sizeOf(context).width * 0.5,
                onPressed: submit,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    final title = _title.text;
    final description = _desc.text;
    final status = completed.toString();

    final todo = Todo(
      title: title,
      description: description,
      status: status,
    );

    if (widget.task == null) {
      // Create new task
      const url = 'https://api.nstack.in/v1/todos';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode == 201) {
        showSnackbar('Task created successfully', Colors.green);
        Navigator.pop(context, widget.isDarkTheme);
      } else {
        showSnackbar('Failed to create task', Colors.red);
      }
    } else {
      // Update existing task
      final url = 'https://api.nstack.in/v1/todos/${widget.task!['_id']}';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode == 200) {
        showSnackbar('Task updated successfully', Colors.green);
        Navigator.pop(context, widget.isDarkTheme);
      } else {
        showSnackbar('Failed to update task', Colors.red);
      }
    }
  }

  void showSnackbar(String message, Color? color) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
