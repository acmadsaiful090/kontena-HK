class Room {
  final String id;
  final String name;
  final String description;

  Room({required this.id, required this.name, required this.description});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'], // Adjust according to your API response structure
      name: json['name'], // Adjust as needed
      description: json['description'], // Adjust as needed
    );
  }
}
