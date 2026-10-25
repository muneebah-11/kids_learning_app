import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const FindNumbersQuizApp());
}

class FindNumbersQuizApp extends StatelessWidget {
  const FindNumbersQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Numbers Quiz - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const FindNumbersQuizScreen(),
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
      CREATE TABLE user_progress (
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
    return 141; 
  }
}

class QuestionPG {
  final int target;
  final String targetUrdu;
  final List<int> options;
  final List<String> optionsUrdu;

  QuestionPG({
    required this.target,
    required this.targetUrdu,
    required this.options,
    required this.optionsUrdu,
  });
}

class QuestionKG {
  final List<String> sequence;
  final int missingIndex;
  final int answer;
  final String answerUrdu;
  final List<int> options;
  final List<String> optionsUrdu;

  QuestionKG({
    required this.sequence,
    required this.missingIndex,
    required this.answer,
    required this.answerUrdu,
    required this.options,
    required this.optionsUrdu,
  });
}

class FindNumbersQuizScreen extends StatefulWidget {
  const FindNumbersQuizScreen({Key? key}) : super(key: key);

  @override
  State<FindNumbersQuizScreen> createState() => _FindNumbersQuizScreenState();
}

class _FindNumbersQuizScreenState extends State<FindNumbersQuizScreen>
    with TickerProviderStateMixin {
  String currentMode = 'PG'; 
  bool isUrdu = false;
  int currentQuestionIndex = 0;
  int round = 1; // Round 1 se start hoga
  int maxRounds = 5;
  int starCount = 141; 
  bool isProcessing = false;
  bool hintUsed = false;
  int? disabledOptionIndex;
  int? filledSequenceAnswer;

  late FlutterTts flutterTts;

  late AnimationController _pipPulseController;
  late AnimationController _cardShakeController;

  String? toastMessage;
  Color toastBgColor = const Color(0xFF30312D);
  Color toastTextColor = const Color(0xFFF2F1EB);
  bool showToastFlag = false;

  List<Widget> sparkleParticles = [];

  final List<QuestionPG> pgQuestions = [
    QuestionPG(target: 3, targetUrdu: '۳', options: [3, 7, 2, 9], optionsUrdu: ['۳', '۷', '۲', '۹']),
    QuestionPG(target: 5, targetUrdu: '۵', options: [4, 5, 8, 1], optionsUrdu: ['۴', '۵', '۸', '۱']),
    QuestionPG(target: 8, targetUrdu: '۸', options: [6, 8, 10, 3], optionsUrdu: ['۶', '۸', '۱۰', '۳']),
    QuestionPG(target: 2, targetUrdu: '۲', options: [2, 6, 9, 4], optionsUrdu: ['۲', '۶', '۹', '۴']),
    QuestionPG(target: 6, targetUrdu: '۶', options: [9, 1, 6, 7], optionsUrdu: ['۹', '۱', '۶', '۷']),
  ];

  final List<QuestionKG> kgQuestions = [
    QuestionKG(sequence: ['5', '6', '?', '8'], missingIndex: 2, answer: 7, answerUrdu: '۷', options: [7, 9, 10, 4], optionsUrdu: ['۷', '۹', '۱۰', '۴']),
    QuestionKG(sequence: ['14', '15', '?', '17'], missingIndex: 2, answer: 16, answerUrdu: '۱۶', options: [13, 16, 18, 12], optionsUrdu: ['۱۳', '۱۶', '۱۸', '۱۲']),
    QuestionKG(sequence: ['9', '?', '11', '12'], missingIndex: 1, answer: 10, answerUrdu: '۱۰', options: [8, 10, 14, 7], optionsUrdu: ['۸', '۱۰', '۱۴', '۷']),
    QuestionKG(sequence: ['?', '2', '3', '4'], missingIndex: 0, answer: 1, answerUrdu: '۱', options: [5, 0, 1, 6], optionsUrdu: ['۵', '۰', '۱', '۶']),
    QuestionKG(sequence: ['17', '18', '19', '?'], missingIndex: 3, answer: 20, answerUrdu: '۲۰', options: [16, 21, 20, 15], optionsUrdu: ['۱۶', '۲۱', '۲۰', '۱۵']),
  ];

  final List<Map<String, dynamic>> cardBadgeAccents = [
    {'bg': const Color(0xFFC2E8FF), 'text': const Color(0xFF001E2C), 'badge': '1'},
    {'bg': const Color(0xFFFFDDB6), 'text': const Color(0xFF2A1800), 'badge': '2'},
    {'bg': const Color(0xFF73FDA3), 'text': const Color(0xFF00210D), 'badge': '3'},
    {'bg': const Color(0xFFE4E2DD), 'text': const Color(0xFF006689), 'badge': '4'},
  ];

  final List<Color> sequenceBoxColors = [
    const Color(0xFFE3F2FD),
    const Color(0xFFE8F5E9),
    const Color(0xFFFFF3E0),
    const Color(0xFFF3E5F5),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialStars();
    _initTts();

    _pipPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _cardShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(isUrdu ? "ur-PK" : "en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(isUrdu ? "ur-PK" : "en-US");
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
    _pipPulseController.dispose();
    _cardShakeController.dispose();
    super.dispose();
  }

  void _showToast(String message, {Color? bg, Color? text}) {
    setState(() {
      toastMessage = message;
      if (bg != null) toastBgColor = bg;
      if (text != null) toastTextColor = text;
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

  void _triggerSparkleBurst() {
    final List<String> emojis = ['⭐', '✨', '🌟', '🎉', '💛'];
    final Random rand = Random();

    List<Widget> tempSparkles = List.generate(12, (index) {
      double left = 40 + rand.nextDouble() * 250;
      double top = 150 + rand.nextDouble() * 250;
      return Positioned(
        left: left,
        top: top,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: 1.0,
          child: Text(
            emojis[rand.nextInt(emojis.length)],
            style: const TextStyle(fontSize: 26),
          ),
        ),
      );
    });

    setState(() {
      sparkleParticles = tempSparkles;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          sparkleParticles = [];
        });
      }
    });
  }

  void _speakCurrentQuestion() {
    if (currentMode == 'PG') {
      var q = pgQuestions[currentQuestionIndex % pgQuestions.length];
      String msg = isUrdu
          ? 'سنیں: نمبر ${q.targetUrdu}'
          : 'Listen and tap number ${q.target}!';
      _speak(msg);
      _showToast('🔊 $msg', bg: const Color(0xFFFFDDB6), text: const Color(0xFF2A1800));
    } else {
      String msg = isUrdu ? 'معمہ حل کریں!' : 'Which number comes next?';
      _speak(msg);
      _showToast('🔊 $msg', bg: const Color(0xFFFFDDB6), text: const Color(0xFF2A1800));
    }
  }

  void _handleAnswerSelection(bool isCorrect, int optionIdx, dynamic displayValue) async {
    if (isProcessing) return;

    if (isCorrect) {
      setState(() {
        isProcessing = true;
        starCount += 1;
        if (currentMode == 'KG') {
          filledSequenceAnswer = optionIdx;
        }
      });

      await DatabaseHelper.instance.saveProgress('Find Numbers $currentMode', 1, round);
      _triggerSparkleBurst();

      String praise = isUrdu ? 'شاباش! بہت خوب!' : 'Awesome job! +1 Star!';
      _speak(praise);
      _showToast('⭐ $praise', bg: const Color(0xFF006D39), text: Colors.white);

      Future.delayed(const Duration(milliseconds: 1300), () {
        if (mounted) {
          _nextQuestion();
          setState(() {
            isProcessing = false;
            filledSequenceAnswer = null;
          });
        }
      });
    } else {
      _cardShakeController.forward(from: 0.0);
      String retryMsg = isUrdu ? 'دوبارہ کوشش کریں!' : 'Try again, little explorer!';
      _speak(retryMsg);
      _showToast('💛 $retryMsg', bg: const Color(0xFFFFDDB6), text: const Color(0xFF2A1800));
    }
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      round = (round % maxRounds) + 1;
      disabledOptionIndex = null;
      hintUsed = false;
    });
  }

  void _giveHint() {
    if (hintUsed || isProcessing) return;

    setState(() {
      hintUsed = true;
    });

    if (currentMode == 'PG') {
      var q = pgQuestions[currentQuestionIndex % pgQuestions.length];
      for (int i = 0; i < q.options.length; i++) {
        if (q.options[i] != q.target) {
          setState(() {
            disabledOptionIndex = i;
          });
          break;
        }
      }
    } else {
      var q = kgQuestions[currentQuestionIndex % kgQuestions.length];
      for (int i = 0; i < q.options.length; i++) {
        if (q.options[i] != q.answer) {
          setState(() {
            disabledOptionIndex = i;
          });
          break;
        }
      }
    }

    String hintMsg = isUrdu ? 'ایک غلط آپشن ہٹا دیا گیا!' : 'Look closely, one choice removed!';
    _speak(hintMsg);
    _showToast('💡 $hintMsg', bg: const Color(0xFFFFAA1D), text: const Color(0xFF6A4300));
  }

  void _skipQuestion() {
    if (isProcessing) return;
    String msg = isUrdu ? 'اگلا سوال پیش ہے!' : 'Moving to next round!';
    _speak(msg);
    _showToast('⏭ $msg', bg: const Color(0xFFE4E2DD), text: const Color(0xFF1B1C19));
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    double progressPct = (round / maxRounds);

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
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFEAE8E2)),
                              boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 24),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isUrdu ? 'نمبر تلاش کوئز' : 'Find Numbers Quiz',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                            Text(
                              isUrdu ? 'پہچانیں، ملائیں اور کھیلیں!' : 'Identify, Match & Play!',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E484F),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFFB958).withOpacity(0.4)),
                                boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2))],
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$starCount',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2A1800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _speak('Leo, Explorer Level 4'),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006689),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 2))],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 20),
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
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF0EEE8)),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, size: 18, color: Color(0xFF006689)),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUrdu ? 'راؤنڈ $round از $maxRounds' : 'Round $round of $maxRounds',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isUrdu = !isUrdu;
                                });
                                _speak(isUrdu ? 'اردو زبان منتخب ہو گئی' : 'Switched to English');
                                _showToast(isUrdu ? 'اردو زبان منتخب ہو گئی 🌐' : 'Switched to English 🌐');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFF0EEE8)),
                                  boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))],
                                ),
                                child: Row(
                                  children: [
                                    const Text('🌐', style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Text(
                                      isUrdu ? 'اردو ⇄ English' : 'English ⇄ اردو',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEE8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEAE8E2)),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progressPct,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF24BC6B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE8E2).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF0EEE8)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentMode = 'PG';
                                      currentQuestionIndex = 0;
                                      round = 1;
                                      disabledOptionIndex = null;
                                      hintUsed = false;
                                    });
                                    _speakCurrentQuestion();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentMode == 'PG' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: currentMode == 'PG' ? const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))] : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('👶', style: TextStyle(fontSize: 14)),
                                        const SizedBox(width: 6),
                                        Text(
                                          isUrdu ? 'پلے گروپ (PG: ۱–۱۰)' : 'Play Group (PG: 1–10)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: currentMode == 'PG' ? const Color(0xFF006689) : const Color(0xFF3E484F),
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
                                      currentMode = 'KG';
                                      currentQuestionIndex = 0;
                                      round = 1;
                                      disabledOptionIndex = null;
                                      hintUsed = false;
                                    });
                                    _speakCurrentQuestion();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: currentMode == 'KG' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: currentMode == 'KG' ? const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))] : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('🎒', style: TextStyle(fontSize: 14)),
                                        const SizedBox(width: 6),
                                        Text(
                                          isUrdu ? 'کنڈرگارڈن (KG: ۱–۲۰)' : 'Kindergarten (KG: 1–20)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: currentMode == 'KG' ? const Color(0xFF006689) : const Color(0xFF3E484F),
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
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFF0EEE8)),
                            boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 16)],
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: _speakCurrentQuestion,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFDDB6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFFFB958).withOpacity(0.3)),
                                        boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 3))],
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text('🐥', style: TextStyle(fontSize: 30)),
                                    ),
                                    Positioned(
                                      bottom: -4,
                                      right: -4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF73FDA3),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: const Color(0xFF24BC6B)),
                                        ),
                                        child: const Text('Pip', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF00210D))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: _speakCurrentQuestion,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3EE),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFF0EEE8)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentMode == 'PG'
                                              ? (isUrdu
                                                  ? 'غور سے سنیں اور نمبر ${pgQuestions[currentQuestionIndex % pgQuestions.length].targetUrdu} کو دبائیں! 🎯'
                                                  : 'Listen and tap number ${pgQuestions[currentQuestionIndex % pgQuestions.length].target}! 🎯')
                                              : (isUrdu
                                                  ? 'کون سا نمبر خالی خانے میں آئے گا؟ 🧩'
                                                  : 'Which number fills the blank? 🧩'),
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isUrdu ? 'دوبارہ سننے کے لیے سپیکر دبائیں 🔊' : 'Tap speaker to hear aloud 🔊',
                                          style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ScaleTransition(
                                scale: Tween(begin: 1.0, end: 1.08).animate(_pipPulseController),
                                child: InkWell(
                                  onTap: _speakCurrentQuestion,
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFAA1D),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: Colors.amber.shade300),
                                      boxShadow: const [BoxShadow(color: Color(0xFF6A4300), offset: Offset(0, 4))],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.volume_up, color: Color(0xFF6A4300), size: 28),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDynamicQuizStage(),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1B1C19),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  side: const BorderSide(color: Color(0xFFF0EEE8)),
                                  shadowColor: const Color(0xFFDBDAD4),
                                ),
                                onPressed: _giveHint,
                                icon: const Icon(Icons.lightbulb, color: Color(0xFFFFAA1D), size: 20),
                                label: Text(isUrdu ? 'اشارہ' : 'Hint', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1B1C19),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  side: const BorderSide(color: Color(0xFFF0EEE8)),
                                  shadowColor: const Color(0xFFDBDAD4),
                                ),
                                onPressed: _speakCurrentQuestion,
                                icon: const Icon(Icons.replay, color: Color(0xFF006689), size: 20),
                                label: Text(isUrdu ? 'دہرائیں' : 'Repeat', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1B1C19),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  side: const BorderSide(color: Color(0xFFF0EEE8)),
                                  shadowColor: const Color(0xFFDBDAD4),
                                ),
                                onPressed: _skipQuestion,
                                icon: const Icon(Icons.skip_next, color: Color(0xFF6E7980), size: 20),
                                label: Text(isUrdu ? 'چھوڑیں' : 'Skip', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...sparkleParticles,
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
                              color: toastBgColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                            ),
                            child: Text(
                              toastMessage ?? '',
                              style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: toastTextColor, fontSize: 13),
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

  Widget _buildDynamicQuizStage() {
    if (currentMode == 'PG') {
      var q = pgQuestions[currentQuestionIndex % pgQuestions.length];
      var displayedOptions = isUrdu ? q.optionsUrdu : q.options;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: displayedOptions.length,
        itemBuilder: (context, idx) {
          bool isDisabled = disabledOptionIndex == idx;
          var accent = cardBadgeAccents[idx % cardBadgeAccents.length];
          bool isCorrect = q.options[idx] == q.target;
          Color boxColor = sequenceBoxColors[idx % sequenceBoxColors.length];

          return Opacity(
            opacity: isDisabled ? 0.3 : 1.0,
            child: InkWell(
              onTap: isDisabled ? null : () => _handleAnswerSelection(isCorrect, idx, displayedOptions[idx]),
              child: Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: accent['bg'] as Color, width: 2),
                  boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 5))],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: accent['bg'] as Color,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          accent['badge'] as String,
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: accent['text'] as Color),
                        ),
                      ),
                    ),
                    Text(
                      '${displayedOptions[idx]}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B1C19),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      var q = kgQuestions[currentQuestionIndex % kgQuestions.length];
      var displayedOptions = isUrdu ? q.optionsUrdu : q.options;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFF0EEE8)),
              boxShadow: const [BoxShadow(color: Color(0x0D40352C), offset: Offset(0, 4), blurRadius: 16)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.extension, color: Color(0xFFFFAA1D), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      isUrdu ? 'نمبر کا تسلسل مکمل کریں' : 'COMPLETE THE NUMBER SEQUENCE',
                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF3E484F)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(q.sequence.length, (idx) {
                    bool isMissingSlot = idx == q.missingIndex;
                    Color seqColor = sequenceBoxColors[idx % sequenceBoxColors.length];
                    return Row(
                      children: [
                        Container(
                          width: 58,
                          height: 72,
                          decoration: BoxDecoration(
                            color: isMissingSlot
                                ? (filledSequenceAnswer != null ? const Color(0xFF73FDA3) : const Color(0xFFFFDDB6))
                                : seqColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isMissingSlot ? const Color(0xFF845400) : Colors.amber.shade200,
                              width: isMissingSlot ? 2 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isMissingSlot ? const Color(0xFFFFB958) : const Color(0xFFDBDAD4),
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isMissingSlot
                                ? (filledSequenceAnswer != null ? '${displayedOptions[filledSequenceAnswer!]}' : '?')
                                : q.sequence[idx],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isMissingSlot ? const Color(0xFF845400) : const Color(0xFF1B1C19),
                            ),
                          ),
                        ),
                        if (idx < q.sequence.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.arrow_forward, size: 16, color: Color(0xFFBDC8D0)),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: displayedOptions.length,
            itemBuilder: (context, idx) {
              bool isDisabled = disabledOptionIndex == idx;
              bool isCorrect = q.options[idx] == q.answer;
              Color gridBoxColor = sequenceBoxColors[idx % sequenceBoxColors.length];

              return Opacity(
                opacity: isDisabled ? 0.3 : 1.0,
                child: InkWell(
                  onTap: isDisabled ? null : () => _handleAnswerSelection(isCorrect, idx, displayedOptions[idx]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: gridBoxColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100, width: 1.5),
                      boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 4))],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${displayedOptions[idx]}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1B1C19),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
  }
}