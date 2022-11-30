class Task{

  int? id;
  String? name;
  String? details;
  String? createdAt;
  String? updatedAt;

  Task({
    this.id,
    this.name,
    this.details,
    this.createdAt,
    this.updatedAt
});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        name: json['name'],
        details: json['details'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']
    );
  }

}