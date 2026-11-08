import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Directory',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const StudentDirectoryPage(),
    );
  }
}

// Student class
class Student {
  final String image;
  final String name;
  final String course;
  final String yearLevel;
  final int age;
  final String hobby;
  final String studentId;
  final String email;
  final String favoriteSubject;

  const Student({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
  });
}

// Student list
final List<Student> students = [
  const Student(
    image: 'assets/121.jpg',
    name: 'Keith Sins',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 29,
    hobby: 'Sleeping',
    studentId: '2023-0001',
    email: 'KeithSins@gmail.com',
    favoriteSubject: 'Mobile Development',
  ),
  const Student(
    image: 'assets/122.jpg',
    name: 'Clyde lilicon',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 17,
    hobby: 'Basketball',
    studentId: '2023-0002',
    email: 'clyde.tibursho@gmail.com',
    favoriteSubject: 'Algorithms',
  ),
  const Student(
    image: 'assets/123.jpg',
    name: 'Antonio Badi',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Reading',
    studentId: '2022-0003',
    email: 'antoniobadi@gmail.com',
    favoriteSubject: 'Database Systems',
  ),
  const Student(
    image: 'assets/124.jpg',
    name: 'Carl gaye',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 25,
    hobby: 'Dancing',
    studentId: '2025-0004',
    email: 'carl.gaye@gmail.com',
    favoriteSubject: 'Web Development',
  ),
  const Student(
    image: 'assets/125.jpg',
    name: 'Liam Badingon',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Cycling',
    studentId: '2023-0005',
    email: 'liam.badingon@gmail.com',
    favoriteSubject: 'Embedded Systems',
  ),
  const Student(
    image: 'assets/parbs.jpg',
    name: 'Allan Iskobar',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    age: 24,
    hobby: 'Cycling',
    studentId: '2023-0006',
    email: 'allan.iskobar@gmail.com',
    favoriteSubject: 'Dark Systems',
  ),
]..sort((first, second) => first.name.compareTo(second.name));

class StudentDirectoryPage extends StatefulWidget {
  const StudentDirectoryPage({super.key});

  @override
  State<StudentDirectoryPage> createState() => _StudentDirectoryPageState();
}

class _StudentDirectoryPageState extends State<StudentDirectoryPage> {
  final Set<String> _favoriteStudentIds = {};

  void _toggleFavorite(Student student) {
    setState(() {
      if (!_favoriteStudentIds.add(student.studentId)) {
        _favoriteStudentIds.remove(student.studentId);
      }
    });

    final isFavorite = _favoriteStudentIds.contains(student.studentId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Added ${student.name} to favorites.'
              : 'Removed ${student.name} from favorites.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteStudent(Student student) {
    setState(() {
      students.removeWhere(
        (currentStudent) => currentStudent.studentId == student.studentId,
      );
      _favoriteStudentIds.remove(student.studentId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.name} removed from the directory.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Student Directory',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${students.length} Students',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: students.isEmpty
          ? const _EmptyStudentState()
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: students
                      .map(
                        (student) => Padding(
                          key: ValueKey(student.studentId),
                          padding: const EdgeInsets.only(bottom: 14),
                          child: StudentCard(
                            student: student,
                            isFavorite: _favoriteStudentIds.contains(
                              student.studentId,
                            ),
                            onFavoritePressed: () => _toggleFavorite(student),
                            onDeletePressed: () => _deleteStudent(student),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onDeletePressed,
  });

  final Student student;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${student.name} card tapped.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      student.image,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 75,
                          height: 75,
                          color: Colors.indigo.shade100,
                          alignment: Alignment.center,
                          child: Text(
                            student.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          student.course,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          student.yearLevel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.indigo.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Divider(height: 1, color: Colors.grey.shade200),

              const SizedBox(height: 14),

              // Student details
              Column(
                children: [
                  _StudentDetail(label: 'Age', value: '${student.age}'),

                  _StudentDetail(label: 'Hobby', value: student.hobby),

                  _StudentDetail(label: 'Student ID', value: student.studentId),

                  _StudentDetail(label: 'Email', value: student.email),

                  _StudentDetail(
                    label: 'Favorite Subject',
                    value: student.favoriteSubject,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onFavoritePressed,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(isFavorite ? 'Favorited' : 'Favorite'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit ${student.name}'),
                          content: const Text(
                            'Student editing is ready for the next step.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                  TextButton.icon(
                    onPressed: onDeletePressed,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentDetail extends StatelessWidget {
  const _StudentDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStudentState extends StatelessWidget {
  const _EmptyStudentState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No students found.',
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
      ),
    );
  }
}
