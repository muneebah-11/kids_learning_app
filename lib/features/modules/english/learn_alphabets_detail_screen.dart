import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const WonderKidsApp());
}

class WonderKidsApp extends StatelessWidget {
  const WonderKidsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const LearnAlphabetsScreen(),
    );
  }
}

// Data Model for Letters
class LetterModel {
  final String capital;
  final String small;
  final String word;
  final String emoji;
  final String ipa;
  final Color cardColor;
  final Color textColor;

  LetterModel({
    required this.capital,
    required this.small,
    required this.word,
    required this.emoji,
    required this.ipa,
    required this.cardColor,
    required this.textColor,
  });
}

class QuizQuestion {
  final String questionText;
  final String emoji;
  final String correctAnswer;
  final List<Map<String, String>> options;

  QuizQuestion({
    required this.questionText,
    required this.emoji,
    required this.correctAnswer,
    required this.options,
  });
}

class LearnAlphabetsScreen extends StatefulWidget {
  const LearnAlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<LearnAlphabetsScreen> createState() => _LearnAlphabetsScreenState();
}

class _LearnAlphabetsScreenState extends State<LearnAlphabetsScreen> {
  bool isPlayGroup = true;
  int selectedIndex = 0;
  int totalStars = 140;

  // Real Text-To-Speech Engine Setup
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Slightly slower for kids
  }

  Future<void> _speakText(String text) async {
    // Show visual feedback SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 Playing Audio: "$text"', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF006689),
      ),
    );

    // Play actual speaker audio sound
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  final List<LetterModel> alphabetList = [
    LetterModel(capital: 'A', small: 'a', word: 'Apple', emoji: '🍎', ipa: 'A is for Apple', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'B', small: 'b', word: 'Ball', emoji: '⚽', ipa: 'B is for Ball', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'C', small: 'c', word: 'Cat', emoji: '🐱', ipa: 'C is for Cat', cardColor: const Color(0xFF73FDA3), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'D', small: 'd', word: 'Duck', emoji: '🦆', ipa: 'D is for Duck', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'E', small: 'e', word: 'Elephant', emoji: '🐘', ipa: 'E is for Elephant', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'F', small: 'f', word: 'Fish', emoji: '🐟', ipa: 'F is for Fish', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'G', small: 'g', word: 'Grapes', emoji: '🍇', ipa: 'G is for Grapes', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'H', small: 'h', word: 'House', emoji: '🏠', ipa: 'H is for House', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'I', small: 'i', word: 'Ice Cream', emoji: '🍦', ipa: 'I is for Ice Cream', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'J', small: 'j', word: 'Juice', emoji: '🧃', ipa: 'J is for Juice', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'K', small: 'k', word: 'Kite', emoji: '🪁', ipa: 'K is for Kite', cardColor: const Color(0xFF73FDA3), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'L', small: 'l', word: 'Lion', emoji: '🦁', ipa: 'L is for Lion', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'M', small: 'm', word: 'Monkey', emoji: '🐒', ipa: 'M is for Monkey', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'N', small: 'n', word: 'Nest', emoji: '🪹', ipa: 'N is for Nest', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'O', small: 'o', word: 'Owl', emoji: '🦉', ipa: 'O is for Owl', cardColor: const Color(0xFF73FDA3), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'P', small: 'p', word: 'Penguin', emoji: '🐧', ipa: 'P is for Penguin', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'Q', small: 'q', word: 'Queen', emoji: '👑', ipa: 'Q is for Queen', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'R', small: 'r', word: 'Rabbit', emoji: '🐰', ipa: 'R is for Rabbit', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'S', small: 's', word: 'Sun', emoji: '☀️', ipa: 'S is for Sun', cardColor: const Color(0xFF73FDA3), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'T', small: 't', word: 'Tree', emoji: '🌳', ipa: 'T is for Tree', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'U', small: 'u', word: 'Umbrella', emoji: '☂️', ipa: 'U is for Umbrella', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'V', small: 'v', word: 'Violin', emoji: '🎻', ipa: 'V is for Violin', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'W', small: 'w', word: 'Watch', emoji: '⌚', ipa: 'W is for Watch', cardColor: const Color(0xFF73FDA3), textColor: const Color(0xFF006D39)),
    LetterModel(capital: 'X', small: 'x', word: 'Xylophone', emoji: '🪗', ipa: 'X is for Xylophone', cardColor: const Color(0xFFEAE8E2), textColor: const Color(0xFF006689)),
    LetterModel(capital: 'Y', small: 'y', word: 'Yak', emoji: '🐂', ipa: 'Y is for Yak', cardColor: const Color(0xFFFFDDB6), textColor: const Color(0xFF845400)),
    LetterModel(capital: 'Z', small: 'z', word: 'Zebra', emoji: '🦓', ipa: 'Z is for Zebra', cardColor: const Color(0xFFC2E8FF), textColor: const Color(0xFF006689)),
  ];

  void _showMoreAlphabetsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFBF9F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext sheetContext) {
        final List<LetterModel> iToZList = alphabetList.sublist(8);

        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE8E2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'All Alphabets (I - Z)',
                style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: iToZList.length,
                  itemBuilder: (ctx, index) {
                    final item = iToZList[index];
                    final int originalIndex = index + 8;
                    final isSelected = selectedIndex == originalIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = originalIndex;
                        });
                        Navigator.pop(sheetContext);
                        _speakText(item.ipa);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected ? Border.all(color: const Color(0xFF006689), width: 2.5) : null,
                          boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 2)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 24)),
                                const Icon(Icons.volume_up, size: 14, color: Color(0xFF006689)),
                              ],
                            ),
                            Text('${item.capital}${item.small}', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: item.textColor)),
                            if (!isPlayGroup)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(10)),
                                child: Text(item.word, style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: item.textColor), overflow: TextOverflow.ellipsis),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = alphabetList[selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                // Clean Header Bar with Navigation Back Arrow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0EEE8),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3), blurRadius: 0)],
                              ),
                              child: const Icon(Icons.arrow_back, color: Color(0xFF006689), size: 22),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('WONDERKIDS', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                              Text('Learn Alphabets (A-Z)', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 3), blurRadius: 0)],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFF845400), size: 16),
                                const SizedBox(width: 4),
                                Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEE8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isPlayGroup = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isPlayGroup ? const Color(0xFF2BB0E6) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '🧸 Play Group (3-4)',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: isPlayGroup ? Colors.white : const Color(0xFF3E484F)),
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
                                      color: !isPlayGroup ? const Color(0xFF2BB0E6) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '🎒 Kinder (4-5)',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: !isPlayGroup ? Colors.white : const Color(0xFF3E484F)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(16),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(20)),
                                    child: Text('Letter ${selectedIndex + 1} of 26', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(20)),
                                    child: Text(isPlayGroup ? 'PG Mode' : 'KG Mode', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => _speakText(currentLetter.word),
                                child: Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC2E8FF).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    currentLetter.emoji,
                                    style: const TextStyle(fontSize: 80),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${currentLetter.capital}${currentLetter.small}', style: TextStyle(fontFamily: 'Rubik', fontSize: 32, fontWeight: FontWeight.w900, color: currentLetter.textColor)),
                                  const SizedBox(width: 8),
                                  Text(currentLetter.emoji, style: const TextStyle(fontSize: 28)),
                                ],
                              ),
                              Text(currentLetter.ipa, style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEAE8E2),
                                  foregroundColor: const Color(0xFF1B1C19),
                                  minimumSize: const Size(double.infinity, 46),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                                ),
                                onPressed: () => _speakText(currentLetter.ipa),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.volume_up, color: Color(0xFF006689), size: 18),
                                    const SizedBox(width: 6),
                                    Text('Tap to Hear "${currentLetter.ipa}"', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
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
                            const Text('Explore Letters', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFEAE8E2), borderRadius: BorderRadius.circular(12)),
                              child: const Text('26 Total', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            if (index == 8) {
                              return GestureDetector(
                                onTap: _showMoreAlphabetsSheet,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE4E2DD),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 2)],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.grid_view_rounded, color: Color(0xFF006689), size: 26),
                                      SizedBox(height: 4),
                                      Text('More', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                      Text('I to Z ➔', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final item = alphabetList[index];
                            final isSelected = selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedIndex = index);
                                _speakText(item.ipa);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: isSelected ? Border.all(color: const Color(0xFF006689), width: 2.5) : null,
                                  boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 2)],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.emoji, style: const TextStyle(fontSize: 24)),
                                        GestureDetector(
                                          onTap: () => _speakText(item.word),
                                          child: Icon(Icons.volume_up, size: 14, color: item.textColor),
                                        ),
                                      ],
                                    ),
                                    Text('${item.capital}${item.small}', style: TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: item.textColor)),
                                    if (!isPlayGroup)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(10)),
                                        child: Text(
                                          '${item.word} (${item.capital})',
                                          style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: item.textColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            final earnedStars = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LetterQuizScreen(isPlayGroup: isPlayGroup, alphabetList: alphabetList)),
                            );
                            if (earnedStars != null && earnedStars is int && mounted) {
                              final newTotal = totalStars + earnedStars;
                              setState(() {
                                totalStars = newTotal;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFAA1D),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Color(0xFF845400), offset: Offset(0, 5), blurRadius: 0)],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21)),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.sports_esports, color: Color(0xFF845400), size: 22),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("Letter Quiz! 🎯", style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF2A1800))),
                                        Text('Match sounds & earn 3 stars!', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6A4300))),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_forward, color: Color(0xFF845400), size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= TRACING SCREEN =================
