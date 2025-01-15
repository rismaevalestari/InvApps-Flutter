class Task {
  int? id; // id bisa null saat pertama kali dibuat
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? createdAt; // Menambahkan tanggal

  // Konstruktor Task
  Task({
    this.id, // id bisa null saat pertama kali dibuat
    required this.title,
    required this.description,
    required this.isCompleted,
    this.createdAt, // Tanggal bisa null, atau di-set saat pembuatan task
  });

  // Mengonversi Task ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id akan bernilai null ketika belum ada ID
      'title': title,
      'description': description,
      'isCompleted':
          isCompleted ? 1 : 0, // Mengubah bool menjadi integer (0 atau 1)
      'createdAt': createdAt
          ?.toIso8601String(), // Menyimpan tanggal dalam format ISO 8601
    };
  }

  // Mengonversi Map ke Task
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'], // id diambil dari map dan bisa null
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1, // Mengubah integer menjadi bool
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null, // Mengambil dan mengonversi tanggal
    );
  }
}
