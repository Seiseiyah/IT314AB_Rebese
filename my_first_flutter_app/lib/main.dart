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
      title: 'My First Flutter Application',

      home: Scaffold(
        backgroundColor: Colors.lightBlue[50],

        // =========================================================
        // APP BAR
        // =========================================================
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'My First Flutter Application',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        // =========================================================
        // BODY
        // =========================================================
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // =====================================================
                // PROFILE CARD
                // =====================================================
                Card(
                  elevation: 8,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(25),

                    // Profile information
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        // =================================================
                        // FLAG 12: IMAGE
                        // =================================================
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/profile.jfif',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 15),

                        // FLAG 10: ICON
                        const Icon(Icons.person, size: 50),

                        const SizedBox(height: 10),

                        // FLAG 1: NAME
                        const Text(
                          'Vincent A. Rebese',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FLAG 1: COURSE
                        // =================================================
                        const Text(
                          'BSIT 3',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FLAG 1: APPLICATION TITLE
                        // =================================================
                        const Text(
                          'My First Flutter Application',
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FLAG 1: DATE
                        // =================================================
                        const Text(
                          'August 11, 2026',
                          style: TextStyle(fontSize: 18),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FLAG 3: HOBBY
                        // =================================================
                        const Text(
                          'Hobby: Lazing',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 15),

                        // =================================================
                        // FLAG 4: ROW
                        // Age and Birthdate are side-by-side
                        // =================================================
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Age: 22', style: TextStyle(fontSize: 18)),

                            // Horizontal spacing
                            SizedBox(width: 30),

                            Text(
                              'Birthdate: December 23, 2003',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // =====================================================
                // SPACE BETWEEN CARDS
                // =====================================================
                const SizedBox(height: 20),

                // =====================================================
                // FAVORITES CARD
                // =====================================================
                Card(
                  elevation: 8,

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        // =================================================
                        // FAVORITES TITLE
                        // =================================================
                        const Text(
                          'My Favorites',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FAVORITE GAME
                        // =================================================
                        const Text('Favorite Game: Mobile Legends'),

                        const SizedBox(height: 5),

                        // =================================================
                        // FAVORITE FOOD
                        // =================================================
                        const Text('Favorite Food: Her'),

                        const SizedBox(height: 5),

                        // =================================================
                        // FAVORITE MOVIE
                        // =================================================
                        const Text('Favorite Movie: The Grudge'),

                        // Flag 5: Spacing
                        const SizedBox(height: 10),

                        // =================================================
                        // FLAG 8: ROW INSIDE FAVORITES CARD
                        // =================================================
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Game: ML, Dota2, Valorant'),

                            SizedBox(width: 20),

                            Text('Food: Adobo'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
