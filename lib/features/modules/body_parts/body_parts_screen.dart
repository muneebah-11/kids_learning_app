import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WonderKidsApp());
}

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
    await db.insert('user_progress', {'totalStars': 0, 'masteredCount': 0});
  }

  Future<int> getStars() async {
    final db = await instance.database;
    final result = await db.query('user_progress');
    if (result.isNotEmpty) {
      return result.first['totalStars'] as int;
    }
    return 0;
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
  final String taglineUr;
  final String speechEn;
  final String speechUr;
  final Color cardColor;

  BodyPartItem({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.emoji,
    required this.taglineEn,
    required this.taglineUr,
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

class _BodyPartsHomeScreenState extends State<BodyPartsHomeScreen> with SingleTickerProviderStateMixin {
  bool isPlayGroup = true;
  int totalStars = 0;
  bool isUrduLanguage = false;

  late BodyPartItem activePart;
  final FlutterTts flutterTts = FlutterTts();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<BodyPartItem> bodyPartsList = [
    BodyPartItem(
      id: 'eyes',
      nameEn: 'Eyes',
      nameUr: 'آنکھیں',
      emoji: '👁️',
      taglineEn: 'Sense of Sight',
      taglineUr: 'دیکھنے کی حس',
      speechEn: 'These are my Eyes! I see colors & friends!',
      speechUr: 'یہ میری آنکھیں ہیں! میں رنگ اور دوست دیکھتا ہوں!',
      cardColor: const Color(0xFFD0EFFF),
    ),
    BodyPartItem(
      id: 'ears',
      nameEn: 'Ears',
      nameUr: 'کان',
      emoji: '👂',
      taglineEn: 'Hearing & Music',
      taglineUr: 'سننے کی حس',
      speechEn: 'These are my Ears! I hear soft songs and birds!',
      speechUr: 'یہ میرے کان ہیں! میں گانے اور پرندے سنتا ہوں!',
      cardColor: const Color(0xFFFFE5C4),
    ),
    BodyPartItem(
      id: 'nose',
      nameEn: 'Nose',
      nameUr: 'ناک',
      emoji: '👃',
      taglineEn: 'Sense of Smell',
      taglineUr: 'سونگھنے کی حس',
      speechEn: 'This is my Nose! I smell sweet cookies and flowers!',
      speechUr: 'یہ میری ناک ہے! میں مٹھائی اور پھول سونگھتا ہوں!',
      cardColor: const Color(0xFFE2F7E2),
    ),
    BodyPartItem(
      id: 'mouth',
      nameEn: 'Mouth',
      nameUr: 'منہ',
      emoji: '👄',
      taglineEn: 'Taste & Talk',
      taglineUr: 'بولنے اور چکھنے کی حس',
      speechEn: 'This is my Mouth! I smile, sing and eat yummy snacks!',
      speechUr: 'یہ میرا منہ ہے! میں مسکراتا ہوں اور کھانا کھاتا ہوں!',
      cardColor: const Color(0xFFFFDBE5),
    ),
    BodyPartItem(
      id: 'hands',
      nameEn: 'Hands',
      nameUr: 'ہاتھ',
      emoji: '✋',
      taglineEn: 'Touch & Clap',
      taglineUr: 'چھونا اور تالی بجانا',
      speechEn: 'These are my Hands! Clap, clap, clap your hands!',
      speechUr: 'یہ میرے ہاتھ ہیں! تالیاں بجائیں!',
      cardColor: const Color(0xFFEAE0FF),
    ),
    BodyPartItem(
      id: 'feet',
      nameEn: 'Feet',
      nameUr: 'پاؤں',
      emoji: '🦶',
      taglineEn: 'Walk & Jump',
      taglineUr: 'چلنا اور کودنا',
      speechEn: 'Feet love jumping and dancing on green grass!',
      speechUr: 'پاؤں گھاس پر کودنا اور ناچنا پسند کرتے ہیں!',
      cardColor: const Color(0xFFD8F3FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    activePart = bodyPartsList[0];
    _loadStarsFromDB();
    _initTts();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void _loadStarsFromDB() async {
    int stars = await DatabaseHelper.instance.getStars();
    setState(() {
      totalStars = stars;
    });
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
      debugPrint("TTS speak error: $e");
    }
  }

  void _updateActivePart(BodyPartItem part) {
    setState(() {
      activePart = part;
    });
    _speakText(isUrduLanguage ? part.speechUr : part.speechEn);
  }

  void _openTouchGameScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TouchAndFindChallengeScreen(
          initialStars: totalStars,
          onStarsUpdated: (newStars) {
            setState(() {
              totalStars = newStars;
            });
            DatabaseHelper.instance.updateStars(newStars);
          },
        ),
      ),
    );
  }

  void _openAssembleBuddyPuzzle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssembleBuddyPuzzleScreen(
          initialStars: totalStars,
          onStarsUpdated: (newStars) {
            setState(() {
              totalStars = newStars;
            });
            DatabaseHelper.instance.updateStars(newStars);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0EEE8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 22),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Body Parts Recognition',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => setState(() => isUrduLanguage = !isUrduLanguage),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2E8FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF006689), width: 1.5),
                                ),
                                child: Text(
                                  isUrduLanguage ? 'اردو 🇵🇰' : 'ENG GB',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003F57),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$totalStars',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF2A1800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEE8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPlayGroup = true),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC2E8FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('🧸', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              isUrduLanguage ? 'پلے گروپ' : 'Play Group',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: isPlayGroup ? const Color(0xFF006689) : const Color(0xFF1B1C19),
                                              ),
                                            ),
                                            if (isPlayGroup) ...[
                                              const SizedBox(width: 4),
                                              const Icon(Icons.check_circle, size: 14, color: Color(0xFF006D39)),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          isUrduLanguage ? '۳-۴ سال' : '3-4 Years',
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF6E7980)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPlayGroup = false),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: !isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE4E2DD),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('🎒', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              isUrduLanguage ? 'کنڈرگارٹن' : 'Kindergarten',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: !isPlayGroup ? const Color(0xFF006689) : const Color(0xFF1B1C19),
                                              ),
                                            ),
                                            if (!isPlayGroup) ...[
                                              const SizedBox(width: 4),
                                              const Icon(Icons.check_circle, size: 14, color: Color(0xFF006D39)),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          isUrduLanguage ? '۴-۵ سال' : '4-5 Years',
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF6E7980)),
                                        ),
                                      ],
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

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 20)
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC2E8FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('👆', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                isUrduLanguage
                                    ? 'نام پر کلک کریں اور باڈی پارٹ کو چمکتا ہوا دیکھیں!'
                                    : 'Tap names to see body parts blink on image!',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001E2C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 380,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 240,
                                height: 350,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox(
                                        width: 240,
                                        height: 350,
                                        child: Image.asset(
                                          'assets/images/buddy_character.png',
                                          fit: BoxFit.cover,
                                          alignment: const Alignment(0, -0.2),
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/buddy character .png',
                                              fit: BoxFit.cover,
                                              errorBuilder: (ctx, err, st) => const Center(
                                                child: Icon(Icons.person, size: 100, color: Colors.orangeAccent),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    _buildSmallBlinkingDot(),
                                  ],
                                ),
                              ),

                              _chartHotspotPin(top: 30, left: 0, part: bodyPartsList[0]),
                              _chartHotspotPin(top: 110, left: 0, part: bodyPartsList[2]),
                              _chartHotspotPin(top: 190, left: 0, part: bodyPartsList[4]),

                              _chartHotspotPin(top: 50, right: 0, part: bodyPartsList[1]),
                              _chartHotspotPin(top: 130, right: 0, part: bodyPartsList[3]),
                              _chartHotspotPin(top: 290, right: 0, part: bodyPartsList[5]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: activePart.cardColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _updateActivePart(activePart),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2BB0E6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.volume_up, color: Colors.white, size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '"${isUrduLanguage ? activePart.speechUr : activePart.speechEn}"',
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF003F57),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => _updateActivePart(activePart),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
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
                        children: [
                          Text(
                            isUrduLanguage ? 'جسم کے اعضا دریافت کریں' : 'Explore Body Parts',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1C19),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('🎈', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDDB6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isUrduLanguage ? '+۳ ستارے 🌟' : '+3 Stars 🌟',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF845400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: bodyPartsList.length,
                    itemBuilder: (context, index) {
                      final item = bodyPartsList[index];
                      return InkWell(
                        onTap: () => _updateActivePart(item),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 4), blurRadius: 0)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.volume_up, size: 16, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nameEn,
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B1C19),
                                    ),
                                  ),
                                  Text(
                                    item.taglineEn,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 10,
                                      color: Color(0xFF6E7980),
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text('⭐ ⭐ ⭐', style: TextStyle(fontSize: 9, color: Colors.amber)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  if (isPlayGroup) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)
                        ],
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
                                  color: const Color(0xFFFFDDB6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Text('🎯', style: TextStyle(fontSize: 22)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDDB6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  isUrduLanguage ? 'پلے گروپ • ⭐ +۳ ستارے' : 'Play Group • ⭐ +3 Stars',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF845400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isUrduLanguage ? 'ٹچ اینڈ فائنڈ چیلنج' : 'Touch & Find Challenge',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1C19),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUrduLanguage
                                ? '"دوست کی ناک کہاں ہے؟ ستارے جیتنے کے لیے ناک کو چھوئیں!"'
                                : '"Where is buddy\'s Nose? Tap the nose to win stars!"',
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006689),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF24BC6B),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: _openTouchGameScreen,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isUrduLanguage ? 'ٹچ گیم شروع کریں' : 'Start Touch Game',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.play_circle_fill, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)
                        ],
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
                                  color: const Color(0xFF73FDA3).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.extension, color: Color(0xFF006D39), size: 24),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF73FDA3).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  isUrduLanguage ? 'کنڈرگارٹن • ⭐ +۳ ستارے' : 'Kindergarten • ⭐ +3 Stars',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF004422),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isUrduLanguage ? 'اسمبل دی بڈی پزل' : 'Assemble the Buddy Puzzle',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1C19),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUrduLanguage
                                ? 'سر، ہاتھ اور ٹانگیں ڈریگ کر کے بڈی کو مکمل کریں!'
                                : 'Drag and snap buddy\'s head, arms, and legs together!',
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006D39),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006D39),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: _openAssembleBuddyPuzzle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isUrduLanguage ? 'اسمبل پزل شروع کریں' : 'Start Assemble Puzzle',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.extension, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chartHotspotPin({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required BodyPartItem part,
  }) {
    final bool isSelected = activePart.id == part.id;
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: InkWell(
        onTap: () => _updateActivePart(part),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF006D39) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF004422) : const Color(0xFF006689),
              width: 1.8,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x1A000000), offset: Offset(0, 3), blurRadius: 4)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(part.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                isUrduLanguage ? part.nameUr : part.nameEn,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12,
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

  Widget _buildSmallBlinkingDot() {
    double top = 0;
    double left = 0;
    double size = 15.0;

    switch (activePart.id) {
      case 'eyes':
        top = 70.0;
        left = 112.0;
        size = 14.0;
        break;
      case 'ears':
        top = 70.0;
        left = 94.0;
        size = 13.0;
        break;
      case 'nose':
        top = 80.0;
        left = 115.0;
        size = 12.0;
        break;
      case 'mouth':
        top = 90.0;
        left = 114.0;
        size = 13.0;
        break;
      case 'hands':
        top = 175.0;
        left = 140.0;
        size = 18.0;
        break;
      case 'feet':
        top = 295.0;
        left = 115.0;
        size = 18.0;
        break;
      default:
        top = 70.0;
        left = 112.0;
    }

    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF3B30).withOpacity(_pulseAnimation.value * 0.75),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3B30).withOpacity(_pulseAnimation.value),
                  blurRadius: 6 * _pulseAnimation.value,
                  spreadRadius: 2 * _pulseAnimation.value,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// 🎯 TOUCH & FIND CHALLENGE GAME SCREEN (Play Group)
