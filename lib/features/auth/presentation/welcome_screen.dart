import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Apni signup screen ka file import ensure kar lein
import 'login_screen.dart'; // Apni LoginScreen file ka path yahan dein

class WonderKidsWelcomeScreen extends StatelessWidget {
  const WonderKidsWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECE6),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFBF9F3),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  'assets/images/welcome_bg.png',
                  fit: BoxFit.fill,
                ),
                
                // Foreground Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9F1C),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('Fun Quests', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7F9CC),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.brush, color: Color(0xFF386641), size: 20),
                                  SizedBox(width: 8),
                                  Text('Creativity', style: TextStyle(color: Color(0xFF386641), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(flex: 1),

                        // Center content: Mascot Image in Circular Container
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    color: Colors.white,
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/mascot.png'),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFFFF9F1C),
                                    radius: 18,
                                    child: Icon(Icons.star_rounded, color: Colors.white, size: 22),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7F9CC),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Color(0xFF386641), size: 18),
                                  SizedBox(width: 8),
                                  Text('PRESCHOOL CERTIFIED', style: TextStyle(color: Color(0xFF386641), fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'WonderKids',
                              style: TextStyle(color: Color(0xFF135A94), fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                children: [
                                  TextSpan(text: 'Play, Learn & Grow! '),
                                  TextSpan(text: '(Ages 3-5)', style: TextStyle(color: Color(0xFFFF9F1C), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(flex: 2),

                        // Bottom action button and login text
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9F1C),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const WonderKidsSignupScreen()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Let's Play!",
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WonderKidsLoginScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_outline, color: Colors.black, size: 18),
                                  const SizedBox(width: 8),
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                      children: [
                                        TextSpan(text: 'I already have a profile • '),
                                        TextSpan(
                                          text: 'Parents Log In',
                                          style: TextStyle(
                                            color: Color(0xFF135A94),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
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