import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const ShortSurahsApp());
}

class ShortSurahsApp extends StatelessWidget {
  const ShortSurahsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Surahs - WonderKids Islamic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const ShortSurahsScreen(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_surahs.db');
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
      CREATE TABLE IF NOT EXISTS surahs_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_id INTEGER,
        stars_earned INTEGER
      )
    ''');
  }

  Future<int> saveProgress(int surahId, int stars) async {
    final db = await instance.database;
    return await db.insert('surahs_progress', {
      'surah_id': surahId,
      'stars_earned': stars,
    });
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM surahs_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return int.parse(result.first['total'].toString());
    }
    return 0;
  }
}

class SurahModel {
  final int id;
  final String titleEn;
  final String titleUr;
  final String subEn;
  final String subUr;
  final String versesTag;
  final String arabic;
  final String transEn;
  final String transUr;
  final int audioSeconds;
  final String audioTag;
  final int rewardStars;
  final String assetImagePath;
  final String stage; // 'pg' | 'kg'

  const SurahModel({
    required this.id,
    required this.titleEn,
    required this.titleUr,
    required this.subEn,
    required this.subUr,
    required this.versesTag,
    required this.arabic,
    required this.transEn,
    required this.transUr,
    required this.audioSeconds,
    required this.audioTag,
    required this.rewardStars,
    required this.assetImagePath,
    required this.stage,
  });
}

class ShortSurahsScreen extends StatefulWidget {
  const ShortSurahsScreen({Key? key}) : super(key: key);

  @override
  State<ShortSurahsScreen> createState() => _ShortSurahsScreenState();
}

class _ShortSurahsScreenState extends State<ShortSurahsScreen> {
  String currentStage = 'pg'; // 'pg' | 'kg'
  bool isUrduLanguage = false;
  int totalStars = 13;

  int? currentlyPlayingId;
  int currentAudioProgressMs = 0;
  Timer? audioTimer;

  final Set<int> completedSurahs = {};
  late FlutterTts flutterTts;

  // PG aur KG ki updated surahs list
  final List<SurahModel> surahsList = const [
    // --- PLAY GROUP (PG) ---
    SurahModel(
      id: 1,
      titleEn: 'Surah Al-Fatiha',
      titleUr: 'الفاتحة',
      subEn: 'The Opening',
      subUr: 'الفاتحة • آغاز',
      versesTag: '🌟 7 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ ۝ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ مَـٰلِكِ يَوْمِ ٱلدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ ۝ صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. All praise is due to Allah, Lord of the worlds..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ سب تعریفیں اللہ کے لیے ہیں..."',
      audioSeconds: 45,
      audioTag: 'Clear Qari Audio',
      rewardStars: 2,
      assetImagePath: 'assets/images/surah_icon_1.png',
      stage: 'pg',
    ),
    SurahModel(
      id: 2,
      titleEn: 'Surah Al-Ikhlas',
      titleUr: 'الإخلاص',
      subEn: 'Purity of Faith',
      subUr: 'الإخلاص • توحید',
      versesTag: '🌟 4 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ قُلْ هُوَ ٱللَّهُ أَحَدٌ ۝ ٱللَّهُ ٱلصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. Say, He is Allah, [who is] One..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ کہہ دیجیے کہ وہ اللہ ایک ہے۔"',
      audioSeconds: 30,
      audioTag: 'Kid-Friendly Speed',
      rewardStars: 1,
      assetImagePath: 'assets/images/surah_icon_2.png',
      stage: 'pg',
    ),
    SurahModel(
      id: 3,
      titleEn: 'Surah Al-Kawthar',
      titleUr: 'الكوثر',
      subEn: 'The Abundance',
      subUr: 'الكوثر • خیرِ کثیر',
      versesTag: '🌟 3 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ إِنَّآ أَعْطَيْنَـٰكَ ٱلْكَوْثَرَ ۝ فَصَلِّ لِرَبِّكَ وَٱنْحَرْ ۝ إِنَّ شَانِئَكَ هُوَ ٱلْأَبْتَرُ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. Indeed, We have granted you al-Kawthar..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ بے شک ہم نے آپ کو کوثر عطا فرمائی۔"',
      audioSeconds: 25,
      audioTag: 'Short & Sweet',
      rewardStars: 1,
      assetImagePath: 'assets/images/surah_icon_3.png',
      stage: 'pg',
    ),

    // --- KINDERGARTEN (KG) ---
    SurahModel(
      id: 4,
      titleEn: 'Surah Ar-Rahman',
      titleUr: 'الرحمن',
      subEn: 'The Most Merciful',
      subUr: 'الرحمن • رحمٰن',
      versesTag: '🌟 5 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ ٱلرَّحْمَـٰنُ ۝ عَلَّمَ ٱلْقُرْءَانَ ۝ خَلَقَ ٱلْإِنسَـٰنَ ۝ عَلَّمَهُ ٱلْبَيَانَ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. The Most Merciful. Taught the Quran..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ رحمٰن نے۔ قرآن سکھایا۔ انسان کو پیدا کیا۔"',
      audioSeconds: 40,
      audioTag: 'Peaceful Recitation',
      rewardStars: 2,
      assetImagePath: 'assets/images/surah_icon_1.png',
      stage: 'kg',
    ),
    SurahModel(
      id: 5,
      titleEn: 'Surah At-Tawbah',
      titleUr: 'التوبة',
      subEn: 'The Repentance',
      subUr: 'التوبة • توبہ',
      versesTag: '🌅 4 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ بَرَاءَةٌ مِّنَ ٱللَّهِ وَرَسُولِهِۥٓ إِلَى ٱلَّذِينَ عَاهَدتُّم مَّنَ ٱلْمُشْرِكِينَ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. [This is a declaration of] disassociation, from Allah and His Messenger..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ اللہ اور اس کے رسول کی طرف سے بیزاری ہے..."',
      audioSeconds: 35,
      audioTag: 'Reflection',
      rewardStars: 2,
      assetImagePath: 'assets/images/surah_icon_2.png',
      stage: 'kg',
    ),
    SurahModel(
      id: 6,
      titleEn: 'Surah Yusuf',
      titleUr: 'يوسف',
      subEn: 'Prophet Yusuf',
      subUr: 'يوسف • حضرت یوسف',
      versesTag: '⏳ 4 Verses',
      arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ۝ الر ۚ تِلْكَ ءَايَـٰتُ ٱلكِتَـٰبِ المُبِينِ ۝ إِنَّا أَنزَلْنَـٰهُ قُرْءَانًا عَرَبِيًّا لَّعَلَّكُمْ تَعْقِلُونَ ۝',
      transEn: '"In the name of Allah, the Most Gracious, the Most Merciful. Alif, Lam, Ra. These are the verses of the clear Book..."',
      transUr: '"شروع اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔ الف لام را۔ یہ روشن کتاب کی آیتیں ہیں۔"',
      audioSeconds: 38,
      audioTag: 'Story & Wisdom',
      rewardStars: 2,
      assetImagePath: 'assets/images/surah_icon_3.png',
      stage: 'kg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadInitialStars();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _loadInitialStars() async {
    int savedStars = await DatabaseHelper.instance.getTotalStars();
    setState(() {
      if (savedStars > 0) totalStars = 13 + savedStars;
    });
  }

  @override
  void dispose() {
    audioTimer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars, color: Color(0xFFFFAA1D), size: 22),
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
        backgroundColor: const Color(0xFF004D68),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2400),
      ),
    );
  }

  Future<void> _toggleAudioPlay(SurahModel surah) async {
    if (currentlyPlayingId == surah.id) {
      audioTimer?.cancel();
      await flutterTts.stop();
      setState(() {
        currentlyPlayingId = null;
        currentAudioProgressMs = 0;
      });
      return;
    }

    audioTimer?.cancel();
    await flutterTts.stop();
    await flutterTts.speak(surah.arabic);

    setState(() {
      currentlyPlayingId = surah.id;
      currentAudioProgressMs = 0;
    });

    final totalDurationMs = surah.audioSeconds * 1000;
    const intervalStep = 200;

    audioTimer = Timer.periodic(const Duration(milliseconds: intervalStep), (timer) {
      setState(() {
        currentAudioProgressMs += intervalStep;
        if (currentAudioProgressMs >= totalDurationMs) {
          timer.cancel();
          currentlyPlayingId = null;
          currentAudioProgressMs = 0;
          _showToast(
            isUrduLanguage
                ? 'ماشاء اللہ! تلاوت مکمل ہو گئی۔ ⭐'
                : 'MashaAllah! Recitation Completed! ⭐',
          );
        }
      });
    });
  }

  void _awardStars(SurahModel surah) async {
    if (completedSurahs.contains(surah.id)) {
      _showToast(
        isUrduLanguage ? 'آپ پہلے ہی اس سورت کے ستارے حاصل کر چکے ہیں!' : 'You already collected stars for this Surah!',
      );
      return;
    }

    setState(() {
      completedSurahs.add(surah.id);
      totalStars += surah.rewardStars;
    });

    await DatabaseHelper.instance.saveProgress(surah.id, surah.rewardStars);

    _showToast(
      isUrduLanguage
          ? 'ماشاءاللہ! ${surah.titleUr} کی تلاوت پر +${surah.rewardStars} ستارے ملے! ⭐'
          : 'MashaAllah! +${surah.rewardStars} ⭐ for reciting ${surah.titleEn}!',
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SurahModel> activeSurahs = surahsList.where((s) => s.stage == currentStage).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                flutterTts.stop();
                                Navigator.maybePop(context);
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.arrow_back, color: Color(0xFF004D68), size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isUrduLanguage ? 'چھوٹی سورتیں' : 'Short Surahs',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    isUrduLanguage ? 'تلاوت و حفظ' : 'Recitation & Audio',
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isUrduLanguage = !isUrduLanguage;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE8E2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'EN⇄UR',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2))],
                            ),
                            child: Text(
                              '⭐ $totalStars',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF2A1800)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: isUrduLanguage ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEE8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFDDB6),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.auto_stories, color: Color(0xFF845400), size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isUrduLanguage ? 'روزانہ قرآن کوئسٹ' : 'Daily Quran Quest',
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF004D68)),
                                      ),
                                      Text(
                                        isUrduLanguage ? 'مکمل سورتیں سنیں اور دوہرائیں!' : 'Tap, listen & repeat full Surahs!',
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE4E2DD)),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.military_tech, size: 16, color: Color(0xFF845400)),
                                    SizedBox(width: 4),
                                    Text('Level 1', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE8E2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentStage = 'pg';
                                      currentlyPlayingId = null;
                                      audioTimer?.cancel();
                                      flutterTts.stop();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentStage == 'pg' ? const Color(0xFF004D68) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: currentStage == 'pg'
                                          ? const [BoxShadow(color: Color(0xFF003348), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          isUrduLanguage ? '👶 پلے گروپ (PG)' : '👶 Play Group (PG)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: currentStage == 'pg' ? Colors.white : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                        Text(
                                          isUrduLanguage ? 'عمر ۳-۴ (۳ سورتیں)' : 'Ages 3-4 (3 Surahs)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: currentStage == 'pg' ? Colors.white.withOpacity(0.85) : const Color(0xFF40484D),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentStage = 'kg';
                                      currentlyPlayingId = null;
                                      audioTimer?.cancel();
                                      flutterTts.stop();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentStage == 'kg' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: currentStage == 'kg'
                                          ? const [BoxShadow(color: Color(0xFFD4880E), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          isUrduLanguage ? '🎒 کنڈرگارٹن (KG)' : '🎒 Kindergarten (KG)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: currentStage == 'kg' ? const Color(0xFF2A1800) : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                        Text(
                                          isUrduLanguage ? 'عمر ۴-۵ (۳ سورتیں)' : 'Ages 4-5 (3 Surahs)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: currentStage == 'kg' ? const Color(0xFF6A4300) : const Color(0xFF40484D),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeSurahs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final surah = activeSurahs[index];
                            bool isPlaying = currentlyPlayingId == surah.id;
                            bool isCompleted = completedSurahs.contains(surah.id);

                            double progressPercent = isPlaying
                                ? (currentAudioProgressMs / (surah.audioSeconds * 1000)).clamp(0.0, 1.0)
                                : 0.0;

                            int elapsedSec = isPlaying ? (currentAudioProgressMs ~/ 1000) : 0;

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: const Color(0xFFBFC8CE).withOpacity(0.3)),
                                boxShadow: const [BoxShadow(color: Color(0x12006689), offset: Offset(0, 8), blurRadius: 24)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: Image.asset(
                                              surah.assetImagePath,
                                              width: 52,
                                              height: 52,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: 52,
                                                height: 52,
                                                color: const Color(0xFFC2E8FF),
                                                alignment: Alignment.center,
                                                child: const Icon(Icons.mosque, color: Color(0xFF004D68)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                surah.titleEn,
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                              ),
                                              Text(
                                                isUrduLanguage ? surah.subUr : surah.subEn,
                                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFDDB6),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Text(
                                          surah.versesTag,
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                        ),
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
                                      border: Border.all(color: const Color(0xFFE4E2DD)),
                                    ),
                                    child: Text(
                                      surah.arabic,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B1C19),
                                        height: 2.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isUrduLanguage ? surah.transUr : surah.transEn,
                                    textAlign: isUrduLanguage ? TextAlign.right : TextAlign.left,
                                    textDirection: isUrduLanguage ? TextDirection.rtl : TextDirection.ltr,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF40484D), height: 1.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0EEE8),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.graphic_eq, size: 18, color: Color(0xFF004D68)),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '0:${elapsedSec < 10 ? '0' : ''}$elapsedSec / 0:${surah.audioSeconds}',
                                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              surah.audioTag,
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF005229)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: progressPercent,
                                            minHeight: 6,
                                            backgroundColor: const Color(0xFFE4E2DD),
                                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFAA1D)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 48,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isPlaying ? const Color(0xFF004D68) : const Color(0xFFEAE8E2),
                                              foregroundColor: isPlaying ? Colors.white : const Color(0xFF004D68),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                            ),
                                            onPressed: () => _toggleAudioPlay(surah),
                                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 22),
                                            label: Text(
                                              isPlaying
                                                  ? (isUrduLanguage ? 'روکیں' : 'Pause')
                                                  : (isUrduLanguage ? 'سنیں' : 'Listen'),
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SizedBox(
                                          height: 48,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isCompleted ? const Color(0xFF73FDA3) : const Color(0xFFFFAA1D),
                                              foregroundColor: isCompleted ? const Color(0xFF00210D) : const Color(0xFF2A1800),
                                              elevation: isCompleted ? 0 : 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                            ),
                                            onPressed: () => _awardStars(surah),
                                            icon: Icon(isCompleted ? Icons.check_circle : Icons.mic, size: 20),
                                            label: Text(
                                              isCompleted
                                                  ? (isUrduLanguage ? 'مکمل' : 'Completed')
                                                  : (isUrduLanguage ? 'پڑھیں +${surah.rewardStars} ⭐' : 'Recite +${surah.rewardStars} ⭐'),
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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