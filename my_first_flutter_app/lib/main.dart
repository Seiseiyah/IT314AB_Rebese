import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

//Profile Data Class
class Profile {
  final String name;
  final String course;
  final int age;
  final String hobby;
  final double height;
  final bool isStudent;
  final String image;

  const Profile({
    required this.name,
    required this.course,
    required this.age,
    required this.hobby,
    required this.height,
    required this.isStudent,
    required this.image,
  });
}

const profiles = [
  Profile(
    name: 'Allan Alomo',
    course: 'BSIT 3',
    age: 22,
    hobby: 'Not Provided',
    height: 160.5,
    isStudent: true,
    image: 'assets/Allan.jfif',
  ),
  Profile(
    name: 'Ceb helen',
    course: 'Unknown',
    age: 21,
    hobby: 'Gaming',
    height: 170,
    isStudent: true,
    image: 'assets/parbs.jpg',
  ),
  Profile(
    name: 'Kenwel Novetnom',
    course: 'BSIT 3',
    age: 19,
    hobby: 'Reading',
    height: 155,
    isStudent: true,
    image: 'assets/profile.jfif',
  ),
  Profile(
    name: 'Keth Lopes',
    course: 'BSIT 3',
    age: 22,
    hobby: 'Computer Programming',
    height: 180,
    isStudent: true,
    image: 'assets/ket.jpg',
  ),
  Profile(
    name: 'Unknown',
    course: 'BSIT-3',
    age: 20,
    hobby: 'Skiing',
    height: 175,
    isStudent: true,
    image: 'assets/eya.png',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //
    // The root widget of the application.
    //
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Creates one ProfileCard for each item in profiles.
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (_, index) => ProfileCard(profile: profiles[index]),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    //Profile object and displays its values.
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profile.image),
            ),
            const SizedBox(height: 15),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              profile.course,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Divider(height: 30),

            InfoRow('Age', '${profile.age}'),
            InfoRow('Hobby', profile.hobby),
            InfoRow('Height', '${profile.height} cm'),
            InfoRow('Student', profile.isStudent ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          // Expanded lets longer values use the remaining horizontal space.
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
