import 'package:flutter/material.dart';
import 'english_stories.dart';
import 'urdu_stories.dart';

// ==========================================
// MORAL STORIES MAIN SELECTION SCREEN
// ==========================================
class MoralStoriesScreen extends StatefulWidget {
  const MoralStoriesScreen({Key? key}) : super(key: key);

  @override
  State<MoralStoriesScreen> createState() => _MoralStoriesScreenState();
}

class _MoralStoriesScreenState extends State<MoralStoriesScreen> {
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
            child: Scaffold(
              backgroundColor: const Color(0xFFFBF9F3),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
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
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Moral Stories 📖',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B1C19),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFF006689),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    // Header Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFDDB6), Color(0xFFFFC278)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A845400),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        children: const [
                          Text('📚 Wonder Stories ✨', style: TextStyle(fontFamily: 'Rubik', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          SizedBox(height: 6),
                          Text(
                            'Choose your language & start reading interactive moral tales!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Rubik', fontSize: 13, color: Color(0xFF643F00)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // English Stories Option Card
                    _buildCategoryCard(
                      context,
                      title: 'English Stories 🇬🇧',
                      subtitle: '3 Interactive Audio Stories',
                      description: 'Read & listen to The Thirsty Crow, Lazy Monkey & Happy Duck with phonics support!',
                      color: const Color(0xFFC2E8FF),
                      textColor: const Color(0xFF003F57),
                      buttonColor: const Color(0xFF006689),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EnglishStoriesScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Urdu Stories Option Card
                    _buildCategoryCard(
                      context,
                      title: 'اردو کہانیاں 🇵🇰',
                      subtitle: 'دلچسپ صوتی کہانیاں',
                      description: 'چڑیا اور سونا، بھورا چوہا اور دیگر خوبصورت کہانیاں صوتی مشق کے ساتھ سنیں!',
                      color: const Color(0xFFC8F8D6),
                      textColor: const Color(0xFF00522A),
                      buttonColor: const Color(0xFF006D39),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UrduKahaniyanScreen(),
                          ),
                        );
                      },
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

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required Color textColor,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1040352C),
            offset: Offset(0, 8),
            blurRadius: 20,
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              subtitle,
              style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Rubik', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, color: Color(0xFF6E7980), height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: onTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('OPEN STORIES 📖', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}