class TracingScreen extends StatefulWidget {
  final LetterModel letter;
  final bool isPlayGroup;
  const TracingScreen({Key? key, required this.letter, required this.isPlayGroup}) : super(key: key);

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  final List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text("Practice Tracing '${widget.letter.capital}'", style: const TextStyle(fontFamily: 'Rubik', color: Color(0xFF1B1C19), fontWeight: FontWeight.bold, fontSize: 16)),
                      TextButton(
                        onPressed: () => setState(() => points.clear()),
                        child: const Text('Clear', style: TextStyle(fontFamily: 'Rubik', color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Trace with your finger below ✍️', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF6E7980))),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanUpdate: (details) {
                                setState(() {
                                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                                  Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                                  points.add(localPosition);
                                });
                              },
                              onPanEnd: (details) {
                                setState(() {
                                  points.add(null);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: const Color(0xFF2BB0E6), width: 3),
                                  boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '${widget.letter.capital}   ${widget.letter.small}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 90,
                                        fontWeight: FontWeight.w900,
                                        color: widget.isPlayGroup 
                                          ? const Color(0xFF2BB0E6).withOpacity(0.3) 
                                          : const Color(0xFFEAE8E2).withOpacity(0.6),
                                      ),
                                    ),
                                    CustomPaint(
                                      painter: TracingPainter(points: points),
                                      size: Size.infinite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF24BC6B),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Great Job! Tracing Saved!')));
                              Navigator.pop(context);
                            },
                            child: const Text('Complete & Earn Star ⭐', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TracingPainter extends CustomPainter {
  final List<Offset?> points;
  TracingPainter({required this.points});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF006689)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, 4.0, paint);
      }
    }
  }
}

