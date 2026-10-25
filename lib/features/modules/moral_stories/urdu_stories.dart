import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ==========================================
// 1. URDU KAHANIYAN LIST SCREEN MODULE
// ==========================================
class UrduKahaniyanScreen extends StatefulWidget {
  const UrduKahaniyanScreen({Key? key}) : super(key: key);

  @override
  State<UrduKahaniyanScreen> createState() => _UrduKahaniyanScreenState();
}

class _UrduKahaniyanScreenState extends State<UrduKahaniyanScreen> {
  void _showToast(String storyTitle) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.equalizer, color: Color(0xFFFFDDB6), size: 20),
                const SizedBox(width: 8),
                Text(
                  '$storyTitle شروع ہو رہی ہے... 📖',
                  style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            const Icon(Icons.check_circle, color: Color(0xFF73FDA3), size: 18),
          ],
        ),
        backgroundColor: const Color(0xFF30312D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        duration: const Duration(milliseconds: 2500),
      ),
    );
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
                preferredSize: const Size.fromHeight(70),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3),
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
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF006D39), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('اردو کہانیاں', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF006D39), fontWeight: FontWeight.bold)),
                                  Text('Story Reader', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0EEE8),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person, color: Color(0xFF006689), size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [BoxShadow(color: Color(0x1040352C), offset: Offset(0, 8), blurRadius: 20)],
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => _showToast('پپ کہانی گو کا استقبالیہ'),
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC2E8FF),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Color(0xFF78D1FF), offset: Offset(0, 3))],
                                ),
                                alignment: Alignment.center,
                                child: const Text('🐤', style: TextStyle(fontSize: 30)),
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
                                      const Text('پپ کہانی گو', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                                      Row(
                                        children: List.generate(4, (index) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                          width: 3,
                                          height: (index % 2 == 0) ? 14 : 8,
                                          decoration: BoxDecoration(color: const Color(0xFF006D39), borderRadius: BorderRadius.circular(2)),
                                        )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'پیارے بچوں! کوئی بھی پیاری کہانی منتخب کریں اور آرام سے سنیں۔ ✨',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 12, color: Color(0xFF3E484F), height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 1st Story: Sparrow
                      _buildUrduStoryCard(
                        imagePath: 'assets/images/sparrow_morning.png',
                        title: 'چڑیا اور سونا 🦜',
                        tagBadge: 'نئی کہانی',
                        badgeBgColor: const Color(0xFFC2E8FF),
                        badgeTextColor: const Color(0xFF004D68),
                        subtitle: 'میٹھی آواز اور دوستی کا خوبصورت قصہ',
                        description: 'ایک پیاری چڑیا کی کہانی جو اپنی میٹھی آواز سے جنگل کے سبھی دوستوں کو خوش رکھتی ہے۔',
                        feature1: 'مکمل آواز',
                        feature2: 'پیارا گیت 🎵',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChiriyaAurSonaScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // 2nd Story: Mouse
                      _buildUrduStoryCard(
                        imagePath: 'assets/images/mouse_story.png',
                        title: 'بھورا چوہا اور مٹھائی کا ڈبہ 🐭',
                        tagBadge: 'بہت مقبول',
                        badgeBgColor: const Color(0xFFFFDDB6),
                        badgeTextColor: const Color(0xFF643F00),
                        subtitle: 'مزیدار اور ہنسانے والی کہانی',
                        description: 'ایک چھوٹا اور شرارتی چوہا جو مٹھائی کی خوشبو سونگھتے ہوئے ایک دن مٹھائی کے ڈبے تک پہنچ جاتا ہے!',
                        feature1: 'مکمل آواز',
                        feature2: 'مزیدار قصہ 🍬',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BhooraChuhaStoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // 3rd Story: Elephant
                      _buildUrduStoryCard(
                        imagePath: 'assets/images/elephant_story.png',
                        title: 'ننھا ہاتھی اور ندی 🐘',
                        tagBadge: 'دوستی',
                        badgeBgColor: const Color(0xFF73FDA3),
                        badgeTextColor: const Color(0xFF00522A),
                        subtitle: 'پہلا ایڈونچر اور پانی کے مزے',
                        description: 'ایک ننھے ہاتھی کے بچے کا پہلی بار ندی میں جا کر پانی سے کھیلنے اور دوست بنانے کا خوبصورت سفر۔',
                        feature1: 'مکمل آواز',
                        feature2: 'ندی کا سفر 🌊',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NanhaHathiStoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite, color: Color(0xFF845400), size: 16),
                              SizedBox(width: 6),
                              Text('بچوں کے لیے محفوظ اور پُرسکون ماحول', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('اشتہار کے بغیر • ونڈر کڈز لائبریری v2.4', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF6E7980))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrduStoryCard({
    required String imagePath,
    required String title,
    required String tagBadge,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String subtitle,
    required String description,
    required String feature1,
    required String feature2,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x1240352C), offset: Offset(0, 8), blurRadius: 20)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(tagBadge, style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: badgeTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, color: Color(0xFF3E484F), height: 1.4)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.headphones, size: 14, color: Color(0xFF006D39)),
                    const SizedBox(width: 4),
                    Text(feature1, style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                child: Text(feature2, style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF643F00))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAA1D),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                shadowColor: const Color(0xFF845400),
              ),
              onPressed: onPressed,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle, size: 22, color: Color(0xFF2A1800)),
                  SizedBox(width: 8),
                  Text('کہانی سنیں 🎧', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. CHIRIYA AUR SONA STORY READER MODULE
// ==========================================
class ChiriyaAurSonaScreen extends StatefulWidget {
  const ChiriyaAurSonaScreen({Key? key}) : super(key: key);

  @override
  State<ChiriyaAurSonaScreen> createState() => _ChiriyaAurSonaScreenState();
}

class _ChiriyaAurSonaScreenState extends State<ChiriyaAurSonaScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPageIndex = 0;
  bool isPlaying = false;
  bool isAutoPlay = true;
  bool showQuizModal = false;
  bool? isQuizCorrect;
  String? toastMessage;
  bool showToastFlag = false;

  final List<Map<String, dynamic>> storyPages = [
    {
      'pageUrdu': '۱',
      'imgPath': 'assets/images/chiriya_page1.png',
      'sceneTitle': 'منظر ۱ • پیاری چڑیا کی صبح 🦜',
      'phonics': 'Chey Chiriya, Seen Sona',
      'phonicsUrdu': '/چ/ چڑیا • /س/ سونا',
      'hotspot2': 'پھول اور ٹہنیاں ✨',
      'urduText': 'ایک پیاری چڑیا نے اپنی میٹھی آواز سے جنگل کے سبھی دوستوں کو خوش کر دیا!',
      'englishText': '"A cute little bird made all the forest friends happy with her sweet singing voice!"',
      'textToSpeakUrdu': 'ایک پیاری چڑیا نے اپنی میٹھی آواز سے جنگل کے سبھی دوستوں کو خوش کر دیا!',
      'textToSpeakEngPhonics': 'Ek pyari chiriya ne apni meethi awaz se jungle ke sabhi doston ko khush kar diya!',
      'birdToast': 'چی چی! میں سنہری چڑیا ہوں!',
      'natureToast': 'بہت خوب! قدرت کے نظارے خوشگوار ہیں!',
      'quizQuestion': 'چڑیا اپنی کس چیز سے سب کو خوش کرتی تھی؟',
      'quizOptions': [
        {'text': '۱. میٹھی آواز سے 🎶', 'isCorrect': true},
        {'text': '۲. زور سے شور مچا کر', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🦜', 'urdu': 'چڑیا', 'phonics': 'Chiriya'},
        {'emoji': '🎶', 'urdu': 'میٹھی آواز', 'phonics': 'Meethi Awaz'},
        {'emoji': '🌳', 'urdu': 'جنگل', 'phonics': 'Jungle'},
        {'emoji': '💛', 'urdu': 'سونا', 'phonics': 'Sona'},
      ],
    },
    {
      'pageUrdu': '۲',
      'imgPath': 'assets/images/chiriya_page2.png',
      'sceneTitle': 'منظر ۲ • محبت سے بانٹنا 🌰',
      'phonics': 'Daal Daane, Bay Beej',
      'phonicsUrdu': '/د/ دانے • /ب/ بیج',
      'hotspot2': 'سنہری بیجوں کی ٹوکری 🧺',
      'urduText': 'چڑیا نے سب دوستوں کو سنہری دانے اور میٹھے بیج بانٹے، سب جانور خوش ہو کر مل جل کر کھانے لگے!',
      'englishText': '"The little bird shared golden seeds with all the forest animals, and everyone ate together happily!"',
      'textToSpeakUrdu': 'چڑیا نے سب دوستوں کو سنہری دانے اور میٹھے بیج بانٹے، سب جانور خوش ہو کر مل جل کر کھانے لگے!',
      'textToSpeakEngPhonics': 'Chiriya ne sab doston ko sunhari daane aur meethe beej baante, sab jaanwar khush ho kar mil jal kar khane lage!',
      'birdToast': 'دوستو! آؤ مل کر دانے کھائیں!',
      'natureToast': 'مزیدار دانے اور بیج!',
      'quizQuestion': 'چڑیا نے اپنے دوستوں کو کیا بانٹا تھا؟',
      'quizOptions': [
        {'text': '۱. سنہری دانے اور میٹھے بیج 🌾', 'isCorrect': true},
        {'text': '۲. پتھر اور مٹی', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🐿️', 'urdu': 'گلہری', 'phonics': 'Gilhari'},
        {'emoji': '🐰', 'urdu': 'خرگوش', 'phonics': 'Khargosh'},
        {'emoji': '🦌', 'urdu': 'ہرن', 'phonics': 'Hiran'},
        {'emoji': '🌾', 'urdu': 'سنہری بیج', 'phonics': 'Sunhari Beej'},
      ],
    },
    {
      'pageUrdu': '۳',
      'imgPath': 'assets/images/chiriya_page3.png',
      'sceneTitle': 'منظر ۳ • جشن اور خوشیاں 🌈',
      'phonics': 'Jeem Jashan, Gaaf Geet',
      'phonicsUrdu': '/ج/ جشن • /گ/ گیت',
      'hotspot2': 'قوسِ قزح کا نظارہ 🌈',
      'urduText': 'سب نے مل کر جشن منایا اور گیت گائے، جنگل میں ہر طرف خوشیوں کا رنگ پھیل گیا!',
      'englishText': '"They celebrated together under the rainbow, spreading love and happiness across the entire forest!"',
      'textToSpeakUrdu': 'سب نے مل کر جشن منایا اور گیت گائے، جنگل میں ہر طرف خوشیوں کا رنگ پھیل گیا!',
      'textToSpeakEngPhonics': 'Sab ne mil kar jashan manaya aur geet gaye, jungle mein har taraf khushiyon ka rang phel gaya!',
      'birdToast': 'آؤ سب مل کر گیت گائیں!',
      'natureToast': 'جنگل میں جشن کا ماحول!',
      'quizQuestion': 'سب جانوروں نے مل کر کیا منایا؟',
      'quizOptions': [
        {'text': '۱. جشن اور گیت 🎈', 'isCorrect': true},
        {'text': '۲. لڑائی اور جھگڑا', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🌈', 'urdu': 'قوسِ قزح', 'phonics': 'Qaus e Qazah'},
        {'emoji': '🎤', 'urdu': 'ترانہ', 'phonics': 'Tarana'},
        {'emoji': '🐻', 'urdu': 'ریچھ میاں', 'phonics': 'Reech Mian'},
        {'emoji': '🎉', 'urdu': 'جشن', 'phonics': 'Jashan'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.42);

      flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
      flutterTts.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _speakSmart(String urduText, String phonicsText) async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        setState(() {
          isPlaying = false;
        });
        return;
      }

      setState(() {
        isPlaying = true;
      });

      var languages = await flutterTts.getLanguages;
      bool hasUrdu = languages != null && languages.contains("ur-PK");

      if (hasUrdu) {
        await flutterTts.setLanguage("ur-PK");
        await flutterTts.speak(urduText);
      } else {
        await flutterTts.setLanguage("en-US");
        await flutterTts.speak(phonicsText);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _toggleAudio() async {
    final page = storyPages[currentPageIndex];
    await _speakSmart(page['textToSpeakUrdu'], page['textToSpeakEngPhonics']);
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
    Future.delayed(const Duration(milliseconds: 2600), () {
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
      if (currentPageIndex < storyPages.length - 1) {
        currentPageIndex++;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر خوش آمدید! ✨');
      } else {
        showQuizModal = true;
        _triggerToast('کوئز حل کریں! 🌟');
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPageIndex > 0) {
        currentPageIndex--;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر واپس آ گئے');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = storyPages[currentPageIndex];

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
                preferredSize: const Size.fromHeight(68),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3),
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
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('چڑیا اور سونا 🦜', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                  Text('صفحہ ${currentPageIndex + 1} از 3', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF6E7980))),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(isPlaying ? Icons.volume_up_sharp : Icons.volume_up, color: const Color(0xFF006689), size: 22),
                                onPressed: _toggleAudio,
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(color: Color(0xFF006689), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.menu_book, color: Color(0xFF006689), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'صفحہ ${currentPage['pageUrdu']} از ۳',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() => isAutoPlay = !isAutoPlay);
                                  _triggerToast(isAutoPlay ? 'خودکار پڑھائی آن ہو گئی 🔊' : 'خودکار پڑھائی بند 🔇');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isAutoPlay ? const Color(0xFF006D39).withOpacity(0.12) : const Color(0xFFF0EEE8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(isAutoPlay ? Icons.volume_up : Icons.volume_off, size: 14, color: isAutoPlay ? const Color(0xFF006D39) : const Color(0xFF6E7980)),
                                      const SizedBox(width: 4),
                                      Text(
                                        isAutoPlay ? 'خودکار آن' : 'خودکار آف',
                                        style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: isAutoPlay ? const Color(0xFF006D39) : const Color(0xFF6E7980)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x18006D39), offset: Offset(0, 8), blurRadius: 20)],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      width: double.infinity,
                                      child: Image.asset(currentPage['imgPath'], fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(currentPage['sceneTitle'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ),
                                    ),
                                    if (isPlaying)
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF006689),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.circle, color: Color(0xFF73FDA3), size: 8),
                                              SizedBox(width: 4),
                                              Text('آواز رواں', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF1B1C19),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['birdToast'], currentPage['birdToast']);
                                          _triggerToast(currentPage['birdToast']);
                                        },
                                        child: const Text('🦜 چڑیا کو چھوئیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFDDB6),
                                          foregroundColor: const Color(0xFF2A1800),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['natureToast'], currentPage['natureToast']);
                                          _triggerToast(currentPage['natureToast']);
                                        },
                                        child: Text(currentPage['hotspot2'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73FDA3).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                      child: const Icon(Icons.record_voice_over, color: Colors.white, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('صوتی مشق (Phonics Sound)', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                                        Text(currentPage['phonicsUrdu'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D39),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    _speakSmart(currentPage['phonicsUrdu'], currentPage['phonics']);
                                    _triggerToast('صوتی آواز سنیے: ${currentPage['phonicsUrdu']} 🎧');
                                  },
                                  icon: const Icon(Icons.volume_up, size: 16),
                                  label: const Text('سنیں', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1240352C), offset: Offset(0, 6), blurRadius: 18)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                                          child: const Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('پپ کہانی گو 🎨', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                      ],
                                    ),
                                    Row(
                                      children: List.generate(4, (index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                        width: 3,
                                        height: index.isEven ? 16 : 10,
                                        decoration: BoxDecoration(color: const Color(0xFF006D39), borderRadius: BorderRadius.circular(2)),
                                      )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3EE),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentPage['urduText'],
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19), height: 1.6),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentPage['englishText'],
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF6E7980)),
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('نئے الفاظ چھوئیں اور سیکھیں:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (currentPage['chips'] as List).map((chip) {
                                    return ActionChip(
                                      label: Text('${chip['emoji']} ${chip['urdu']}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      onPressed: () {
                                        _speakSmart(chip['urdu'], chip['phonics']);
                                        _triggerToast('لفظ: "${chip['urdu']}" 🔊');
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentPageIndex == index ? 28 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: currentPageIndex == index ? const Color(0xFF006689) : const Color(0xFFBDC8D0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex < 2 ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                    foregroundColor: currentPageIndex < 2 ? Colors.white : const Color(0xFF2A1800),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _nextPage,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(currentPageIndex == 2 ? 'کوئز ⭐' : 'اگلا', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 4),
                                      Icon(currentPageIndex == 2 ? Icons.celebration : Icons.arrow_back, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                    foregroundColor: isPlaying ? Colors.white : const Color(0xFF2A1800),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _toggleAudio,
                                  child: Text(isPlaying ? 'کہانی روکیں ⏸️' : 'کہانی سنیں 🎧', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex > 0 ? const Color(0xFF006D39) : const Color(0xFFF0EEE8),
                                    foregroundColor: currentPageIndex > 0 ? Colors.white : const Color(0xFF6E7980),
                                    elevation: currentPageIndex > 0 ? 3 : 1,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: currentPageIndex > 0 ? _prevPage : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.arrow_forward, size: 18),
                                      SizedBox(width: 4),
                                      Text('پچھلا', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () => setState(() => showQuizModal = true),
                            icon: const Icon(Icons.quiz, size: 16, color: Color(0xFF006689)),
                            label: const Text('📝 کہانی کا سبق اور کوئز کھیلیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                          ),
                        ],
                      ),
                    ),
                    if (showToastFlag)
                      Positioned(
                        top: 80,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF30312D),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                              ),
                              child: Text(
                                toastMessage ?? '',
                                style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFFF2F1EB), fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showQuizModal)
                      Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('🌟', style: TextStyle(fontSize: 22)),
                                      SizedBox(width: 8),
                                      Text('شاباش! کوئز ٹائم', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() => showQuizModal = false),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (currentPageIndex == 2) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('💡 کہانی کا سبق:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                      SizedBox(height: 4),
                                      Text('میٹھی زبان اور اچھا رویہ سب کا دل جیت لیتا ہے! بانٹنے سے محبت بڑھتی ہے۔', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)), textAlign: TextAlign.right),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              Text('صفحہ ${currentPage['pageUrdu']} کا سوال (Comprehension):', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                              const SizedBox(height: 4),
                              Text(currentPage['quizQuestion'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)), textAlign: TextAlign.right),
                              const SizedBox(height: 10),
                              if (isQuizCorrect != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: isQuizCorrect! ? const Color(0xFF73FDA3) : const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isQuizCorrect! ? 'شاباش! بالکل درست جواب! 🎉' : 'دوبارہ کوشش کریں! ❌',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isQuizCorrect! ? const Color(0xFF00522A) : const Color(0xFF93000A)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ...(currentPage['quizOptions'] as List).map((option) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      foregroundColor: const Color(0xFF1B1C19),
                                      minimumSize: const Size(double.infinity, 46),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isQuizCorrect = option['isCorrect'];
                                      });
                                    },
                                    child: Text(option['text'], style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006689),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showQuizModal = false;
                                    isQuizCorrect = null;
                                  });
                                },
                                child: const Text('واپس کہانی پر جائیں 🔄', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }
}