// =========================================================================
class TouchAndFindChallengeScreen extends StatefulWidget {
  final int initialStars;
  final ValueChanged<int> onStarsUpdated;

  const TouchAndFindChallengeScreen({
    Key? key,
    required this.initialStars,
    required this.onStarsUpdated,
  }) : super(key: key);

  @override
  State<TouchAndFindChallengeScreen> createState() => _TouchAndFindChallengeScreenState();
}

class _TouchAndFindChallengeScreenState extends State<TouchAndFindChallengeScreen> {
  late int stars;
  int currentRound = 1;
  bool isAnswerCorrect = false;
  String errorMessage = "";
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> roundsData = [
    {
      'target': 'nose',
      'en': 'Where is Buddy\'s Nose? Tap the Nose!',
      'ur': 'دوست کی ناک کہاں ہے؟ ناک کو چھوئیں!',
      'phonics': 'Phonics: /n/ /n/ Nose',
    },
    {
      'target': 'eyes',
      'en': 'Where are Buddy\'s Eyes? Tap the Eyes!',
      'ur': 'دوست کی آنکھیں کہاں ہیں؟ آنکھوں کو چھوئیں!',
      'phonics': 'Phonics: /e/ /e/ Eyes',
    },
    {
      'target': 'ears',
      'en': 'Where are Buddy\'s Ears? Tap the Ears!',
      'ur': 'دوست کے کان کہاں ہیں؟ کانوں کو چھوئیں!',
      'phonics': 'Phonics: /ea/ /ea/ Ears',
    },
    {
      'target': 'mouth',
      'en': 'Where is Buddy\'s Mouth? Tap the Mouth!',
      'ur': 'دوست کا منہ کہاں ہے؟ منہ کو چھوئیں!',
      'phonics': 'Phonics: /m/ /m/ Mouth',
    },
    {
      'target': 'hands',
      'en': 'Where are Buddy\'s Hands? Tap the Hands!',
      'ur': 'دوست کے ہاتھ کہاں ہیں؟ ہاتھوں کو چھوئیں!',
      'phonics': 'Phonics: /h/ /h/ Hands',
    },
  ];

