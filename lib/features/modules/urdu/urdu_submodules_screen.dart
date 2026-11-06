import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kids_learning_app/core/database/database_helper.dart';
import 'urdu_haroof_screen.dart';
import 'word_explorer_screen.dart';

void main() {
  runApp(const UrduHubApp());
}

class UrduHubApp extends StatelessWidget {
  const UrduHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urdu Haroof - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const UrduSubmodulesScreen(),
    );
  }
}

class UrduSubmodulesScreen extends StatefulWidget {
  const UrduSubmodulesScreen({Key? key}) : super(key: key);

  @override
  State<UrduSubmodulesScreen> createState() => _UrduSubmodulesScreenState();
}

class _UrduSubmodulesScreenState extends State<UrduSubmodulesScreen> {
  int totalStars = 0; // Shuru mein 0 stars taake fake value show na ho

  @override
  void initState() {
    super.initState();
    _loadUserProgressFromDatabase();
  }

  // Database se actual progress aur stars load karne ka tareeqa
  Future<void> _loadUserProgressFromDatabase() async {
    try {
      final db = await DatabaseHelper.instance.database;
      // Yahan database se query chala kar earned stars fetch kiye ja sakte hain
      // For testing/default structure, agar record na ho to 0 rahega
      setState(() {
        totalStars = 0; 
      });
    } catch (e) {
      debugPrint("Database load error: $e");
    }
  }

  Future<void> _updateDatabaseStars(int addedStars) async {
    try {
      setState(() {
        totalStars += addedStars;
      });
      // Database mein stars update karne ki logic yahan aayegi
    } catch (e) {
      debugPrint("Database update error: $e");
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.rocket_launch, color: Color(0xFFFFAA1D), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF30312D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2200),
      ),
    );
  }

  void _launchModule(String title, int stars) {
    _updateDatabaseStars(5);
    _showToast('🚀 Launching $title! (+5 Stars)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.95),
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.maybePop(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.arrow_back, color: Color(0xFF004D68), size: 22),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'اردو حروف (Urdu Haroof)',
                                  style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                ),
                                Text(
                                  'Explore letters & sounds',
                                  style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // 🌟 Light background aur dark prominent text/emoji wala Star container
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF6E5), // Bohat halka light background
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFFD166), width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 14)), // Dark/Bright Star Emoji
                                  const SizedBox(width: 5),
                                  Text(
                                    '$totalStars',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF845400)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 🍎 Offline Alf-Be / Apple Avatar Icon jo hamesha show hoga
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF004D68),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ا ب', // Offline Urdu Haroof badge inside profile
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Urdu Adventure ',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF004D68)),
                              ),
                              Text(
                                'اردو سیکھیں',
                                style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Select a joyful world to begin learning!',
                            style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CARD 1: Haroof-e-Tahajji
                 _buildSubModuleCard(
  imagePath: 'assets/images/learn_haroof.png',
  badgeText: '37 Letters',
  badgeBg: const Color(0xFFFFDDB6),
  badgeFg: const Color(0xFF2A1800),
  starReward: '+30',
  title: 'حروفِ تہجی (Learn Haroof)',
  subtitle: 'A-Z Sounds & Pronunciation',
  buttonText: 'Start Letters →',
  buttonUrdu: '(شروع کریں)',
  buttonColor: const Color(0xFFFFAA1D),
  textColor: const Color(0xFF2A1800),
  shadowColor: const Color(0xFFD4880E),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UrduHaroofScreen(),
      ),
    );
  },
),

                  // CARD 2: Word Explorer
                  _buildSubModuleCard(
  imagePath: 'assets/images/word_explorer.png',
  badgeText: 'Vocabulary',
  badgeBg: const Color(0xFF73FDA3),
  badgeFg: const Color(0xFF00210D),
  starReward: '+25',
  title: 'الفاظ کی شناخت (Word Explorer)',
  subtitle: 'Simple Word Recognition',
  buttonText: 'Explore Words →',
  buttonUrdu: '(الفاظ دیکھیں)',
  buttonColor: const Color(0xFF006689),
  textColor: Colors.white,
  shadowColor: const Color(0xFF003348),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WordExplorerScreen()),
    );
  },
),
const SizedBox(height: 14),

                  // CARD 3: Writing & Slate
                  _buildSubModuleCard(
                    imagePath: 'assets/images/urdu_writing.png',
                    badgeText: 'Tracing & Art',
                    badgeBg: const Color(0xFFFFDDB6),
                    badgeFg: const Color(0xFF643F00),
                    starReward: '+35',
                    title: 'لکھائی اور ٹریسنگ (Writing & Slate)',
                    subtitle: 'Interactive Letter Tracing',
                    buttonText: 'Practice Tracing →',
                    buttonUrdu: '(مشق کریں)',
                    buttonColor: const Color(0xFF845400),
                    textColor: Colors.white,
                    shadowColor: const Color(0xFF5E3B00),
                    onTap: () => _launchModule('Writing & Slate', 35),
                  ),
                  const SizedBox(height: 14),

                  // CARD 4: Phonics & Rhymes
                  _buildSubModuleCard(
                    imagePath: 'assets/images/phonics_rhymes.png',
                    badgeText: 'Phonics & Stories',
                    badgeBg: const Color(0xFFC2E8FF),
                    badgeFg: const Color(0xFF001E2C),
                    starReward: '+50',
                    title: 'آواز اور کہنی (Phonics & Rhymes)',
                    subtitle: 'Audio Practice & Fun Rhymes',
                    buttonText: 'Listen & Sing →',
                    buttonUrdu: '(سنیں اور گائیں)',
                    buttonColor: const Color(0xFF004D68),
                    textColor: Colors.white,
                    shadowColor: const Color(0xFF002B3B),
                    onTap: () => _launchModule('Phonics & Rhymes', 50),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubModuleCard({
    required String imagePath,
    required String badgeText,
    required Color badgeBg,
    required Color badgeFg,
    required String starReward,
    required String title,
    required String subtitle,
    required String buttonText,
    required String buttonUrdu,
    required Color buttonColor,
    required Color textColor,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x10006689), offset: Offset(0, 6), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book, color: Color(0xFF004D68)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: badgeFg),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 13, color: Color(0xFF845400)),
                            const SizedBox(width: 2),
                            Text(
                              starReward,
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF004D68)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              ),
              onPressed: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    buttonUrdu,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}