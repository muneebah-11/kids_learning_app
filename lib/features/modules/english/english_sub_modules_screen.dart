import 'package:flutter/material.dart';
import 'learn_alphabets_detail_screen.dart';
import 'word_association_screen.dart'; // Agar same folder mein hai
import 'pronunciation_and_rhymes_screen.dart'; // Apni file ka sahi naam yahan dein
import 'fun_puzzles_screen.dart'; // Apni file ka sahi naam yahan dein

class EnglishLearningDashboard extends StatelessWidget {
  const EnglishLearningDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.9),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 24),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'WonderKids',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006689),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF40352C).withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.stars, color: Color(0xFFFFAA1D), size: 16),
                            SizedBox(width: 4),
                            Text(
                              '140',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF40352C).withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.face, color: Color(0xFF006689), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back & Title Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            boxShadow: const [
                              BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF006689), size: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ABC & Phonics',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006689),
                            ),
                          ),
                          Text(
                            'Ages 3–5 Play Hub',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF845400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 2), blurRadius: 0)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.stars, color: Color(0xFFFFAA1D), size: 16),
                            SizedBox(width: 4),
                            Text('140', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFC2E8FF),
                          boxShadow: const [BoxShadow(color: Color(0xFF78D1FF), offset: Offset(0, 2), blurRadius: 0)],
                        ),
                        child: const Icon(Icons.face, color: Color(0xFF006689), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0xFFF0EEE8), offset: Offset(0, 4), blurRadius: 0)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDDB6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.auto_awesome, size: 12, color: Color(0xFF643F00)),
                          SizedBox(width: 4),
                          Text('Toddler English Playground', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF643F00))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Learn English Adventures! 🔤',
                      style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Explore magical letters, happy words, and sing along! 🍎',
                      style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sub-modules Cards List
              Column(
                children: [
                  // Card 1: Learn Alphabets
                  _buildSubModuleCard(
                    bgColor: const Color(0xFFC2E8FF),
                    shadowColor: const Color(0xFF78D1FF),
                    badgeText: '26 Letters ✨',
                    badgeColor: Colors.white,
                    badgeTextColor: const Color(0xFF006689),
                    title: 'Learn Alphabets (A-Z)',
                    subtitle: 'A-Z Recognition, Sounds & Shapes',
                    imagePath: 'assets/images/abc_blocks.png',
                    audioButtonColor: const Color(0xFF006689),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LearnAlphabetsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Card 2: Word Association
                  _buildSubModuleCard(
                    bgColor: const Color(0xFFFFDDB6),
                    shadowColor: const Color(0xFFFFB958),
                    badgeText: '100+ words 🎈',
                    badgeColor: Colors.white,
                    badgeTextColor: const Color(0xFF845400),
                    title: 'Word Association',
                    subtitle: 'Visual Vocabulary • A for Apple',
                    imagePath: 'assets/images/apple_word.png',
                    audioButtonColor: const Color(0xFFFFAA1D),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WordAssociationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Card 3: Pronunciation & Rhymes
                  
                  // Card 3: Pronunciation & Rhymes

          _buildSubModuleCard(
            bgColor: const Color(0xFFFFEEEE),
            shadowColor: const Color(0xFFFFB2B2),
            badgeText: '12 Catchy Songs 🎵',
            badgeColor: Colors.white,
            badgeTextColor: const Color(0xFFD32F2F),
            title: 'Pronunciation & Rhymes',
            subtitle: 'Phonics Sounds & Sing-Alongs',
            imagePath: 'assets/images/rhymes.png',
            audioButtonColor: const Color(0xFFE57373),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PronunciationHomeScreen(letterIndex: 0),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
                  // Card 4: Fun Activities & Puzzles
                  // Card 4: Fun Activities & Puzzles
// Card 4: Fun Activities & Puzzles
_buildSubModuleCard(
  bgColor: const Color(0xFF73FDA3).withOpacity(0.4),
  shadowColor: const Color(0xFF53DF8A),
  badgeText: 'Stress-Free Play Zone 🎈',
  badgeColor: Colors.white,
  badgeTextColor: const Color(0xFF006D39),
  title: 'Fun Activities & Puzzles',
  subtitle: 'Drag & Drop, Shadows & Letter Pairs',
  imagePath: 'assets/images/puzzle.png',
  audioButtonColor: const Color(0xFF006D39),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FunActivitiesScreen(),
      ),
    );
  },
),

                  // Card 5: Writing & Tracing Pad
                  _buildSubModuleCard(
                    bgColor: const Color(0xFFEAE8E2),
                    shadowColor: const Color(0xFFDBDAD4),
                    badgeText: 'Practice Pad ✍️',
                    badgeColor: Colors.white,
                    badgeTextColor: const Color(0xFF845400),
                    title: 'Writing & Tracing Pad',
                    subtitle: 'A-Z Finger & Stylus Magic Tracing',
                    imagePath: 'assets/images/tracing_pad.png',
                    audioButtonColor: const Color(0xFF845400),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Sub-Module Cards
  Widget _buildSubModuleCard({
    required Color bgColor,
    required Color shadowColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color audioButtonColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1C19),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 11,
                      color: Color(0xFF3E484F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
  // Helper method for sub-module cards using local assets (Optimized for Mobile Layouts)
  Widget _buildSubModuleCard({
    required Color bgColor,
    required Color shadowColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color audioButtonColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: badgeTextColor),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: audioButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Tap to Explore',
                            style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF006689)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
