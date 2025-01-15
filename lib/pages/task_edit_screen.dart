import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  const TaskEditScreen({super.key, this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
      _selectedDate = widget.task!.createdAt;
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();

    setState(() {
      _selectedDate = picked;
    });
  }

  void _saveTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedDate == null) return;

    final task = Task(
      id: widget.task?.id,
      title: title,
      description: description,
      isCompleted: _isCompleted,
      createdAt: _selectedDate!,
    );

    if (widget.task == null) {
      // Menambahkan task baru
      Provider.of<TaskProvider>(context, listen: false).addTask(task);
    } else {
      // Memperbarui task
      Provider.of<TaskProvider>(context, listen: false).updateTask(task);
    }

    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Tambah Data' : 'Edit Data',
          style: TextStyle(
              color: Colors.white), // Menambahkan warna putih pada teks
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Judul Task
              _buildTextField(
                controller: _titleController,
                labelText: 'Judul Kerjaan',
              ),
              SizedBox(height: 20),
              // Input Deskripsi Task
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Deskripsi Kerjaan',
                maxLines: 5,
              ),
              SizedBox(height: 20),
              // Switch untuk Completed
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Sudah Selesai', style: TextStyle(fontSize: 16)),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Input Tanggal
              _buildDatePicker(),
              SizedBox(height: 30),
              // Tombol Add / Save Changes
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueGrey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  widget.task == null ? 'Tambah Data' : 'Simpan Perubahan',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat widget TextField dengan desain lebih bersih
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey[800]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Membuat widget untuk memilih tanggal dengan desain lebih menarik
  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            _selectedDate == null
                ? 'Pilih Tanggal'
                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.calendar_today, color: Colors.blueGrey[800]),
        ),
      ),
    );
  }
}
