import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const MatchPuzzleApp());
}

class MatchPuzzleApp extends StatelessWidget {
  const MatchPuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Puzzle - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const MatchPuzzleScreen(),
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

class PuzzleItem {
  final String id;
  final int value;
  final String type; // 'pg' or 'kg'
  final List<String>? items;
  final String? itemEmoji;
  final int? count;
  final String countBadge;
  final String leftLabelEn;
  final String leftLabelUr;
  final String rightDisplay;
  final String wordEn;
  final String wordUr;

  const PuzzleItem({
    required this.id,
    required this.value,
    required this.type,
    this.items,
    this.itemEmoji,
    this.count,
    required this.countBadge,
    required this.leftLabelEn,
    required this.leftLabelUr,
    required this.rightDisplay,
    required this.wordEn,
    required this.wordUr,
  });
}

class MatchPuzzleScreen extends StatefulWidget {
  const MatchPuzzleScreen({Key? key}) : super(key: key);

  @override
  State<MatchPuzzleScreen> createState() => _MatchPuzzleScreenState();
}

class _MatchPuzzleScreenState extends State<MatchPuzzleScreen>
    with TickerProviderStateMixin {
  String currentMode = 'pg'; // 'pg' or 'kg'
  String currentLang = 'en'; // 'en' or 'ur'
  int starCount = 0;

  String? selectedLeftId;
  String? selectedRightId;
  List<String> matchedPairs = [];

  List<PuzzleItem> activeLevelData = [];
  List<PuzzleItem> randomizedRight = [];
  bool useAlt = false;

  late FlutterTts flutterTts;

  final Map<String, List<PuzzleItem>> datasets = {
    'pg': [
      const PuzzleItem(
        id: 'pg_1',
        value: 3,
        type: 'pg',
        items: ['🍎', '🍎', '🍎'],
        countBadge: '3',
        leftLabelEn: '3 Red Apples',
        leftLabelUr: '۳ سرخ سیب',
        rightDisplay: '3',
        wordEn: 'Three',
        wordUr: 'تین',
      ),
      const PuzzleItem(
        id: 'pg_2',
        value: 5,
        type: 'pg',
        items: ['⭐', '⭐', '⭐', '⭐', '⭐'],
        countBadge: '5',
        leftLabelEn: '5 Golden Stars',
        leftLabelUr: '۵ چمکتے ستارے',
        rightDisplay: '5',
        wordEn: 'Five',
        wordUr: 'پانچ',
      ),
      const PuzzleItem(
        id: 'pg_3',
        value: 2,
        type: 'pg',
        items: ['🎈', '🎈'],
        countBadge: '2',
        leftLabelEn: '2 Cheerful Balloons',
        leftLabelUr: '۲ غبارے',
        rightDisplay: '2',
        wordEn: 'Two',
        wordUr: 'دو',
      ),
      const PuzzleItem(
        id: 'pg_4',
        value: 4,
        type: 'pg',
        items: ['🐥', '🐥', '🐥', '🐥'],
        countBadge: '4',
        leftLabelEn: '4 Cute Ducklings',
        leftLabelUr: '۴ ننھی بطخیں',
        rightDisplay: '4',
        wordEn: 'Four',
        wordUr: 'چار',
      ),
    ],
    'kg': [
      const PuzzleItem(
        id: 'kg_1',
        value: 12,
        type: 'kg',
        itemEmoji: '🍓',
        count: 12,
        countBadge: '12',
        leftLabelEn: '12 Sweet Berries',
        leftLabelUr: '۱۲ میٹھی بیریاں',
        rightDisplay: '12',
        wordEn: 'Twelve',
        wordUr: 'بارہ',
      ),
      const PuzzleItem(
        id: 'kg_2',
        value: 15,
        type: 'kg',
        itemEmoji: '⭐',
        count: 15,
        countBadge: '15',
        leftLabelEn: '15 Shiny Stars',
        leftLabelUr: '۱۵ چمکدار ستارے',
        rightDisplay: '15',
        wordEn: 'Fifteen',
        wordUr: 'پندرہ',
      ),
      const PuzzleItem(
        id: 'kg_3',
        value: 18,
        type: 'kg',
        itemEmoji: '🌸',
        count: 18,
        countBadge: '18',
        leftLabelEn: '18 Spring Flowers',
        leftLabelUr: '۱۸ بہار کے پھول',
        rightDisplay: '18',
        wordEn: 'Eighteen',
        wordUr: 'اٹھارہ',
      ),
      const PuzzleItem(
        id: 'kg_4',
        value: 20,
        type: 'kg',
        itemEmoji: '🚀',
        count: 20,
        countBadge: '20',
        leftLabelEn: '20 Speedy Rockets',
        leftLabelUr: '۲۰ تیز راکٹ',
        rightDisplay: '20',
        wordEn: 'Twenty',
        wordUr: 'بیس',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadInitialStars();
    _loadRound(currentMode, false);
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
      starCount = savedStars;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _loadRound(String mode, bool alternate) {
    setState(() {
      currentMode = mode;
      selectedLeftId = null;
      selectedRightId = null;
      matchedPairs.clear();
      activeLevelData = List.from(datasets[mode]!);
      if (alternate) {
        activeLevelData.shuffle(Random());
      }
      randomizedRight = List.from(activeLevelData)..shuffle(Random());
    });
  }

  void _onLeftClick(PuzzleItem item) {
    if (matchedPairs.contains(item.id)) return;
    setState(() {
      selectedLeftId = item.id;
    });
    _speak(currentLang == 'ur' ? item.leftLabelUr : item.leftLabelEn);
    _checkMatch();
  }

  void _onRightClick(PuzzleItem item) {
    if (matchedPairs.contains(item.id)) return;
    setState(() {
      selectedRightId = item.id;
    });
    _speak(currentLang == 'ur' ? item.wordUr : item.wordEn);
    _checkMatch();
  }

  void _checkMatch() {
    if (selectedLeftId == null || selectedRightId == null) return;

    if (selectedLeftId == selectedRightId) {
      setState(() {
        matchedPairs.add(selectedLeftId!);
        selectedLeftId = null;
        selectedRightId = null;
      });
      _speak(currentLang == 'ur' ? 'بہت خوب!' : 'Correct!');

      if (matchedPairs.length == activeLevelData.length) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _showCompleteModal();
        });
      }
    } else {
      _speak(currentLang == 'ur' ? 'دوبارہ کوشش کریں' : 'Try again');
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            selectedLeftId = null;
            selectedRightId = null;
          });
        }
      });
    }
  }

  Future<void> _showCompleteModal() async {
    setState(() {
      starCount += 1;
    });
    await DatabaseHelper.instance.saveProgress('Match Puzzle $currentMode', 1, activeLevelData.length);
    
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFF73FDA3),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0xFF24BC6B), offset: Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: const Text('🌟', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 12),
            Text(
              currentLang == 'ur' ? 'شاباش! شاندار نتیجہ!' : 'Super Genius!',
              style: const TextStyle(fontFamily: 'Rubik', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
            ),
            const SizedBox(height: 4),
            Text(
              currentLang == 'ur' ? 'آپ نے تمام نمبر صحیح ملائے!' : 'You matched all pairs correctly!',
              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDDB6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  Text('⭐', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text('+1 Shiny Star Added!', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF2A1800))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA1D),
                  foregroundColor: const Color(0xFF2A1800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  setState(() {
                    useAlt = !useAlt;
                    _loadRound(currentMode, useAlt);
                  });
                },
                child: Text(
                  currentLang == 'ur' ? 'اگلا راؤنڈ کھیلیں! 🚀' : 'Play Next Round! 🚀',
                  style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 14),
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

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
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
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 22),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Match Puzzle 🧩',
                              style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                            ),
                            Text(
                              isUr ? 'گنتی اور جوڑیاں بنائیں!' : 'Group & Match Numbers!',
                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFFB958).withOpacity(0.6)),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$starCount',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF845400)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC2E8FF),
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
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() => currentLang = isUr ? 'en' : 'ur');
                          _speak(isUr ? 'اردو زبان منتخب ہو گئی' : 'Switched to English');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFEAE8E2)),
                            boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))],
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
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEE8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _loadRound('pg', false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: currentMode == 'pg' ? const Color(0xFF006689) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('👶', style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(
                                      isUr ? 'پلے گروپ (1-10)' : 'Play Group (1–10)',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: currentMode == 'pg' ? Colors.white : const Color(0xFF3E484F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _loadRound('kg', false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: currentMode == 'kg' ? const Color(0xFF006689) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('🎒', style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(
                                      isUr ? 'کے جی (11-20)' : 'Kindergarten (11–20)',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: currentMode == 'kg' ? Colors.white : const Color(0xFF3E484F),
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF0EEE8)),
                        boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 12)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🐥', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isUr ? 'پپ کا مشورہ' : "Pip's Clue",
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                ),
                                Text(
                                  isUr ? 'بائیں طرف سے تصویر چنیں اور صحیح نمبر سے ملائیں!' : 'Tap a picture group on the left, then tap its matching number!',
                                  style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => _speak(isUr ? 'بائیں طرف سے تصویر چنیں اور صحیح نمبر سے ملائیں۔' : 'Tap a picture group on the left, then tap its matching number!'),
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
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: activeLevelData.map((item) {
                              bool isMatched = matchedPairs.contains(item.id);
                              bool isSelected = selectedLeftId == item.id;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  onTap: () => _onLeftClick(item),
                                  child: Container(
                                    height: 96,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isMatched
                                          ? const Color(0xFF73FDA3).withOpacity(0.35)
                                          : isSelected
                                              ? const Color(0xFFC2E8FF).withOpacity(0.6)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isMatched
                                            ? const Color(0xFF24BC6B)
                                            : isSelected
                                                ? const Color(0xFF2BB0E6)
                                                : const Color(0xFFEAE8E2),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (item.type == 'pg') ...[
                                              Wrap(
                                                alignment: WrapAlignment.center,
                                                spacing: 4,
                                                children: item.items!.map((em) => Text(em, style: const TextStyle(fontSize: 20))).toList(),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(10)),
                                                    child: Text(item.countBadge, style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF006689))),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      isUr ? item.leftLabelUr : item.leftLabelEn,
                                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else ...[
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(10)),
                                                child: Text(
                                                  List.generate(item.count!, (_) => item.itemEmoji!).join(''),
                                                  style: const TextStyle(fontSize: 12),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                isUr ? item.leftLabelUr : item.leftLabelEn,
                                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                        if (isMatched)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.check, color: Colors.white, size: 14),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: randomizedRight.map((item) {
                              bool isMatched = matchedPairs.contains(item.id);
                              bool isSelected = selectedRightId == item.id;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  onTap: () => _onRightClick(item),
                                  child: Container(
                                    height: 96,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isMatched
                                          ? const Color(0xFF73FDA3).withOpacity(0.35)
                                          : isSelected
                                              ? const Color(0xFFFFDDB6).withOpacity(0.7)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isMatched
                                            ? const Color(0xFF24BC6B)
                                            : isSelected
                                                ? const Color(0xFFFFAA1D)
                                                : const Color(0xFFEAE8E2),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0EEE8),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                item.rightDisplay,
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              isUr ? '${item.rightDisplay} ${item.wordUr}' : '${item.rightDisplay} ${item.wordEn}',
                                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        if (isMatched)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.check, color: Colors.white, size: 14),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 12)],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFDDB6),
                                foregroundColor: const Color(0xFF845400),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {
                                PuzzleItem? unmatched = activeLevelData.firstWhere(
                                  (item) => !matchedPairs.contains(item.id),
                                  orElse: () => activeLevelData.first,
                                );
                                setState(() {
                                  selectedLeftId = unmatched.id;
                                  selectedRightId = unmatched.id;
                                });
                                _checkMatch();
                              },
                              icon: const Icon(Icons.lightbulb, size: 18),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {
                                setState(() {
                                  randomizedRight.shuffle(Random());
                                  selectedLeftId = null;
                                  selectedRightId = null;
                                });
                              },
                              icon: const Icon(Icons.shuffle, size: 18),
                              label: Text(isUr ? 'مکس' : 'Mix', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2BB0E6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () {
                                setState(() {
                                  useAlt = !useAlt;
                                  _loadRound(currentMode, useAlt);
                                });
                              },
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: Text(isUr ? 'اگلا' : 'Next', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
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