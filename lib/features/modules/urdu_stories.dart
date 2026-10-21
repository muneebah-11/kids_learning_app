import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ==========================================
// URDU KAHANIYAN LIST SCREEN MODULE
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
                      _buildUrduStoryCard(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB9D6CgED8SZATRE5gr2DGcyXKlUPlAmQ3GfGAYvEsiiX_s7YLhVfGNrxGTSwzkQm5a1SJTX484yEOLJUg3zAt4kMz7p16MeWtiDgKV_MqKQ5YuEzFf6oAwC2Cv2BXTScmZFkkj0fyLcQC50Gkfk7wMITUUX0mKQNnGIUAwEn8ysikA1TghTX7s6iPuyximqk3vXLYlBYXuWY4zBIyerRoKjlaNR2W3uvR2BjOB3HldEWgudjbX6yE',
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
                      _buildUrduStoryCard(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBswQKpbk82bS_hr9bWe-BsSCLXhM4L74JeZKiLcwnVfoGG9gM2eE1xh0__qSTxO54YRD8HjtJacaWj-KMjKKhhZRAx6mWiejlbjeWCqjAw1IVO5HV_YnVcdoTVH5sSvPH9eLk4h-raZg77Fl-_V9KoSb399KD_XT-56hI5-ObG_USLr7Zw4uCZCL2AuTErNrXYiCd60F5EhUhkUnUW436YWkfvdvgKLPhFxIuzsWFN0hfOG8NzQ9E',
                        title: 'بھورا چوہا اور مٹھائی کا ڈبہ 🐭',
                        tagBadge: 'بہت مقبول',
                        badgeBgColor: const Color(0xFFFFDDB6),
                        badgeTextColor: const Color(0xFF643F00),
                        subtitle: 'مزیدار اور ہنسانے والی کہانی',
                        description: 'ایک چھوٹا اور شرارتی چوہا جو مٹھائی کی خوشبو سونگھتے ہوئے ایک دن مٹھائی کے ڈبے تک پہنچ جاتا ہے!',
                        feature1: 'مکمل آواز',
                        feature2: 'مزیدار قصہ 🍬',
                        onPressed: () => _showToast('بھورا چوہا اور مٹھائی کا ڈبہ 🐭'),
                      ),
                      const SizedBox(height: 20),
                      _buildUrduStoryCard(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDf1GqpLDtOgR5V03jyMoqTKsb_Fqvv1KW_7jG3sF1WvQVrpAPTsrydCAtG6dQ2AD0Si42Mk_BkN6YFpNtQI78cxzT_YEIjeQq4FjkTL8gsUu6xV3hMedWnbdOu1Oe6eooYhgvefn_kTyDdo6aBnc3jaedipcU7LRKRrmoMg5aqvwnEVYHCzGJojVg9Q1Cor5jMWwGGlLiZZg4hyt64S-YXzhBi_lDAWDXBWN2dHSeFBXjWzwMz5jw',
                        title: 'ننھا ہاتھی اور ندی 🐘',
                        tagBadge: 'دوستی',
                        badgeBgColor: const Color(0xFF73FDA3),
                        badgeTextColor: const Color(0xFF00522A),
                        subtitle: 'پہلا ایڈونچر اور پانی کے مزے',
                        description: 'ایک ننھے ہاتھی کے بچے کا پہلی بار ندی میں جا کر پانی سے کھیلنے اور دوست بنانے کا خوبصورت سفر۔',
                        feature1: 'مکمل آواز',
                        feature2: 'ندی کا سفر 🌊',
                        onPressed: () => _showToast('ننھا ہاتھی اور ندی 🐘'),
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
    required String imageUrl,
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
              child: Image.network(imageUrl, fit: BoxFit.cover),
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
                decoration: BoxDecoration(color: const Color(0xFFFFDDB6).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
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
// CHIRIYA AUR SONA STORY READER MODULE
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
      'imgUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAVEPw1xnAOoCZWBombg9eIwzKr6wfJxeF6SPJWyxzNApuYFGi9pPbQn5GZ9mqGQoRKxCpB1YIhtO0Q_5qW2dQc7C8Aeno7LAXMTxL-pz3Z6huT8TAr9xmeEJ9vr2LPwnvXassAh_zQanbaCW-NhYLmZb8f5VPgED1EWOVhmwAaaugNRZHIuvCNGbjbo8A_Vf3A1DcT1y2Fo95ZpeHhtyynoxs6lJ0E11eBzvQCjtA8ATw4cNjSO5M',
      'sceneTitle': 'منظر ۱ • پیاری چڑیا کی صبح 🦜',
      'phonics': 'Chey Chiriya, Seen Sona',
      'phonicsUrdu': '/چ/ چڑیا • /س/ سونا',
      'hotspot2': 'پھول اور ٹہنیاں ✨',
      'urduText': 'ایک پیاری چڑیا نے اپنی میٹھی آواز سے جنگل کے سبھی دوستوں کو خوش کر دیا!',
      'englishText': '"A cute little bird made all the forest friends happy with her sweet singing voice!"',
      'textToSpeakUrdu': 'ایک پیاری چڑیا نے اپنی میٹھی آواز سے جنگل کے سبھی دوستوں کو خوش کر دیا!',
      'textToSpeakEngPhonics': 'Ek pyari chiriya ne apni meethi awaz se jungle ke sabhi doston ko khush kar diya!',
      'birdToast': 'Chi chi! Main sunhari chiriya hoon!',
      'natureToast': 'Bohat khoob! Qudrat ke nazare khushgwar hain!',
      'chips': [
        {'emoji': '🦜', 'urdu': 'چڑیا', 'phonics': 'Chiriya'},
        {'emoji': '🎶', 'urdu': 'میٹھی آواز', 'phonics': 'Meethi Awaz'},
        {'emoji': '🌳', 'urdu': 'جنگل', 'phonics': 'Jungle'},
        {'emoji': '💛', 'urdu': 'سونا', 'phonics': 'Sona'},
      ],
    },
    {
      'pageUrdu': '۲',
      'imgUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuATJvzsfKPjs8lec9h4_IvDgo7UrMl2J-5GjCrBY4lvsG9kvoCXG48886U0bTIZJl9LKAVtl-Glt3YQ-8GFLv3VPb9AlXUZkwf-xTWiFjAU9Bvz8TA-zsrzoh5qQlIQxxQAjQJ1S-mXcBNLSWDhexiXQMZrTjC1l2cnTykjBpsqb3dwfnXB1eVcvDFJ0jXiVU_dXew4WVWURjY36PfEZayzc4U-fUJxS_VqkEjsNE-Yhu7JHuAAyag',
      'sceneTitle': 'منظر ۲ • محبت سے بانٹنا 🌰',
      'phonics': 'Daal Daane, Bay Beej',
      'phonicsUrdu': '/د/ دانے • /ب/ بیج',
      'hotspot2': 'سنہری بیجوں کی ٹوکری 🧺',
      'urduText': 'چڑیا نے سب دوستوں کو سنہری دانے اور میٹھے بیج بانٹے، سب جانور خوش ہو کر مل جل کر کھانے لگے!',
      'englishText': '"The little bird shared golden seeds with all the forest animals, and everyone ate together happily!"',
      'textToSpeakUrdu': 'چڑیا نے سب دوستوں کو سنہری دانے اور میٹھے بیج بانٹے، سب جانور خوش ہو کر مل جل کر کھانے لگے!',
      'textToSpeakEngPhonics': 'Chiriya ne sab doston ko sunhari daane aur meethe beej baante, sab jaanwar khush ho kar mil jal kar khane lage!',
      'birdToast': 'Dosto! Aao mil kar daane khayein!',
      'natureToast': 'Mazedar daane aur beej!',
      'chips': [
        {'emoji': '🐿️', 'urdu': 'گلہری', 'phonics': 'Gilhari'},
        {'emoji': '🐰', 'urdu': 'خرگوش', 'phonics': 'Khargosh'},
        {'emoji': '🦌', 'urdu': 'ہرن', 'phonics': 'Hiran'},
        {'emoji': '🌾', 'urdu': 'سنہری بیج', 'phonics': 'Sunhari Beej'},
      ],
    },
    {
      'pageUrdu': '۳',
      'imgUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQkFtHbwOzKZQmnio0FLJEnGc6qcA7ZDZcbE8FECwUNRPW8ykFjJuL-3w-yF5k5h-MPoIVKy79BKCjWzgc81LMnyGUx5uXV5rWIXysjY8nQxDdfsMMiS6tokYwEIeCTnig82Xj63hVtVJksYOyUa5_vqvCWtGxfCecLKfa37NHjn6OvIsI39PKLcgz-8LIjQNY62NjvHUngYqreUBoJDWuc38ZL0A7hWLFEJf_qi5phWWRGw4h6IA',
      'sceneTitle': 'منظر ۳ • جشن اور خوشیاں 🌈',
      'phonics': 'Jeem Jashan, Gaaf Geet',
      'phonicsUrdu': '/ج/ جشن • /گ/ گیت',
      'hotspot2': 'قوسِ قزح کا نظارہ 🌈',
      'urduText': 'سب نے مل کر جشن منایا اور گیت گائے، جنگل میں ہر طرف خوشیوں کا رنگ پھیل گیا!',
      'englishText': '"They celebrated together under the rainbow, spreading love and happiness across the entire forest!"',
      'textToSpeakUrdu': 'سب نے مل کر جشن منایا اور گیت گائے، جنگل میں ہر طرف خوشیوں کا رنگ پھیل گیا!',
      'textToSpeakEngPhonics': 'Sab ne mil kar jashan manaya aur geet gaye, jungle mein har taraf khushiyon ka rang phel gaya!',
      'birdToast': 'Aao sab mil kar geet gayein!',
      'natureToast': 'Jungle mein jashan ka mahol!',
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
                              InkWell(
                                onTap: () {
                                  flutterTts.stop();
                                  _triggerToast('لائبریری میں واپسی... 📚');
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0EEE8),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 2))],
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.arrow_back, color: Color(0xFF006689), size: 16),
                                      SizedBox(width: 4),
                                      Text('لائبریری', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                                    ],
                                  ),
                                ),
                              ),
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
                                      child: Image.network(currentPage['imgUrl'], fit: BoxFit.cover),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
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
                                            color: const Color(0xFF006689).withOpacity(0.85),
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
                                          backgroundColor: Colors.white.withOpacity(0.9),
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
                                    backgroundColor: const Color(0xFFF0EEE8),
                                    foregroundColor: const Color(0xFF6E7980),
                                    elevation: 2,
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
                                    backgroundColor: currentPageIndex == 2 ? const Color(0xFFFFAA1D) : const Color(0xFF006D39),
                                    foregroundColor: currentPageIndex == 2 ? const Color(0xFF2A1800) : Colors.white,
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
                                      Text('شاباش! کہانی مکمل', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() => showQuizModal = false),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFFFDDB6).withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
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
                              const Text('چھوٹا سوال (Comprehension):', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                              const SizedBox(height: 4),
                              const Text('چڑیا اپنی کس چیز سے سب کو خوش کرتی تھی؟', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)), textAlign: TextAlign.right),
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
                                    isQuizCorrect! ? 'شاباش! بالکل درست جواب! 🎉' : 'دوبارہ کوشش کریں! چڑیا بہت پیارا گاتی تھی! ❌',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isQuizCorrect! ? const Color(0xFF00522A) : const Color(0xFF93000A)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0EEE8),
                                  foregroundColor: const Color(0xFF1B1C19),
                                  minimumSize: const Size(double.infinity, 46),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isQuizCorrect = true;
                                  });
                                },
                                child: const Text('۱. میٹھی آواز سے 🎶', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0EEE8),
                                  foregroundColor: const Color(0xFF1B1C19),
                                  minimumSize: const Size(double.infinity, 46),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isQuizCorrect = false;
                                  });
                                },
                                child: const Text('۲. زور سے شور مچا کر ❌', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 14),
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
                                    currentPageIndex = 0;
                                    isQuizCorrect = null;
                                  });
                                },
                                child: const Text('کہانی دوبارہ پڑھیں 🔄', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
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