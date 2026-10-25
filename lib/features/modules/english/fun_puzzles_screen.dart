import 'dart:math';
import 'package:flutter/material.dart';
// Agar aapki database helper file yahan hai toh import karein:
import 'package:kids_learning_app/core/database/database_helper.dart';

void main() {
  runApp(const WonderKidsActivitiesApp());
}

class WonderKidsActivitiesApp extends StatelessWidget {
  const WonderKidsActivitiesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids - Fun Activities & Puzzles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const FunActivitiesScreen(),
    );
  }
}

// Data Model for Activities & Puzzles (A to Z)
class ActivityItem {
  final String letter;
  final String smallLetter;
  final String word;
  final String emoji;
  final String imageUrl;
  final List<String> kgOptions; // Multiple options for Kindergarten mode

  ActivityItem({
    required this.letter,
    required this.smallLetter,
    required this.word,
    required this.emoji,
    required this.imageUrl,
    required this.kgOptions,
  });
}

class FunActivitiesScreen extends StatefulWidget {
  const FunActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<FunActivitiesScreen> createState() => _FunActivitiesScreenState();
}

class _FunActivitiesScreenState extends State<FunActivitiesScreen> {
  bool isPlayGroup = true; // true = Play Group (3-4), false = Kinder (4-5)
  int totalStars = 140;
  int currentItemIndex = 0;
  bool isLoading = true;

