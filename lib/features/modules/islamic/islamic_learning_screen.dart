import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const IslamicHubApp());
}

class IslamicHubApp extends StatelessWidget {
  const IslamicHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Learning Hub - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const IslamicLearningScreen(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_islamic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        module_name TEXT,
        stars_earned INTEGER,
        completed_rounds INTEGER
      )
    ''');
  }

  Future<int> saveProgress(String module, int stars, int rounds) async {
    final db = await instance.database;
    return await db.insert('user_progress', {
      'module_name': module,
      'stars_earned': stars,
      'completed_rounds': rounds,
    });
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM user_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return int.parse(result.first['total'].toString());
    }
    return 0;
  }
}

class LessonData {
  final int id;
  final String titleEn;
  final String titleUr;
  final String descEn;
  final String descUr;
  final String badgeEn;
  final String badgeUr;
  final String badgeCountEn;
  final String badgeCountUr;
  final String actionEn;
  final String actionUr;
  final String stars;
  final String icon;
  final Color cardColor;
  final Color badgeColor;
  final Color textColor;
  final IconData actionIcon;
  final String assetImagePath;
  final String arabic;
  final String transEn;
  final String transUr;

  const LessonData({
    required this.id,
    required this.titleEn,
    required this.titleUr,
    required this.descEn,
    required this.descUr,
    required this.badgeEn,
    required this.badgeUr,
    required this.badgeCountEn,
    required this.badgeCountUr,
    required this.actionEn,
    required this.actionUr,
    required this.stars,
    required this.icon,
    required this.cardColor,
    required this.badgeColor,
    required this.textColor,
    required this.actionIcon,
    required this.assetImagePath,
    required this.arabic,
    required this.transEn,
    required this.transUr,
  });
}

class IslamicLearningScreen extends StatefulWidget {
  const IslamicLearningScreen({Key? key}) : super(key: key);

  @override
  State<IslamicLearningScreen> createState() => _IslamicLearningScreenState();
}

class _IslamicLearningScreenState extends State<IslamicLearningScreen> with SingleTickerProviderStateMixin {
  String currentLang = 'en'; // 'en' | 'ur'
  int starsCount = 12;
  bool isPlayingAudio = false;
  double audioProgress = 0.0;
  Timer? audioTimer;
  int audioSeconds = 0;

  late FlutterTts flutterTts;
  late AnimationController _pipSpinController;

  final List<LessonData> lessons = [
    const LessonData(
      id: 1,
      titleEn: "Basic Duas",
      titleUr: "روزمرہ کی دعائیں",
      descEn: "Before Eating, Sleeping & Waking Up",
      descUr: "کھانے سے پہلے، سونے اور جاگنے کی دعائیں",
      badgeEn: "Dua Lesson",
      badgeUr: "دعاؤں کا سبق",
      badgeCountEn: "6 Duas",
      badgeCountUr: "۶ دعائیں",
      actionEn: "Start Dua",
      actionUr: "شروع کریں",
      stars: "+2",
      icon: "🤲",
      cardColor: Color(0xFFC2E8FF),
      badgeColor: Color(0xFFC2E8FF),
      textColor: Color(0xFF006689),
      actionIcon: Icons.play_arrow,
      assetImagePath: "assets/images/islamic_duas.png",
      arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ",
      transEn: "'In the Name of Allah, with Whose Name nothing can cause harm in earth or heaven.'",
      transUr: "اللہ کے نام کے ساتھ جس کے نام کی برکت سے زمین اور آسمان میں کوئی چیز نقصان نہیں پہنچاتی۔",
    ),
    const LessonData(
      id: 2,
      titleEn: "First Kalma",
      titleUr: "کلمہ طیبہ",
      descEn: "Tayyibah with Urdu & English Meaning",
      descUr: "کلمہ طیبہ اردو اور انگریزی ترجمہ کے ساتھ",
      badgeEn: "First Kalma",
      badgeUr: "کلمہ اول",
      badgeCountEn: "Recite & Audio",
      badgeCountUr: "صوتی تلاوت",
      actionEn: "Listen Now",
      actionUr: "سنیں",
      stars: "+2",
      icon: "📖",
      cardColor: Color(0xFF73FDA3),
      badgeColor: Color(0xFF73FDA3),
      textColor: Color(0xFF006D39),
      actionIcon: Icons.headphones,
      assetImagePath: "assets/images/islamic_kalma.png",
      arabic: "لَا إِلٰهَ إِلَّا اللهُ مُحَمَّدٌ رَسُولُ اللهِ",
      transEn: "'There is no deity except Allah, Muhammad is the Messenger of Allah.'",
      transUr: "اللہ کے سوا کوئی عبادت کے لائق نہیں، محمد ﷺ اللہ کے رسول ہیں۔",
    ),
    const LessonData(
      id: 3,
      titleEn: "Short Surahs",
      titleUr: "چھوٹی سورتیں",
      descEn: "Al-Fatiha, Al-Ikhlas & Al-Kawthar",
      descUr: "سورۃ الفاتحہ، اخلاص اور کوثر",
      badgeEn: "Surah Al-Kawthar",
      badgeUr: "سورۃ الکوثر",
      badgeCountEn: "3 Surahs",
      badgeCountUr: "۳ سورتیں",
      actionEn: "Recite",
      actionUr: "تلاوت کریں",
      stars: "+3",
      icon: "🌙",
      cardColor: Color(0xFFFFDDB6),
      badgeColor: Color(0xFFFFDDB6),
      textColor: Color(0xFF845400),
      actionIcon: Icons.auto_stories,
      assetImagePath: "assets/images/islamic_surahs.png",
      arabic: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ • فَصَلِّ لِرَبِّكَ وَانْحَرْ",
      transEn: "'Indeed, We have granted you Al-Kawthar. So pray to your Lord and offer sacrifice.'",
      transUr: "بیشک ہم نے آپ کو کوثر عطا فرمائی، پس اپنے رب کے لیے نماز پڑھیں اور قربانی کریں۔",
    ),
    const LessonData(
      id: 4,
      titleEn: "Namaz Learning",
      titleUr: "نماز کی تعلیم",
      descEn: "Step-by-Step Prayer Steps for Little Ones",
      descUr: "چھوٹے بچوں کے لیے نماز کے آسان مراحل",
      badgeEn: "Step 1: Takbeer",
      badgeUr: "پہلا مرحلہ: تکبیر",
      badgeCountEn: "Step-by-Step",
      badgeCountUr: "آسان طریقے",
      actionEn: "Learn Steps",
      actionUr: "سیکھیں",
      stars: "+3",
      icon: "🕌",
      cardColor: Color(0xFFC2E8FF),
      badgeColor: Color(0xFFC2E8FF),
      textColor: Color(0xFF006689),
      actionIcon: Icons.accessibility_new,
      assetImagePath: "assets/images/islamic_namaz.png",
      arabic: "اللهُ أَكْبَرُ • سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ",
      transEn: "'Allah is the Greatest. Glory be to You, O Allah, and with Your praise.'",
      transUr: "اللہ سب سے بڑا ہے۔ پاک ہے تو اے اللہ اپنی تعریفوں کے ساتھ۔",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadInitialStars();
    _pipSpinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(currentLang == 'ur' ? "ur-PK" : "en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(currentLang == 'ur' ? "ur-PK" : "en-US");
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  Future<void> _loadInitialStars() async {
    int savedStars = await DatabaseHelper.instance.getTotalStars();
    setState(() {
      if (savedStars > 0) starsCount = 12 + savedStars;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _pipSpinController.dispose();
    audioTimer?.cancel();
    super.dispose();
  }

  void _showToast(String message, String icon) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
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

  void _playPipSpeech() {
    _pipSpinController.forward(from: 0.0);

    final List<String> pipQuotes = currentLang == 'en'
        ? [
            "Pip says: 'Bismillah brings barakah!' 🐤",
            "Tap any card to collect bright golden stars! ✨",
            "Pip is cheering for you, little champion! 🐤"
          ]
        : [
            "پپ کہتا ہے: ہر کام سے پہلے بسم اللہ پڑھیں! 🐤",
            "کوئی بھی کارڈ چنیں اور چمکتے ستارے جیتیں! ✨",
            "شاباش ننھے دوست! 🐤"
          ];

    final quote = (pipQuotes..shuffle()).first;
    _speak(quote);
    _showToast(quote, '🐤');
  }

  void _toggleLanguage() {
    setState(() {
      currentLang = currentLang == 'en' ? 'ur' : 'en';
    });
    _speak(currentLang == 'en' ? 'Switched to English' : 'زبان اردو ہو گئی');
    _showToast(
      currentLang == 'en' ? 'Language changed to English 🇬🇧' : 'زبان اردو میں تبدیل ہو گئی 🇵🇰',
      '🌐',
    );
  }

  void _openLessonModal(LessonData lesson) {
    bool isUr = currentLang == 'ur';
    setState(() {
      isPlayingAudio = false;
      audioProgress = 0.0;
      audioSeconds = 0;
    });
    audioTimer?.cancel();
    _speak(isUr ? lesson.titleUr : lesson.titleEn);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E2DD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: lesson.badgeColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(lesson.icon, style: const TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: lesson.badgeColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isUr ? lesson.badgeUr : lesson.badgeEn,
                                  style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: lesson.textColor),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isUr ? lesson.titleUr : lesson.titleEn,
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          audioTimer?.cancel();
                          flutterTts.stop();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Color(0xFF1B1C19)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          lesson.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006689),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isUr ? lesson.transUr : lesson.transEn,
                          textAlign: TextAlign.center,
                          textDirection: isUr ? TextDirection.rtl : TextDirection.ltr,
                          style: const TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3E484F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: audioProgress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFEAE8E2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF24BC6B)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0:0$audioSeconds', style: const TextStyle(fontSize: 11, color: Color(0xFF6E7980))),
                            const Text('0:08', style: TextStyle(fontSize: 11, color: Color(0xFF6E7980))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA1D),
                        foregroundColor: const Color(0xFF2A1800),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      onPressed: () {
                        setModalState(() {
                          if (isPlayingAudio) {
                            isPlayingAudio = false;
                            audioTimer?.cancel();
                            flutterTts.stop();
                          } else {
                            isPlayingAudio = true;
                            audioSeconds = 0;
                            audioProgress = 0.0;
                            _speak(lesson.arabic);
                            audioTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
                              setModalState(() {
                                audioSeconds++;
                                audioProgress = (audioSeconds / 8).clamp(0.0, 1.0);
                                if (audioSeconds >= 8) {
                                  audioTimer?.cancel();
                                  isPlayingAudio = false;
                                  setState(() {
                                    starsCount += 1;
                                  });
                                  DatabaseHelper.instance.saveProgress('Islamic Hub', 1, lesson.id);
                                  _showToast(
                                    isUr ? 'ماشاء اللہ! بہترین تلاوت۔ +1 ستارہ!' : 'MashaAllah! Beautiful recitation. +1 Star!',
                                    '⭐',
                                  );
                                }
                              });
                            });
                          }
                        });
                      },
                      icon: Icon(isPlayingAudio ? Icons.pause : Icons.play_arrow, size: 26),
                      label: Text(
                        isPlayingAudio
                            ? (isUr ? 'آواز جاری ہے...' : 'Playing Audio...')
                            : (isUr ? 'تلاوت سنیں' : 'Listen to Recitation'),
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF24BC6B),
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () async {
                        audioTimer?.cancel();
                        flutterTts.stop();
                        Navigator.pop(context);
                        setState(() {
                          starsCount += 2;
                        });
                        await DatabaseHelper.instance.saveProgress('Islamic Hub Complete', 2, lesson.id);
                        _showToast(
                          isUr ? '+۲ ستارے حاصل کیے! شاباش! ⭐' : '+2 Stars Earned! Keep shining! ⭐',
                          '🌟',
                        );
                      },
                      icon: const Text('⭐', style: TextStyle(fontSize: 16)),
                      label: Text(
                        isUr ? 'مکمل کریں (+۲ ستارے)' : 'Complete & Earn +2 Stars',
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUr = currentLang == 'ur';

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            children: [
              // Custom Top Header Perfectly Contained inside 450px MaxWidth
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: const [
                                  Text('Islamic Learning', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19))),
                                  Text(' 🌙', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                              Text(
                                isUr ? 'دعائیں، کلمے اور بہت کچھ!' : 'Learn Duas, Kalmas & More!',
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  '$starsCount',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2A1800)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFDBDAD4), width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: const Text('👦', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Main Body Content
              Expanded(
                child: Directionality(
                  textDirection: isUr ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Language Switcher Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE8E2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF006D39),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUr ? 'اسلامی لرننگ ہب' : 'Active Learning Hub',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: _toggleLanguage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                                ),
                                child: Row(
                                  children: [
                                    const Text('🌐', style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(
                                      isUr ? 'اردو ⇄ English' : 'English ⇄ اردو',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Pip's Guidance Card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Color(0x0F40352C), offset: Offset(0, 6), blurRadius: 16)],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDDB6),
                                      shape: BoxShape.circle,
                                      boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 3))],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('🐤', style: TextStyle(fontSize: 28)),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF24BC6B),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isUr ? 'پپ کی رہنمائی 🐤' : "Pip's Guidance 🐤",
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                                        ),
                                        InkWell(
                                          onTap: _playPipSpeech,
                                          child: RotationTransition(
                                            turns: Tween(begin: 0.0, end: 1.0).animate(_pipSpinController),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFAA1D),
                                                shape: BoxShape.circle,
                                                boxShadow: const [BoxShadow(color: Color(0xFF845400), offset: Offset(0, 3))],
                                              ),
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.volume_up, color: Color(0xFF2A1800), size: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUr ? 'نیچے دیے گئے کسی بھی کارڈ پر ٹیپ کریں، سنیں اور ستارے جیتیں! ✨' : 'Tap any card below to listen, learn and collect golden stars! ✨',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F), height: 1.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🌟', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 6),
                                Text(
                                  isUr ? 'اپنا سبق منتخب کریں' : 'Choose Your Lesson',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC2E8FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isUr ? '۴ اسباق' : '4 Adventures',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF003F57)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 2x2 Interactive Curriculum Cards Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return InkWell(
                              onTap: () => _openLessonModal(lesson),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 5))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: lesson.badgeColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            isUr ? lesson.badgeCountUr : lesson.badgeCountEn,
                                            style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: lesson.textColor),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFDDB6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              const Text('⭐', style: TextStyle(fontSize: 10)),
                                              const SizedBox(width: 2),
                                              Text(
                                                lesson.stars,
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.asset(
                                          lesson.assetImagePath,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: lesson.cardColor,
                                            alignment: Alignment.center,
                                            child: Text(lesson.icon, style: const TextStyle(fontSize: 40)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isUr ? lesson.titleUr : lesson.titleEn,
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: lesson.textColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isUr ? lesson.descUr : lesson.descEn,
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isUr ? lesson.actionUr : lesson.actionEn,
                                          style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: lesson.textColor),
                                        ),
                                        Container(
                                          width: 26,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: lesson.badgeColor,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(lesson.actionIcon, size: 16, color: lesson.textColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}