// ================= LETTER QUIZ SCREEN =================
class LetterQuizScreen extends StatefulWidget {
  final bool isPlayGroup;
  final List<LetterModel> alphabetList;
  const LetterQuizScreen({Key? key, required this.isPlayGroup, required this.alphabetList}) : super(key: key);

  @override
  State<LetterQuizScreen> createState() => _LetterQuizScreenState();
}

class _LetterQuizScreenState extends State<LetterQuizScreen> {
  int currentQuestionIndex = 0;
  int userScore = 0;
  int earnedStarsTotal = 0;
  String? selectedOption;
  bool isAnswered = false;
  late List<QuizQuestion> activeQuestions;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    List<QuizQuestion> allPool = [];

    for (var item in widget.alphabetList) {
      List<LetterModel> otherLetters = widget.alphabetList.where((l) => l.word != item.word).toList()..shuffle(Random());
      List<Map<String, String>> currentOptions = [
        {'word': item.word, 'label': widget.isPlayGroup ? '${item.capital}${item.small} (${item.word})' : item.word.split('').join(' - ')},
        {'word': otherLetters[0].word, 'label': widget.isPlayGroup ? '${otherLetters[0].capital}${otherLetters[0].small} (${otherLetters[0].word})' : otherLetters[0].word.split('').join(' - ')},
        {'word': otherLetters[1].word, 'label': widget.isPlayGroup ? '${otherLetters[1].capital}${otherLetters[1].small} (${otherLetters[1].word})' : otherLetters[1].word.split('').join(' - ')},
      ];
      currentOptions.shuffle(Random());

      allPool.add(QuizQuestion(
        questionText: widget.isPlayGroup ? 'Which word starts with this emoji?' : 'Select the correct spelling:',
        emoji: item.emoji,
        correctAnswer: item.word,
        options: currentOptions,
      ));
    }

