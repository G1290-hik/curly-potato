import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/views/todo.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
    this.title,
    this.toggleTheme,
    this.isDarkTheme=false,
  });

  final String? title;
  final VoidCallback? toggleTheme;
  bool isDarkTheme;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  void _gotoCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoScreen(
          title: "Create Task",
          isDarkTheme: widget.isDarkTheme,
        ),
      ),
    );
    if (result != null && result is bool) {
      setState(() {
        widget.isDarkTheme = result;
      });
    }
    fetchTodo(); // Refresh the list after returning
  }

  void _gotoEdit(Map item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoScreen(
          title: "Edit Task",
          isDarkTheme: widget.isDarkTheme,
          task: item, // Pass the task details to TodoScreen
        ),
      ),
    );
    if (result != null && result is bool) {
      setState(() {
        widget.isDarkTheme = result;
      });
    }
    fetchTodo(); // Refresh the list after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Text(
              widget.title.toString(),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map;
            final id = item['_id'] as String;
            return ListTile(
              leading: Text('${index + 1}'),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    _gotoEdit(item); // Pass the selected item
                  } else if (value == 'delete') {
                    deleteById(id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ];
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoCreate,
        tooltip: 'Go to Edit/New task screen',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    setState(() {
      isLoading = true;
    });
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      showSnackbar("Deleted Successfully", Colors.green);
      setState(() {
        items = filtered;
      });
    } else {
      showSnackbar("Unable to delete", Colors.red);
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
  }

  void showSnackbar(String message, Color? color) {
    final snackbar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
