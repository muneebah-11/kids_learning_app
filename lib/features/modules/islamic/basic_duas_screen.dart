import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const BasicDuasApp());
}

class BasicDuasApp extends StatelessWidget {
  const BasicDuasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Duas - WonderKids Islamic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const BasicDuasScreen(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_duas.db');
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
      CREATE TABLE IF NOT EXISTS duas_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dua_id TEXT,
        stars_earned INTEGER
      )
    ''');
  }

  Future<int> saveProgress(String duaId, int stars) async {
    final db = await instance.database;
    return await db.insert('duas_progress', {
      'dua_id': duaId,
      'stars_earned': stars,
    });
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM duas_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return int.parse(result.first['total'].toString());
    }
    return 0;
  }
}

class DuaModel {
  final String id;
  final String titleEn;
  final String titleUr;
  final String categoryEn;
  final String categoryUr;
  final String arabic;
  final String translationEn;
  final String translationUr;
  final String instructionEn;
  final String instructionUr;
  final String imagePath;

  const DuaModel({
    required this.id,
    required this.titleEn,
    required this.titleUr,
    required this.categoryEn,
    required this.categoryUr,
    required this.arabic,
    required this.translationEn,
    required this.translationUr,
    required this.instructionEn,
    required this.instructionUr,
    required this.imagePath,
  });
}

class BasicDuasScreen extends StatefulWidget {
  const BasicDuasScreen({Key? key}) : super(key: key);

  @override
  State<BasicDuasScreen> createState() => _BasicDuasScreenState();
}

class _BasicDuasScreenState extends State<BasicDuasScreen> {
  String currentGrade = 'pg'; // 'pg' | 'kg'
  String currentLang = 'en'; // 'en' | 'ur'
  int totalStars = 13;

  String? currentlyPlayingId;
  double audioProgress = 0.0;
  Timer? audioTimer;

  final Set<String> claimedRewards = {};
  late AudioPlayer audioPlayer;

  final List<DuaModel> pgDuas = const [
    DuaModel(
      id: 'pg_1',
      titleEn: '1. Before Eating',
      titleUr: '۱۔ کھانا شروع کرنے کی دعا',
      categoryEn: 'Dining Etiquette',
      categoryUr: 'کھانے کے آداب',
      arabic: 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
      translationEn: 'In the name of Allah and upon the blessings of Allah.',
      translationUr: 'اللہ کے نام کے ساتھ اور اللہ کی برکت پر۔',
      instructionEn: 'Say this with your right hand before enjoying your yummy meal!',
      instructionUr: 'مزے دار کھانا شروع کرنے سے پہلے دائیں ہاتھ سے یہ دعا پڑھیں',
      imagePath: 'assets/images/pg_eating.png',
    ),
    DuaModel(
      id: 'pg_2',
      titleEn: '2. Drinking Water',
      titleUr: '۲۔ پانی پینے کے بعد کی دعا',
      categoryEn: 'Hydration Sunnah',
      categoryUr: 'پانی پینے کی سنت',
      arabic: 'الْحَمْدُ لِلَّهِ',
      translationEn: 'All praise is due to Allah.',
      translationUr: 'تمام تعریفیں اللہ ہی کے لیے ہیں۔',
      instructionEn: 'Sit down, take 3 small sips, then say Alhamdulillah happily!',
      instructionUr: 'بیٹھ کر تین گھونٹ میں پانی پیئں اور پھر خوشی سے الحمد للہ کہیں۔',
      imagePath: 'assets/images/pg_water.png',
    ),
    DuaModel(
      id: 'pg_3',
      titleEn: '3. Drinking Milk',
      titleUr: '۳۔ دودھ پینے کی دعا',
      categoryEn: 'Healthy Toddler',
      categoryUr: 'صحت مند غذا',
      arabic: 'اللَّهُمَّ بَارِكْ لَنَا فِيهِ وَزِدْنَا مِنْهُ',
      translationEn: 'O Allah, bless it for us and increase it for us.',
      translationUr: 'اے اللہ! ہمارے لیے اس میں برکت دے اور اس سے زیادہ عطا فرما۔',
      instructionEn: 'Milk gives you strong bones! Recite this for strength.',
      instructionUr: 'دودھ پینے سے طاقت ملتی ہے، برکت کے لیے یہ دعا پڑھیں۔',
      imagePath: 'assets/images/pg_milk.png',
    ),
    DuaModel(
      id: 'pg_4',
      titleEn: '4. Before Sleeping',
      titleUr: '۴۔ سوتے وقت کی دعا',
      categoryEn: 'Bedtime Peace',
      categoryUr: 'سونے کی دعا',
      arabic: 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
      translationEn: 'O Allah, in Your name I die and live.',
      translationUr: 'اے اللہ! تیرے نام کے ساتھ ہی میں مرتا اور جیتا ہوں۔',
      instructionEn: 'Snuggle into your cozy bed and ask Allah for sweet dreams.',
      instructionUr: 'اپنے نرم بستر میں لیٹ کر پیارے خوابوں کے لیے دعا مانگیں۔',
      imagePath: 'assets/images/pg_sleeping.png',
    ),
    DuaModel(
      id: 'pg_5',
      titleEn: '5. Climbing Stairs',
      titleUr: '۵۔ سیڑھیاں چڑھنے اور اترنے کی دعا',
      categoryEn: 'Daily Movement',
      categoryUr: 'روزمرہ کی حرکات',
      arabic: 'سُبْحَانَ اللَّهِ / وَاللَّهُ أَكْبَرُ',
      translationEn: 'Say Allahu Akbar when going up, and SubhanAllah when coming down.',
      translationUr: 'چڑھتے وقت اللہ اکبر اور اترتے وقت سبحان اللہ کہیں۔',
      instructionEn: 'Climb safely holding the handrail while remembering Allah!',
      instructionUr: 'سیڑھیاں چڑھتے اور اترتے ہوئے اللہ کو یاد رکھیں۔',
      imagePath: 'assets/images/pg_stairs.png',
    ),
  ];

  final List<DuaModel> kgDuas = const [
    DuaModel(
      id: 'kg_1',
      titleEn: '1. After Eating',
      titleUr: '۱۔ کھانے کے بعد کی دعا',
      categoryEn: 'Gratitude',
      categoryUr: 'شکر گزاری',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      translationEn: 'All praise is for Allah who gave us food and drink and made us Muslims.',
      translationUr: 'تمام تعریفیں اللہ کے لیے جس نے ہمیں کھلایا، پلایا اور مسلمان بنایا۔',
      instructionEn: 'Wipe your gentle hands and thank Allah for today\'s yummy feast!',
      instructionUr: 'کھانے کے بعد اللہ کا شکر ادا کریں کہ اس نے ہمیں رزق دیا۔',
      imagePath: 'assets/images/kg_after_eating.png',
    ),
    DuaModel(
      id: 'kg_2',
      titleEn: '2. Eating Fresh Fruits',
      titleUr: '۲۔ پھل کھانے کی دعا',
      categoryEn: 'Sunnah Snack',
      categoryUr: 'پھل کھانے کی سنت',
      arabic: 'اللَّهُمَّ بَارِكْ لَنَا فِي ثَمَرِنَا',
      translationEn: 'O Allah, bless us in our fruits.',
      translationUr: 'اے اللہ! ہمارے پھلوں میں برکت عطا فرما۔',
      instructionEn: 'When tasting apples, dates, or bananas, pray for sweet blessings.',
      instructionUr: 'کوئی بھی تازہ اور لذیذ پھل کھاتے وقت یہ پیاری دعا مانگیں۔',
      imagePath: 'assets/images/kg_fruits.png',
    ),
    DuaModel(
      id: 'kg_3',
      titleEn: '3. Looking in Mirror',
      titleUr: '۳۔ آئینہ دیکھنے کی دعا',
      categoryEn: 'Character & Manners',
      categoryUr: 'خوبصورت اخلاق',
      arabic: 'اللَّهُمَّ كَمَا حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي',
      translationEn: 'O Allah, just as You made my appearance good, make my character good.',
      translationUr: 'اے اللہ! جیسا تو نے میری صورت کو اچھا بنایا، ویسے ہی میرے اخلاق کو بھی اچھا بنا دے۔',
      instructionEn: 'Smile at your reflection and ask Allah for beautiful manners.',
      instructionUr: 'آئینے میں مسکراتے ہوئے اچھے اور پیارے اخلاق کی دعا کریں۔',
      imagePath: 'assets/images/kg_mirror.png',
    ),
    DuaModel(
      id: 'kg_4',
      titleEn: '4. Safe Journey',
      titleUr: '۴۔ سفر کی دعا',
      categoryEn: 'Travel Protection',
      categoryUr: 'سفر کی حفاظت',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
      translationEn: 'Glory unto Him who has subjected this unto us, and we were not able to subdue it.',
      translationUr: 'پاک ہے وہ ذات جس نے اس کو ہمارے تابع کر دیا۔',
      instructionEn: 'Buckle up in the car or bus, and recite together for a safe trip!',
      instructionUr: 'گاڑی میں بیٹھتے وقت حفاظتی بیلٹ باندھیں اور یہ دعا پڑھیں۔',
      imagePath: 'assets/images/kg_journey.png',
    ),
    DuaModel(
      id: 'kg_5',
      titleEn: '5. Leaving Home',
      titleUr: '۵۔ گھر سے نکلتے وقت کی دعا',
      categoryEn: 'Daily Protection',
      categoryUr: 'گھر سے روانگی',
      arabic: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      translationEn: 'In the name of Allah, I place my trust in Allah, there is no might nor power except with Allah.',
      translationUr: 'اللہ کے نام کے ساتھ، میں نے اللہ پر بھروسہ کیا، گناہوں سے بچنے اور نیکی کرنے کی طاقت صرف اللہ سے ہے۔',
      instructionEn: 'Step out with your right foot and put your full trust in Allah.',
      instructionUr: 'دایاں پاؤں باہر رکھتے ہوئے اللہ پر بھروسہ کر کے نکلیں۔',
      imagePath: 'assets/images/kg_leaving_home.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _loadInitialStars();
  }

  Future<void> _loadInitialStars() async {
    int savedStars = await DatabaseHelper.instance.getTotalStars();
    setState(() {
      if (savedStars > 0) totalStars = 13 + savedStars;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioTimer?.cancel();
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
                style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF30312D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2400),
      ),
    );
  }

  void _toggleAudioPlay(DuaModel dua) async {
    if (currentlyPlayingId == dua.id) {
      audioTimer?.cancel();
      await audioPlayer.stop();
      setState(() {
        currentlyPlayingId = null;
        audioProgress = 0.0;
      });
      return;
    }

    audioTimer?.cancel();
    await audioPlayer.stop();
    setState(() {
      currentlyPlayingId = dua.id;
      audioProgress = 0.0;
    });

    try {
      // آف لائن لوکل آڈیو پلے کرنے کا طریقہ (مثلاً assets/audio/pg_1.mp3)
      await audioPlayer.play(AssetSource('audio/${dua.id}.mp3'));
    } catch (e) {
      print("Audio playback error: $e");
    }

    int ticks = 0;
    const totalTicks = 40; 
    audioTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      ticks++;
      setState(() {
        audioProgress = (ticks / totalTicks).clamp(0.0, 1.0);
      });

      if (ticks >= totalTicks) {
        timer.cancel();
        setState(() {
          currentlyPlayingId = null;
          audioProgress = 0.0;
        });
      }
    });
  }

  Future<void> _claimReward(DuaModel dua) async {
    if (claimedRewards.contains(dua.id)) return;

    setState(() {
      claimedRewards.add(dua.id);
      totalStars += 1;
    });

    await DatabaseHelper.instance.saveProgress(dua.id, 1);

    bool isUr = currentLang == 'ur';
    _showToast(
      isUr
          ? 'ماشاءاللہ! مبارک ہو، +1 سنہرا ستارہ حاصل کیا! ⭐'
          : 'MashaAllah! +1 Golden Star earned! ✨',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUr = currentLang == 'ur';
    List<DuaModel> activeList = currentGrade == 'pg' ? pgDuas : kgDuas;

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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.maybePop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0EEE8),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Dua Learning Session',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                              ),
                              Text(
                                isUr ? 'مسنون دعائیں (روزمرہ کی)' : 'Basic Duas',
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDDB6),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2))],
                        ),
                        child: Text(
                          '⭐ $totalStars',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2A1800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: isUr ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                      color: Color(0xFF24BC6B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    currentGrade == 'pg'
                                        ? (isUr ? 'پلے گروپ (پی جی)' : 'Play Group (PG)')
                                        : (isUr ? 'کنڈرگارٹن (کے جی)' : 'Kindergarten (KG)'),
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  currentLang = currentLang == 'en' ? 'ur' : 'en';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 2))],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.translate, size: 16, color: Color(0xFF006689)),
                                    const SizedBox(width: 4),
                                    Text(
                                      isUr ? '🌐 اردو ⇄ English' : '🌐 English ⇄ اردو',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 10)],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFDDB6),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 3))],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.cruelty_free, color: Color(0xFF2A1800), size: 28),
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
                                          isUr ? 'پپ الو دوست' : 'Pip the Owl',
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF73FDA3),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            isUr ? 'سنت کا ساتھی' : 'Sunnah Friend',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF00210D)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUr
                                          ? 'دعا کی تلاوت سننے کے لیے سنیں دبائیں، اور ستارے جمع کرنے کے لیے پڑھیں اور کمائیں پر ٹیپ کریں!'
                                          : 'Tap Listen to hear the soothing melody, or tap Recite & Earn to collect golden stars!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
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
                                      currentGrade = 'pg';
                                      currentlyPlayingId = null;
                                      audioTimer?.cancel();
                                      audioPlayer.stop();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentGrade == 'pg' ? const Color(0xFF006689) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: currentGrade == 'pg'
                                          ? const [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          isUr ? '👶 پلے گروپ' : '👶 Play Group',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: currentGrade == 'pg' ? Colors.white : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                        Text(
                                          isUr ? '۵ بنیادی دعائیں' : '5 Foundations',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: currentGrade == 'pg' ? Colors.white.withOpacity(0.9) : const Color(0xFF6E7980),
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
                                      currentGrade = 'kg';
                                      currentlyPlayingId = null;
                                      audioTimer?.cancel();
                                      audioPlayer.stop();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentGrade == 'kg' ? const Color(0xFF006689) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: currentGrade == 'kg'
                                          ? const [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          isUr ? '🎒 کنڈرگارٹن' : '🎒 Kindergarten',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: currentGrade == 'kg' ? Colors.white : const Color(0xFF1B1C19),
                                          ),
                                        ),
                                        Text(
                                          isUr ? '۵ مشقی دعائیں' : '5 Practice Duas',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: currentGrade == 'kg' ? Colors.white.withOpacity(0.9) : const Color(0xFF6E7980),
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
                          itemCount: activeList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final dua = activeList[index];
                            bool isClaimed = claimedRewards.contains(dua.id);
                            bool isPlaying = currentlyPlayingId == dua.id;

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 6))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC2E8FF),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isUr ? dua.categoryUr : dua.categoryEn,
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF001E2C)),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isClaimed ? const Color(0xFF73FDA3) : const Color(0xFFF0EEE8),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isClaimed ? Icons.check_circle : Icons.star,
                                              size: 14,
                                              color: isClaimed ? const Color(0xFF00210D) : const Color(0xFFFFAA1D),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isClaimed ? (isUr ? 'مکمل' : 'Completed') : '+1 Star',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isClaimed ? const Color(0xFF00210D) : const Color(0xFF3E484F),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        // لوکل ایسٹ سے آف لائن تصویر شو کرنے کے لیے Image.asset
                                        Image.asset(
                                          dua.imagePath,
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 160,
                                            color: const Color(0xFFC2E8FF),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.mosque, size: 50, color: Color(0xFF006689)),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 12,
                                          right: 12,
                                          child: Text(
                                            isUr ? dua.titleUr : dua.titleEn,
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3EE),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      dua.arabic,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF006689),
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isUr ? dua.translationUr : dua.translationEn,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '💡 ${isUr ? dua.instructionUr : dua.instructionEn}',
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF3E484F)),
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: isPlaying ? audioProgress : 0.0,
                                      minHeight: 6,
                                      backgroundColor: const Color(0xFFEAE8E2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF24BC6B)),
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
                                              backgroundColor: isPlaying ? const Color(0xFF006689) : const Color(0xFFC2E8FF),
                                              foregroundColor: isPlaying ? Colors.white : const Color(0xFF001E2C),
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                            ),
                                            onPressed: () => _toggleAudioPlay(dua),
                                            icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 22),
                                            label: Text(
                                              isPlaying
                                                  ? (isUr ? 'جاری ہے...' : 'Playing...')
                                                  : (isUr ? 'سنیں' : 'Listen'),
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 48,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isClaimed ? const Color(0xFFE4E2DD) : const Color(0xFFFFAA1D),
                                              foregroundColor: isClaimed ? const Color(0xFF6E7980) : const Color(0xFF2A1800),
                                              elevation: isClaimed ? 0 : 2,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                            ),
                                            onPressed: isClaimed ? null : () => _claimReward(dua),
                                            icon: Icon(Icons.stars, size: 22, color: isClaimed ? const Color(0xFF6E7980) : const Color(0xFF2A1800)),
                                            label: Text(
                                              isClaimed
                                                  ? (isUr ? 'حاصل شدہ' : 'Earned')
                                                  : (isUr ? 'پڑھیں اور کمائیں' : 'Recite & Earn'),
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