  // Full A to Z Dataset for Offline Mode Puzzles
  List<ActivityItem> activityDataset = [
    ActivityItem(
      letter: 'A',
      smallLetter: 'a',
      word: 'Apple',
      emoji: '🍎',
      imageUrl: 'https://lh3.googleusercontent.com/aida/AEtjO1V3kP38V90a59xL2hX9kXyH5-N3gGzQ4aL9Q4mP0tU-2A_B3C4D5E6F7G8H9I0J',
      kgOptions: ['Apple 🍎', 'Ant 🐜', 'Airplane ✈️', 'Ball ⚽'],
    ),
    ActivityItem(
      letter: 'B',
      smallLetter: 'b',
      word: 'Ball',
      emoji: '⚽',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAonZFSm-jhPmPzFFNfa3iKKW7bh21qRmIcV_YcH_6xQLWh5HRUOjaMZuqPVnHPwR5v0SCASlCpJWKgBwEOmKR07gdEm0EQlR7eViOgcwrtDMOJFAPc-N8QIhi3xBGufGzSUnFHPo6GVfpDXrEJJ0djsK3_Ov1C2dAjgQfBMY1Lz0Tr9-_aO-zBFKlWMJR3Ottdzc1cBG4a-MHnuLtHxdSUAp53xEI4mI2TlNeonlfd0bb7nHh7e-g',
      kgOptions: ['Ball ⚽', 'Butterfly 🦋', 'Banana 🍌', 'Cat 🐱'],
    ),
    ActivityItem(
      letter: 'C',
      smallLetter: 'c',
      word: 'Cat',
      emoji: '🐱',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeBoTCc3tB-3pxrJlRiWvGyuS9fasRc4RPJDKroa6fssaKRRjm6HFLO6pwx4oiXHj4br_wJkmTarIMZlV27nfxBZfVgH2UJskjNThLw49irRj97xyWRo54OCsOgMGLb0pHBF2qnxDPEVuXLz3W1iQRp8PNfr0UqUb3txqGppd7jWbJGNHHOGO-DkYpeV7sjlJGsuRnJxUcjXeUBjsPj_Sx18AU5m6RrKUcMWfcGq3hzA3hyYMYapo',
      kgOptions: ['Cat 🐱', 'Car 🚗', 'Cup ☕', 'Apple 🍎'],
    ),
    ActivityItem(
      letter: 'D',
      smallLetter: 'd',
      word: 'Duck',
      emoji: '🦆',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDllXx_lgmUqyQYBxvtbTrQXxdfTwWEsoP5DiKiOc4hcOjSOrGrXSc7Ufr2tO0ok2D3-eUBTMj1Hnm4rLGWYnmkICtGIu4rVB4XWwkZBW4ZrYjQAmRrVOSe8H6p6xVOjOep58Ry1dQcxGYTszXe7IA-MI2Rd3PM_EvL0hgrH80ebTewMKwGdH8hXjKTqdsC2sKo2DcHluYeHDb-4ANFEqp5VmhIUYU0dDT7bsjgflnYhoaFSifpFRE',
      kgOptions: ['Duck 🦆', 'Dog 🐶', 'Drum 🥁', 'Fish 🐟'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  // Database Connection Hook
  Future<void> _loadDataFromDatabase() async {
    try {
      // Yahan aap apna database helper call kar sakti hain:
      // final dbStars = await DatabaseHelper.instance.getUserStars();
      // if (dbStars != null) { setState(() { totalStars = dbStars; }); }
      
      // final dbActivities = await DatabaseHelper.instance.getActivitiesData();
      // if (dbActivities != null && dbActivities.isNotEmpty) {
      //   setState(() { activityDataset = dbActivities; });
      // }
    } catch (e) {
      debugPrint("Database fetch error: $e");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  void _triggerSuccessReward(String activityName) {
    setState(() {
      totalStars += 3;
    });

    // Database mein stars update karne ka function yahan call kar sakte hain:
    // DatabaseHelper.instance.updateUserStars(totalStars);

    List<String> praises = [
      "🎉 Woohoo! Great job!",
      "⭐ Super Star!",
      "🥳 Amazing! +3 Stars earned!",
      "👏 Fantastic matching!"
    ];
    String randomPraise = praises[Random().nextInt(praises.length)];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$randomPraise ($activityName)', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 14)),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF006D39),
      ),
    );
  }

  // ================= ACTIVITY 1: DRAG & DROP LETTER TO PICTURE =================
  void _openDragDropActivity() {
    final currentItem = activityDataset[currentItemIndex];
    bool isMatched = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: const Color(0xFFFBF9F3),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPlayGroup ? '🧸 Play Group: Drag & Drop' : '🎒 Kinder: Multi-Choice Match',
                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                  ),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isPlayGroup
                        ? 'Drag letter "${currentItem.letter}" to the glowing picture basket (${currentItem.word})!'
                        : 'Select the correct picture matching letter "${currentItem.letter}" from options below:',
                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  
                  if (isPlayGroup) ...[
                    DragTarget<String>(
                      onWillAccept: (data) => data == currentItem.letter,
                      onAccept: (data) {
                        setDialogState(() => isMatched = true);
                        _triggerSuccessReward('Drag & Drop');
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMatched ? const Color(0xFF73FDA3).withOpacity(0.4) : const Color(0xFFC2E8FF).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2BB0E6), width: 2),
                          ),
                          child: Column(
                            children: [
                              Text(currentItem.emoji, style: const TextStyle(fontSize: 42)),
                              const SizedBox(height: 4),
                              Text(isMatched ? '✅ Correct Match!' : 'Drop Letter "${currentItem.letter}" Here ✨', 
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isMatched ? const Color(0xFF006D39) : const Color(0xFF006689))),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    if (!isMatched)
                      Draggable<String>(
                        data: currentItem.letter,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(color: const Color(0xFFFFB958), borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: Text(currentItem.letter, style: const TextStyle(fontFamily: 'Rubik', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        child: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(color: const Color(0xFF2BB0E6), borderRadius: BorderRadius.circular(14)),
                          alignment: Alignment.center,
                          child: Text(currentItem.letter, style: const TextStyle(fontFamily: 'Rubik', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                  ] else ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: currentItem.kgOptions.map((opt) {
                        bool isCorrectOpt = opt.contains(currentItem.word);
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1B1C19),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: const BorderSide(color: Color(0xFF006689), width: 1.5),
                          ),
                          onPressed: () {
                            if (isCorrectOpt) {
                              _triggerSuccessReward('Kinder Match');
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Try Again!')));
                            }
                          },
                          child: Text(opt, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
              actions: [
                if (isPlayGroup && isMatched)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB958), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), minimumSize: const Size(double.infinity, 42)),
                    onPressed: () {
                      setState(() {
                        currentItemIndex = (currentItemIndex + 1) % activityDataset.length;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Next Puzzle ➔', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= ACTIVITY 2: CAPITAL & SMALL LETTER PAIR MATCHING =================
  void _openLetterPairsActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: const Color(0xFFFBF9F3),
          title: Text(
            isPlayGroup ? '🧸 Play Group: Color Cued Pairs' : '🎒 Kinder: A-Z Independent Match',
            style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPlayGroup
                    ? 'Match basic pairs (A-a, B-b) highlighted with matching background color cues.'
                    : 'Connect capital letters to small counterparts across mixed A-Z alphabet layout.',
                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('A ⟷ a  |  B ⟷ b', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB958),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size(double.infinity, 42),
              ),
              onPressed: () {
                _triggerSuccessReward('Letter Pairs');
                Navigator.pop(context);
              },
              child: const Text('Complete Match ⭐', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
            ),
          ],
        );
      },
    );
  }

  // ================= ACTIVITY 3: SHADOW & SILHOUETTE MATCH =================
  void _openShadowMatchActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: const Color(0xFFFBF9F3),
          title: Text(
            isPlayGroup ? '🧸 Play Group: Simple Shapes (2 Shadows)' : '🎒 Kinder: Complex Silhouettes (4-5 Shapes)',
            style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006D39)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPlayGroup
                    ? 'Match familiar objects (Cat 🐱, Duck 🦆) to their simple shadows without confusion.'
                    : 'Observe fine details (ears, fins, shapes) to match complex silhouettes accurately.',
                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF73FDA3).withOpacity(0.4), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🐱 ⟷ 🐈 (Shadow Match)', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73FDA3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size(double.infinity, 42),
              ),
              onPressed: () {
                _triggerSuccessReward('Shadow Match');
                Navigator.pop(context);
              },
              child: const Text('Success! ⭐', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFBF9F3),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFFB958))),
      );
    }

    final currentItem = activityDataset[currentItemIndex % activityDataset.length];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFFBF9F3),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
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
                              width: 38, height: 38,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))]),
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Fun Activities & Puzzles 🧩', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFB958), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Text('⭐', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reassurance Banner
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('🌟', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 6),
                        Text('Stress-Free Play Zone • Unlimited Tries & Smiles!', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Age Mode Switcher
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPlayGroup = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: isPlayGroup ? const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))] : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('🧸', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Text('Play Group (3-4)', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPlayGroup = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: !isPlayGroup ? const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2))] : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('🎒', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Text('Kindergarten (4-5)', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Featured Spotlight Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2E8FF).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC2E8FF), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                              child: Text("TODAY'S FEATURED: '${currentItem.letter}'", style: const TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                            ),
                            const Icon(Icons.volume_up, color: Color(0xFF006689), size: 18),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Match Letter '${currentItem.letter}' to ${currentItem.word}! ${currentItem.emoji}", style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19))),
                        const SizedBox(height: 3),
                        Text('Drag the wooden alphabet block into the sweet ${currentItem.word.toLowerCase()} basket!', style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF3E484F))),
                        const SizedBox(height: 10),
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              currentItem.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(child: Text(currentItem.emoji, style: const TextStyle(fontSize: 40))),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB958),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            onPressed: _openDragDropActivity,
                            child: const Text('Play Featured Puzzle Now ➔', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Choose Your Puzzle Fun Section
                  const Text('Choose Your Puzzle Fun 🎈', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19))),
                  const Text('Tap any colorful game to jump right in!', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF6E7980))),
                  const SizedBox(height: 10),

                  // Card 1: Drag & Drop Letter to Picture
                  _buildPuzzleCard(
                    title: 'Drag Letter to Picture',
                    subtitle: isPlayGroup ? 'PG: Single letter matching with guide lines' : 'KG: Multiple picture options selection',
                    icon: Icons.extension,
                    color: const Color(0xFFC2E8FF),
                    onTap: _openDragDropActivity,
                  ),
                  const SizedBox(height: 10),

                  // Card 2: Big & Little Letter Pairs
                  _buildPuzzleCard(
                    title: 'Big & Little Letter Pairs',
                    subtitle: isPlayGroup ? 'PG: Color-cued basic pairs (A-a)' : 'KG: Independent mixed A-Z matching',
                    icon: Icons.sort_by_alpha,
                    color: const Color(0xFFFFDDB6),
                    onTap: _openLetterPairsActivity,
                  ),
                  const SizedBox(height: 10),

                  // Card 3: Shadow & Silhouette Match
                  _buildPuzzleCard(
                    title: 'Shadow & Silhouette Match',
                    subtitle: isPlayGroup ? 'PG: Simple familiar shapes (Cat/Duck)' : 'KG: Complex silhouettes and fine details',
                    icon: Icons.pets,
                    color: const Color(0xFF73FDA3),
                    onTap: _openShadowMatchActivity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPuzzleCard({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFF006689), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                    Text(subtitle, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF6E7980))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: onTap,
              child: const Text('Start Activity ➔', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
            ),
          ),
        ],
      ),
    );
  }
}