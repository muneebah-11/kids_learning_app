import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WonderKidsPronunciationApp());
}

// ================= DATABASE HELPER =================
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonder_kids_pronunciation.db');
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
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalStars INTEGER,
        currentLetter TEXT
      )
    ''');
    await db.insert('user_progress', {'totalStars': 140, 'currentLetter': 'C'});
  }

  Future<int> getStars() async {
    final db = await instance.database;
    final result = await db.query('user_progress');
    if (result.isNotEmpty) {
      return result.first['totalStars'] as int;
    }
    return 140;
  }

  Future<void> updateStars(int stars) async {
    final db = await instance.database;
    await db.update('user_progress', {'totalStars': stars}, where: 'id = ?', whereArgs: [1]);
  }
}

class WonderKidsPronunciationApp extends StatelessWidget {
  const WonderKidsPronunciationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids - Pronunciation & Rhymes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const PronunciationHomeScreen(letterIndex: 0),
    );
  }
}

class PronunciationModel {
  final String letter;
  final String smallLetter;
  final String emoji;
  final String soundIPA;
  final String songTitle;
  final String songLevel;
  final String karaokeLine;
  final List<Map<String, String>> rhymePairs;
  final Color themeColor;

  PronunciationModel({
    required this.letter,
    required this.smallLetter,
    required this.emoji,
    required this.soundIPA,
    required this.songTitle,
    required this.songLevel,
    required this.karaokeLine,
    required this.rhymePairs,
    required this.themeColor,
  });
}

class PronunciationHomeScreen extends StatefulWidget {
  final int letterIndex;
  const PronunciationHomeScreen({Key? key, this.letterIndex = 0}) : super(key: key);

  @override
  State<PronunciationHomeScreen> createState() => _PronunciationHomeScreenState();
}

class _PronunciationHomeScreenState extends State<PronunciationHomeScreen> {
  late int currentIndex;
  int totalStars = 140;

  bool isPlaying = false;
  double playbackSpeed = 1.0;
  Timer? _playbackTimer;
  double progressValue = 0.0;
  final FlutterTts flutterTts = FlutterTts();

  // A to Z Dataset with exact kid-friendly sound patterns
  final List<PronunciationModel> pronunciationData = [
    PronunciationModel(
      letter: 'A', smallLetter: 'a', emoji: '🍎', soundIPA: '/æ/',
      songTitle: 'The Phonics ABC Song (Letter A)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'A aa Apple, A aa Ant, A aa Airplane',
      rhymePairs: [
        {'pair': 'Cat & Hat', 'phonics': 'C • a • t rhymes with H • a • t', 'emoji1': '🐱', 'emoji2': '🎩'},
        {'pair': 'Map & Cap', 'phonics': 'M • a • p rhymes with C • a • p', 'emoji1': '🗺️', 'emoji2': '🧢'},
      ],
      themeColor: const Color(0xFFC2E8FF),
    ),
    PronunciationModel(
      letter: 'B', smallLetter: 'b', emoji: '🦋', soundIPA: '/b/',
      songTitle: 'The Phonics ABC Song (Letter B)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'B ba Ball, B ba Bat, B ba Bag',
      rhymePairs: [
        {'pair': 'Pin & Bin', 'phonics': 'P • i • n rhymes with B • i • n', 'emoji1': '📌', 'emoji2': '🗑️'},
        {'pair': 'Sun & Run', 'phonics': 'S • u • n rhymes with R • u • n', 'emoji1': '☀️', 'emoji2': '🏃'},
      ],
      themeColor: const Color(0xFFFFDDB6),
    ),
    PronunciationModel(
      letter: 'C', smallLetter: 'c', emoji: '🐱', soundIPA: '/k/',
      songTitle: 'The Phonics ABC Song (Letter C)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'C ka Cat, C ka Cup, C ka Car',
      rhymePairs: [
        {'pair': 'Cup & Pup', 'phonics': 'C • u • p rhymes with P • u • p', 'emoji1': '☕', 'emoji2': '🐶'},
        {'pair': 'Car & Jar', 'phonics': 'C • a • r rhymes with J • a • r', 'emoji1': '🚗', 'emoji2': '🫙'},
      ],
      themeColor: const Color(0xFF73FDA3),
    ),
    PronunciationModel(
      letter: 'D', smallLetter: 'd', emoji: '🦆', soundIPA: '/d/',
      songTitle: 'The Phonics ABC Song (Letter D)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'D da Dog, D da Duck, D da Drum',
      rhymePairs: [
        {'pair': 'Dog & Log', 'phonics': 'D • o • g rhymes with L • o • g', 'emoji1': '🐶', 'emoji2': '🪵'},
        {'pair': 'Dig & Pig', 'phonics': 'D • i • g rhymes with P • i • g', 'emoji1': '⛏️', 'emoji2': '🐷'},
      ],
      themeColor: const Color(0xFFEAE8E2),
    ),
    PronunciationModel(
      letter: 'E', smallLetter: 'e', emoji: '🐘', soundIPA: '/e/',
      songTitle: 'The Phonics ABC Song (Letter E)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'E eh Egg, E eh Elephant, E eh Engine',
      rhymePairs: [
        {'pair': 'Pen & Hen', 'phonics': 'P • e • n rhymes with H • e • n', 'emoji1': '🖊️', 'emoji2': '🐔'},
      ],
      themeColor: const Color(0xFFFFC2C2),
    ),
    PronunciationModel(
      letter: 'F', smallLetter: 'f', emoji: '🐟', soundIPA: '/f/',
      songTitle: 'The Phonics ABC Song (Letter F)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'F fa Fish, F fa Fan, F fa Frog',
      rhymePairs: [
        {'pair': 'Fan & Man', 'phonics': 'F • a • n rhymes with M • a • n', 'emoji1': '🌀', 'emoji2': '👨'},
      ],
      themeColor: const Color(0xFFC2FFD7),
    ),
    PronunciationModel(
      letter: 'G', smallLetter: 'g', emoji: '🍇', soundIPA: '/ɡ/',
      songTitle: 'The Phonics ABC Song (Letter G)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'G ga Grapes, G ga Goat, G ga Girl',
      rhymePairs: [{'pair': 'Goat & Boat', 'phonics': 'G • o • a • t rhymes with B • o • a • t', 'emoji1': '🐐', 'emoji2': '⛵'}],
      themeColor: const Color(0xFFE1BEE7),
    ),
    PronunciationModel(
      letter: 'H', smallLetter: 'h', emoji: '🎩', soundIPA: '/h/',
      songTitle: 'The Phonics ABC Song (Letter H)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'H ha Hat, H ha House, H ha Horse',
      rhymePairs: [{'pair': 'Hat & Cat', 'phonics': 'H • a • t rhymes with C • a • t', 'emoji1': '🎩', 'emoji2': '🐱'}],
      themeColor: const Color(0xFFFFCDD2),
    ),
    PronunciationModel(
      letter: 'I', smallLetter: 'i', emoji: '🍦', soundIPA: '/aɪ/',
      songTitle: 'The Phonics ABC Song (Letter I)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'I ih Ice cream, I ih Igloo, I ih Ink',
      rhymePairs: [{'pair': 'Pig & Fig', 'phonics': 'P • i • g rhymes with F • i • g', 'emoji1': '🐷', 'emoji2': ' figs'}],
      themeColor: const Color(0xFFFFF3CD),
    ),
    PronunciationModel(
      letter: 'J', smallLetter: 'j', emoji: '🫖', soundIPA: '/dʒ/',
      songTitle: 'The Phonics ABC Song (Letter J)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'J ja Jug, J ja Jam, J ja Jet',
      rhymePairs: [{'pair': 'Jam & Ram', 'phonics': 'J • a • m rhymes with R • a • m', 'emoji1': '🍓', 'emoji2': '🐏'}],
      themeColor: const Color(0xFFC2E8FF),
    ),
    PronunciationModel(
      letter: 'K', smallLetter: 'k', emoji: '🪁', soundIPA: '/k/',
      songTitle: 'The Phonics ABC Song (Letter K)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'K ka Kite, K ka Kangaroo, K ka Key',
      rhymePairs: [{'pair': 'Key & Bee', 'phonics': 'K • e • y rhymes with B • e • e', 'emoji1': '🔑', 'emoji2': '🐝'}],
      themeColor: const Color(0xFFFFDDB6),
    ),
    PronunciationModel(
      letter: 'L', smallLetter: 'l', emoji: '🦁', soundIPA: '/l/',
      songTitle: 'The Phonics ABC Song (Letter L)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'L la Lion, L la Leaf, L la Lamp',
      rhymePairs: [{'pair': 'Log & Dog', 'phonics': 'L • o • g rhymes with D • o • g', 'emoji1': '🪵', 'emoji2': '🐶'}],
      themeColor: const Color(0xFF73FDA3),
    ),
    PronunciationModel(
      letter: 'M', smallLetter: 'm', emoji: '🐵', soundIPA: '/m/',
      songTitle: 'The Phonics ABC Song (Letter M)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'M ma Monkey, M ma Moon, M ma Milk',
      rhymePairs: [{'pair': 'Map & Cap', 'phonics': 'M • a • p rhymes with C • a • p', 'emoji1': '🗺️', 'emoji2': '🧢'}],
      themeColor: const Color(0xFFEAE8E2),
    ),
    PronunciationModel(
      letter: 'N', smallLetter: 'n', emoji: '🪹', soundIPA: '/n/',
      songTitle: 'The Phonics ABC Song (Letter N)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'N na Nest, N na Nut, N na Net',
      rhymePairs: [{'pair': 'Net & Wet', 'phonics': 'N • e • t rhymes with W • e • t', 'emoji1': '🥅', 'emoji2': '🌧️'}],
      themeColor: const Color(0xFFC2E8FF),
    ),
    PronunciationModel(
      letter: 'O', smallLetter: 'o', emoji: '🦉', soundIPA: '/ɒ/',
      songTitle: 'The Phonics ABC Song (Letter O)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'O oo Owl, O oo Orange, O oo Octopus',
      rhymePairs: [{'pair': 'Pot & Hot', 'phonics': 'P • o • t rhymes with H • o • t', 'emoji1': '🍯', 'emoji2': '🔥'}],
      themeColor: const Color(0xFFFFDDB6),
    ),
    PronunciationModel(
      letter: 'P', smallLetter: 'p', emoji: '🐧', soundIPA: '/p/',
      songTitle: 'The Phonics ABC Song (Letter P)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'P pa Penguin, P pa Pen, P pa Pig',
      rhymePairs: [{'pair': 'Pin & Bin', 'phonics': 'P • i • n rhymes with B • i • n', 'emoji1': '📌', 'emoji2': '🗑️'}],
      themeColor: const Color(0xFF73FDA3),
    ),
    PronunciationModel(
      letter: 'Q', smallLetter: 'q', emoji: '👑', soundIPA: '/kw/',
      songTitle: 'The Phonics ABC Song (Letter Q)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'Q qua Queen, Q qua Quilt, Q qua Quail',
      rhymePairs: [{'pair': 'Quilt & Built', 'phonics': 'Q • u • i • l • t rhymes with B • u • i • l • t', 'emoji1': '🛏️', 'emoji2': '🧱'}],
      themeColor: const Color(0xFFEAE8E2),
    ),
    PronunciationModel(
      letter: 'R', smallLetter: 'r', emoji: '🐰', soundIPA: '/r/',
      songTitle: 'The Phonics ABC Song (Letter R)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'R ra Rabbit, R ra Ring, R ra Rocket',
      rhymePairs: [{'pair': 'Run & Sun', 'phonics': 'R • u • n rhymes with S • u • n', 'emoji1': '🏃', 'emoji2': '☀️'}],
      themeColor: const Color(0xFFC2E8FF),
    ),
    PronunciationModel(
      letter: 'S', smallLetter: 's', emoji: '☀️', soundIPA: '/s/',
      songTitle: 'The Phonics ABC Song (Letter S)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'S sa Sun, S sa Star, S sa Snake',
      rhymePairs: [{'pair': 'Sun & Run', 'phonics': 'S • u • n rhymes with R • u • n', 'emoji1': '☀️', 'emoji2': '🏃'}],
      themeColor: const Color(0xFFFFDDB6),
    ),
    PronunciationModel(
      letter: 'T', smallLetter: 't', emoji: '🐯', soundIPA: '/t/',
      songTitle: 'The Phonics ABC Song (Letter T)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'T ta Tiger, T ta Tree, T ta Top',
      rhymePairs: [{'pair': 'Top & Hop', 'phonics': 'T • o • p rhymes with H • o • p', 'emoji1': '🪀', 'emoji2': '🦘'}],
      themeColor: const Color(0xFF73FDA3),
    ),
    PronunciationModel(
      letter: 'U', smallLetter: 'u', emoji: '☂️', soundIPA: '/ʌ/',
      songTitle: 'The Phonics ABC Song (Letter U)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'U ah Umbrella, U ah Uncle, U ah Up',
      rhymePairs: [{'pair': 'Cup & Pup', 'phonics': 'C • u • p rhymes with P • u • p', 'emoji1': '☕', 'emoji2': '🐶'}],
      themeColor: const Color(0xFFEAE8E2),
    ),
    PronunciationModel(
      letter: 'V', smallLetter: 'v', emoji: '🎻', soundIPA: '/v/',
      songTitle: 'The Phonics ABC Song (Letter V)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'V va Violin, V va Van, V va Vase',
      rhymePairs: [{'pair': 'Van & Fan', 'phonics': 'V • a • n rhymes with F • a • n', 'emoji1': '🚐', 'emoji2': '🌀'}],
      themeColor: const Color(0xFFC2E8FF),
    ),
    PronunciationModel(
      letter: 'W', smallLetter: 'w', emoji: '⌚', soundIPA: '/w/',
      songTitle: 'The Phonics ABC Song (Letter W)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'W wa Watch, W wa Watermelon, W wa Wind',
      rhymePairs: [{'pair': 'Well & Bell', 'phonics': 'W • e • l • l rhymes with B • e • l • l', 'emoji1': '🪣', 'emoji2': '🔔'}],
      themeColor: const Color(0xFFFFDDB6),
    ),
    PronunciationModel(
      letter: 'X', smallLetter: 'x', emoji: '🛜', soundIPA: '/ks/',
      songTitle: 'The Phonics ABC Song (Letter X)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'X ks Xylophone, X ks Box, X ks Fox',
      rhymePairs: [{'pair': 'Box & Fox', 'phonics': 'B • o • x rhymes with F • o • x', 'emoji1': '📦', 'emoji2': '🦊'}],
      themeColor: const Color(0xFF73FDA3),
    ),
    PronunciationModel(
      letter: 'Y', smallLetter: 'y', emoji: '🪀', soundIPA: '/j/',
      songTitle: 'The Phonics ABC Song (Letter Y)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'Y ya Yo-yo, Y ya Yak, Y ya Yellow',
      rhymePairs: [{'pair': 'Yak & Sack', 'phonics': 'Y • a • k rhymes with S • a • c • k', 'emoji1': '🐂', 'emoji2': '🛍️'}],
      themeColor: const Color(0xFFEAE8E2),
    ),
    PronunciationModel(
      letter: 'Z', smallLetter: 'z', emoji: '🦓', soundIPA: '/z/',
      songTitle: 'The Phonics ABC Song (Letter Z)', songLevel: 'Level 1 • Catchy Rhyme & Beat',
      karaokeLine: 'Z za Zebra, Z za Zip, Z za Zoo',
      rhymePairs: [{'pair': 'Zip & Dip', 'phonics': 'Z • i • p rhymes with D • i • p', 'emoji1': '🤐', 'emoji2': '🏊'}],
      themeColor: const Color(0xFFC2E8FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.letterIndex;
    _loadStarsFromDB();
    _initTts();
  }

  void _loadStarsFromDB() async {
    int stars = await DatabaseHelper.instance.getStars();
    if (!mounted) return;
    setState(() {
      totalStars = stars;
    });
  }

  void _initTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      // Set to a calm, kid-friendly slow speed
      await flutterTts.setSpeechRate(0.28);
      await flutterTts.setPitch(1.1);
      await flutterTts.setVolume(1.0);

      // Handle speech completion to reset state smoothly
      flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isPlaying = false;
            progressValue = 1.0;
            _playbackTimer?.cancel();
          });
        }
      });
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  void _speakText(String text) async {
    try {
      await flutterTts.stop();
      // Adjust speech rate based on user preference multiplier
      await flutterTts.setSpeechRate(playbackSpeed == 1.5 ? 0.4 : 0.28);
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void _togglePlayPause() async {
    setState(() {
      isPlaying = !isPlaying;
    });

    final currentModel = pronunciationData[currentIndex];
    if (isPlaying) {
      setState(() {
        progressValue = 0.0;
      });

      _speakText(currentModel.karaokeLine);

      // Calculate dynamic progress duration based on text length for smooth pacing
      int textLength = currentModel.karaokeLine.length;
      int totalDurationMs = textLength * 200; // tuned for slow child-friendly rate
      int steps = 60;
      int intervalMs = totalDurationMs ~/ steps;
      double increment = 1.0 / steps;

      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
        if (!mounted || !isPlaying) {
          timer.cancel();
          return;
        }
        setState(() {
          progressValue += increment;
          if (progressValue >= 1.0) {
            progressValue = 1.0;
            isPlaying = false;
            timer.cancel();
          }
        });
      });
    } else {
      await flutterTts.stop();
      _playbackTimer?.cancel();
    }
  }

  void _toggleSpeed() {
    setState(() {
      playbackSpeed = playbackSpeed == 1.0 ? 1.5 : 1.0;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '⚡ Speed set to ${playbackSpeed}x',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        duration: Duration(milliseconds: 800),
        backgroundColor: Color(0xFF006689),
      ),
    );
  }

  void _replaySong() {
    setState(() {
      progressValue = 0.0;
      isPlaying = true;
    });
    final currentModel = pronunciationData[currentIndex];
    _speakText(currentModel.karaokeLine);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Scaffold(
            backgroundColor: const Color(0xFFFBF9F3),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: const Color(0xFFFBF9F3),
                elevation: 0,
                leading: Center(
                  child: InkWell(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEE8),
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2), blurRadius: 0)],
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                    ),
                  ),
                ),
                titleSpacing: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('WONDERKIDS', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                    SizedBox(height: 2),
                    Text('Pronunciation & Rhymes', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                  ],
                ),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDDB6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                        ),
                        child: Row(
                          children: const [
                            Text('⭐', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4),
                            Text('140', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phonics Sound Board Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Phonics Sound Board 🗣️', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(10)),
                        child: const Text('26 Sounds', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Horizontal List of A to Z Sounds
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pronunciationData.length,
                      itemBuilder: (context, index) {
                        final item = pronunciationData[index];
                        final isSelected = currentIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              isPlaying = false;
                              progressValue = 0.0;
                            });
                            _speakText("${item.letter} says ${item.soundIPA}");
                          },
                          child: Container(
                            width: 65,
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : item.themeColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected ? Border.all(color: const Color(0xFF006689), width: 2) : null,
                              boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 2),
                                Text('${item.letter}${item.smallLetter}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF006689))),
                                Text(item.soundIPA, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spotlight Song Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(12)),
                              child: const Text('🎵 SPOTLIGHT SONG', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.timer, size: 12, color: Color(0xFF6E7980)),
                                SizedBox(width: 4),
                                Text('2:15 mins', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, color: Color(0xFF6E7980))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(color: const Color(0xFFC2E8FF).withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🎶 ⭐️ 🎶', style: TextStyle(fontSize: 22)),
                                const SizedBox(height: 6),
                                Text(pronunciationData[currentIndex % pronunciationData.length].songTitle, style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19))),
                                Text(pronunciationData[currentIndex % pronunciationData.length].songLevel, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF6E7980))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.mic, size: 12, color: Color(0xFF845400)),
                                  SizedBox(width: 4),
                                  Text('KARAOKE SING-ALONG', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFF2BB0E6), borderRadius: BorderRadius.circular(10)),
                                child: Text(pronunciationData[currentIndex % pronunciationData.length].karaokeLine, style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFEAE8E2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFB958)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: _toggleSpeed,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(14)),
                                child: Text('${playbackSpeed}x', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                              ),
                            ),
                            InkWell(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: const Color(0xFFFFB958), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0xFF845400), offset: Offset(0, 3), blurRadius: 0)]),
                                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: const Color(0xFF2A1800), size: 24),
                              ),
                            ),
                            InkWell(
                              onTap: _replaySong,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFFF0EEE8), shape: BoxShape.circle),
                                child: const Icon(Icons.replay, size: 18, color: Color(0xFF1B1C19)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Words That Sound The Same Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Words That Sound The Same!', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Rhyme Match 🎵', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: pronunciationData[currentIndex % pronunciationData.length].rhymePairs.map((pair) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                              child: Text(pair['emoji1']!, style: const TextStyle(fontSize: 18)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text('+', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(12)),
                              child: Text(pair['emoji2']!, style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pair['pair']!, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                  Text(pair['phonics']!, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF6E7980))),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => _speakText(pair['pair']!),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFF2BB0E6), shape: BoxShape.circle),
                                child: const Icon(Icons.volume_up, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}