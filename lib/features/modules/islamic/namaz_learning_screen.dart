import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class NamazDatabaseHelper {
  static final NamazDatabaseHelper instance = NamazDatabaseHelper._init();
  static Database? _database;

  NamazDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_namaz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS namaz_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        step_id INTEGER,
        stars_earned INTEGER
      )
    ''');
  }

  Future<int> saveProgress(int stepId, int stars) async {
    final db = await instance.database;
    return await db.insert('namaz_progress', {'step_id': stepId, 'stars_earned': stars});
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM namaz_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return int.parse(result.first['total'].toString());
    }
    return 0;
  }
}

class NamazStepModel {
  final int id;
  final int num;
  final String titleEn;
  final String titleUr;
  final String arabicText;
  final String arabicSubtitle;
  final String meaningEn;
  final String meaningUr;
  final int rewardStars;
  final int durationSec;
  final String assetImagePath;
  final String stage; // 'pg' | 'kg'

  const NamazStepModel({
    required this.id,
    required this.num,
    required this.titleEn,
    required this.titleUr,
    required this.arabicText,
    required this.arabicSubtitle,
    required this.meaningEn,
    required this.meaningUr,
    required this.rewardStars,
    required this.durationSec,
    required this.assetImagePath,
    required this.stage,
  });
}

class NamazLearningScreen extends StatefulWidget {
  const NamazLearningScreen({Key? key}) : super(key: key);

  @override
  State<NamazLearningScreen> createState() => _NamazLearningScreenState();
}

class _NamazLearningScreenState extends State<NamazLearningScreen> {
  String currentStage = 'pg'; // 'pg' | 'kg'
  String displayLanguage = 'both'; // 'both' | 'en' | 'ur'
  int totalStars = 13;

  int? currentlyPlayingId;
  int currentAudioProgressMs = 0;
  Timer? audioTimer;

  final Set<int> completedSteps = {};

  final List<NamazStepModel> namazStepsList = const [
    // --- PLAY GROUP (PG: STEPS 1-3) ---
    NamazStepModel(
      id: 1,
      num: 1,
      titleEn: 'Niyat & Takbeer',
      titleUr: 'نیت اور تکبیر',
      arabicText: 'اَللّٰهُ أَكْبَرُ',
      arabicSubtitle: 'Allahu Akbar',
      meaningEn: 'Meaning: Allah is the Greatest. Make intention sincerely in your heart, stand peacefully facing Qibla, and raise both hands up to earlobes.',
      meaningUr: 'اللہ سب سے بڑا ہے۔ دل میں خلوص نیت کے ساتھ قبلہ رخ کھڑے ہو کر دونوں ہاتھ کانوں تک اٹھائیں اور تکبیر تحریمہ کہیں۔',
      rewardStars: 2,
      durationSec: 15,
      assetImagePath: 'assets/images/namaz_step_1.png',
      stage: 'pg',
    ),
    NamazStepModel(
      id: 2,
      num: 2,
      titleEn: 'Qiyam (Sana & Surah)',
      titleUr: 'قیام میں کھڑے ہونا (ثنا اور سورۃ)',
      arabicText: 'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلٰهَ غَيْرُكَ',
      arabicSubtitle: "SubhanakAllahumma wa bihamdika wa tabarakasmuka wa ta'ala jadduka wa la ilaha ghayruk",
      meaningEn: 'Meaning: Recite Sana first. Then recite Surah Al-Fatiha and a short Surah peacefully while standing.',
      meaningUr: 'پہلے ثنا پڑھیں۔ اس کے بعد سکون سے کھڑے ہو کر سورۃ الفاتحہ اور کوئی سورت تلاوت کریں۔',
      rewardStars: 2,
      durationSec: 35,
      assetImagePath: 'assets/images/namaz_step_2.png',
      stage: 'pg',
    ),
    NamazStepModel(
      id: 3,
      num: 3,
      titleEn: 'Ruku',
      titleUr: 'رکوع میں جھکنا',
      arabicText: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      arabicSubtitle: 'Subhana Rabbiyal Azeem (x3)',
      meaningEn: 'Meaning: Glory be to my Lord, the Most Magnificent. Bow respectfully keeping your back flat and level.',
      meaningUr: 'پاک ہے میرا رب جو بڑی عظمت والا ہے۔ گھٹنوں پر مضبوطی سے ہاتھ رکھ کر ادب کے ساتھ جھکیں۔',
      rewardStars: 1,
      durationSec: 20,
      assetImagePath: 'assets/images/namaz_step_3.png',
      stage: 'pg',
    ),

    // --- KINDERGARTEN (KG: STEPS 4-6) ---
    NamazStepModel(
      id: 4,
      num: 4,
      titleEn: 'Sajdah',
      titleUr: 'سجدہ کرنا',
      arabicText: 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
      arabicSubtitle: "Subhana Rabbiyal A'la (x3)",
      meaningEn: 'Meaning: Glory be to my Lord, the Most High. Prostrate with forehead, nose, palms and knees touching firmly.',
      meaningUr: 'پاک ہے میرا رب جو سب سے بلند و بالا ہے۔ پیشانی، ناک، ہتھیلیاں اور گھٹنے زمین پر رکھ کر سجدہ کریں۔',
      rewardStars: 2,
      durationSec: 25,
      assetImagePath: 'assets/images/namaz_step_4.png',
      stage: 'kg',
    ),
    NamazStepModel(
      id: 5,
      num: 5,
      titleEn: 'Qaadah & Tashahhud',
      titleUr: 'قاعدہ اور تشہد (التحیات)',
      arabicText: 'التَّحِيَّاتُ لِلّٰهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ...',
      arabicSubtitle: 'At-tahiyyatu lillahi was-salawatu wat-tayyibat...',
      meaningEn: 'Meaning: Sit upright calmly. Recite At-tahiyyat, and raise your right index finger when testifying Shahadah.',
      meaningUr: 'بائیں پاؤں پر اطمینان سے بیٹھیں، التحیات پڑھیں اور کلمہ شہادت پر انگلی اٹھائیں۔',
      rewardStars: 2,
      durationSec: 40,
      assetImagePath: 'assets/images/namaz_step_5.png',
      stage: 'kg',
    ),
    NamazStepModel(
      id: 6,
      num: 6,
      titleEn: 'Salam',
      titleUr: 'سلام پھیرنا',
      arabicText: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللّٰهِ',
      arabicSubtitle: 'Assalamu Alaikum wa Rahmatullah',
      meaningEn: 'Meaning: Peace and mercy of Allah be upon you. Turn your face to the right, then to the left shoulder.',
      meaningUr: 'پہلے دائیں اور پھر بائیں کندھے کی طرف چہرہ پھیر کر سلام کے ساتھ نماز مکمل کریں۔',
      rewardStars: 1,
      durationSec: 15,
      assetImagePath: 'assets/images/namaz_step_6.png',
      stage: 'kg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialStars();
  }

  Future<void> _loadInitialStars() async {
    int savedStars = await NamazDatabaseHelper.instance.getTotalStars();
    setState(() {
      if (savedStars > 0) totalStars = 13 + savedStars;
    });
  }

  @override
  void dispose() {
    audioTimer?.cancel();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF004D68),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _toggleAudioPlay(NamazStepModel step) {
    if (currentlyPlayingId == step.id) {
      audioTimer?.cancel();
      setState(() {
        currentlyPlayingId = null;
        currentAudioProgressMs = 0;
      });
      return;
    }

    audioTimer?.cancel();
    setState(() {
      currentlyPlayingId = step.id;
      currentAudioProgressMs = 0;
    });

    final totalDurationMs = step.durationSec * 1000;
    const intervalStep = 200;

    audioTimer = Timer.periodic(const Duration(milliseconds: intervalStep), (timer) {
      setState(() {
        currentAudioProgressMs += intervalStep;
        if (currentAudioProgressMs >= totalDurationMs) {
          timer.cancel();
          currentlyPlayingId = null;
          currentAudioProgressMs = 0;
        }
      });
    });
  }

  Future<void> _reciteEarnReward(NamazStepModel step) async {
    if (completedSteps.contains(step.id)) {
      _showToast('You already collected stars for this step!');
      return;
    }

    setState(() {
      completedSteps.add(step.id);
      totalStars += step.rewardStars;
    });

    await NamazDatabaseHelper.instance.saveProgress(step.id, step.rewardStars);
    _showToast('MashaAllah! +${step.rewardStars} ⭐ Earned for ${step.titleEn}!');
  }

  @override
  Widget build(BuildContext context) {
    List<NamazStepModel> activeSteps = namazStepsList.where((s) => s.stage == currentStage).toList();

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
                              onTap: () => Navigator.maybePop(context),
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
                                  const Text(
                                    'Namaz Learning',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    displayLanguage == 'ur' ? 'نماز کی مشق' : 'Step-by-Step Guide',
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
                                if (displayLanguage == 'both') {
                                  displayLanguage = 'en';
                                } else if (displayLanguage == 'en') {
                                  displayLanguage = 'ur';
                                } else {
                                  displayLanguage = 'both';
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE8E2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                displayLanguage.toUpperCase(),
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEE8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(color: Color(0xFFFFDDB6), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const Icon(Icons.mosque, color: Color(0xFF845400), size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Daily Namaz Adventure',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF004D68)),
                                  ),
                                  Text(
                                    'Learn every posture step-by-step!',
                                    style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stage Selector Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() { currentStage = 'pg'; currentlyPlayingId = null; }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: currentStage == 'pg' ? const Color(0xFF004D68) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '👶 Play Group (1-3)',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: currentStage == 'pg' ? Colors.white : const Color(0xFF1B1C19)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() { currentStage = 'kg'; currentlyPlayingId = null; }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: currentStage == 'kg' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '🎒 Kindergarten (4-6)',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: currentStage == 'kg' ? const Color(0xFF2A1800) : const Color(0xFF1B1C19)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of Steps
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeSteps.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final step = activeSteps[index];
                          bool isPlaying = currentlyPlayingId == step.id;
                          bool isCompleted = completedSteps.contains(step.id);
                          double progressPercent = isPlaying ? (currentAudioProgressMs / (step.durationSec * 1000)).clamp(0.0, 1.0) : 0.0;
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
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF004D68),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${step.num}',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              step.titleEn,
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                            ),
                                            Text(
                                              step.titleUr,
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
                                        '+${step.rewardStars} ⭐',
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // 3D Cartoon Illustration Image on Top of Arabic Box
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      step.assetImagePath,
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 130,
                                        width: 130,
                                        color: const Color(0xFFC2E8FF),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.accessibility_new, size: 50, color: Color(0xFF004D68)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3EE),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE4E2DD)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        step.arabicText,
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B1C19),
                                          height: 1.8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        step.arabicSubtitle,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (displayLanguage == 'both' || displayLanguage == 'en') ...[
                                  Text(
                                    step.meaningEn,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF40484D), height: 1.4),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                                if (displayLanguage == 'both' || displayLanguage == 'ur') ...[
                                  Text(
                                    step.meaningUr,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF40484D), height: 1.4),
                                  ),
                                ],
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
                                                '0:${elapsedSec < 10 ? '0' : ''}$elapsedSec / 0:${step.durationSec}',
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            'Step Guide Audio',
                                            style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF005229)),
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
                                          onPressed: () => _toggleAudioPlay(step),
                                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 22),
                                          label: Text(
                                            isPlaying ? 'Pause' : 'Listen',
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
                                          onPressed: () => _reciteEarnReward(step),
                                          icon: Icon(isCompleted ? Icons.check_circle : Icons.stars, size: 20),
                                          label: Text(
                                            isCompleted ? 'Completed' : 'Recite +${step.rewardStars} ⭐',
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
            ],
          ),
        ),
      ),
    );
  }
}