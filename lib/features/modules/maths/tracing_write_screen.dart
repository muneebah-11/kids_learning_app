import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const TracingWriteApp());
}

class TracingWriteApp extends StatelessWidget {
  const TracingWriteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracing & Write - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const TracingWriteScreen(),
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
    final path = join(dbPath, filePath);

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

class NumberMeta {
  final String en;
  final String ur;
  final String item;
  final int count;

  const NumberMeta({
    required this.en,
    required this.ur,
    required this.item,
    required this.count,
  });
}

class TracingWriteScreen extends StatefulWidget {
  const TracingWriteScreen({Key? key}) : super(key: key);

  @override
  State<TracingWriteScreen> createState() => _TracingWriteScreenState();
}

class _TracingWriteScreenState extends State<TracingWriteScreen>
    with TickerProviderStateMixin {
  String currentLevel = 'PG'; 
  String currentViewMode = 'dotted'; 
  int currentNumber = 1;
  String currentLanguage = 'en'; 
  Color strokeColor = const Color(0xFF2BB0E6);
  bool hintGuideActive = false;
  int starCount = 0;

  late FlutterTts flutterTts;

  final List<List<Offset>> _tracingStrokes = [];
  List<Offset>? _currentTracingStroke;

  final List<List<Offset>> _freehandStrokes = [];
  List<Offset>? _currentFreehandStroke;

  String? toastMessage;
  bool showToastFlag = false;

  final Map<int, NumberMeta> numData = {
    1: const NumberMeta(en: 'One', ur: 'ایک', item: '🍎', count: 1),
    2: const NumberMeta(en: 'Two', ur: 'دو', item: '🐥', count: 2),
    3: const NumberMeta(en: 'Three', ur: 'تین', item: '⭐', count: 3),
    4: const NumberMeta(en: 'Four', ur: 'چار', item: '🎈', count: 4),
    5: const NumberMeta(en: 'Five', ur: 'پانچ', item: '🚗', count: 5),
    6: const NumberMeta(en: 'Six', ur: 'چھ', item: '🌸', count: 6),
    7: const NumberMeta(en: 'Seven', ur: 'سات', item: '🍓', count: 7),
    8: const NumberMeta(en: 'Eight', ur: 'آٹھ', item: '🐸', count: 8),
    9: const NumberMeta(en: 'Nine', ur: 'نو', item: '🍬', count: 9),
    10: const NumberMeta(en: 'Ten', ur: 'دس', item: '🚀', count: 10),
    11: const NumberMeta(en: 'Eleven', ur: 'گیارہ', item: '🌟', count: 11),
    12: const NumberMeta(en: 'Twelve', ur: 'بارہ', item: '🧸', count: 12),
    13: const NumberMeta(en: 'Thirteen', ur: 'تیرہ', item: '🌼', count: 13),
    14: const NumberMeta(en: 'Fourteen', ur: 'چودہ', item: '🍩', count: 14),
    15: const NumberMeta(en: 'Fifteen', ur: 'پندرہ', item: '⚽', count: 15),
    16: const NumberMeta(en: 'Sixteen', ur: 'سولہ', item: '🥑', count: 16),
    17: const NumberMeta(en: 'Seventeen', ur: 'سترہ', item: '🎨', count: 17),
    18: const NumberMeta(en: 'Eighteen', ur: 'اٹھارہ', item: '🧩', count: 18),
    19: const NumberMeta(en: 'Nineteen', ur: 'انیس', item: '🍭', count: 19),
    20: const NumberMeta(en: 'Twenty', ur: 'بیس', item: '🏆', count: 20),
  };

  @override
  void initState() {
    super.initState();
    _loadInitialStars();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(currentLanguage == 'ur' ? "ur-PK" : "en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(currentLanguage == 'ur' ? "ur-PK" : "en-US");
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

  void _showToast(String message) {
    setState(() {
      toastMessage = message;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          showToastFlag = false;
        });
      }
    });
  }

  void _selectLevel(String level) {
    setState(() {
      currentLevel = level;
      if (level == 'PG') {
        currentViewMode = 'dotted';
        if (currentNumber > 10 || currentNumber < 1) {
          currentNumber = 1;
        }
      } else {
        if (currentNumber <= 10) {
          currentNumber = 11;
        }
      }
      _clearCanvas();
    });
    String msg = level == 'PG' ? 'Play Group (1-10)' : 'KG Mode (1-20)';
    _speak(msg);
    _showToast(msg);
  }

  void _selectKGSubMode(String subMode) {
    if (currentLevel != 'KG') return;
    setState(() {
      currentViewMode = subMode;
      _clearCanvas();
    });
  }

  void _clearCanvas() {
    setState(() {
      _tracingStrokes.clear();
      _freehandStrokes.clear();
    });
  }

  void _stepNumber(int delta) {
    int max = currentLevel == 'PG' ? 10 : 20;
    int min = 1;
    int next = currentNumber + delta;
    if (next > max) next = min;
    if (next < min) next = max;

    setState(() {
      currentNumber = next;
      _clearCanvas();
    });
    NumberMeta data = numData[currentNumber]!;
    _speak(currentLanguage == 'ur' ? data.ur : data.en);
  }

