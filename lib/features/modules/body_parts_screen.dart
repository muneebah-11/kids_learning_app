import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WonderKidsApp());
}

// ================= DATABASE HELPER =================
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonder_kids_body_parts.db');
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
        masteredCount INTEGER
      )
    ''');
    await db.insert('user_progress', {'totalStars': 140, 'masteredCount': 6});
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
    await db.update(
      'user_progress',
      {'totalStars': stars},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}

class WonderKidsApp extends StatelessWidget {
  const WonderKidsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids - Preschool Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const BodyPartsHomeScreen(),
    );
  }
}

class BodyPartItem {
  final String id;
  final String nameEn;
  final String nameUr;
  final String emoji;
  final String taglineEn;
  final String speechEn;
  final String speechUr;
  final Color cardColor;

  BodyPartItem({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.emoji,
    required this.taglineEn,
    required this.speechEn,
    required this.speechUr,
    required this.cardColor,
  });
}

class BodyPartsHomeScreen extends StatefulWidget {
  const BodyPartsHomeScreen({Key? key}) : super(key: key);

  @override
  State<BodyPartsHomeScreen> createState() => _BodyPartsHomeScreenState();
}

class _BodyPartsHomeScreenState extends State<BodyPartsHomeScreen> {
  bool isPlayGroup = true;
  int totalStars = 140;

  late BodyPartItem activePart;
  final FlutterTts flutterTts = FlutterTts();

  final List<BodyPartItem> bodyPartsList = [
    BodyPartItem(
      id: 'eyes',
      nameEn: 'Eyes',
      nameUr: 'آنکھیں',
      emoji: '👁️',
      taglineEn: 'Sense of Sight',
      speechEn: 'These are my Eyes! I see colors & friends!',
      speechUr: 'یہ میری آنکھیں ہیں! میں رنگ اور دوست دیکھتا ہوں!',
      cardColor: const Color(0xFFC2E8FF),
    ),
    BodyPartItem(
      id: 'ears',
      nameEn: 'Ears',
      nameUr: 'کان',
      emoji: '👂',
      taglineEn: 'Hearing & Music',
      speechEn: 'These are my Ears! I hear soft songs and birds!',
      speechUr: 'یہ میرے کان ہیں! میں گانے اور پرندے سنتا ہوں!',
      cardColor: const Color(0xFFFFDDB6),
    ),
    BodyPartItem(
      id: 'nose',
      nameEn: 'Nose',
      nameUr: 'ناک',
      emoji: '👃',
      taglineEn: 'Sense of Smell',
      speechEn: 'This is my Nose! I smell sweet cookies and flowers!',
      speechUr: 'یہ میری ناک ہے! میں مٹھائی اور پھول سونگھتا ہوں!',
      cardColor: const Color(0xFFC2E8FF),
    ),
    BodyPartItem(
      id: 'mouth',
      nameEn: 'Mouth',
      nameUr: 'منہ',
      emoji: '👄',
      taglineEn: 'Taste & Talk',
      speechEn: 'This is my Mouth! I smile, sing and eat yummy snacks!',
      speechUr: 'یہ میرا منہ ہے! میں مسکراتا ہوں اور کھانا کھاتا ہوں!',
      cardColor: const Color(0xFFFFDAD6),
    ),
    BodyPartItem(
      id: 'hands',
      nameEn: 'Hands',
      nameUr: 'ہاتھ',
      emoji: '✋',
      taglineEn: 'Touch & Clap',
      speechEn: 'These are my Hands! Clap, clap, clap your hands!',
      speechUr: 'یہ میرے ہاتھ ہیں! تالیاں بجائیں!',
      cardColor: const Color(0xFF73FDA3),
    ),
    BodyPartItem(
      id: 'feet',
      nameEn: 'Feet',
      nameUr: 'پاؤں',
      emoji: '🦶',
      taglineEn: 'Walk & Jump',
      speechEn: 'Feet love jumping and dancing on green grass!',
      speechUr: 'پاؤں گھاس پر کودنا اور ناچنا پسند کرتے ہیں!',
      cardColor: const Color(0xFF78D1FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    activePart = bodyPartsList[0];
    _loadStarsFromDB();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.35);
      await flutterTts.setPitch(1.1);
      await flutterTts.setVolume(1.0);
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  void _speakText(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void _loadStarsFromDB() async {
    int stars = await DatabaseHelper.instance.getStars();
    if (!mounted) return;
    setState(() {
      totalStars = stars;
    });
  }

  void _saveStarsToDB(int newStars) async {
    setState(() {
      totalStars = newStars;
    });
    await DatabaseHelper.instance.updateStars(newStars);
  }

  void _updateActivePart(BodyPartItem part) {
    setState(() {
      activePart = part;
    });
    _speakText(part.speechEn);
  }

  void _openTouchGameScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TouchAndFindChallengeScreen(
          initialStars: totalStars,
          onStarsUpdated: (newStars) {
            _saveStarsToDB(newStars);
          },
        ),
      ),
    );
  }

  void _open3DPuzzleScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssembleBuddyPuzzleScreen(
          initialStars: totalStars,
          onStarsUpdated: (newStars) {
            _saveStarsToDB(newStars);
          },
        ),
      ),
    );
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
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                backgroundColor: const Color(0xFFFBF9F3),
                elevation: 0,
                leading: Center(
                  child: InkWell(
                    onTap: () => Navigator.maybePop(context),
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
                ),
                title: const Text(
                  'Body Parts Recognition',
                  style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                ),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2A1800))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFC2E8FF),
                            child: Text('👧', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF73FDA3).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🌟', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 6),
                        Text(
                          'Safe Toddler Zone • 100% Offline Audio & Touch • Zero Timers',
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004422)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 4), blurRadius: 0)],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isPlayGroup = true),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPlayGroup ? const Color(0xFFF0EEE8) : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: isPlayGroup ? Border.all(color: const Color(0xFFDBDAD4)) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('🧸', style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Play Group', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                          const SizedBox(width: 6),
                                          if (isPlayGroup) const Icon(Icons.check_circle, size: 16, color: Color(0xFF006D39)),
                                        ],
                                      ),
                                      const Text('3-4 Years • Guided Touch & Voice', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF6E7980))),
                                    ],
                                  ),
                                ),
                                if (isPlayGroup)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(10)),
                                    child: const Text('ACTIVE', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF004422))),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => isPlayGroup = false),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: !isPlayGroup ? const Color(0xFFF0EEE8) : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: !isPlayGroup ? Border.all(color: const Color(0xFFDBDAD4)) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFFFDAD6), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('🎒', style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Kindergarten', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                          const SizedBox(width: 6),
                                          if (!isPlayGroup) const Icon(Icons.check_circle, size: 16, color: Color(0xFF006D39)),
                                        ],
                                      ),
                                      const Text('4-5 Years • Matching & Puzzles', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF6E7980))),
                                    ],
                                  ),
                                ),
                                if (!isPlayGroup)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(10)),
                                    child: const Text('ACTIVE', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF004422))),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 20)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('👆', style: TextStyle(fontSize: 13)),
                              SizedBox(width: 6),
                              Text('Tap glowing spots to hear names!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF001E2C))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 240,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF2E6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text('👧', style: TextStyle(fontSize: 110)),
                                ),
                              ),
                              _hotspotPin(top: 35, left: 2, part: bodyPartsList[0]),
                              _hotspotPin(top: 35, right: 2, part: bodyPartsList[1]),
                              _hotspotPin(top: 105, left: 12, part: bodyPartsList[2]),
                              _hotspotPin(top: 135, right: 12, part: bodyPartsList[3]),
                              _hotspotPin(bottom: 2, part: bodyPartsList[4]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFC2E8FF).withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _updateActivePart(activePart),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                                  child: const Icon(Icons.volume_up, color: Colors.white, size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '"${activePart.speechEn}"',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF003F57)),
                                    ),
                                    Text(
                                      activePart.speechUr,
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, color: Color(0xFF006689)),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => _updateActivePart(activePart),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.replay, size: 18, color: Color(0xFF6E7980)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('Explore Body Parts', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                          SizedBox(width: 6),
                          Text('🎈', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
                        child: const Text('+3 Stars 🌟', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.15,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: bodyPartsList.length,
                    itemBuilder: (context, index) {
                      final item = bodyPartsList[index];
                      return InkWell(
                        onTap: () => _updateActivePart(item),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 4), blurRadius: 0)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: item.cardColor.withOpacity(0.5), shape: BoxShape.circle),
                                    child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                                    child: const Icon(Icons.volume_up, size: 14, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.nameEn, style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                  Text(item.nameUr, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                ],
                              ),
                              Text(item.taglineEn, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF6E7980))),
                              const Row(
                                children: [
                                  Text('⭐ ⭐ ⭐', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  const Text('Fun Play & Practice 🎮', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isPlayGroup ? const Color(0xFFFFDDB6) : const Color(0xFFC2E8FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(isPlayGroup ? '🎯' : '🧩', style: const TextStyle(fontSize: 22)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                isPlayGroup ? 'Play Group • ⭐ +3 Stars' : 'Kindergarten • ⭐ +3 Stars',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isPlayGroup ? 'Touch & Find Challenge' : 'Assemble Buddy Puzzle',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPlayGroup
                              ? '"Where is buddy\'s Nose? Tap the nose to win stars!"'
                              : '"Drag & snap missing body parts onto Buddy\'s figure to win stars!"',
                          style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                        ),
                        Text(
                          isPlayGroup
                              ? '"دوست کی ناک کہاں ہے؟ ستارے جیتنے کے لیے ناک کو چھوئیں!"'
                              : '"مسنگ باڈی پارٹس کو گھسیٹ کر Buddy کی باڈی پر فٹ کریں!"',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, color: Color(0xFF006689)),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPlayGroup ? const Color(0xFF24BC6B) : const Color(0xFFFFAA1D),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            onPressed: isPlayGroup ? _openTouchGameScreen : _open3DPuzzleScreen,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isPlayGroup ? 'Start Touch Game' : 'Start Puzzle Challenge',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isPlayGroup ? Colors.white : const Color(0xFF2A1800),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.play_circle_fill,
                                  color: isPlayGroup ? Colors.white : const Color(0xFF2A1800),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDDB6).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                          child: const Text('💡', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PARENT SENSORY TIP', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                              SizedBox(height: 2),
                              Text(
                                'Point to your own nose and ask your toddler to tap buddy\'s nose on screen to boost body awareness and tactile reflexes!',
                                style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF3E484F)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, size: 16, color: Color(0xFF006689)),
                      label: const Text('Back to All Modules', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
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

  Widget _hotspotPin({double? top, double? bottom, double? left, double? right, required BodyPartItem part}) {
    final bool isSelected = activePart.id == part.id;
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: () => _updateActivePart(part),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF006689) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? const Color(0xFF006D39) : const Color(0xFF006689), width: 1.5),
            boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(part.emoji, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 4),
              Text(
                '${part.nameEn}  ${part.nameUr}',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1B1C19),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= TOUCH & FIND CHALLENGE SCREEN =================
class TouchAndFindChallengeScreen extends StatefulWidget {
  final int initialStars;
  final ValueChanged<int> onStarsUpdated;

  const TouchAndFindChallengeScreen({Key? key, required this.initialStars, required this.onStarsUpdated}) : super(key: key);

  @override
  State<TouchAndFindChallengeScreen> createState() => _TouchAndFindChallengeScreenState();
}

class _TouchAndFindChallengeScreenState extends State<TouchAndFindChallengeScreen> with SingleTickerProviderStateMixin {
  late int stars;
  bool isCorrectGuessed = false;
  String feedbackMessage = "";

  final List<Map<String, String>> challenges = [
    {"part": "Nose", "labelUr": "ناک", "emoji": "👃"},
    {"part": "Eyes", "labelUr": "آنکھیں", "emoji": "👁️"},
    {"part": "Ears", "labelUr": "کان", "emoji": "👂"},
    {"part": "Mouth", "labelUr": "منہ", "emoji": "👄"},
    {"part": "Hands", "labelUr": "ہاتھ", "emoji": "✋"},
    {"part": "Feet", "labelUr": "پاؤں", "emoji": "🦶"},
  ];

  int currentIndex = 0;

  String? blinkingPartName;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    stars = widget.initialStars;

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _speakCurrentPrompt();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void _speakCurrentPrompt() async {
    final current = challenges[currentIndex];
    try {
      await flutterTts.stop();
      await flutterTts.speak("Where is Buddy's ${current['part']}? Tap the ${current['part']}!");
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void _speakText(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void triggerBlink(String partName) {
    setState(() {
      blinkingPartName = partName;
    });
    _blinkController.forward().then((_) {
      _blinkController.reverse().then((_) {
        setState(() {
          blinkingPartName = null;
        });
      });
    });
  }

  void handleGuess(String selectedPart) {
    final correctPart = challenges[currentIndex]['part']!;
    if (selectedPart == correctPart) {
      setState(() {
        isCorrectGuessed = true;
        stars += 3;
        widget.onStarsUpdated(stars);
        feedbackMessage = "Awesome Job! You found Buddy's $correctPart! 🎉 (+3 Stars)";
      });
      triggerBlink(correctPart);
      _speakText("Awesome job! You found Buddy's $correctPart!");

      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          isCorrectGuessed = false;
          feedbackMessage = "";
          currentIndex = (currentIndex + 1) % challenges.length;
        });
        _speakCurrentPrompt();
      });
    } else {
      setState(() {
        feedbackMessage = "Oops! That is $selectedPart. Look at the blinking $correctPart! ✨";
      });
      triggerBlink(correctPart);
      _speakText("Oops! Try finding the $correctPart!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = challenges[currentIndex];

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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                    ),
                  ),
                ),
                title: const Text('Touch & Find Challenge', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text('$stars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2A1800))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _speakCurrentPrompt,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                            child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Where is Buddy's ${current['part']}? Tap it! ${current['emoji']}",
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF003F57)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "دوست کا ${current['labelUr']} کہاں ہے؟ اسے چھوئین!",
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF006689)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Large Figure Card - ALLINCHASQA: BoxShapeData yupay pantaypas pichasqa
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [BoxShadow(color: Color(0x1440352C), blurRadius: 20, offset: Offset(0, 8))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF73FDA3).withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                          child: const Text('🌟 Full Body Interactive Buddy 🌟', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004422))),
                        ),
                        const SizedBox(height: 12),
                        
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9F2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFFFDDB6), width: 2),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('👧', style: TextStyle(fontSize: 110)),
                                  SizedBox(height: 10),
                                  Text('👕  👖', style: TextStyle(fontSize: 36)),
                                ],
                              ),

                              Positioned(top: 25, child: _bodyPartHotspot("Eyes", "👁️ Eyes")),
                              Positioned(top: 25, left: 25, child: _bodyPartHotspot("Ears", "👂 Ears")),
                              Positioned(top: 85, child: _bodyPartHotspot("Nose", "👃 Nose")),
                              Positioned(top: 115, child: _bodyPartHotspot("Mouth", "👄 Mouth")),
                              Positioned(bottom: 60, child: _bodyPartHotspot("Hands", "✋ Hands")),
                              Positioned(bottom: 10, child: _bodyPartHotspot("Feet", "🦶 Feet")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Buddy\'s Body Part:', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                  ),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
                    children: challenges.map((item) {
                      return _gameChoiceCard(item['part']!, item['emoji']!);
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  if (feedbackMessage.isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCorrectGuessed ? const Color(0xFF24BC6B) : const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isCorrectGuessed ? Icons.check_circle : Icons.error, color: isCorrectGuessed ? Colors.white : const Color(0xFF93000A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feedbackMessage,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCorrectGuessed ? Colors.white : const Color(0xFF93000A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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

  Widget _bodyPartHotspot(String partName, String label) {
    bool isBlinking = blinkingPartName == partName;
    return FadeTransition(
      opacity: isBlinking ? _blinkAnimation : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: () => handleGuess(partName),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF006689), width: 1.5),
            boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Text(
            label,
            style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
          ),
        ),
      ),
    );
  }

  Widget _gameChoiceCard(String partName, String emoji) {
    bool isBlinking = blinkingPartName == partName;
    return FadeTransition(
      opacity: isBlinking ? _blinkAnimation : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: () => handleGuess(partName),
        child: Container(
          decoration: BoxDecoration(
            color: isBlinking ? const Color(0xFFFFAA1D) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isBlinking ? Colors.red : const Color(0xFFEAE8E2), width: isBlinking ? 2 : 1),
            boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 5, offset: Offset(0, 3))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                partName,
                style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= KINDERGARTEN PUZZLE SCREEN =================
class AssembleBuddyPuzzleScreen extends StatefulWidget {
  final int initialStars;
  final ValueChanged<int> onStarsUpdated;

  const AssembleBuddyPuzzleScreen({Key? key, required this.initialStars, required this.onStarsUpdated}) : super(key: key);

  @override
  State<AssembleBuddyPuzzleScreen> createState() => _AssembleBuddyPuzzleScreenState();
}

class _AssembleBuddyPuzzleScreenState extends State<AssembleBuddyPuzzleScreen> {
  late int stars;
  int puzzleStage = 0;
  bool isCurrentStageSolved = false;
  String feedbackText = "";
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> puzzleStages = [
    {
      "target": "head",
      "instructionEn": "Drag and snap Buddy's Head! 🧩",
      "subEn": "Buddy's Head is missing! Drag the head onto Buddy's body!",
    },
    {
      "target": "hands",
      "instructionEn": "Drag and snap Buddy's Hands! ✋",
      "subEn": "Buddy's Hands are missing! Drag the hands onto Buddy!",
    },
    {
      "target": "feet",
      "instructionEn": "Drag and snap Buddy's Feet! 🦶",
      "subEn": "Buddy's Feet are missing! Drag the feet at the bottom!",
    },
  ];

  @override
  void initState() {
    super.initState();
    stars = widget.initialStars;
  }

  void _speak(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS error: $e");
    }
  }

  void handleItemDropped(String droppedItem) {
    String currentTarget = puzzleStages[puzzleStage]["target"];
    if (droppedItem == currentTarget) {
      setState(() {
        isCurrentStageSolved = true;
        stars += 3;
        widget.onStarsUpdated(stars);
        feedbackText = "Well Done! 🎉 Buddy is Assembled!";
      });
      _speak("Awesome snapping! Buddy is Assembled!");
    } else {
      setState(() {
        feedbackText = "Oops! Try Again! ❌ Wrong part dropped!";
      });
      _speak("Oops! Try Again!");
    }
  }

  void nextPuzzle() {
    if (puzzleStage < puzzleStages.length - 1) {
      setState(() {
        puzzleStage++;
        isCurrentStageSolved = false;
        feedbackText = "";
      });
      _speak(puzzleStages[puzzleStage]["instructionEn"]);
    } else {
      setState(() {
        feedbackText = "🏆 All Puzzles Completed! You are a Master!";
      });
      _speak("All Puzzles Completed! You are a Master!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final stageData = puzzleStages[puzzleStage];

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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                    ),
                  ),
                ),
                title: const Text('Assemble Buddy Puzzle', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text('$stars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('🏆 Level ${puzzleStage + 1} of 3', style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                              child: const Text('Kindergarten • ⭐ +3 Stars', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Container(height: 8, decoration: BoxDecoration(color: puzzleStage >= 0 ? const Color(0xFF006D39) : const Color(0xFFE4E2DD), borderRadius: BorderRadius.circular(4)))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 8, decoration: BoxDecoration(color: puzzleStage >= 1 ? const Color(0xFF006D39) : const Color(0xFFE4E2DD), borderRadius: BorderRadius.circular(4)))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 8, decoration: BoxDecoration(color: puzzleStage >= 2 ? const Color(0xFF006D39) : const Color(0xFFE4E2DD), borderRadius: BorderRadius.circular(4)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFC2E8FF).withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _speak(stageData["instructionEn"]),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.volume_up, color: Colors.white, size: 18),
                                Text('TAP ME', style: TextStyle(fontFamily: 'Rubik', fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stageData["instructionEn"], style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF003F57))),
                              const SizedBox(height: 2),
                              Text(stageData["subEn"], style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF3E484F))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DragTarget<String>(
                                onAccept: (data) => handleItemDropped(data),
                                builder: (context, candidateData, rejectedData) {
                                  bool isHeadSolved = isCurrentStageSolved || puzzleStage > 0;
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: isHeadSolved ? const Color(0xFFFFF2E6) : const Color(0xFFEAE8E2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isHeadSolved ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                        width: isHeadSolved ? 2 : 3,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: isHeadSolved
                                        ? const Text('👧', style: TextStyle(fontSize: 55))
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.help_outline, color: Color(0xFFFFAA1D), size: 26),
                                              Text('MISSING HEAD', style: TextStyle(fontFamily: 'Rubik', fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                            ],
                                          ),
                                  );
                                },
                              ),
                              const SizedBox(height: 6),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DragTarget<String>(
                                    onAccept: (data) => handleItemDropped(data),
                                    builder: (context, candidateData, rejectedData) {
                                      bool isHandsSolved = isCurrentStageSolved ? puzzleStage >= 1 : puzzleStage > 1;
                                      return Container(
                                        width: 45,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: isHandsSolved ? const Color(0xFF73FDA3).withOpacity(0.3) : const Color(0xFFEAE8E2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isHandsSolved ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                            width: isHandsSolved ? 1.5 : 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(isHandsSolved ? '✋' : '❓', style: TextStyle(fontSize: isHandsSolved ? 24 : 16)),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 85,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2BB0E6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('👕', style: TextStyle(fontSize: 28)),
                                        Text('Body ✓', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  DragTarget<String>(
                                    onAccept: (data) => handleItemDropped(data),
                                    builder: (context, candidateData, rejectedData) {
                                      bool isHandsSolved = isCurrentStageSolved ? puzzleStage >= 1 : puzzleStage > 1;
                                      return Container(
                                        width: 45,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: isHandsSolved ? const Color(0xFF73FDA3).withOpacity(0.3) : const Color(0xFFEAE8E2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isHandsSolved ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                            width: isHandsSolved ? 1.5 : 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(isHandsSolved ? '🤚' : '❓', style: TextStyle(fontSize: isHandsSolved ? 24 : 16)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              DragTarget<String>(
                                onAccept: (data) => handleItemDropped(data),
                                builder: (context, candidateData, rejectedData) {
                                  bool isFeetSolved = isCurrentStageSolved ? puzzleStage == 2 : false;
                                  return Container(
                                    width: 100,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: isFeetSolved ? const Color(0xFF78D1FF).withOpacity(0.3) : const Color(0xFFEAE8E2),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isFeetSolved ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                        width: isFeetSolved ? 1.5 : 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: isFeetSolved
                                        ? const Text('🦶  🦶', style: TextStyle(fontSize: 22))
                                        : const Text('MISSING FEET ❓', style: TextStyle(fontFamily: 'Rubik', fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('SNAP UPWARDS TO ATTACH! ⬆️', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFFAA1D))),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _imageDraggableCard("head", "👧", "Head"),
                              _imageDraggableCard("hands", "✋", "Hands"),
                              _imageDraggableCard("feet", "🦶", "Feet"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (isCurrentStageSolved) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('🎉', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 6),
                              Text('Buddy is Assembled!', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(width: 6),
                              Text('⭐', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFB958), borderRadius: BorderRadius.circular(12)),
                            child: const Text('⭐ +3 Stars Collected!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFAA1D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                        onPressed: nextPuzzle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('NEXT PUZZLE', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Color(0xFF2A1800)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (feedbackText.isNotEmpty && !isCurrentStageSolved)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(feedbackText, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red)),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23))),
                      onPressed: () => _speak(stageData["instructionEn"]),
                      child: Row(
                        // ALLINCHASQA: MainDataFrame chantamanta MainAxisAlignment allinchasqa
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.replay, color: Color(0xFF006689), size: 18),
                          SizedBox(width: 6),
                          Text('Hear Instruction', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
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
    );
  }

  Widget _imageDraggableCard(String id, String emoji, String label) {
    return Draggable<String>(
      data: id,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(color: Color(0xFFFFB958), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 38)),
        ),
      ),
      childWhenDragging: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 28, color: Colors.grey)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB958),
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Color(0xFFD98800), offset: Offset(0, 3))],
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
        ],
      ),
    );
  }
}