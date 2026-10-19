import 'package:flutter/material.dart';
import 'learn_screen.dart'; // Apni LearnScreen wali file ko yahan import kar lein

class KidsHomeScreen extends StatelessWidget {
  final String childName;
  final String childClass;
  final String parentEmail;

  const KidsHomeScreen({
    Key? key,
    required this.childName,
    required this.childClass,
    required this.parentEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D68)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 28),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WonderKids Portal',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF004D68),
                    ),
                  ),
                  Text(
                    'Playing & Learning',
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFA8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.star, color: Color(0xFFFF8500), size: 18),
                  SizedBox(width: 4),
                  Text(
                    '0',
                    style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF664000)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFC2E8FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0083B0), width: 2),
              ),
              child: const Icon(Icons.face, color: Color(0xFF004D68)),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image (Offline asset)
          Image.asset(
            'assets/images/kids_playroom_bg.jpg',
            fit: BoxFit.cover,
          ),
          
          // 2. Soft Dark Overlay for better contrast and readability
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // 3. Foreground Content Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Playful Icon
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F4FC),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2BB0E6).withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🌟', style: TextStyle(fontSize: 38)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Welcome Heading
                    Text(
                      'Welcome, $childName! 👋',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF002838),
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      "Ready to start your fun learning journey in $childClass today?",
                      style: const TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 14,
                        color: Color(0xFF212529),
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Start Learning Button with Navigation to LearnScreen
                    SizedBox(
                      width: 230,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0083B0),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          shadowColor: const Color(0xFF004D68).withOpacity(0.5),
                        ),
                        onPressed: () {
                          // Button click par Modules wali LearnScreen khul jaye gi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LearnScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.rocket_launch_rounded, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Start Learning 🚀',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
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
        ],
      ),
    );
  }
}