// ==========================================
// 3. BHOORA CHUHA STORY READER MODULE
// ==========================================
class BhooraChuhaStoryScreen extends StatefulWidget {
  const BhooraChuhaStoryScreen({Key? key}) : super(key: key);

  @override
  State<BhooraChuhaStoryScreen> createState() => _BhooraChuhaStoryScreenState();
}

class _BhooraChuhaStoryScreenState extends State<BhooraChuhaStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPageIndex = 0;
  bool isPlaying = false;
  bool isAutoPlay = true;
  bool showQuizModal = false;
  bool? isQuizCorrect;
  String? toastMessage;
  bool showToastFlag = false;

  final List<Map<String, dynamic>> storyPages = [
    {
      'pageUrdu': '۱',
      'sceneBadge': 'منظر ۱ • مٹھائی کی خوشبو ✨',
      'imgPath': 'assets/images/mouse_page1.png',
      'urduText': 'ایک چھوٹا اور چالاک بھورا چوہا مٹھائی کی خوشبو سونگھتے ہوئے مٹھائی کے ڈبے تک پہنچ گیا!',
      'englishText': '"A clever little brown mouse smelled sweet treats and found a delicious box of mithai!"',
      'phonics': 'Chey Chuha, Meem Mithai, Khe Khushbu',
      'phonicsUrdu': '/چ/ چوہا • /م/ مٹھائی • /خ/ خوشبو',
      'textToSpeakUrdu': 'ایک چھوٹا اور چالاک بھورا چوہا مٹھائی کی خوشبو سونگھتے ہوئے مٹھائی کے ڈبے تک پہنچ گیا!',
      'textToSpeakEngPhonics': 'Ek chota aur chalak bhoora chuha mithai ki khushbu songhte hue dabe tak pahunch gaya!',
      'hotspotMouseMsg': 'چی چی! میں ایک ننھا بھورا چوہا ہوں! 🐭',
      'hotspotBoxMsg': 'واہ! کتنا لذیذ اور میٹھا ڈبہ ہے! 🍬',
      'quizQuestion': 'بھورا چوہا خوشبو سونگھ کر کہاں پہنچا؟',
      'quizOptions': [
        {'text': '۱. مٹھائی کے ڈبے تک 🍬', 'isCorrect': true},
        {'text': '۲. پانی کے تالاب تک', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🐭', 'urdu': 'چوہا', 'phonics': 'Chuha'},
        {'emoji': '🍬', 'urdu': 'مٹھائی', 'phonics': 'Mithai'},
        {'emoji': '🎁', 'urdu': 'ڈبہ', 'phonics': 'Dabba'},
        {'emoji': '🌸', 'urdu': 'خوشبو', 'phonics': 'Khushbu'},
      ],
    },
    {
      'pageUrdu': '۲',
      'sceneBadge': 'منظر ۲ • دوستوں کے ساتھ بانٹنا 🤝',
      'imgPath': 'assets/images/mouse_page2.png',
      'urduText': 'بھورے چوہے نے اکیلے کھانے کے بجائے اپنے دوستوں گلہری اور چڑیا کو بھی بلایا اور مٹھائی بانٹی!',
      'englishText': '"Instead of eating alone, the little brown mouse shared the sweets with squirrel and bird friends!"',
      'phonics': 'Daal Dost, Bay Bantna, Gaaf Gilhari',
      'phonicsUrdu': '/د/ دوست • /ب/ بانٹنا • /گ/ گلہری',
      'textToSpeakUrdu': 'بھورے چوہے نے اکیلے کھانے کے بجائے اپنے دوستوں گلہری اور چڑیا کو بھی بلایا اور مٹھائی بانٹی!',
      'textToSpeakEngPhonics': 'Bhooray chuhey ne akele khane ke bajaye apne doston gilhari aur chiriya ko bulaya!',
      'hotspotMouseMsg': 'دوستوں کے ساتھ بانٹ کر کھانا کتنا مزے دار ہے! 🌰',
      'hotspotBoxMsg': 'سب مل کر خوشی سے کھا رہے ہیں! 🥧',
      'quizQuestion': 'چوہے نے مٹھائی کس کے ساتھ بانٹی؟',
      'quizOptions': [
        {'text': '۱. گلہری اور چڑیا دوستوں کے ساتھ 🐿️', 'isCorrect': true},
        {'text': '۲. اکیلے چھپ کر کھا گیا', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🐿️', 'urdu': 'گلہری', 'phonics': 'Gilhari'},
        {'emoji': '🦜', 'urdu': 'چڑیا', 'phonics': 'Chiriya'},
        {'emoji': '🤝', 'urdu': 'دوست', 'phonics': 'Dost'},
        {'emoji': '🥧', 'urdu': 'بانٹنا', 'phonics': 'Bantna'},
      ],
    },
    {
      'pageUrdu': '۳',
      'sceneBadge': 'منظر ۳ • جشن اور خوشیاں 🎈',
      'imgPath': 'assets/images/mouse_page3.png',
      'urduText': 'سب دوست مل جل کر خوش ہوئے اور چوہے کا شکریہ ادا کیا! مل کر کھانے میں ہی اصل برکت ہے!',
      'englishText': '"All the animal companions celebrated together with joyful smiles and thanked the happy mouse!"',
      'phonics': 'Jeem Jashan, Seen Shukriya, Khay Khushi',
      'phonicsUrdu': '/ج/ جشن • /ش/ شکریہ • /خ/ خوشی',
      'textToSpeakUrdu': 'سب دوست مل جل کر خوش ہوئے اور چوہے کا شکریہ ادا کیا! مل کر کھانے میں ہی اصل برکت ہے!',
      'textToSpeakEngPhonics': 'Sab dost mil kar khush hue aur chuhey ka shukriya ada kiya!',
      'hotspotMouseMsg': 'ہورے! ہم سب اچھے دوست ہیں! 🥳',
      'hotspotBoxMsg': 'ڈبہ ختم مگر خوشیاں ہمیشہ رہیں گی! ⭐',
      'quizQuestion': 'سب دوستوں نے خوش ہو کر کیا کیا؟',
      'quizOptions': [
        {'text': '۱. شکریہ ادا کیا اور جشن منایا 🎉', 'isCorrect': true},
        {'text': '۲. ناراض ہو گئے', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🥳', 'urdu': 'جشن', 'phonics': 'Jashan'},
        {'emoji': '💖', 'urdu': 'برکت', 'phonics': 'Barkat'},
        {'emoji': '⭐', 'urdu': 'خوشی', 'phonics': 'Khushi'},
        {'emoji': '🤝', 'urdu': 'شکریہ', 'phonics': 'Shukriya'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.42);

      flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
      flutterTts.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _speakSmart(String urduText, String phonicsText) async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        setState(() {
          isPlaying = false;
        });
        return;
      }

      setState(() {
        isPlaying = true;
      });

      var languages = await flutterTts.getLanguages;
      bool hasUrdu = languages != null && languages.contains("ur-PK");

      if (hasUrdu) {
        await flutterTts.setLanguage("ur-PK");
        await flutterTts.speak(urduText);
      } else {
        await flutterTts.setLanguage("en-US");
        await flutterTts.speak(phonicsText);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _toggleAudio() async {
    final page = storyPages[currentPageIndex];
    await _speakSmart(page['textToSpeakUrdu'], page['textToSpeakEngPhonics']);
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
    Future.delayed(const Duration(milliseconds: 2600), () {
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
      if (currentPageIndex < storyPages.length - 1) {
        currentPageIndex++;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر خوش آمدید! ✨');
      } else {
        showQuizModal = true;
        _triggerToast('کوئز حل کریں! 🌟');
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPageIndex > 0) {
        currentPageIndex--;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر واپس آ گئے');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = storyPages[currentPageIndex];

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
                preferredSize: const Size.fromHeight(68),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3),
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
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'بھورا چوہا اور مٹھائی کا ڈبہ 🐭',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(color: Color(0xFF006689), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.menu_book, color: Color(0xFF006689), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'صفحہ ${currentPage['pageUrdu']} از ۳',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x18006D39), offset: Offset(0, 8), blurRadius: 20)],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      width: double.infinity,
                                      child: Image.asset(currentPage['imgPath'], fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(currentPage['sceneBadge'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF1B1C19),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['hotspotMouseMsg'], currentPage['hotspotMouseMsg']);
                                          _triggerToast(currentPage['hotspotMouseMsg']);
                                        },
                                        child: const Text('🐭 چوہے کو چھوئیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFDDB6),
                                          foregroundColor: const Color(0xFF2A1800),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['hotspotBoxMsg'], currentPage['hotspotBoxMsg']);
                                          _triggerToast(currentPage['hotspotBoxMsg']);
                                        },
                                        child: const Text('🍬 ڈبہ چھوئیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73FDA3).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                      child: const Icon(Icons.record_voice_over, color: Colors.white, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('صوتی مشق و تلفظ', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                                        Text(currentPage['phonicsUrdu'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D39),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    _speakSmart(currentPage['phonicsUrdu'], currentPage['phonics']);
                                    _triggerToast('تلفظ سنیے: ${currentPage['phonicsUrdu']} 🎧');
                                  },
                                  icon: const Icon(Icons.volume_up, size: 16),
                                  label: const Text('سنیں', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1240352C), offset: Offset(0, 6), blurRadius: 18)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                                          child: const Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('پپ کہانی گو 🎨', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                      ],
                                    ),
                                    Row(
                                      children: List.generate(4, (index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                        width: 3,
                                        height: index.isEven ? 16 : 10,
                                        decoration: BoxDecoration(color: const Color(0xFF006D39), borderRadius: BorderRadius.circular(2)),
                                      )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3EE),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentPage['urduText'],
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19), height: 1.6),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentPage['englishText'],
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF6E7980)),
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('نئے الفاظ چھوئیں اور سیکھیں:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (currentPage['chips'] as List).map((chip) {
                                    return ActionChip(
                                      label: Text('${chip['emoji']} ${chip['urdu']}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      onPressed: () {
                                        _speakSmart(chip['urdu'], chip['phonics']);
                                        _triggerToast('لفظ: "${chip['urdu']}" 🔊');
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentPageIndex == index ? 28 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: currentPageIndex == index ? const Color(0xFF006689) : const Color(0xFFBDC8D0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex < 2 ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                    foregroundColor: currentPageIndex < 2 ? Colors.white : const Color(0xFF2A1800),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _nextPage,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(currentPageIndex == 2 ? 'کوئز ⭐' : 'اگلا', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 4),
                                      Icon(currentPageIndex == 2 ? Icons.celebration : Icons.arrow_back, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                    foregroundColor: isPlaying ? Colors.white : const Color(0xFF2A1800),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _toggleAudio,
                                  child: Text(isPlaying ? 'کہانی روکیں ⏸️' : 'کہانی سنیں 🎧', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex > 0 ? const Color(0xFF006D39) : const Color(0xFFF0EEE8),
                                    foregroundColor: currentPageIndex > 0 ? Colors.white : const Color(0xFF6E7980),
                                    elevation: currentPageIndex > 0 ? 3 : 1,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: currentPageIndex > 0 ? _prevPage : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.arrow_forward, size: 18),
                                      SizedBox(width: 4),
                                      Text('پچھلا', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () => setState(() => showQuizModal = true),
                            icon: const Icon(Icons.quiz, size: 16, color: Color(0xFF006689)),
                            label: const Text('📝 کہانی کا سبق اور کوئز کھیلیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                          ),
                        ],
                      ),
                    ),
                    if (showToastFlag)
                      Positioned(
                        top: 80,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF30312D),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                              ),
                              child: Text(
                                toastMessage ?? '',
                                style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFFF2F1EB), fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showQuizModal)
                      Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('🌟', style: TextStyle(fontSize: 22)),
                                      SizedBox(width: 8),
                                      Text('شاباش! کوئز ٹائم', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() => showQuizModal = false),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (currentPageIndex == 2) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('💡 کہانی کا سبق:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                      SizedBox(height: 4),
                                      Text('مل جل کر کھانے سے خوشیاں اور برکت بڑھتی ہے!', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)), textAlign: TextAlign.right),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              Text('صفحہ ${currentPage['pageUrdu']} کا سوال (Comprehension):', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                              const SizedBox(height: 4),
                              Text(currentPage['quizQuestion'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)), textAlign: TextAlign.right),
                              const SizedBox(height: 10),
                              if (isQuizCorrect != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: isQuizCorrect! ? const Color(0xFF73FDA3) : const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isQuizCorrect! ? 'شاباش! بالکل درست جواب! 🎉' : 'دوبارہ کوشش کریں! ❌',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isQuizCorrect! ? const Color(0xFF00522A) : const Color(0xFF93000A)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ...(currentPage['quizOptions'] as List).map((option) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      foregroundColor: const Color(0xFF1B1C19),
                                      minimumSize: const Size(double.infinity, 46),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isQuizCorrect = option['isCorrect'];
                                      });
                                    },
                                    child: Text(option['text'], style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006689),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showQuizModal = false;
                                    isQuizCorrect = null;
                                  });
                                },
                                child: const Text('واپس کہانی پر جائیں 🔄', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }
}

