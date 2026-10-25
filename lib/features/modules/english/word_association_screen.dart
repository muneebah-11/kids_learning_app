import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const WonderKidsWordAssocApp());
}

class WonderKidsWordAssocApp extends StatelessWidget {
  const WonderKidsWordAssocApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids - Word Association',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const WordAssociationScreen(),
    );
  }
}

class WordAssociationModel {
  final String letter;
  final String emoji;
  final String mainWord;
  final String phonicsIPA;
  final String wordType;
  final String imagePath;
  final List<Map<String, String>> extraWords;

  WordAssociationModel({
    required this.letter,
    required this.emoji,
    required this.mainWord,
    required this.phonicsIPA,
    required this.wordType,
    required this.imagePath,
    required this.extraWords,
  });
}

class WordAssociationScreen extends StatefulWidget {
  const WordAssociationScreen({Key? key}) : super(key: key);

  @override
  State<WordAssociationScreen> createState() => _WordAssociationScreenState();
}

class _WordAssociationScreenState extends State<WordAssociationScreen> {
  bool isPlayGroup = true;
  int selectedIndex = 0;

  final FlutterTts flutterTts = FlutterTts();

  final List<WordAssociationModel> wordAssocList = [
    WordAssociationModel(
      letter: 'A', emoji: '🍎', mainWord: 'Apple', phonicsIPA: '/æ-pəl/', wordType: 'Noun',
      imagePath: 'assets/images/apple.png',
      extraWords: [
        {'word': 'Ant', 'phonics': 'A • n • t', 'emoji': '🐜', 'color': '0xFFE0F7FA'},
        {'word': 'Airplane', 'phonics': 'Air • plane', 'emoji': '✈️', 'color': '0xFFFFCDD2'},
        {'word': 'Alligator', 'phonics': 'Al • li • ga • tor', 'emoji': '🐊', 'color': '0xFFFFF3CD'},
        {'word': 'Astronaut', 'phonics': 'As • tro • naut', 'emoji': '🧑‍🚀', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'B', emoji: '⚽', mainWord: 'Ball', phonicsIPA: '/bɔːl/', wordType: 'Noun',
      imagePath: 'assets/images/ball.png',
      extraWords: [
        {'word': 'Butterfly', 'phonics': 'But • ter • fly', 'emoji': '🦋', 'color': '0xFFE0F7FA'},
        {'word': 'Bear', 'phonics': 'B • e • a • r', 'emoji': '🐻', 'color': '0xFFFFCDD2'},
        {'word': 'Banana', 'phonics': 'Ba • na • na', 'emoji': '🍌', 'color': '0xFFFFF3CD'},
        {'word': 'Boat', 'phonics': 'B • o • a • t', 'emoji': '⛵', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'C', emoji: '🐱', mainWord: 'Cat', phonicsIPA: '/kæt/', wordType: 'Noun',
      imagePath: 'assets/images/cat.png',
      extraWords: [
        {'word': 'Car', 'phonics': 'C • a • r', 'emoji': '🚗', 'color': '0xFFE0F7FA'},
        {'word': 'Cake', 'phonics': 'C • a • k • e', 'emoji': '🎂', 'color': '0xFFFFCDD2'},
        {'word': 'Cup', 'phonics': 'C • u • p', 'emoji': '☕', 'color': '0xFFFFF3CD'},
        {'word': 'Cow', 'phonics': 'C • o • w', 'emoji': '🐮', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'D', emoji: '🦆', mainWord: 'Duck', phonicsIPA: '/dʌk/', wordType: 'Noun',
      imagePath: 'assets/images/duck.png',
      extraWords: [
        {'word': 'Dog', 'phonics': 'D • o • g', 'emoji': '🐶', 'color': '0xFFE0F7FA'},
        {'word': 'Drum', 'phonics': 'D • r • u • m', 'emoji': '🥁', 'color': '0xFFFFCDD2'},
        {'word': 'Door', 'phonics': 'D • o • o • r', 'emoji': '🚪', 'color': '0xFFFFF3CD'},
        {'word': 'Dolphin', 'phonics': 'Dol • phin', 'emoji': '🐬', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'E', emoji: '🐘', mainWord: 'Elephant', phonicsIPA: '/ˈɛlɪfənt/', wordType: 'Noun',
      imagePath: 'assets/images/elephant.png',
      extraWords: [
        {'word': 'Egg', 'phonics': 'E • g • g', 'emoji': '🥚', 'color': '0xFFE0F7FA'},
        {'word': 'Engine', 'phonics': 'En • gine', 'emoji': '🚂', 'color': '0xFFFFCDD2'},
        {'word': 'Eye', 'phonics': 'E • y • e', 'emoji': '👁️', 'color': '0xFFFFF3CD'},
        {'word': 'Eagle', 'phonics': 'Ea • gle', 'emoji': '🦅', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'F', emoji: '🐟', mainWord: 'Fish', phonicsIPA: '/fɪʃ/', wordType: 'Noun',
      imagePath: 'assets/images/fish.png',
      extraWords: [
        {'word': 'Fan', 'phonics': 'F • a • n', 'emoji': '🌀', 'color': '0xFFE0F7FA'},
        {'word': 'Frog', 'phonics': 'F • r • o • g', 'emoji': '🐸', 'color': '0xFFFFCDD2'},
        {'word': 'Fox', 'phonics': 'F • o • x', 'emoji': '🦊', 'color': '0xFFFFF3CD'},
        {'word': 'Feather', 'phonics': 'Fea • ther', 'emoji': '🪶', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'G', emoji: '🍇', mainWord: 'Grapes', phonicsIPA: '/ɡreɪps/', wordType: 'Noun',
      imagePath: 'assets/images/grapes.png',
      extraWords: [
        {'word': 'Goat', 'phonics': 'G • o • a • t', 'emoji': '🐐', 'color': '0xFFE0F7FA'},
        {'word': 'Girl', 'phonics': 'G • i • r • l', 'emoji': '👧', 'color': '0xFFFFCDD2'},
        {'word': 'Gift', 'phonics': 'G • i • f • t', 'emoji': '🎁', 'color': '0xFFFFF3CD'},
        {'word': 'Guitar', 'phonics': 'Gui • tar', 'emoji': '🎸', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'H', emoji: '🎩', mainWord: 'Hat', phonicsIPA: '/hæt/', wordType: 'Noun',
      imagePath: 'assets/images/hat.png',
      extraWords: [
        {'word': 'House', 'phonics': 'H • o • u • s • e', 'emoji': '🏠', 'color': '0xFFE0F7FA'},
        {'word': 'Horse', 'phonics': 'H • o • r • s • e', 'emoji': '🐴', 'color': '0xFFFFCDD2'},
        {'word': 'Hand', 'phonics': 'H • a • n • d', 'emoji': '✋', 'color': '0xFFFFF3CD'},
        {'word': 'Heart', 'phonics': 'H • e • a • r • t', 'emoji': '❤️', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'I', emoji: '🍦', mainWord: 'Ice Cream', phonicsIPA: '/ˈaɪs kriːm/', wordType: 'Noun',
      imagePath: 'assets/images/icecream.png',
      extraWords: [
        {'word': 'Igloo', 'phonics': 'Ig • loo', 'emoji': '🧊', 'color': '0xFFE0F7FA'},
        {'word': 'Ink', 'phonics': 'I • n • k', 'emoji': '✒️', 'color': '0xFFFFCDD2'},
        {'word': 'Iguana', 'phonics': 'I • gua • na', 'emoji': '🦎', 'color': '0xFFFFF3CD'},
        {'word': 'Insect', 'phonics': 'In • sect', 'emoji': '🐛', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'J', emoji: '🫖', mainWord: 'Jug', phonicsIPA: '/dʒʌɡ/', wordType: 'Noun',
      imagePath: 'assets/images/jug.png',
      extraWords: [
        {'word': 'Jam', 'phonics': 'J • a • m', 'emoji': '🍓', 'color': '0xFFE0F7FA'},
        {'word': 'Jelly', 'phonics': 'Jel • ly', 'emoji': '🍮', 'color': '0xFFFFCDD2'},
        {'word': 'Jet', 'phonics': 'J • e • t', 'emoji': '✈️', 'color': '0xFFFFF3CD'},
        {'word': 'Jacket', 'phonics': 'Jack • et', 'emoji': '🧥', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'K', emoji: '🪁', mainWord: 'Kite', phonicsIPA: '/kaɪt/', wordType: 'Noun',
      imagePath: 'assets/images/kite.png',
      extraWords: [
        {'word': 'Kangaroo', 'phonics': 'Kan • ga • roo', 'emoji': '🦘', 'color': '0xFFE0F7FA'},
        {'word': 'Key', 'phonics': 'K • e • y', 'emoji': '🔑', 'color': '0xFFFFCDD2'},
        {'word': 'King', 'phonics': 'K • i • n • g', 'emoji': '👑', 'color': '0xFFFFF3CD'},
        {'word': 'Koala', 'phonics': 'Ko • a • la', 'emoji': '🐨', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'L', emoji: '🦁', mainWord: 'Lion', phonicsIPA: '/ˈlaɪən/', wordType: 'Noun',
      imagePath: 'assets/images/lion.png',
      extraWords: [
        {'word': 'Leaf', 'phonics': 'L • e • a • f', 'emoji': '🍃', 'color': '0xFFE0F7FA'},
        {'word': 'Lamp', 'phonics': 'L • a • m • p', 'emoji': '🏮', 'color': '0xFFFFCDD2'},
        {'word': 'Lemon', 'phonics': 'Lem • on', 'emoji': '🍋', 'color': '0xFFFFF3CD'},
        {'word': 'Lock', 'phonics': 'L • o • c • k', 'emoji': '🔒', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'M', emoji: '🐵', mainWord: 'Monkey', phonicsIPA: '/ˈmʌŋki/', wordType: 'Noun',
      imagePath: 'assets/images/monkey.png',
      extraWords: [
        {'word': 'Moon', 'phonics': 'M • o • o • n', 'emoji': '🌙', 'color': '0xFFE0F7FA'},
        {'word': 'Milk', 'phonics': 'M • i • l • k', 'emoji': '🥛', 'color': '0xFFFFCDD2'},
        {'word': 'Mouse', 'phonics': 'M • o • u • s • e', 'emoji': '🐭', 'color': '0xFFFFF3CD'},
        {'word': 'Mug', 'phonics': 'M • u • g', 'emoji': '☕', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'N', emoji: '🪹', mainWord: 'Nest', phonicsIPA: '/nɛst/', wordType: 'Noun',
      imagePath: 'assets/images/nest.png',
      extraWords: [
        {'word': 'Nut', 'phonics': 'N • u • t', 'emoji': '🥜', 'color': '0xFFE0F7FA'},
        {'word': 'Net', 'phonics': 'N • e • t', 'emoji': '🥅', 'color': '0xFFFFCDD2'},
        {'word': 'Nurse', 'phonics': 'Nurs • e', 'emoji': '👩‍⚕️', 'color': '0xFFFFF3CD'},
        {'word': 'Nail', 'phonics': 'N • a • i • l', 'emoji': '💅', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'O', emoji: '🦉', mainWord: 'Owl', phonicsIPA: '/aʊl/', wordType: 'Noun',
      imagePath: 'assets/images/owl.png',
      extraWords: [
        {'word': 'Orange', 'phonics': 'Or • ange', 'emoji': '🍊', 'color': '0xFFE0F7FA'},
        {'word': 'Octopus', 'phonics': 'Oc • to • pus', 'emoji': '🐙', 'color': '0xFFFFCDD2'},
        {'word': 'Ox', 'phonics': 'O • x', 'emoji': '🐂', 'color': '0xFFFFF3CD'},
        {'word': 'Ostrich', 'phonics': 'Os • trich', 'emoji': '🐦', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'P', emoji: '🐧', mainWord: 'Penguin', phonicsIPA: '/ˈpɛŋɡwɪn/', wordType: 'Noun',
      imagePath: 'assets/images/penguin.png',
      extraWords: [
        {'word': 'Pen', 'phonics': 'P • e • n', 'emoji': '🖊️', 'color': '0xFFE0F7FA'},
        {'word': 'Pig', 'phonics': 'P • i • g', 'emoji': '🐷', 'color': '0xFFFFCDD2'},
        {'word': 'Panda', 'phonics': 'Pan • da', 'emoji': '🐼', 'color': '0xFFFFF3CD'},
        {'word': 'Pencil', 'phonics': 'Pen • cil', 'emoji': '✏️', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'Q', emoji: '👑', mainWord: 'Queen', phonicsIPA: '/kwiːn/', wordType: 'Noun',
      imagePath: 'assets/images/queen.png',
      extraWords: [
        {'word': 'Quilt', 'phonics': 'Q • u • i • l • t', 'emoji': '🛌', 'color': '0xFFE0F7FA'},
        {'word': 'Quail', 'phonics': 'Q • u • a • i • l', 'emoji': '🐦', 'color': '0xFFFFCDD2'},
        {'word': 'Quiet', 'phonics': 'Qui • et', 'emoji': '🤫', 'color': '0xFFFFF3CD'},
        {'word': 'Quarter', 'phonics': 'Quar • ter', 'emoji': '🪙', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'R', emoji: '🐰', mainWord: 'Rabbit', phonicsIPA: '/ˈræbɪt/', wordType: 'Noun',
      imagePath: 'assets/images/rabbit.png',
      extraWords: [
        {'word': 'Ring', 'phonics': 'R • i • n • g', 'emoji': '💍', 'color': '0xFFE0F7FA'},
        {'word': 'Rocket', 'phonics': 'Rock • et', 'emoji': '🚀', 'color': '0xFFFFCDD2'},
        {'word': 'Rose', 'phonics': 'R • o • s • e', 'emoji': '🌹', 'color': '0xFFFFF3CD'},
        {'word': 'Rain', 'phonics': 'R • a • i • n', 'emoji': '🌧️', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'S', emoji: '☀️', mainWord: 'Sun', phonicsIPA: '/sʌn/', wordType: 'Noun',
      imagePath: 'assets/images/sun.png',
      extraWords: [
        {'word': 'Star', 'phonics': 'S • t • a • r', 'emoji': '⭐', 'color': '0xFFE0F7FA'},
        {'word': 'Snake', 'phonics': 'S • n • a • k • e', 'emoji': '🐍', 'color': '0xFFFFCDD2'},
        {'word': 'Sock', 'phonics': 'S • o • c • k', 'emoji': '🧦', 'color': '0xFFFFF3CD'},
        {'word': 'Soap', 'phonics': 'S • o • a • p', 'emoji': '🧼', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'T', emoji: '🐯', mainWord: 'Tiger', phonicsIPA: '/ˈtaɪɡər/', wordType: 'Noun',
      imagePath: 'assets/images/tiger.png',
      extraWords: [
        {'word': 'Tree', 'phonics': 'T • r • e • e', 'emoji': '🌳', 'color': '0xFFE0F7FA'},
        {'word': 'Top', 'phonics': 'T • o • p', 'emoji': '🪀', 'color': '0xFFFFCDD2'},
        {'word': 'Tent', 'phonics': 'T • e • n • t', 'emoji': '⛺', 'color': '0xFFFFF3CD'},
        {'word': 'Train', 'phonics': 'T • r • a • i • n', 'emoji': '🚂', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'U', emoji: '☂️', mainWord: 'Umbrella', phonicsIPA: '/ʌmˈbrɛlə/', wordType: 'Noun',
      imagePath: 'assets/images/umbrella.png',
      extraWords: [
        {'word': 'Uncle', 'phonics': 'Un • cle', 'emoji': '👨‍💼', 'color': '0xFFE0F7FA'},
        {'word': 'Up', 'phonics': 'U • p', 'emoji': '⬆️', 'color': '0xFFFFCDD2'},
        {'word': 'Urn', 'phonics': 'U • r • n', 'emoji': '🏺', 'color': '0xFFFFF3CD'},
        {'word': 'Unicorn', 'phonics': 'Uni • corn', 'emoji': '🦄', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'V', emoji: '🎻', mainWord: 'Violin', phonicsIPA: '/ˌvaɪəˈlɪn/', wordType: 'Noun',
      imagePath: 'assets/images/violin.png',
      extraWords: [
        {'word': 'Van', 'phonics': 'V • a • n', 'emoji': '🚐', 'color': '0xFFE0F7FA'},
        {'word': 'Vase', 'phonics': 'V • a • s • e', 'emoji': '🏺', 'color': '0xFFFFCDD2'},
        {'word': 'Volcano', 'phonics': 'Vol • ca • no', 'emoji': '🌋', 'color': '0xFFFFF3CD'},
        {'word': 'Vest', 'phonics': 'V • e • s • t', 'emoji': '🎽', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'W', emoji: '⌚', mainWord: 'Watch', phonicsIPA: '/wɒtʃ/', wordType: 'Noun',
      imagePath: 'assets/images/watch.png',
      extraWords: [
        {'word': 'Watermelon', 'phonics': 'Wa • ter • mel • on', 'emoji': '🍉', 'color': '0xFFE0F7FA'},
        {'word': 'Wind', 'phonics': 'W • i • n • d', 'emoji': '💨', 'color': '0xFFFFCDD2'},
        {'word': 'Whale', 'phonics': 'Wh • a • l • e', 'emoji': '🐋', 'color': '0xFFFFF3CD'},
        {'word': 'Window', 'phonics': 'Win • dow', 'emoji': '🪟', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'X', emoji: '🛜', mainWord: 'Xylophone', phonicsIPA: '/ˈzaɪləfəʊn/', wordType: 'Noun',
      imagePath: 'assets/images/xylophone.png',
      extraWords: [
        {'word': 'X-Ray', 'phonics': 'X • Ray', 'emoji': '🦴', 'color': '0xFFE0F7FA'},
        {'word': 'Box', 'phonics': 'B • o • x', 'emoji': '📦', 'color': '0xFFFFCDD2'},
        {'word': 'Fox', 'phonics': 'F • o • x', 'emoji': '🦊', 'color': '0xFFFFF3CD'},
        {'word': 'Six', 'phonics': 'S • i • x', 'emoji': '6️⃣', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'Y', emoji: '🪀', mainWord: 'Yo-Yo', phonicsIPA: '/ˈjəʊ jəʊ/', wordType: 'Noun',
      imagePath: 'assets/images/yoyo.png',
      extraWords: [
        {'word': 'Yak', 'phonics': 'Y • a • k', 'emoji': '🐂', 'color': '0xFFE0F7FA'},
        {'word': 'Yellow', 'phonics': 'Yel • low', 'emoji': '🟡', 'color': '0xFFFFCDD2'},
        {'word': 'Yarn', 'phonics': 'Y • a • r • n', 'emoji': '🧶', 'color': '0xFFFFF3CD'},
        {'word': 'Yogurt', 'phonics': 'Yo • gurt', 'emoji': '🥛', 'color': '0xFFE1BEE7'},
      ],
    ),
    WordAssociationModel(
      letter: 'Z', emoji: '🦓', mainWord: 'Zebra', phonicsIPA: '/ˈzɛbrə/', wordType: 'Noun',
      imagePath: 'assets/images/zebra.png',
      extraWords: [
        {'word': 'Zip', 'phonics': 'Z • i • p', 'emoji': '🤐', 'color': '0xFFE0F7FA'},
        {'word': 'Zoo', 'phonics': 'Z • o • o', 'emoji': '🦁', 'color': '0xFFFFCDD2'},
        {'word': 'Zero', 'phonics': 'Ze • ro', 'emoji': '0️⃣', 'color': '0xFFFFF3CD'},
        {'word': 'Zucchini', 'phonics': 'Zuc • chi • ni', 'emoji': '🥒', 'color': '0xFFE1BEE7'},
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
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
      await flutterTts.setVolume(1.0);
      await flutterTts.speak(text);
      
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔊 Audio: "$text"', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
          duration: const Duration(milliseconds: 1000),
          backgroundColor: const Color(0xFF006689),
        ),
      );
    } catch (e) {
      debugPrint("TTS speak error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = wordAssocList[selectedIndex < wordAssocList.length ? selectedIndex : 0];
    final nextLetterChar = wordAssocList[(selectedIndex + 1) % wordAssocList.length].letter;

    final String cleanWord = currentItem.mainWord.replaceAll(' ', '').toUpperCase();
    final List<String> spellChars = cleanWord.split('');

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFFBF9F3),
          elevation: 0,
          automaticallyImplyLeading: false,
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2), blurRadius: 0)],
                              ),
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 18),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Word Association',
                            style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                          ),
                        ],
                      ),
                      // Stars container removed completely, only profile icon remains[cite: 17]
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF006689), width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Color(0xFF006689)),
                          ),
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAE8E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text('🎈', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text('Visual Vocabulary • Letter ${currentItem.letter}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF73FDA3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.volume_up, size: 12, color: Color(0xFF006D39)),
                            SizedBox(width: 4),
                            Text('Phonics On', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(4),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isPlayGroup ? const Color(0xFF006689) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '🧸 Play Group (3-4)',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: isPlayGroup ? Colors.white : const Color(0xFF3E484F)),
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
                                color: !isPlayGroup ? const Color(0xFF006689) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '🎒 Kinder (4-5)',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: !isPlayGroup ? Colors.white : const Color(0xFF3E484F)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text('Touch any block or button to hear natural phonics 🎧', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, color: Color(0xFF3E484F))),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Explore Alphabet', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                      Text('${wordAssocList.length} Letters', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: wordAssocList.length,
                      itemBuilder: (context, index) {
                        final item = wordAssocList[index];
                        final isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedIndex = index);
                            _speakText("${item.letter}. ${item.mainWord}");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFB958) : const Color(0xFFF0EEE8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: isSelected ? const Color(0xFF845400) : const Color(0xFFDBDAD4), offset: const Offset(0, 2), blurRadius: 0)
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(item.letter, style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: isSelected ? const Color(0xFF2A1800) : const Color(0xFF1B1C19))),
                                const SizedBox(width: 4),
                                Text(item.emoji, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Spotlight Card
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
                              decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(12)),
                              child: const Text('☀️ Spotlight Word', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(12)),
                              child: Text('Phonics: ${currentItem.phonicsIPA}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC2E8FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              currentItem.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text(currentItem.emoji, style: const TextStyle(fontSize: 72)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text('${currentItem.letter} is for ${currentItem.mainWord} ${currentItem.emoji}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19))),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(12)),
                          child: Text('${currentItem.phonicsIPA} • ${currentItem.wordType}', style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2BB0E6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () => _speakText(currentItem.mainWord),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.volume_up, color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text('Tap to Hear "${currentItem.mainWord}" 🎵', style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            children: [
                              const Text('Tap blocks to spell:', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                              const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 6,
                                runSpacing: 6,
                                children: spellChars.map((ch) {
                                  return GestureDetector(
                                    onTap: () => _speakText(ch),
                                    child: Container(
                                      width: 38,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFDDB6),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        ch,
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF845400)),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // More Words Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("More Words with '${currentItem.letter}' 📚", style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(10)),
                        child: Text('${currentItem.extraWords.length} Words', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: currentItem.extraWords.length,
                    itemBuilder: (context, index) {
                      final ex = currentItem.extraWords[index];
                      final cardColor = Color(int.parse(ex['color'] ?? '0xFFFFF3CD'));
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFF73FDA3), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('Phonics', style: TextStyle(fontFamily: 'Rubik', fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                                ),
                                InkWell(
                                  onTap: () => _speakText(ex['word']!),
                                  child: const Icon(Icons.volume_up, size: 18, color: Color(0xFF006689)),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(ex['emoji']!, style: const TextStyle(fontSize: 42)),
                            const Spacer(),
                            Text(ex['word']!, style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                            const SizedBox(height: 2),
                            Text(ex['phonics']!, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF6E7980))),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      InkWell(
                        onTap: () => _speakText(currentItem.mainWord),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EEE8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 2), blurRadius: 0)],
                          ),
                          child: const Icon(Icons.volume_up, color: Color(0xFF1B1C19), size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB958),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              final nextIdx = (selectedIndex + 1) % wordAssocList.length;
                              setState(() {
                                selectedIndex = nextIdx;
                              });
                              _speakText("${wordAssocList[nextIdx].letter}. ${wordAssocList[nextIdx].mainWord}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Next Word: Letter '$nextLetterChar'", style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2A1800))),
                                const SizedBox(width: 6),
                                const Icon(Icons.arrow_forward, color: Color(0xFF2A1800), size: 18),
                              ],
                            ),
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
    );
  }
}