  @override
  void initState() {
    super.initState();
    stars = widget.initialStars;
    _speakQuestion();
  }

  void _speakQuestion() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak(roundsData[currentRound - 1]['en']);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  void _onBodyPartTap(String part) {
    String target = roundsData[currentRound - 1]['target'];
    setState(() {
      if (part == target) {
        isAnswerCorrect = true;
        errorMessage = "";
        stars += 3;
        widget.onStarsUpdated(stars);
        flutterTts.speak("Awesome job! You found it!");
      } else {
        isAnswerCorrect = false;
        errorMessage = "Wrong! Please select the correct Buddy's $target.";
        flutterTts.speak("Oops! Try again.");
      }
    });
  }

  void _nextQuestion() {
    if (currentRound < 5) {
      setState(() {
        currentRound++;
        isAnswerCorrect = false;
        errorMessage = "";
      });
      _speakQuestion();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var roundInfo = roundsData[currentRound - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Color(0x10000000), blurRadius: 6, offset: Offset(0, 2))
                            ],
                          ),
                          child: const Icon(Icons.chevron_left, color: Color(0xFF1B1C19), size: 28),
                        ),
                      ),
                      Column(
                        children: const [
                          Text(
                            'WONDERKIDS PLAY',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006689),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Touch & Find ...',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B1C19),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFAA1D),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  '$stars',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF2A1800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFFFDDB6),
                            child: const Text('👶', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.emoji_events, color: Color(0xFFFFAA1D), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Round $currentRound of 5',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B1C19),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F7E2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(radius: 3, backgroundColor: Color(0xFF24BC6B)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Target: $currentRound / 5',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006D39),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            int rNum = index + 1;
                            bool isDone = rNum < currentRound;
                            bool isActive = rNum == currentRound;
                            bool isLocked = rNum > currentRound;
                            return _buildRoundBadge('R-$rNum', isDone: isDone, isActive: isActive, isLocked: isLocked);
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: _speakQuestion,
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2BB0E6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.volume_up, color: Colors.white, size: 20),
                                    Text(
                                      'TAP ME',
                                      style: TextStyle(
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDDB6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Question $currentRound',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF845400),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2F7E2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '🗣️ ${roundInfo['phonics']}',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006D39),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          roundInfo['en'],
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003F57),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          roundInfo['ur'],
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF845400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    height: 290,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('👶', style: TextStyle(fontSize: 80)),
                          ),
                        ),
                        Positioned(
                          top: 105,
                          left: 95,
                          child: _buildPartTag('👁️ Eyes', onTap: () => _onBodyPartTap('eyes')),
                        ),
                        Positioned(
                          top: 105,
                          right: 95,
                          child: _buildPartTag('👂 Ears', onTap: () => _onBodyPartTap('ears')),
                        ),
                        Positioned(
                          top: 125,
                          left: 135,
                          child: _buildPartTag('👃 Nose', onTap: () => _onBodyPartTap('nose')),
                        ),
                        Positioned(
                          top: 152,
                          left: 135,
                          child: _buildPartTag('👄 Mouth', onTap: () => _onBodyPartTap('mouth')),
                        ),
                        Positioned(
                          bottom: 45,
                          child: _buildPartTag('✋ Hands', onTap: () => _onBodyPartTap('hands')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF93000A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (isAnswerCorrect)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F7E2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF24BC6B), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '🎉 Woohoo! Super Star!',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004422),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '⭐ +3 Golden Stars Collected! Excellent job!',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF845400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA1D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: _nextQuestion,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentRound < 5 ? 'NEXT QUESTION' : 'FINISH ROUNDS',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A1800),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right, color: Color(0xFF2A1800), size: 22),
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

  Widget _buildRoundBadge(
    String label, {
    bool isDone = false,
    bool isActive = false,
    bool isLocked = false,
  }) {
    Color bg = Colors.white;
    Color border = const Color(0xFFE0E0E0);
    Widget icon = Text(
      label,
      style: const TextStyle(
        fontFamily: 'Rubik',
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6E7980),
      ),
    );

    if (isDone) {
      bg = const Color(0xFFFFAA1D);
      border = const Color(0xFFFFAA1D);
      icon = const Icon(Icons.star, color: Colors.white, size: 16);
    } else if (isActive) {
      bg = const Color(0xFF2BB0E6);
      border = const Color(0xFF2BB0E6);
      icon = const Icon(Icons.auto_awesome, color: Colors.white, size: 14);
    } else if (isLocked) {
      bg = const Color(0xFFF0EEE8);
      icon = const Icon(Icons.lock, color: Color(0xFFB0BEC5), size: 14);
    }

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: border),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF2BB0E6) : const Color(0xFF6E7980),
          ),
        ),
      ],
    );
  }

  Widget _buildPartTag(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: const [
            BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1C19),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 🧩 ASSEMBLE BUDDY PUZZLE SCREEN (Cleaned: No Auto-Snap, No Offline Text, 0 Stars Start)
// =========================================================================
class AssembleBuddyPuzzleScreen extends StatefulWidget {
  final int initialStars;
  final ValueChanged<int> onStarsUpdated;

  const AssembleBuddyPuzzleScreen({
    Key? key,
    required this.initialStars,
    required this.onStarsUpdated,
  }) : super(key: key);

  @override
  State<AssembleBuddyPuzzleScreen> createState() => _AssembleBuddyPuzzleScreenState();
}

class _AssembleBuddyPuzzleScreenState extends State<AssembleBuddyPuzzleScreen> {
  late int stars;
  int currentLevel = 1; // 1: Head, 2: Arms, 3: Legs
  
  bool isHeadSnapped = false;
  bool isArmsSnapped = false;
  bool isLegsSnapped = false;
  bool isUrduPuzzleLang = false;

  @override
  void initState() {
    super.initState();
    stars = widget.initialStars; // Will be 0 initially as requested
  }

  void onPartDropped(String partType) {
    setState(() {
      if (partType == 'head' && !isHeadSnapped) {
        isHeadSnapped = true;
        stars += 3;
        widget.onStarsUpdated(stars);
      } else if (partType == 'arms' && !isArmsSnapped) {
        isArmsSnapped = true;
        stars += 3;
        widget.onStarsUpdated(stars);
      } else if (partType == 'legs' && !isLegsSnapped) {
        isLegsSnapped = true;
        stars += 3;
        widget.onStarsUpdated(stars);
      }
    });
  }

  void handleNextPuzzle() {
    setState(() {
      if (currentLevel == 1) {
        if (isHeadSnapped) {
          currentLevel = 2; // Move to Arms
        }
      } else if (currentLevel == 2) {
        if (isArmsSnapped) {
          currentLevel = 3; // Move to Legs
        }
      } else if (currentLevel == 3) {
        if (isLegsSnapped) {
          Navigator.pop(context); // Finish puzzle
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentDone = (currentLevel == 1 && isHeadSnapped) ||
        (currentLevel == 2 && isArmsSnapped) ||
        (currentLevel == 3 && isLegsSnapped);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0EEE8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 22),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Assemble Buddy',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$stars',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF2A1800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => isUrduPuzzleLang = !isUrduPuzzleLang),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2E8FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF006689), width: 1.5),
                                ),
                                child: Text(
                                  isUrduPuzzleLang ? 'اردو 🇵🇰' : 'ENG 🇬🇧',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003F57),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Level Status Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 6), blurRadius: 16)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🏆', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  isUrduPuzzleLang ? 'لیول $currentLevel از ۳' : 'Level $currentLevel of 3',
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF006689),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isUrduPuzzleLang ? 'ماسٹر کوئز' : 'Master Quiz',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF845400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC2E8FF).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.school, size: 16, color: Color(0xFF006689)),
                              const SizedBox(width: 6),
                              Text(
                                isUrduPuzzleLang
                                    ? 'کنڈرگارٹن موڈ (عمر ۴-۵) • ڈریگ اینڈ سنپ'
                                    : 'Kindergarten Mode (Ages 4-5) • Drag & Snap',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003F57),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isHeadSnapped ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isArmsSnapped
                                      ? const Color(0xFF006D39)
                                      : (currentLevel >= 2 ? const Color(0xFFFFAA1D) : const Color(0xFFE4E2DD)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isLegsSnapped
                                      ? const Color(0xFF006D39)
                                      : (currentLevel >= 3 ? const Color(0xFFFFAA1D) : const Color(0xFFE4E2DD)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(isUrduPuzzleLang ? 'سر' : 'Head', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, color: isHeadSnapped ? const Color(0xFF006D39) : const Color(0xFF6E7980), fontWeight: FontWeight.bold)),
                            Text(isUrduPuzzleLang ? 'بازو' : 'Arms', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, color: isArmsSnapped ? const Color(0xFF006D39) : const Color(0xFF6E7980), fontWeight: FontWeight.bold)),
                            Text(isUrduPuzzleLang ? 'ٹانگیں' : 'Legs', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, color: isLegsSnapped ? const Color(0xFF006D39) : const Color(0xFF6E7980), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Audio Prompt Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2E8FF).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x14006689), offset: Offset(0, 4), blurRadius: 12)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2BB0E6),
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.volume_up, color: Colors.white, size: 22),
                              Text('TAP ME', style: TextStyle(fontFamily: 'Rubik', fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentLevel == 1
                                    ? (isUrduPuzzleLang ? 'سر کا ایموجی ڈریگ کر کے اوپر رکھیں! 🧩' : 'Drag Buddy\'s Head Emoji Up! 🧩')
                                    : (currentLevel == 2
                                        ? (isUrduPuzzleLang ? 'بازو کا ایموجی ڈریگ کریں! 💪' : 'Drag Buddy\'s Arms Emoji Up! 💪')
                                        : (isUrduPuzzleLang ? 'ٹانگوں کا ایموجی ڈریگ کریں! 🦵' : 'Drag Buddy\'s Legs Emoji Up! 🦵')),
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003F57)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isUrduPuzzleLang ? 'مسنگ حصے کو نیچے سے اوپر ڈراپ کریں!' : 'Drop the missing part from below into place!',
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF3E484F), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Buddy Assembly Structure Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 28)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 280, minHeight: 310),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Head Drop Target & Display
                              DragTarget<String>(
                                onAccept: (receivedData) {
                                  if (receivedData == 'head') onPartDropped('head');
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: isHeadSnapped ? const Color(0xFFFFDDB6) : const Color(0xFFEAE8E2),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF73FDA3), width: 3),
                                    ),
                                    alignment: Alignment.center,
                                    child: isHeadSnapped
                                        ? const Text('👦', style: TextStyle(fontSize: 36))
                                        : const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.face, color: Color(0xFF006D39), size: 22),
                                              Text('HEAD', style: TextStyle(fontFamily: 'Rubik', fontSize: 8, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                  );
                                },
                              ),
                              const SizedBox(height: 6),

                              // Torso / Body Structure
                              Container(
                                width: 130,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2BB0E6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: const Text('👕 Torso', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                              const SizedBox(height: 6),

                              // Arms Drop Target & Display
                              DragTarget<String>(
                                onAccept: (receivedData) {
                                  if (receivedData == 'arms') onPartDropped('arms');
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 140,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: isArmsSnapped ? const Color(0xFFC2E8FF) : const Color(0xFFEAE8E2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF006689), width: 2),
                                    ),
                                    alignment: Alignment.center,
                                    child: isArmsSnapped
                                        ? const Text('💪 Arms Attached', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF003F57)))
                                        : const Text('➕ Missing Arms (Drop Here)', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                  );
                                },
                              ),
                              const SizedBox(height: 6),

                              // Legs Drop Target & Display
                              DragTarget<String>(
                                onAccept: (receivedData) {
                                  if (receivedData == 'legs') onPartDropped('legs');
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 120,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: isLegsSnapped ? const Color(0xFFE2F7E2) : const Color(0xFFEAE8E2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF24BC6B), width: 2),
                                    ),
                                    alignment: Alignment.center,
                                    child: isLegsSnapped
                                        ? const Text('🦵 Legs Attached', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004422)))
                                        : const Text('➕ Missing Legs (Drop Here)', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('DRAG MISSING PARTS UPWARDS! ⬆️', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFAA1D))),
                        const SizedBox(height: 14),

                        // Draggable Footer Tray (Persistent Emojis)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEE8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Head Draggable Emoji
                              Draggable<String>(
                                data: 'head',
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: const BoxDecoration(color: Color(0xFFFFB958), shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: const Text('👦', style: TextStyle(fontSize: 28)),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isHeadSnapped ? const Color(0xFF73FDA3) : const Color(0xFFFFB958),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(isHeadSnapped ? '✅' : '👦', style: const TextStyle(fontSize: 22)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(isUrduPuzzleLang ? 'سر' : 'Head', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              // Arms Draggable Emoji
                              Draggable<String>(
                                data: 'arms',
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: const BoxDecoration(color: Color(0xFF2BB0E6), shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: const Text('💪', style: TextStyle(fontSize: 28)),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isArmsSnapped ? const Color(0xFF73FDA3) : const Color(0xFF2BB0E6),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(isArmsSnapped ? '✅' : '💪', style: const TextStyle(fontSize: 22)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(isUrduPuzzleLang ? 'بازو' : 'Arms', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              // Legs Draggable Emoji
                              Draggable<String>(
                                data: 'legs',
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: const BoxDecoration(color: Color(0xFF24BC6B), shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: const Text('🦵', style: TextStyle(fontSize: 28)),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isLegsSnapped ? const Color(0xFF73FDA3) : const Color(0xFF24BC6B),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(isLegsSnapped ? '✅' : '🦵', style: const TextStyle(fontSize: 22)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(isUrduPuzzleLang ? 'ٹانگیں' : 'Legs', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (isCurrentDone) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🎉', style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 8),
                              Text(isUrduPuzzleLang ? 'مرحلہ مکمل ہو گیا!' : 'Level Completed!', style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                              const SizedBox(width: 8),
                              const Text('⭐', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFB958), borderRadius: BorderRadius.circular(14)),
                            child: Text(isUrduPuzzleLang ? '⭐ +۳ ستارے جمع ہو گئے!' : '⭐ +3 Stars Collected!', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Big Orange NEXT PUZZLE CTA Button with Single Arrow
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA1D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      onPressed: handleNextPuzzle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentLevel < 3
                                ? (isUrduPuzzleLang ? 'اگلا پزل' : 'NEXT PUZZLE')
                                : (isUrduPuzzleLang ? 'مشن مکمل!' : 'COMPLETE PUZZLE 🎉'),
                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Color(0xFF2A1800)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}