// ==========================================
// 4. NANHA HATHI STORY READER MODULE (3rd Story)
// ==========================================
class NanhaHathiStoryScreen extends StatefulWidget {
  const NanhaHathiStoryScreen({Key? key}) : super(key: key);

  @override
  State<NanhaHathiStoryScreen> createState() => _NanhaHathiStoryScreenState();
}

class _NanhaHathiStoryScreenState extends State<NanhaHathiStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentPageIndex = 0;
  bool isPlaying = false;
  bool isAutoPlay = true;
  bool showQuizModal = false;
  bool? isQuizCorrect;
  String? toastMessage;
  bool showToastFlag = false;

  final List<Map<String, dynamic>> storyPages = [
    {
      'pageUrdu': '۱',
      'sceneBadge': 'منظر ۱: ندی کی سیر ✨',
      'imgPath': 'assets/images/elephant_page1.png',
      'urduText': 'ایک ننھے ہاتھی کے بچے کا پہلی بار ندی میں جا کر پانی سے کھیلنے اور دوست بنانے کا خوبصورت سفر۔',
      'englishText': '"A cute baby elephant\'s wonderful first adventure playing in the river and making new friends!"',
      'phonics': 'Heh Hathi, Noon Nadi',
      'phonicsUrdu': '/ہ/ ہاتھی • /ن/ ندی',
      'textToSpeakUrdu': 'ایک ننھے ہاتھی کے بچے کا پہلی بار ندی میں جا کر پانی سے کھیلنے اور دوست بنانے کا خوبصورت سفر۔',
      'textToSpeakEngPhonics': 'Ek nanhey hathi ke bachay ka pehli baar nadi mein ja kar khelne ka safar!',
      'hotspotElephantMsg': 'پھُرّ! ننھا ہاتھی پانی اڑا رہا ہے! 🐘💦',
      'hotspotRiverMsg': 'چھپ چھپ! ندی کا پانی ٹھنڈا اور میٹھا ہے! 🌊✨',
      'quizQuestion': 'ننھا ہاتھی پہلی بار کہاں گیا تھا؟',
      'quizOptions': [
        {'text': '۱. ندی میں پانی کھیلنے 🌊', 'isCorrect': true},
        {'text': '۲. اونچے پہاڑ پر', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🐘', 'urdu': 'ہاتھی', 'phonics': 'Hathi'},
        {'emoji': '🌊', 'urdu': 'ندی', 'phonics': 'Nadi'},
        {'emoji': '💧', 'urdu': 'پانی', 'phonics': 'Pani'},
        {'emoji': '🤝', 'urdu': 'دوست', 'phonics': 'Dost'},
      ],
    },
    {
      'pageUrdu': '۲',
      'sceneBadge': 'منظر ۲: نئے جنگلی دوست ✨',
      'imgPath': 'assets/images/elephant_page2.png',
      'urduText': 'ننھے ہاتھی نے ندی کنارے خرگوش، لومڑی اور پرندوں کو دیکھا اور ان پر ٹھنڈا پانی اڑا کر ہنسنے لگا!',
      'englishText': '"The baby elephant saw little bunny, fox and bird friends by the river bank and gently splashed cool water!"',
      'phonics': 'Khay Khargosh, Lam Lomri',
      'phonicsUrdu': '/خ/ خرگوش • /ل/ لومڑی',
      'textToSpeakUrdu': 'ننھے ہاتھی نے ندی کنارے خرگوش، لومڑی اور پرندوں کو دیکھا اور ان پر ٹھنڈا پانی اڑا کر ہنسنے لگا!',
      'textToSpeakEngPhonics': 'Nanha hathi ne nadi kinare khargosh aur lomri ko dekha!',
      'hotspotElephantMsg': 'ہاتھی سب دوستوں کو سلام کر رہا ہے! 🐘',
      'hotspotRiverMsg': 'ٹھنڈا پانی سب کو پسند آیا! 💧✨',
      'quizQuestion': 'ہاتھی نے کن جانوروں کو دیکھا؟',
      'quizOptions': [
        {'text': '۱. خرگوش، لومڑی اور پرندے 🐰', 'isCorrect': true},
        {'text': '۲. شیر اور چيتا', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🐰', 'urdu': 'خرگوش', 'phonics': 'Khargosh'},
        {'emoji': '🦊', 'urdu': 'لومڑی', 'phonics': 'Lomri'},
        {'emoji': '🦜', 'urdu': 'پرندے', 'phonics': 'Parinday'},
        {'emoji': '💦', 'urdu': 'چھینٹے', 'phonics': 'Chheetay'},
      ],
    },
    {
      'pageUrdu': '۳',
      'sceneBadge': 'منظر ۳: خوشیوں کی برسات ✨',
      'imgPath': 'assets/images/elephant_page3.png',
      'urduText': 'سب جانور خوشی سے جھوم اٹھے اور ننھے ہاتھی کے پکے دوست بن گئے۔ جنگل میں خوب ہنسی اور مستی چھا گئی!',
      'englishText': '"All the jungle friends danced with joy and became best friends with the baby elephant forever!"',
      'phonics': 'Jeem Jungle, Daal Dost',
      'phonicsUrdu': '/ج/ جنگل • /د/ دوست',
      'textToSpeakUrdu': 'سب جانور خوشی سے جھوم اٹھے اور ننھے ہاتھی کے پکے دوست بن گئے۔ جنگل میں خوب ہنسی اور مستی چھا گئی!',
      'textToSpeakEngPhonics': 'Sab jaanwar khushi se jhoom uthe aur pakke dost ban gaye!',
      'hotspotElephantMsg': 'سب جانور مل کر خوش ہو رہے ہیں! 🥳',
      'hotspotRiverMsg': 'دوستی کا خوبصورت ماحول! 💖',
      'quizQuestion': 'سب جانوروں کا آپس میں کیا رشتہ بن گیا؟',
      'quizOptions': [
        {'text': '۱. سب پکے دوست بن گئے 💖', 'isCorrect': true},
        {'text': '۲. سب لڑ پڑے', 'isCorrect': false},
      ],
      'chips': [
        {'emoji': '🌳', 'urdu': 'جنگل', 'phonics': 'Jungle'},
        {'emoji': '🥳', 'urdu': 'مستی', 'phonics': 'Masti'},
        {'emoji': '💖', 'urdu': 'محبت', 'phonics': 'Mohabbat'},
        {'emoji': '🎉', 'urdu': 'جشن', 'phonics': 'Jashan'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.42);

      flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
      flutterTts.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _speakSmart(String urduText, String phonicsText) async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        setState(() {
          isPlaying = false;
        });
        return;
      }

      setState(() {
        isPlaying = true;
      });

      var languages = await flutterTts.getLanguages;
      bool hasUrdu = languages != null && languages.contains("ur-PK");

      if (hasUrdu) {
        await flutterTts.setLanguage("ur-PK");
        await flutterTts.speak(urduText);
      } else {
        await flutterTts.setLanguage("en-US");
        await flutterTts.speak(phonicsText);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _toggleAudio() async {
    final page = storyPages[currentPageIndex];
    await _speakSmart(page['textToSpeakUrdu'], page['textToSpeakEngPhonics']);
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
    Future.delayed(const Duration(milliseconds: 2600), () {
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
      if (currentPageIndex < storyPages.length - 1) {
        currentPageIndex++;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر خوش آمدید! ✨');
      } else {
        showQuizModal = true;
        _triggerToast('کوئز حل کریں! 🌟');
      }
    });
  }

  void _prevPage() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      if (currentPageIndex > 0) {
        currentPageIndex--;
        isQuizCorrect = null;
        _triggerToast('صفحہ ${storyPages[currentPageIndex]['pageUrdu']} پر واپس آ گئے');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = storyPages[currentPageIndex];

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
                preferredSize: const Size.fromHeight(68),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3),
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
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'ننھا ہاتھی اور ندی 🐘',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(color: Color(0xFF006689), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.menu_book, color: Color(0xFF006689), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'صفحہ ${currentPage['pageUrdu']} از ۳',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x18006D39), offset: Offset(0, 8), blurRadius: 20)],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      width: double.infinity,
                                      child: Image.asset(currentPage['imgPath'], fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(currentPage['sceneBadge'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF1B1C19),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['hotspotElephantMsg'], currentPage['hotspotElephantMsg']);
                                          _triggerToast(currentPage['hotspotElephantMsg']);
                                        },
                                        child: const Text('🐘 ہاتھی کو چھوئیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFDDB6),
                                          foregroundColor: const Color(0xFF2A1800),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          elevation: 3,
                                        ),
                                        onPressed: () {
                                          _speakSmart(currentPage['hotspotRiverMsg'], currentPage['hotspotRiverMsg']);
                                          _triggerToast(currentPage['hotspotRiverMsg']);
                                        },
                                        child: const Text('🌊 ندی کا پانی!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73FDA3).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                      child: const Icon(Icons.record_voice_over, color: Colors.white, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('صوتی مشق و تلفظ', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                                        Text(currentPage['phonicsUrdu'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006D39),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    _speakSmart(currentPage['phonicsUrdu'], currentPage['phonics']);
                                    _triggerToast('تلفظ سنیے: ${currentPage['phonicsUrdu']} 🎧');
                                  },
                                  icon: const Icon(Icons.volume_up, size: 16),
                                  label: const Text('سنیں', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1240352C), offset: Offset(0, 6), blurRadius: 18)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                                          child: const Icon(Icons.cruelty_free, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('پپ کہانی گو 🎨', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                      ],
                                    ),
                                    Row(
                                      children: List.generate(4, (index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                        width: 3,
                                        height: index.isEven ? 16 : 10,
                                        decoration: BoxDecoration(color: const Color(0xFF006D39), borderRadius: BorderRadius.circular(2)),
                                      )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3EE),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentPage['urduText'],
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19), height: 1.6),
                                        textAlign: TextAlign.right,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentPage['englishText'],
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF6E7980)),
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('نئے الفاظ چھوئیں اور سیکھیں:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (currentPage['chips'] as List).map((chip) {
                                    return ActionChip(
                                      label: Text('${chip['emoji']} ${chip['urdu']}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      onPressed: () {
                                        _speakSmart(chip['urdu'], chip['phonics']);
                                        _triggerToast('لفظ: "${chip['urdu']}" 🔊');
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentPageIndex == index ? 28 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: currentPageIndex == index ? const Color(0xFF006689) : const Color(0xFFBDC8D0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex < 2 ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                    foregroundColor: currentPageIndex < 2 ? Colors.white : const Color(0xFF2A1800),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _nextPage,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(currentPageIndex == 2 ? 'کوئز ⭐' : 'اگلا', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 4),
                                      Icon(currentPageIndex == 2 ? Icons.celebration : Icons.arrow_back, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPlaying ? Colors.redAccent : const Color(0xFFFFAA1D),
                                    foregroundColor: isPlaying ? Colors.white : const Color(0xFF2A1800),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: _toggleAudio,
                                  child: Text(isPlaying ? 'کہانی روکیں ⏸️' : 'کہانی سنیں 🎧', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentPageIndex > 0 ? const Color(0xFF006D39) : const Color(0xFFF0EEE8),
                                    foregroundColor: currentPageIndex > 0 ? Colors.white : const Color(0xFF6E7980),
                                    elevation: currentPageIndex > 0 ? 3 : 1,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: currentPageIndex > 0 ? _prevPage : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.arrow_forward, size: 18),
                                      SizedBox(width: 4),
                                      Text('پچھلا', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () => setState(() => showQuizModal = true),
                            icon: const Icon(Icons.quiz, size: 16, color: Color(0xFF006689)),
                            label: const Text('📝 کہانی کا سبق اور کوئز کھیلیں!', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                          ),
                        ],
                      ),
                    ),
                    if (showToastFlag)
                      Positioned(
                        top: 80,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF30312D),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                              ),
                              child: Text(
                                toastMessage ?? '',
                                style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFFF2F1EB), fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showQuizModal)
                      Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('🌟', style: TextStyle(fontSize: 22)),
                                      SizedBox(width: 8),
                                      Text('شاباش! کوئز ٹائم', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() => showQuizModal = false),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (currentPageIndex == 2) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('💡 کہانی کا سبق:', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                      SizedBox(height: 4),
                                      Text('مل جل کر کھانے سے خوشیاں اور برکت بڑھتی ہے!', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)), textAlign: TextAlign.right),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              Text('صفحہ ${currentPage['pageUrdu']} کا سوال (Comprehension):', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                              const SizedBox(height: 4),
                              Text(currentPage['quizQuestion'], style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)), textAlign: TextAlign.right),
                              const SizedBox(height: 10),
                              if (isQuizCorrect != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: isQuizCorrect! ? const Color(0xFF73FDA3) : const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isQuizCorrect! ? 'شاباش! بالکل درست جواب! 🎉' : 'دوبارہ کوشش کریں! ❌',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isQuizCorrect! ? const Color(0xFF00522A) : const Color(0xFF93000A)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ...(currentPage['quizOptions'] as List).map((option) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      foregroundColor: const Color(0xFF1B1C19),
                                      minimumSize: const Size(double.infinity, 46),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isQuizCorrect = option['isCorrect'];
                                      });
                                    },
                                    child: Text(option['text'], style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006689),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showQuizModal = false;
                                    isQuizCorrect = null;
                                  });
                                },
                                child: const Text('واپس کہانی پر جائیں 🔄', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }
}