    allPool.shuffle(Random());
    activeQuestions = allPool.sublist(0, 10);
    currentQuestionIndex = 0;
    userScore = 0;
    earnedStarsTotal = 0;
    isAnswered = false;
    selectedOption = null;
  }

  void _handleOptionTap(String optionWord) {
    if (isAnswered) return;

    setState(() {
      selectedOption = optionWord;
      isAnswered = true;
      if (optionWord == activeQuestions[currentQuestionIndex].correctAnswer) {
        userScore++;
        earnedStarsTotal += 3;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < activeQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedOption = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: const Color(0xFFFBF9F3),
        title: Column(
          children: const [
            Text('🥳', style: TextStyle(fontSize: 48)),
            SizedBox(height: 6),
            Text('Quiz Completed!', style: TextStyle(fontFamily: 'Rubik', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF006689))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You scored $userScore out of 10!', style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Color(0xFF845400), size: 22),
                  const SizedBox(width: 6),
                  Text('Earned Stars: +$earnedStarsTotal ⭐', style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB958),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(earnedStarsTotal);
              },
              child: const Text('Save & Back to Dashboard ➔', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = activeQuestions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / activeQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: const Color(0xFFFBF9F3),
                  elevation: 0,
                  leading: InkWell(
                    onTap: () => Navigator.pop(context, 0),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 20),
                    ),
                  ),
                  title: Text(widget.isPlayGroup ? 'Play Group Quiz 🧸' : 'Kindergarten Quiz 🎒', style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(20)),
                              child: Text('Question ${currentQuestionIndex + 1} of 10 🌟', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(20)),
                              child: Text('+3 Stars / Correct', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFEAE8E2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFB958)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(color: const Color(0xFFC2E8FF).withOpacity(0.3), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(currentQ.emoji, style: const TextStyle(fontSize: 50)),
                              ),
                              const SizedBox(height: 12),
                              Text(currentQ.questionText, style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: currentQ.options.map((option) {
                            final String optWord = option['word']!;
                            final bool isSelected = selectedOption == optWord;
                            final bool isCorrect = optWord == currentQ.correctAnswer;

                            Color cardBg = Colors.white;
                            Color borderColor = const Color(0xFFEAE8E2);

                            if (isAnswered) {
                              if (isCorrect) {
                                cardBg = const Color(0xFF73FDA3).withOpacity(0.3);
                                borderColor = const Color(0xFF006D39);
                              } else if (isSelected) {
                                cardBg = const Color(0xFFFFDAD6);
                                borderColor = Colors.red;
                              }
                            }

                            return GestureDetector(
                              onTap: () => _handleOptionTap(optWord),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: borderColor, width: isAnswered && (isCorrect || isSelected) ? 2.5 : 1),
                                  boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 4), blurRadius: 0)],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(option['label']!, style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                    if (isAnswered && isCorrect)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: const Color(0xFF006D39), borderRadius: BorderRadius.circular(12)),
                                        child: const Text('Correct! ✅', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (isAnswered) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB958),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 0,
                              ),
                              onPressed: _nextQuestion,
                              child: Text(currentQuestionIndex < activeQuestions.length - 1 ? 'Next Question ➔' : 'See Final Results 🎉', style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF2A1800))),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}