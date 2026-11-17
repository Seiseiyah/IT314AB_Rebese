import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name != StudentDetailsScreen.routeName) return null;

    final arguments = settings.arguments;
    if (arguments is! StudentDetailsRouteArguments) {
      throw ArgumentError.value(
        arguments,
        'settings.arguments',
        'Expected StudentDetailsRouteArguments.',
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => StudentDetailsScreen(
        student: arguments.student,
        onStudentSaved: arguments.onStudentSaved,
      ),
    );
  }

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
      initialRoute: StudentListScreen.routeName,
      routes: {
        StudentListScreen.routeName: (context) => const StudentListScreen(),
        AddStudentScreen.routeName: (context) => const AddStudentScreen(),
      },
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

// Student class
class Student {
  final String image;
  final String name;
  final String course;
  final String yearLevel;
  final bool isActive;
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
    required this.isActive,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
  });
}

class StudentDetailsRouteArguments {
  const StudentDetailsRouteArguments({
    required this.student,
    required this.onStudentSaved,
  });

  final Student student;
  final ValueChanged<Student> onStudentSaved;
}

// Student list
final List<Student> students = [
  const Student(
    image: 'assets/121.jpg',
    name: 'Keith Sins',
    course: 'BS Information Technology',
    yearLevel: '3rd Year',
    isActive: true,
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
    isActive: false,
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
    isActive: true,
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
    isActive: false,
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
    isActive: true,
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
    isActive: false,
    age: 24,
    hobby: 'Cycling',
    studentId: '2023-0006',
    email: 'allan.iskobar@gmail.com',
    favoriteSubject: 'Dark Systems',
  ),
]..sort((first, second) => first.name.compareTo(second.name));

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  static const routeName = '/student-list';

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final Set<String> _favoriteStudentIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

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

  void _openStudentDetails(Student student) {
    Navigator.of(context).pushNamed<void>(
      StudentDetailsScreen.routeName,
      arguments: StudentDetailsRouteArguments(
        student: student,
        onStudentSaved: _updateStudent,
      ),
    );
  }

  void _openAddStudent() {
    Navigator.of(context).pushNamed<void>(AddStudentScreen.routeName);
  }

  void _updateStudent(Student updatedStudent) {
    final studentIndex = students.indexWhere(
      (student) => student.studentId == updatedStudent.studentId,
    );
    if (studentIndex == -1) {
      throw StateError(
        'Student ${updatedStudent.studentId} is no longer in the directory.',
      );
    }

    setState(() {
      students[studentIndex] = updatedStudent;
      students.sort((first, second) => first.name.compareTo(second.name));
    });
  }

  Widget _buildDirectoryContent() {
    if (_isLoading) {
      return const _LoadingStudentState();
    }

    if (students.isEmpty) {
      return const _EmptyStudentState();
    }

    return Center(
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
                    isFavorite: _favoriteStudentIds.contains(student.studentId),
                    onFavoritePressed: () => _toggleFavorite(student),
                    onDeletePressed: () => _deleteStudent(student),
                    onTap: () => _openStudentDetails(student),
                  ),
                ),
              )
              .toList(),
        ),
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
          IconButton(
            tooltip: 'Add Student',
            onPressed: _openAddStudent,
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
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
      body: _buildDirectoryContent(),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  static const routeName = '/add-student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Center(
        child: Text(
          'The student form will be added in a future step.',
          style: TextStyle(color: Colors.grey.shade600),
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
    required this.onTap,
  });

  final Student student;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: student.isActive
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                student.isActive
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 14,
                                color: student.isActive
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                student.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: student.isActive
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ],
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

              if (isFavorite)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 15, color: Colors.pink.shade700),
                        const SizedBox(width: 5),
                        Text(
                          'Favorite student',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

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

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({
    super.key,
    required this.student,
    required this.onStudentSaved,
  });

  static const routeName = '/student-details';

  final Student student;
  final ValueChanged<Student> onStudentSaved;

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  Future<void> _editStudent() async {
    final updatedStudent = await showDialog<Student>(
      context: context,
      builder: (context) => _StudentEditDialog(student: _student),
    );
    if (!mounted || updatedStudent == null) return;

    widget.onStudentSaved(updatedStudent);
    setState(() {
      _student = updatedStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          TextButton.icon(
            onPressed: _editStudent,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _student.image,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 88,
                                height: 88,
                                color: Colors.indigo.shade100,
                                alignment: Alignment.center,
                                child: Text(
                                  _student.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 32,
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
                          child: Text(
                            _student.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 16),
                    _StudentDetail(
                      label: 'Student ID',
                      value: _student.studentId,
                    ),
                    _StudentDetail(label: 'Course', value: _student.course),
                    _StudentDetail(
                      label: 'Year Level',
                      value: _student.yearLevel,
                    ),
                    _StudentDetail(
                      label: 'Status',
                      value: _student.isActive ? 'Active' : 'Inactive',
                    ),
                    _StudentDetail(label: 'Age', value: '${_student.age}'),
                    _StudentDetail(label: 'Hobby', value: _student.hobby),
                    _StudentDetail(label: 'Email', value: _student.email),
                    _StudentDetail(
                      label: 'Favorite Subject',
                      value: _student.favoriteSubject,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentEditDialog extends StatefulWidget {
  const _StudentEditDialog({required this.student});

  final Student student;

  @override
  State<_StudentEditDialog> createState() => _StudentEditDialogState();
}

class _StudentEditDialogState extends State<_StudentEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _studentIdController;
  late final TextEditingController _courseController;
  late final TextEditingController _yearLevelController;
  late final TextEditingController _ageController;
  late final TextEditingController _hobbyController;
  late final TextEditingController _emailController;
  late final TextEditingController _favoriteSubjectController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    _nameController = TextEditingController(text: student.name);
    _studentIdController = TextEditingController(text: student.studentId);
    _courseController = TextEditingController(text: student.course);
    _yearLevelController = TextEditingController(text: student.yearLevel);
    _ageController = TextEditingController(text: '${student.age}');
    _hobbyController = TextEditingController(text: student.hobby);
    _emailController = TextEditingController(text: student.email);
    _favoriteSubjectController = TextEditingController(
      text: student.favoriteSubject,
    );
    _isActive = student.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _ageController.dispose();
    _hobbyController.dispose();
    _emailController.dispose();
    _favoriteSubjectController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  String? _validateAge(String? value) {
    final age = int.tryParse(value?.trim() ?? '');
    if (age == null || age < 1) {
      return 'Enter a valid age.';
    }
    return null;
  }

  Widget _buildTextField({
    required String key,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      key: ValueKey(key),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: validator ?? _validateRequired,
    );
  }

  void _saveStudent() {
    if (!_formKey.currentState!.validate()) return;

    final updatedStudent = Student(
      image: widget.student.image,
      name: _nameController.text.trim(),
      studentId: _studentIdController.text.trim(),
      course: _courseController.text.trim(),
      yearLevel: _yearLevelController.text.trim(),
      isActive: _isActive,
      age: int.parse(_ageController.text.trim()),
      hobby: _hobbyController.text.trim(),
      email: _emailController.text.trim(),
      favoriteSubject: _favoriteSubjectController.text.trim(),
    );
    Navigator.of(context).pop(updatedStudent);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Edit Student'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              key: 'student-name',
              label: 'Name',
              controller: _nameController,
            ),
            _buildTextField(
              key: 'student-id',
              label: 'Student ID',
              controller: _studentIdController,
            ),
            _buildTextField(
              key: 'student-course',
              label: 'Course',
              controller: _courseController,
            ),
            _buildTextField(
              key: 'student-year-level',
              label: 'Year Level',
              controller: _yearLevelController,
            ),
            _buildTextField(
              key: 'student-age',
              label: 'Age',
              controller: _ageController,
              keyboardType: TextInputType.number,
              validator: _validateAge,
            ),
            _buildTextField(
              key: 'student-hobby',
              label: 'Hobby',
              controller: _hobbyController,
            ),
            _buildTextField(
              key: 'student-email',
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              key: 'student-favorite-subject',
              label: 'Favorite Subject',
              controller: _favoriteSubjectController,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _saveStudent, child: const Text('Save')),
      ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.indigo.shade300),
          const SizedBox(height: 16),
          const Text(
            'No students found.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no students in the directory yet.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _LoadingStudentState extends StatelessWidget {
  const _LoadingStudentState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading students...',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
