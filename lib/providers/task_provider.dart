import 'package:flutter/material.dart';
import '../models/task.dart';
import '../helpers/db_helper.dart'; // Pastikan path ini benar

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Ambil task dari database
  Future<void> fetchTasks() async {
    try {
      final taskList = await DBHelper.getTasks();
      _tasks = taskList;
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load tasks: $error');
    }
  }

  // Tambahkan task baru
  Future<void> addTask(Task task) async {
    try {
      // Jika createdAt null, set dengan waktu saat ini
      task = Task(
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt ??
            DateTime.now(), // Menambahkan waktu saat ini jika tidak ada tanggal
      );
      final id = await DBHelper.insertTask(task);
      task.id = id; // Set ID yang baru
      _tasks.add(task); // Menambahkan task ke list yang ada
      notifyListeners(); // Notifikasi perubahan UI
    } catch (error) {
      throw Exception('Failed to add task: $error');
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    try {
      // Jika task sudah ada, pastikan createdAt tetap tidak berubah
      final existingTask = _tasks.firstWhere((t) => t.id == task.id);
      task = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        createdAt:
            existingTask.createdAt, // Tetap menggunakan createdAt yang lama
      );
      await DBHelper.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task; // Update task di list
        notifyListeners(); // Notifikasi perubahan UI
      }
    } catch (error) {
      throw Exception('Failed to update task: $error');
    }
  }

  // Hapus task
  Future<void> deleteTask(int id) async {
    try {
      await DBHelper.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id); // Hapus task dari list
      notifyListeners(); // Notifikasi perubahan UI
    } catch (error) {
      throw Exception('Failed to delete task: $error');
    }
  }
}
