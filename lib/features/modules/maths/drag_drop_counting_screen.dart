import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const DragDropCountingApp());
}

class DragDropCountingApp extends StatelessWidget {
  const DragDropCountingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Adventure - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const DragDropCountingScreen(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_math.db');
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

class ChallengeData {
  final int target;
  final int poolSize;
  final String emoji;
  final String key;

  const ChallengeData({
    required this.target,
    required this.poolSize,
    required this.emoji,
    required this.key,
  });
}

class DragDropCountingScreen extends StatefulWidget {
  const DragDropCountingScreen({Key? key}) : super(key: key);

  @override
  State<DragDropCountingScreen> createState() => _DragDropCountingScreenState();
}

class _DragDropCountingScreenState extends State<DragDropCountingScreen> {
  String currentLang = 'en'; // 'en' or 'ur'
  String currentMode = 'PG'; // 'PG' or 'KG'
  int starsCount = 12;

  Map<String, int> challengeIndex = {'PG': 0, 'KG': 0};
  int currentCollected = 0;
  List<bool> itemStates = []; // Tracks which field items are collected

  late FlutterTts flutterTts;

  final Map<String, List<ChallengeData>> challenges = {
    'PG': [
      const ChallengeData(target: 4, poolSize: 8, emoji: '🍎', key: 'apple'),
      const ChallengeData(target: 3, poolSize: 7, emoji: '🎈', key: 'balloon'),
      const ChallengeData(target: 6, poolSize: 9, emoji: '🌸', key: 'flower'),
      const ChallengeData(target: 5, poolSize: 8, emoji: '🍓', key: 'strawberry'),
    ],
    'KG': [
      const ChallengeData(target: 14, poolSize: 18, emoji: '⭐', key: 'star'),
      const ChallengeData(target: 12, poolSize: 16, emoji: '💎', key: 'gem'),
      const ChallengeData(target: 15, poolSize: 19, emoji: '🍓', key: 'strawberry'),
      const ChallengeData(target: 11, poolSize: 15, emoji: '🍎', key: 'apple'),
    ],
  };

  final Map<String, Map<String, String>> itemNames = {
    'en': {
      'apple': 'Apples',
      'star': 'Golden Stars',
      'strawberry': 'Strawberries',
      'balloon': 'Balloons',
      'gem': 'Gems',
      'flower': 'Flowers',
    },
    'ur': {
      'apple': 'سیب',
      'star': 'سنہری ستارے',
      'strawberry': 'سٹرابیری',
      'balloon': 'غبارے',
      'gem': 'ہیرے',
      'flower': 'پھول',
    },
  };

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadInitialStars();
    _loadChallenge();
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
    super.dispose();
  }

  void _loadChallenge() {
    final list = challenges[currentMode]!;
    final index = challengeIndex[currentMode]! % list.length;
    final challenge = list[index];

    setState(() {
      currentCollected = 0;
      itemStates = List.filled(challenge.poolSize, false);
    });
  }

  ChallengeData get activeChallenge {
    final list = challenges[currentMode]!;
    final index = challengeIndex[currentMode]! % list.length;
    return list[index];
  }

  Future<void> _collectItem(int index) async {
    if (itemStates[index] || currentCollected >= activeChallenge.target) return;

    setState(() {
      itemStates[index] = true;
      currentCollected++;
    });
    _speak('$currentCollected');

    if (currentCollected == activeChallenge.target) {
      setState(() {
        starsCount += 1;
      });
      await DatabaseHelper.instance.saveProgress('Drag & Drop $currentMode', 1, activeChallenge.target);
      _speak(currentLang == 'ur' ? 'شاباش! آپ جیت گئے!' : 'Super Job! You Did It!');
      _showCelebrationDialog();
    }
  }

  void _resetGame() {
    _loadChallenge();
    _speak(currentLang == 'ur' ? 'دوبارہ شروع کریں' : 'Reset challenge');
  }

  void _nextChallenge() {
    setState(() {
      challengeIndex[currentMode] = challengeIndex[currentMode]! + 1;
      _loadChallenge();
    });
  }

  void _switchMode(String mode) {
    if (currentMode == mode) return;
    setState(() {
      currentMode = mode;
      _loadChallenge();
    });
    _speak(mode == 'PG' ? 'Play Group Mode' : 'Kindergarten Mode');
  }

  void _showCelebrationDialog() {
    bool isUr = currentLang == 'ur';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉 🌟 🍎', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              isUr ? 'شاباش! آپ جیت گئے!' : 'Super Job! You Did It!',
              style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isUr ? 'آپ نے سب گن لیا! +1 ستارہ مل گیا!' : 'Pip collected all items! +1 Star Earned!',
              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA1D),
                  foregroundColor: const Color(0xFF2A1800),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _nextChallenge();
                },
                child: Text(
                  isUr ? 'اگلا چیلنج' : 'Next Challenge',
                  style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUr = currentLang == 'ur';
    final challenge = activeChallenge;
    final itemName = itemNames[currentLang]?[challenge.key] ?? challenge.key;
    final instruction = isUr
        ? (currentMode == 'PG'
            ? 'ٹوکری میں ${challenge.target} $itemName ڈالیں!'
            : 'جادوئی صندوق میں ${challenge.target} $itemName جمع کریں!')
        : (currentMode == 'PG'
            ? 'Put ${challenge.target} $itemName in the Basket!'
            : 'Collect ${challenge.target} $itemName in the Magic Chest!');

    double progress = challenge.target > 0 ? (currentCollected / challenge.target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.9),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEE8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDDB6).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              '$starsCount',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2A1800)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text('🦊', style: TextStyle(fontSize: 18)),
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
        textDirection: isUr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Language Toggle Button
              Center(
                child: InkWell(
                  onTap: () {
                    setState(() => currentLang = isUr ? 'en' : 'ur');
                    _speak(isUr ? 'اردو زبان منتخب ہو گئی' : 'Switched to English');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE8E2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, color: Color(0xFF006689), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          isUr ? 'اردو ⇄ English' : 'English ⇄ اردو',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isUr ? 'گنتی اور ڈریگ کریں' : 'Drag & Drop Counting',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                            ),
                            const SizedBox(width: 6),
                            const Text('🍎📥', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isUr ? 'چیزیں گنیں اور ٹوکری میں ڈالیں!' : 'Count, Drag & Drop! Have fun with numbers!',
                          style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Mode Selector Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEE8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _switchMode('PG'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: currentMode == 'PG' ? const Color(0xFF006689) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('👶', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                isUr ? 'پلے گروپ (۱–۱۰)' : 'Play Group (1–10)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: currentMode == 'PG' ? Colors.white : const Color(0xFF3E484F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _switchMode('KG'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: currentMode == 'KG' ? const Color(0xFF845400) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🎒', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                isUr ? 'کنڈرگارٹن (۱۱–۲۰)' : 'Kindergarten (11–20)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: currentMode == 'KG' ? Colors.white : const Color(0xFF3E484F),
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
              const SizedBox(height: 12),

              // Pip's Mission Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDDB6),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🐤', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUr ? 'پِپ کا مشن 🐤' : "Pip's Mission 🐤",
                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                          ),
                          Text(
                            instruction,
                            style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _speak(instruction),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFAA1D),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.volume_up, color: Color(0xFF2A1800), size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Drop Zone / Basket Container (DragTarget)
              DragTarget<int>(
                onAccept: (int index) {
                  _collectItem(index);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty ? const Color(0xFFE2F6EA) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: candidateData.isNotEmpty ? const Color(0xFF24BC6B) : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 12)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: currentMode == 'PG' ? const Color(0xFFC2E8FF) : const Color(0xFFFFDDb6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                currentMode == 'PG' ? '👶 PG Mode' : '🎒 KG Mode',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF003F57)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE8E2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${isUr ? 'تعداد:' : 'Items:'} $currentCollected / ${challenge.target}',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFF0EEE8),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF24BC6B)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Basket Box
                        Container(
                          constraints: const BoxConstraints(minHeight: 130),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: currentCollected == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shopping_basket, size: 36, color: Color(0xFF6E7980)),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUr ? 'یہاں چیزیں ڈالیں!' : 'Drop items here!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
                                  ],
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                    currentCollected,
                                    (index) => Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 4)],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(challenge.emoji, style: const TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Draggable Nursery Grass Tray Zone
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 12)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.eco, color: Color(0xFF006D39), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              isUr ? 'میدان سے چنیں' : 'Pick from the Field',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                            ),
                          ],
                        ),
                        Text(
                          isUr ? 'چیز کو ڈریگ کریں!' : 'Drag items!',
                          style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      constraints: const BoxConstraints(minHeight: 130),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73FDA3).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: List.generate(challenge.poolSize, (index) {
                          bool isCollected = itemStates[index];
                          Widget itemWidget = Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 3))],
                            ),
                            alignment: Alignment.center,
                            child: Text(challenge.emoji, style: const TextStyle(fontSize: 22)),
                          );

                          if (isCollected) {
                            return Opacity(
                              opacity: 0.2,
                              child: itemWidget,
                            );
                          }

                          return LongPressDraggable<int>(
                            data: index,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                                ),
                                alignment: Alignment.center,
                                child: Text(challenge.emoji, style: const TextStyle(fontSize: 26)),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.2,
                              child: itemWidget,
                            ),
                            child: itemWidget,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Bottom Action Dock
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAE8E2),
                        foregroundColor: const Color(0xFF1B1C19),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {
                        for (int i = 0; i < itemStates.length; i++) {
                          if (!itemStates[i]) {
                            _collectItem(i);
                            break;
                          }
                        }
                      },
                      icon: const Icon(Icons.lightbulb, size: 18, color: Color(0xFF845400)),
                      label: Text(isUr ? 'اشارہ' : 'Hint', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAE8E2),
                        foregroundColor: const Color(0xFF1B1C19),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: _resetGame,
                      icon: const Icon(Icons.restart_alt, size: 18, color: Color(0xFFBA1A1A)),
                      label: Text(isUr ? 'دوبارہ' : 'Reset', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006689),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: _nextChallenge,
                      icon: const Icon(Icons.skip_next, size: 18),
                      label: Text(isUr ? 'اگلا' : 'Next', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Footer Note
              Text(
                isUr ? '♡ ۱۰۰٪ محفوظ • بچوں کے لیے مفت • ونڈر کڈز ریاضی' : '♡ 100% Safe • Ad-Free Kids Zone • WonderKids Math v2.4',
                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}