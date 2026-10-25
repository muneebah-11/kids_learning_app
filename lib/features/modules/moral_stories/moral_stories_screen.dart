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
  bool isUrduLanguage = false;

  void _toggleLanguage() {
    setState(() {
      isUrduLanguage = !isUrduLanguage;
    });
  }

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
                preferredSize: const Size.fromHeight(80),
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
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 3), blurRadius: 0)],
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isUrduLanguage ? 'ونڈر کڈز' : 'WONDERKIDS',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                  ),
                                  Text(
                                    isUrduLanguage ? 'اخلاقی کہانیاں 📖' : 'Moral Stories 📖',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: _toggleLanguage,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: !isUrduLanguage ? const Color(0xFF006689) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'ENG',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: !isUrduLanguage ? Colors.white : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: _toggleLanguage,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isUrduLanguage ? const Color(0xFF006689) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'اردو',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isUrduLanguage ? Colors.white : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(color: Color(0xFF006689), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 16),
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
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MAIN INTERACTIVE HUB MODULES
                    Column(
                      children: [
                        // Card 1: English Stories 🇬🇧📖 (Offline Asset)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x20006689), offset: Offset(0, 10), blurRadius: 24)],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: double.infinity,
                                    child: Image.asset(
                                      'assets/images/english_stories_banner.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: const Color(0xFFC2E8FF),
                                        child: const Center(
                                          child: Icon(Icons.image, size: 40, color: Color(0xFF006689)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 2), blurRadius: 0)],
                                      ),
                                      child: Row(
                                        children: const [
                                          Text('🇬🇧', style: TextStyle(fontSize: 13)),
                                          SizedBox(width: 6),
                                          Text(
                                            'ENGLISH LIBRARY',
                                            style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'English Stories 📖',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Whimsical fables, bedtime dreams and playful phonics adventures.',
                                      style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF3E484F)),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(color: const Color(0xFFC2E8FF).withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.graphic_eq, size: 14, color: Color(0xFF006689)),
                                              SizedBox(width: 4),
                                              Text(
                                                'Full Audio',
                                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(16)),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.schedule, size: 14, color: Color(0xFF3E484F)),
                                              SizedBox(width: 4),
                                              Text(
                                                '3-5 Min Each',
                                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFAA1D),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                          shadowColor: const Color(0xFF9A5B00),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const EnglishStoriesScreen(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'EXPLORE STORIES',
                                              style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Card 2: Urdu Kahaniyan 🇵🇰📚 (Offline Asset)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x20006D39), offset: Offset(0, 10), blurRadius: 24)],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: double.infinity,
                                    child: Image.asset(
                                      'assets/images/urdu_stories_banner.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: const Color(0xFFC2E8FF),
                                        child: const Center(
                                          child: Icon(Icons.image, size: 40, color: Color(0xFF006D39)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 2), blurRadius: 0)],
                                      ),
                                      child: Row(
                                        children: const [
                                          Text('🇵🇰', style: TextStyle(fontSize: 13)),
                                          SizedBox(width: 6),
                                          Text(
                                            'اردو کہانیاں',
                                            style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006D39)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'اردو کہانیاں 🌙',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'اخلاقی کہانیاں اور سبق آموز قصے۔',
                                      style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF3E484F)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(color: const Color(0xFF73FDA3).withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                                          child: Row(
                                            children: const [
                                              Text(
                                                'پرسکون آواز',
                                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006D39)),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.mic, size: 14, color: Color(0xFF006D39)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(16)),
                                          child: Row(
                                            children: const [
                                              Text(
                                                '۳ تا ۵ منٹ',
                                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.timer, size: 14, color: Color(0xFF3E484F)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF006D39),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const UrduKahaniyanScreen(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'کہانیاں سنیں',
                                              style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                            SizedBox(width: 8),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                            ),
                                          ],
                                        ),
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
          ),
        ),
      ),
    );
  }
}