class Todo {
  String? title;
  String? description;
  String? status;

  Todo({
    this.title,
    this.description,
    this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      status: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': status,
    };
  }
}
