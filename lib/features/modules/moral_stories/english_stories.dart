import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ==========================================
// ENGLISH STORIES LIST SCREEN MODULE
// ==========================================
class EnglishStoriesScreen extends StatelessWidget {
  const EnglishStoriesScreen({Key? key}) : super(key: key);

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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                            ),
                          ),
                          const Text('English Stories 📚', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(color: Color(0xFF006689), shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                child: Column(
                  children: [
                    _buildStoryCard(
                      context,
                      imageUrl: 'assets/images/crow_scene1.png',
                      title: 'The Thirsty Crow 🦅',
                      subtitle: 'Funny & Easy Twist',
                      description: "Pecky the crow finds a shiny clay pot! Can you help him drop pebbles to drink fresh water?",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoryReaderScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      imageUrl: 'assets/images/monkey_scene1.png',
                      title: 'The Lazy Little Monkey 🐒',
                      subtitle: 'Cute Playful Story',
                      description: "Mimi the monkey learns that sharing sweet yellow bananas brings the biggest giggles in the jungle!",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LazyMonkeyStoryScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      imageUrl: 'assets/images/duck_scene1.png',
                      title: 'The Happy Little Duck 🦆',
                      subtitle: 'Sweet Rhyming Tale',
                      description: "Quack, quack! Puddle the duck loves singing joyful morning songs across the lilypad pond.",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HappyDuckStoryScreen(),
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

  Widget _buildStoryCard(BuildContext context, {
    required String imageUrl,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 20, spreadRadius: -4)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 176,
              width: double.infinity,
              child: imageUrl.startsWith('assets/')
                  ? Image.asset(imageUrl, fit: BoxFit.cover)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFC2E8FF),
                        child: const Center(child: Icon(Icons.image, size: 40, color: Color(0xFF006689))),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, color: Color(0xFF1B1C19))),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAA1D),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    onPressed: onPressed,
                    child: const Text('LISTEN & READ 🎧', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 1. THIRSTY CROW STORY READER MODULE
// ==========================================
class StoryReaderScreen extends StatefulWidget {
  const StoryReaderScreen({Key? key}) : super(key: key);

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPage = 1;
  bool isPlaying = false;
  String toastMessage = '';
  bool showToastFlag = false;
  String? activeEmojiPopup;

  final List<Map<String, dynamic>> storyPages = [
    {
      'page': 1,
      'badge': 'Scene 1 • Searching for Water ✨',
      'imageAsset': 'assets/images/crow_scene1.png',
      'englishHtml': 'Once upon a time, Pecky the crow was very thirsty. He looked everywhere for water and found a tall pitcher with very little water at the bottom!',
      'textToSpeak': 'Once upon a time, Pecky the crow was very thirsty. He looked everywhere for water and found a tall pitcher with very little water at the bottom!',
      'urduText': 'ایک دفعہ کا ذکر ہے، پیاسا کوا پانی کی تلاش میں تھا- اسے ایک لمبا گھڑا ملا جس کی تہہ میں بہت تھوڑا پانی تھا-',
      'phonics': 'Phonics Focus: /k/ Crow • /w/ Water',
      'phonicsSpeech': 'k Crow, w Water',
      'crowToast': 'Pecky says: "Caw caw! I am so thirsty!"',
      'crowEmoji': '🦅✨',
      'pitcherToast': 'Pitcher: *Splish splash!* Water is far below!',
      'pitcherEmoji': '🏺💧',
    },
    {
      'page': 2,
      'badge': 'Scene 2 • A Clever Idea ✨',
      'imageAsset': 'assets/images/crow_scene2.png',
      'englishHtml': 'Pecky tried to reach the water with his beak, but the pitcher was too deep. Then he saw shiny pebbles on the ground and had a clever idea!',
      'textToSpeak': 'Pecky tried to reach the water with his beak, but the pitcher was too deep. Then he saw shiny pebbles on the ground and had a clever idea!',
      'urduText': 'پیکی نے اپنی چونچ سے پانی پینے کی کوشش کی، لیکن گھڑا بہت گہرا تھا- پھر اس نے زمین پر چمکدار کنکریاں دیکھیں اور ایک ترکیب سوچی!',
      'phonics': 'Phonics Focus: /b/ Beak • /p/ Pebbles',
      'phonicsSpeech': 'b Beak, p Pebbles',
      'crowToast': 'Pecky chirps: "Aha! Look at these shiny pebbles!"',
      'crowEmoji': '💡🦅',
      'pitcherToast': 'Pebbles glisten: *Clack clack!*',
      'pitcherEmoji': '🪨✨',
    },
    {
      'page': 3,
      'badge': 'Scene 3 • Water Rises High! ✨',
      'imageAsset': 'assets/images/crow_scene3.png',
      'englishHtml': 'One by one, Pecky picked up pebbles and dropped them into the pitcher. The water rose higher until Pecky took a big, happy drink!',
      'textToSpeak': 'One by one, Pecky picked up pebbles and dropped them into the pitcher. The water rose higher until Pecky took a big, happy drink!',
      'urduText': 'ایک ایک کر کے، پیکی نے کنکریاں اٹھائیں اور گھڑے میں ڈالیں- پانی اوپر آتا گیا اور پیکی نے مزے سے پانی پی لیا!',
      'phonics': 'Phonics Focus: /d/ Drink • /h/ High',
      'phonicsSpeech': 'd Drink, h High',
      'crowToast': 'Pecky cheers: "Gulp gulp! We did it!"',
      'crowEmoji': '🎉🦅',
      'pitcherToast': 'Pitcher sparkles: *Hooray! Water is at the top!*',
      'pitcherEmoji': '🏺🎉',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.42);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      setState(() {
        isPlaying = true;
      });
      String text = storyPages[currentPage - 1]['textToSpeak'];
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _triggerInteractivePopup(String message, String emoji) {
    setState(() {
      toastMessage = message;
      activeEmojiPopup = emoji;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          showToastFlag = false;
          activeEmojiPopup = null;
        });
      }
    });
  }

  void _nextPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage < 3) {
        currentPage++;
      } else {
        Navigator.maybePop(context);
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageData = storyPages[currentPage - 1];

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
                preferredSize: const Size.fromHeight(64),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.8),
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
                                onTap: () {
                                  flutterTts.stop();
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Story Reader 📖', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            ],
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_up, color: const Color(0xFF006689), size: 18),
                              onPressed: _toggleAudio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('The Thirsty Crow', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                SizedBox(width: 4),
                                Text('🦅', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(18)),
                              child: Text('Page $currentPage of 3', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 240,
                                      width: double.infinity,
                                      color: const Color(0xFFF5F3EE),
                                      child: Image.asset(
                                        pageData['imageAsset'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFC2E8FF),
                                          child: const Center(child: Text('📖 Scene Illustration', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF006689)))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (activeEmojiPopup != null)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.2, end: 1.0),
                                        duration: const Duration(milliseconds: 300),
                                        builder: (context, value, child) => Transform.scale(scale: value, child: Text(activeEmojiPopup!, style: const TextStyle(fontSize: 56))),
                                      ),
                                    ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                                      child: Text(pageData['badge'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerInteractivePopup(pageData['crowToast'], pageData['crowEmoji']),
                                          child: const Text('👆 Tap Pecky! 🦅', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerInteractivePopup(pageData['pitcherToast'], pageData['pitcherEmoji']),
                                          child: const Text('💧 Water Pitcher! 🏺', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Phonics Focus Bar
                              InkWell(
                                onTap: () async {
                                  await flutterTts.stop();
                                  await flutterTts.setVolume(1.0);
                                  await flutterTts.speak(pageData['phonicsSpeech']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.record_voice_over, color: Color(0xFF006689), size: 18),
                                          const SizedBox(width: 6),
                                          Text(pageData['phonics'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF003F57))),
                                        ],
                                      ),
                                      const Icon(Icons.volume_up, color: Color(0xFF006689), size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pageData['englishHtml'], style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1C19), height: 1.4)),
                              const SizedBox(height: 10),
                              Text(pageData['urduText'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E484F), height: 1.4), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage > 1 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage > 1 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: currentPage > 1 ? _prevPage : null,
                                child: const Text('Back', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                  foregroundColor: isPlaying ? Colors.white : const Color(0xFF6A4300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _toggleAudio,
                                child: Text(isPlaying ? 'PAUSE STORY' : 'PLAY STORY', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage < 3 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage < 3 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _nextPage,
                                child: Text(currentPage == 3 ? 'Finish' : 'Next', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showToastFlag && toastMessage.isNotEmpty)
                    Positioned(
                      top: 70,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFFFAA1D), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10)]),
                            child: Text(toastMessage, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. LAZY LITTLE MONKEY STORY SCREEN MODULE
// ==========================================
class LazyMonkeyStoryScreen extends StatefulWidget {
  const LazyMonkeyStoryScreen({Key? key}) : super(key: key);

  @override
  State<LazyMonkeyStoryScreen> createState() => _LazyMonkeyStoryScreenState();
}

class _LazyMonkeyStoryScreenState extends State<LazyMonkeyStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPage = 1;
  bool isPlaying = false;
  String? toastMessage;
  bool showToastFlag = false;

  final List<Map<String, dynamic>> storyPages = [
    {
      'page': 1,
      'badge': 'Scene 1 • Sweet Bananas ✨',
      'imageAsset': 'assets/images/monkey_scene1.png',
      'phonics': 'Phonics Focus: /m/ Monkey • /b/ Banana',
      'phonicsSpeech': 'm Monkey, b Banana',
      'hotspotItem': '🍌 Yellow Bananas!',
      'englishHtml': 'Once upon a time, Mimi the monkey learned that sharing sweet yellow bananas brings the biggest giggles in the jungle!',
      'textToSpeak': 'Once upon a time, Mimi the monkey learned that sharing sweet yellow bananas brings the biggest giggles in the jungle!',
      'urduText': 'ایک دفعہ کا ذکر ہے، میمی بندریا نے سیکھا کہ جنگل میں میٹھے پیلے کیلے بانٹنے سے سب سے زیادہ خوشیاں ملتی ہیں۔',
      'mimiToast': 'Mimi giggles: Ooh-ooh-aah-aah! 🐒✨',
      'itemToast': 'Sweet and delicious jungle bananas! 🍌',
    },
    {
      'page': 2,
      'badge': 'Scene 2 • The Friendly Parrot 🦜',
      'imageAsset': 'assets/images/monkey_scene2.png',
      'phonics': 'Phonics Focus: /p/ Parrot • /f/ Friends',
      'phonicsSpeech': 'p Parrot, f Friends',
      'hotspotItem': '🦜 Polly Parrot!',
      'englishHtml': 'Mimi saw Polly Parrot sitting quietly on a high branch. She shared a yummy piece, and they both started singing happy songs together!',
      'textToSpeak': 'Mimi saw Polly Parrot sitting quietly on a high branch. She shared a yummy piece, and they both started singing happy songs together!',
      'urduText': 'میمی نے اونچی شاخ پر طوطے کو اداس دیکھا۔ میمی نے کیلے کا ایک ٹکڑا اس کو دیا اور دونوں خوشی سے گیت گانے لگے۔',
      'mimiToast': 'Mimi chirps: Sharing makes me so happy! 🦜',
      'itemToast': 'Polly squawks: Thank you Mimi! Chirp-chirp! 🦜',
    },
    {
      'page': 3,
      'badge': 'Scene 3 • Jungle Party 🌴',
      'imageAsset': 'assets/images/monkey_scene3.png',
      'phonics': 'Phonics Focus: /s/ Sharing • /j/ Joy',
      'phonicsSpeech': 's Sharing, j Joy',
      'hotspotItem': '🎉 Big Party!',
      'englishHtml': 'Soon, all the friendly animals gathered for a jungle feast. Mimi was no longer lazy; she was the kindest helper!',
      'textToSpeak': 'Soon, all the friendly animals gathered for a jungle feast. Mimi was no longer lazy; she was the kindest helper!',
      'urduText': 'جلد ہی تمام جنگلی جانور دعوت کے لیے اکٹھے ہو گئے۔ اب میمی بالکل سست نہیں تھی، بلکہ وہ جنگل کی سب سے پیاری اور مددگار ساتھی بن گئی!',
      'mimiToast': 'Mimi dances: Look at our wonderful friends! 🌴',
      'itemToast': 'Hooray! The whole jungle is celebrating! 🎉',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.42);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      setState(() {
        isPlaying = true;
      });
      String text = storyPages[currentPage - 1]['textToSpeak'];
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _triggerToast(String message) {
    setState(() {
      toastMessage = message;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          showToastFlag = false;
        });
      }
    });
  }

  void _nextPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage < 3) {
        currentPage++;
      } else {
        Navigator.maybePop(context);
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageData = storyPages[currentPage - 1];

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
                preferredSize: const Size.fromHeight(64),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.8),
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
                                onTap: () {
                                  flutterTts.stop();
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Story Reader 📖', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            ],
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_up, color: const Color(0xFF006689), size: 18),
                              onPressed: _toggleAudio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('The Lazy Little Monkey', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                SizedBox(width: 4),
                                Text('🐒', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(18)),
                              child: Text('Page $currentPage of 3', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 240,
                                      width: double.infinity,
                                      color: const Color(0xFFF5F3EE),
                                      child: Image.asset(
                                        pageData['imageAsset'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFC2E8FF),
                                          child: const Center(child: Text('📖 Scene Illustration', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF006689)))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                                      child: Text(pageData['badge'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerToast(pageData['mimiToast']),
                                          child: const Text('👆 Tap Mimi! 🐒', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerToast(pageData['itemToast']),
                                          child: Text(pageData['hotspotItem'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Phonics Focus Bar
                              InkWell(
                                onTap: () async {
                                  await flutterTts.stop();
                                  await flutterTts.setVolume(1.0);
                                  await flutterTts.speak(pageData['phonicsSpeech']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.record_voice_over, color: Color(0xFF006689), size: 18),
                                          const SizedBox(width: 6),
                                          Text(pageData['phonics'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF003F57))),
                                        ],
                                      ),
                                      const Icon(Icons.volume_up, color: Color(0xFF006689), size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pageData['englishHtml'], style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1C19), height: 1.4)),
                              const SizedBox(height: 10),
                              Text(pageData['urduText'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E484F), height: 1.4), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage > 1 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage > 1 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: currentPage > 1 ? _prevPage : null,
                                child: const Text('Back', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                  foregroundColor: isPlaying ? Colors.white : const Color(0xFF6A4300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _toggleAudio,
                                child: Text(isPlaying ? 'PAUSE STORY' : 'PLAY STORY', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage < 3 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage < 3 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _nextPage,
                                child: const Text('Next', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showToastFlag && toastMessage != null && toastMessage!.isNotEmpty)
                    Positioned(
                      top: 70,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFFFAA1D), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10)]),
                            child: Text(toastMessage!, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. THE HAPPY LITTLE DUCK STORY READER MODULE
// ==========================================
class HappyDuckStoryScreen extends StatefulWidget {
  const HappyDuckStoryScreen({Key? key}) : super(key: key);

  @override
  State<HappyDuckStoryScreen> createState() => _HappyDuckStoryScreenState();
}

class _HappyDuckStoryScreenState extends State<HappyDuckStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPage = 1;
  bool isPlaying = false;
  bool showQuizModal = false;
  bool? isCorrectAnswer;
  String? toastMessage;
  bool showToastFlag = false;

  final List<Map<String, dynamic>> storyPages = [
    {
      'page': 1,
      'badge': 'Scene 1 • Morning Songs ✨',
      'imageAsset': 'assets/images/duck_scene1.png',
      'phonics': '/d/ Duck • /p/ Pond 🔊',
      'phonicsSpeech': 'd Duck, p Pond',
      'textToSpeak': 'Quack, quack! Puddle the duck loves singing joyful morning songs across the lilypad pond with bright feathers!',
      'englishHtml': 'Quack, quack! Puddle the duck loves singing joyful morning songs across the lilypad pond with bright feathers!',
      'urduText': 'قوں قوں! پڈل بتھ کو کنول کے تالاب پر صبح کے خوشگوار گیت گانا بہت پسند تھا-',
      'duckToast': 'Quack Quack! Puddle splashes happily! ✨',
      'pondToast': 'Splash! Cool sparkling pond water! 💦',
      'chips': [
        {'text': '🦆 Puddle', 'urdu': 'Puddle', 'sound': 'Puddle!'},
        {'text': '🎶 Singing', 'urdu': 'Singing', 'sound': 'Singing'},
        {'text': '🌊 Pond', 'urdu': 'Pond', 'sound': 'Pond'},
        {'text': '🪶 Feathers', 'urdu': 'Feathers', 'sound': 'Feathers'},
      ]
    },
    {
      'page': 2,
      'badge': 'Scene 2 • Meeting Froggy Friends ✨',
      'imageAsset': 'assets/images/duck_scene2.png', // Corrected image asset path here[cite: 9]
      'phonics': '/f/ Frog • /s/ Splash 🔊',
      'phonicsSpeech': 'f Frog, s Splash',
      'textToSpeak': 'Ribbit! Puddle splashed water to say hello to his little green friends who were leaping happily over the smooth river stones!',
      'englishHtml': 'Ribbit! Puddle splashed water to say hello to his little green friends who were leaping happily over the smooth river stones!',
      'urduText': 'پڈل نے مینڈک دوستوں کے ساتھ چھینٹیں اڑائیں اور مل کر خوب مستی کی-',
      'duckToast': 'Puddle greets: Hello froggy friends! 🐸',
      'pondToast': 'Ribbit! The frogs jump over smooth river stones! 🪨',
      'chips': [
        {'text': '🐸 Frog', 'urdu': 'Frog', 'sound': 'Frog'},
        {'text': '🤝 Friends', 'urdu': 'Friends', 'sound': 'Friends'},
        {'text': '🦘 Leaping', 'urdu': 'Leaping', 'sound': 'Leaping'},
        {'text': '🪨 Stones', 'urdu': 'Stones', 'sound': 'Stones'},
      ]
    },
    {
      'page': 3,
      'badge': 'Scene 3 • Joyful Sunset Quacks ✨',
      'imageAsset': 'assets/images/duck_scene3.png',
      'phonics': '/s/ Sun • /j/ Joy 🔊',
      'phonicsSpeech': 's Sun, j Joy',
      'textToSpeak': 'As the warm yellow sun smiled down, the whole family started swimming together, sharing sweet kindness with all pond animals!',
      'englishHtml': 'As the warm yellow sun smiled down, the whole family started swimming together, sharing sweet kindness with all pond animals!',
      'urduText': 'پورے تالاب نے سنہری سورج تلے مل کر نغمے گائے اور خوشیاں بانٹیں-',
      'duckToast': 'Puddle cheers: Sunset songs are the best! 🌅',
      'pondToast': 'The sun sparkles over the quiet warm pond! ☀️',
      'chips': [
        {'text': '☀️ Sun', 'urdu': 'Sun', 'sound': 'Sun'},
        {'text': '🏊 Swimming', 'urdu': 'Swimming', 'sound': 'Swimming'},
        {'text': '💖 Kindness', 'urdu': 'Kindness', 'sound': 'Kindness'},
        {'text': '🦆 Quack', 'urdu': 'Quack', 'sound': 'Quack Quack'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.42);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      setState(() {
        isPlaying = true;
      });
      String text = storyPages[currentPage - 1]['textToSpeak'];
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _triggerToast(String message) {
    setState(() {
      toastMessage = message;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          showToastFlag = false;
        });
      }
    });
  }

  void _nextPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage < 3) {
        currentPage++;
      } else {
        showQuizModal = true;
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageData = storyPages[currentPage - 1];

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
                preferredSize: const Size.fromHeight(64),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.8),
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
                                onTap: () {
                                  flutterTts.stop();
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Story Reader 📖', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            ],
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_up, color: const Color(0xFF006689), size: 18),
                              onPressed: _toggleAudio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('The Happy Little Duck', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                SizedBox(width: 4),
                                Text('🦆', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(18)),
                              child: Text('Page $currentPage of 3', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 240,
                                      width: double.infinity,
                                      color: const Color(0xFFF5F3EE),
                                      child: Image.asset(
                                        pageData['imageAsset'],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFC2E8FF),
                                          child: const Center(child: Text('📖 Scene Illustration', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF006689)))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                                      child: Text(pageData['badge'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerToast(pageData['duckToast']),
                                          child: const Text('👆 Tap Puddle! 🦆', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFF1B1C19),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          ),
                                          onPressed: () => _triggerToast(pageData['pondToast']),
                                          child: const Text('🌊 Lilypad Pond!', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Phonics Focus Bar
                              InkWell(
                                onTap: () async {
                                  await flutterTts.stop();
                                  await flutterTts.setVolume(1.0);
                                  await flutterTts.speak(pageData['phonicsSpeech']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.record_voice_over, color: Color(0xFF006689), size: 18),
                                          const SizedBox(width: 6),
                                          Text(pageData['phonics'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF003F57))),
                                        ],
                                      ),
                                      const Icon(Icons.volume_up, color: Color(0xFF006689), size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pageData['englishHtml'], style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1C19), height: 1.4)),
                              const SizedBox(height: 10),
                              Text(pageData['urduText'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E484F), height: 1.4), textAlign: TextAlign.right, textDirection: TextDirection.rtl),
                              const SizedBox(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('TAP WORD FOR PRONUNCIATION:', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (pageData['chips'] as List).map((chip) {
                                  return InkWell(
                                    onTap: () async {
                                      await flutterTts.stop();
                                      await flutterTts.setVolume(1.0);
                                      await flutterTts.setLanguage("en-US");
                                      await flutterTts.speak(chip['sound']);
                                      _triggerToast('Pronouncing: "${chip['sound']}" 🗣️');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F3EE),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 2))],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(chip['text'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                          const SizedBox(width: 4),
                                          Text('(${chip['urdu']})', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF6E7980))),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage > 1 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage > 1 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: currentPage > 1 ? _prevPage : null,
                                child: const Text('Back', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                  foregroundColor: isPlaying ? Colors.white : const Color(0xFF6A4300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _toggleAudio,
                                child: Text(isPlaying ? 'PAUSE STORY' : 'PLAY STORY', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentPage < 3 ? const Color(0xFF24BC6B) : const Color(0xFFF0EEE8),
                                  foregroundColor: currentPage < 3 ? Colors.white : const Color(0xFF6E7980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: _nextPage,
                                child: const Text('Next', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showToastFlag && toastMessage != null && toastMessage!.isNotEmpty)
                    Positioned(
                      top: 70,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFFFAA1D), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10)]),
                            child: Text(toastMessage!, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}