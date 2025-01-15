import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_edit_screen.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _selectedIndex = 0; // Untuk melacak tab yang dipilih

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Tab Home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome to InvApps!')),
      );
    } else if (index == 1) {
      // Tambah Task
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => TaskEditScreen()))
          .then((_) {
        Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      });
    } else if (index == 2) {
      // Lihat Task (Refresh)
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } else if (index == 3) {
      // Logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'InvApps',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text(
                'Tidak Ada Data Kerjaan!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (ctx, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: task.isCompleted ? Colors.green[50] : Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.orange,
                      size: 30,
                    ),
                    title: Text(
                      task.title,
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color:
                            task.isCompleted ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                task.isCompleted ? Colors.grey : Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Created at: ${task.createdAt?.toLocal().toString().split(' ')[0]}', // Tanggal dalam format YYYY-MM-DD
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await taskProvider.deleteTask(task.id!);
                      },
                    ),
                    onTap: () {
                      Navigator.of(ctx)
                          .push(MaterialPageRoute(
                        builder: (_) => TaskEditScreen(task: task),
                      ))
                          .then((_) {
                        taskProvider.fetchTasks();
                      });
                    },
                    onLongPress: () {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        isCompleted: !task.isCompleted,
                        createdAt: task.createdAt, // Menjaga tanggal tetap
                      );
                      taskProvider.updateTask(updatedTask);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
                Icons.work), // Ikon untuk Home, lebih relevan untuk pekerjaan
            label: '', // Menghilangkan label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task), // Ikon untuk menambahkan task
            label: '', // Menghilangkan label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), // Ikon untuk melihat task
            label: '', // Menghilangkan label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app), // Ikon untuk logout, tetap relevan
            label: '', // Menghilangkan label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