  Future<void> _earnStarAndSave() async {
    setState(() {
      starCount += 1;
    });
    await DatabaseHelper.instance.saveProgress('Tracing & Write $currentLevel', 1, currentNumber);
    String msg = currentLanguage == 'ur' ? '⭐ ستارہ مل گیا! شاندار!' : '⭐ Star Earned! Awesome!';
    _speak(msg);
    _showToast(msg);
  }

  @override
  Widget build(BuildContext context) {
    bool isUr = currentLanguage == 'ur';
    NumberMeta data = numData[currentNumber] ??
        const NumberMeta(en: '1', ur: '۱', item: '⭐', count: 1);

    int maxNum = currentLevel == 'PG' ? 10 : 20;
    bool isFirst = currentNumber == 1;
    bool isLast = currentNumber == maxNum;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: const Color(0xFFFBF9F3),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
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
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.maybePop(context),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Title placed closer to the back arrow as requested
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'Tracing & Write',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1B1C19),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text('✍️', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                const Text(
                                  'Dotted line guides',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6E7980),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF006689),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '1234',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
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
            body: Directionality(
              textDirection: isUr ? TextDirection.rtl : TextDirection.ltr,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: Column(
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() => currentLanguage = isUr ? 'en' : 'ur');
                              _speak(isUr ? 'اردو زبان منتخب ہو گئی' : 'Switched to English');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 4))],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.language, color: Color(0xFF006689), size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUr ? 'اردو ⇄ English' : 'English ⇄ اردو',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Color(0xFF24BC6B), shape: BoxShape.circle),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
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
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDDB6),
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('🐥', style: TextStyle(fontSize: 22)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isUr ? 'پپ چوزہ' : 'Pip the Chick',
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                      ),
                                      Text(
                                        isUr ? 'نقطوں پر آہستہ آہستہ پینسل چلائیں!' : 'Follow the dots and draw carefully!',
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  String msg = isUr ? 'آئیے نمبر ${data.ur} لکھنا سیکھیں!' : 'Let us practice number ${data.en}!';
                                  _speak(msg);
                                  _showToast(msg);
                                },
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2BB0E6),
                                    borderRadius: BorderRadius.circular(19),
                                    boxShadow: const [BoxShadow(color: Color(0xFF006689), offset: Offset(0, 3))],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
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
                                  onTap: () => _selectLevel('PG'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentLevel == 'PG' ? const Color(0xFF006689) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isUr ? 'پلے گروپ (1–10)' : 'Play Group (1–10)',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: currentLevel == 'PG' ? Colors.white : const Color(0xFF3E484F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectLevel('KG'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentLevel == 'KG' ? const Color(0xFF006689) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isUr ? 'کے جی (1–20)' : 'KG (1–20)',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: currentLevel == 'KG' ? Colors.white : const Color(0xFF3E484F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (currentLevel == 'KG')
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [BoxShadow(color: Color(0x0A40352C), blurRadius: 6)],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectKGSubMode('dotted'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: currentViewMode == 'dotted' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUr ? 'نقطہ ورک شیٹ (11-20)' : 'Dotted Sheet (11–20)',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: currentViewMode == 'dotted' ? const Color(0xFF2A1800) : const Color(0xFF3E484F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectKGSubMode('freehand'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: currentViewMode == 'freehand' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUr ? 'آزاد مشق کینوس' : 'Freehand Canvas',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: currentViewMode == 'freehand' ? const Color(0xFF2A1800) : const Color(0xFF3E484F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 52,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentLevel == 'PG' ? 10 : 20,
                            itemBuilder: (context, index) {
                              int num = index + 1;
                              bool isSelected = num == currentNumber;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentNumber = num;
                                      _clearCanvas();
                                    });
                                    NumberMeta d = numData[num]!;
                                    _speak(isUr ? d.ur : d.en);
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFFFAA1D) : const Color(0xFFF0EEE8),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: isSelected ? const [BoxShadow(color: Color(0xFF845400), offset: Offset(0, 3))] : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$num',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: isSelected ? const Color(0xFF2A1800) : const Color(0xFF1B1C19),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F3EE),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFAA1D),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: const [BoxShadow(color: Color(0xFF845400), offset: Offset(0, 3))],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$currentNumber',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.en,
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF006689)),
                                            ),
                                            Text(
                                              data.ur,
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF845400)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(min(data.count, 5), (i) => Text(data.item, style: const TextStyle(fontSize: 16))),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () => _speak(isUr ? data.ur : data.en),
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFC2E8FF),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.volume_up, color: Color(0xFF003F57), size: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (currentViewMode == 'dotted' || currentLevel == 'PG') ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isUr ? 'نقطوں کے اوپر لکیر کھینچیں' : 'Trace inside the dotted guidelines',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
                                    const Text(
                                      '5 Ruled Lines',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFDF7),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: const Color(0xFFBDC8D0).withOpacity(0.4)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: List.generate(5, (row) {
                                          return Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: const Color(0xFFBDC8D0).withOpacity(0.3), width: 1.5)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: List.generate(currentNumber >= 10 ? 4 : 5, (col) {
                                                return Text(
                                                  '$currentNumber',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 28,
                                                    fontWeight: hintGuideActive ? FontWeight.w900 : FontWeight.bold,
                                                    color: hintGuideActive ? const Color(0xFF006689).withOpacity(0.5) : const Color(0xFFCBD5E1),
                                                    letterSpacing: 4,
                                                  ),
                                                );
                                              }),
                                            ),
                                          );
                                        }),
                                      ),
                                      GestureDetector(
                                        onPanStart: (details) {
                                          setState(() {
                                            _currentTracingStroke = [details.localPosition];
                                            _tracingStrokes.add(_currentTracingStroke!);
                                          });
                                        },
                                        onPanUpdate: (details) {
                                          setState(() {
                                            _currentTracingStroke?.add(details.localPosition);
                                          });
                                        },
                                        onPanEnd: (details) {
                                          _currentTracingStroke = null;
                                        },
                                        child: CustomPaint(
                                          painter: StrokePainter(strokes: _tracingStrokes, color: strokeColor),
                                          size: Size.infinite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isUr ? 'آزاد لکھائی زون - بغیر نقطوں کے لکھیں!' : 'Freehand Practice - Write without dots!',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                    ),
                                    const Text('Blank Grid', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF24BC6B))),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: const Color(0xFFBDC8D0).withOpacity(0.4)),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        '$currentNumber',
                                        style: TextStyle(fontFamily: 'Rubik', fontSize: 140, fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(0.08)),
                                      ),
                                      GestureDetector(
                                        onPanStart: (details) {
                                          setState(() {
                                            _currentFreehandStroke = [details.localPosition];
                                            _freehandStrokes.add(_currentFreehandStroke!);
                                          });
                                        },
                                        onPanUpdate: (details) {
                                          setState(() {
                                            _currentFreehandStroke?.add(details.localPosition);
                                          });
                                        },
                                        onPanEnd: (details) {
                                          _currentFreehandStroke = null;
                                        },
                                        child: CustomPaint(
                                          painter: StrokePainter(strokes: _freehandStrokes, color: strokeColor),
                                          size: Size.infinite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF24BC6B),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 2,
                                    ),
                                    onPressed: _earnStarAndSave,
                                    icon: const Icon(Icons.verified),
                                    label: Text(
                                      isUr ? 'چیک کریں اور ستارہ جیتیں ⭐' : 'Auto-Check & Win Star ⭐',
                                      style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Color(0x0A40352C), blurRadius: 10)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildColorButton(const Color(0xFF2BB0E6)),
                                  const SizedBox(width: 8),
                                  _buildColorButton(const Color(0xFFFFAA1D)),
                                  const SizedBox(width: 8),
                                  _buildColorButton(const Color(0xFF24BC6B)),
                                  const SizedBox(width: 8),
                                  _buildColorButton(const Color(0xFFBA1A1A)),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hintGuideActive ? const Color(0xFFFFAA1D) : const Color(0xFFFFDDB6),
                                      foregroundColor: const Color(0xFF2A1800),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => setState(() => hintGuideActive = !hintGuideActive),
                                    icon: const Icon(Icons.lightbulb, size: 16),
                                    label: Text(isUr ? 'اشارہ' : 'Hint', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF0EEE8),
                                      foregroundColor: const Color(0xFF1B1C19),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: _clearCanvas,
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: Text(isUr ? 'صاف کریں' : 'Clear', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFirst 
                                      ? const Color(0xFFFFDDB6).withOpacity(0.4) 
                                      : const Color(0xFFFFDDB6),
                                  foregroundColor: const Color(0xFF2A1800),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: isFirst ? 0 : 2,
                                ),
                                onPressed: isFirst ? null : () => _stepNumber(-1),
                                icon: const Icon(Icons.arrow_back, size: 18),
                                label: Text(isUr ? 'پچھلی ورک شیٹ' : 'Prev Worksheet', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isLast 
                                      ? const Color(0xFFFFAA1D).withOpacity(0.4) 
                                      : const Color(0xFFFFAA1D),
                                  foregroundColor: const Color(0xFF2A1800),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: isLast ? 0 : 2,
                                ),
                                onPressed: isLast ? null : () {
                                  _earnStarAndSave();
                                  _stepNumber(1);
                                },
                                icon: const Icon(Icons.auto_awesome, size: 20),
                                label: Text(isUr ? 'اگلی ورک شیٹ ❯' : 'Next Worksheet ❯', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showToastFlag)
                    Positioned(
                      top: 90,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF30312D),
                              borderRadius: BorderRadius.circular(24),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    bool isSelected = strokeColor == color;
    return InkWell(
      onTap: () => setState(() => strokeColor = color),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: isSelected ? 3 : 1),
          boxShadow: [BoxShadow(color: color.withOpacity(0.5), offset: const Offset(0, 3), blurRadius: 4)],
        ),
        alignment: Alignment.center,
        child: isSelected ? const Icon(Icons.brush, color: Colors.white, size: 16) : null,
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  StrokePainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      if (stroke.isEmpty) continue;
      final Path path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}