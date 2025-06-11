class StudentApplication {
  final int id;
  final String name;
  final double progress;
  final String status;

  StudentApplication(this.status,  {
    required this.id,
    required this.name,
    required this.progress,
  });

  factory StudentApplication.fromJson(Map<String, dynamic> json) {
  return StudentApplication(
    json['status'] ?? 'Unknown', // Default to 'Unknown' if status is not present
    id: json['id'],
    name: json['name'],
    progress: json['progress']?.toDouble() ?? 0.0,
  );
  }
}