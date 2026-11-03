import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning_app/core/database/database_helper.dart';

class HaroofModel {
  final String id;
  final String char;
  final String name;
  final String urduWord;
  final String engWord;
  final String emoji;
  final Color pastelBg;
  final Color pastelFg;

  const HaroofModel({
    required this.id,
    required this.char,
    required this.name,
    required this.urduWord,
    required this.engWord,
    required this.emoji,
    required this.pastelBg,
    required this.pastelFg,
  });
}

class QuizQuestion {
  final String emoji;
  final String questionTitle;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.emoji,
    required this.questionTitle,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class UrduHaroofScreen extends StatefulWidget {
  const UrduHaroofScreen({super.key});

  @override
  State<UrduHaroofScreen> createState() => _UrduHaroofScreenState();
}

class _UrduHaroofScreenState extends State<UrduHaroofScreen> {
  String currentGrade = 'pg'; // 'pg' (3-4 Years) | 'kg' (4-5 Years)
  int totalStars = 0;
  late FlutterTts flutterTts;

  int selectedIndex = 0;

  // Quiz States for PG & KG
  int pgQuizIndex = 0;
  int? pgSelectedOption;
  bool pgIsCorrect = false;
  String? pgFeedbackMessage;
  bool pgIsErrorFeedback = false;

  int kgQuizIndex = 0;
  int? kgSelectedOption;
  bool kgIsCorrect = false;
  String? kgFeedbackMessage;
  bool kgIsErrorFeedback = false;

  // Play Group Quiz Questions
  final List<QuizQuestion> pgQuizQuestions = const [
    QuizQuestion(
      emoji: '🌳',
      questionTitle: 'درست الفاظ کی نشاندہی کریں:',
      options: ['آم', 'ڈھول', 'درخت'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      emoji: '🍇',
      questionTitle: 'درست الفاظ کی نشاندہی کریں:',
      options: ['انگور', 'بلی', 'سیب'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      emoji: '🐱',
      questionTitle: 'درست الفاظ کی نشاندہی کریں:',
      options: ['پنکھا', 'بلی', 'تتلی'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      emoji: '🥭',
      questionTitle: 'درست الفاظ کی نشاندہی کریں:',
      options: ['آم', 'ٹماٹر', 'شیر'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      emoji: '🍏',
      questionTitle: 'درست الفاظ کی نشاندہی کریں:',
      options: ['خربوزہ', 'سیب', 'ریل گاڑی'],
      correctAnswerIndex: 1,
    ),
  ];

  // Kindergarten Quiz Questions (Phonics Breakup)
  final List<QuizQuestion> kgQuizQuestions = const [
    QuizQuestion(
      emoji: '🥭',
      questionTitle: 'لفظ "آم" کے صحیح جوڑ توڑ منتخب کریں:',
      options: ['آ - م', 'ا - ن - گ - و - ر', 'د - ر - خ - ت'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      emoji: '🌳',
      questionTitle: 'لفظ "درخت" کے صحیح جوڑ توڑ منتخب کریں:',
      options: ['ب - ل - ی', 'د - ر - خ - ت', 'پ - ن - ک - ھ - ا'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      emoji: '🐱',
      questionTitle: 'لفظ "بلی" کے صحیح جوڑ توڑ منتخب کریں:',
      options: ['ت - ت - ل - ی', 'ب - ل - ی', 'ش - ی - ر'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      emoji: '🍇',
      questionTitle: 'لفظ "انگور" کے صحیح جوڑ توڑ منتخب کریں:',
      options: ['ا - ن - گ - و - ر', 'س - ی - ب', 'آ - م'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      emoji: '🦁',
      questionTitle: 'لفظ "شیر" کے صحیح جوڑ توڑ منتخب کریں:',
      options: ['ح - ل - و - ہ', 'خ - ر - ب - و - ز - ہ', 'ش - ی - ر'],
      correctAnswerIndex: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadUserProgressFromDatabase();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    try {
      await flutterTts.setLanguage("ur-PK");
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
    } catch (e) {
      debugPrint("TTS initialization error: $e");
    }
  }

  Future<void> _loadUserProgressFromDatabase() async {
    try {
      final db = await DatabaseHelper.instance.database;
      setState(() {
        totalStars = 0; 
      });
    } catch (e) {
      debugPrint("Database load error: $e");
    }
  }

  Future<void> _updateDatabaseStars(int addedStars) async {
    try {
      final db = await DatabaseHelper.instance.database;
      setState(() {
        totalStars += addedStars;
      });
    } catch (e) {
      debugPrint("Database update error: $e");
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakUrduText(String haroof, String word) async {
    await flutterTts.stop();
    String textToSpeak = "حرف $haroof، اور $word";
    try {
      await flutterTts.setLanguage("ur-PK");
      await flutterTts.speak(textToSpeak);
    } catch (e) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak("$haroof for $word");
    }
  }

  // PG Letters (3-4 Years) - 20 Haroof
  final List<HaroofModel> pgLetters = const [
    HaroofModel(id: 'l-1', char: 'ا', name: 'Alif', urduWord: 'انگور', engWord: 'Angoor', emoji: '🍇', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'l-2', char: 'آ', name: 'Alif Madd', urduWord: 'آم', engWord: 'Aam', emoji: '🥭', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'l-3', char: 'ب', name: 'Bay', urduWord: 'بلی', engWord: 'Billi', emoji: '🐱', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'l-4', char: 'پ', name: 'Pey', urduWord: 'پنکھا', engWord: 'Pankha', emoji: '🪭', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'l-5', char: 'ت', name: 'Tey', urduWord: 'تتلی', engWord: 'Titli', emoji: '🦋', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'l-6', char: 'ٹ', name: 'Ttey', urduWord: 'ٹماٹر', engWord: 'Tamatar', emoji: '🍅', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'l-7', char: 'ث', name: 'Sey', urduWord: 'ثمر', engWord: 'Samar', emoji: '🍓', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'l-8', char: 'ج', name: 'Jeem', urduWord: 'جگنو', engWord: 'Jugnoo', emoji: '✨', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'l-9', char: 'چ', name: 'Chey', urduWord: 'چڑیا', engWord: 'Chiriya', emoji: '🐦', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'l-10', char: 'ح', name: 'Hey', urduWord: 'حلوہ', engWord: 'Halwa', emoji: '🍯', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'l-11', char: 'خ', name: 'Khey', urduWord: 'خربوزہ', engWord: 'Kharbooza', emoji: '🍈', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'l-12', char: 'د', name: 'Daal', urduWord: 'درخت', engWord: 'Darakht', emoji: '🌳', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'l-13', char: 'ڈ', name: 'Ddaal', urduWord: 'ڈھول', engWord: 'Dhol', emoji: '🥁', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'l-14', char: 'ذ', name: 'Zaal', urduWord: 'ذخیرہ', engWord: 'Zakheera', emoji: '💎', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'l-15', char: 'ر', name: 'Ray', urduWord: 'ریل گاڑی', engWord: 'Rail Gaadi', emoji: '🚂', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'l-16', char: 'ڑ', name: 'Rray', urduWord: 'پہاڑ', engWord: 'Pahar', emoji: '🏔️', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'l-17', char: 'ز', name: 'Zay', urduWord: 'زیبرا', engWord: 'Zebra', emoji: '🦓', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'l-18', char: 'ژ', name: 'Zhey', urduWord: 'ژالہ باری', engWord: 'Zhala Baari', emoji: '🌧️', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'l-19', char: 'س', name: 'Seen', urduWord: 'سیب', engWord: 'Saib', emoji: '🍏', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'l-20', char: 'ش', name: 'Sheen', urduWord: 'شیر', engWord: 'Sher', emoji: '🦁', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
  ];

  // KG Letters (4-5 Years) - 38 Haroof
  final List<HaroofModel> kgLetters = const [
    HaroofModel(id: 'k-1', char: 'ا', name: 'Alif', urduWord: 'انگور', engWord: 'Angoor', emoji: '🍇', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-2', char: 'آ', name: 'Alif Madd', urduWord: 'آم', engWord: 'Aam', emoji: '🥭', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-3', char: 'ب', name: 'Bay', urduWord: 'بستہ', engWord: 'Basta', emoji: '🎒', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-4', char: 'پ', name: 'Pey', urduWord: 'پتنگ', engWord: 'Patang', emoji: '🪁', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-5', char: 'ت', name: 'Tey', urduWord: 'تالا', engWord: 'Taala', emoji: '🔒', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-6', char: 'ٹ', name: 'Ttey', urduWord: 'ٹوپی', engWord: 'Topi', emoji: '🧢', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-7', char: 'ث', name: 'Sey', urduWord: 'ثمر', engWord: 'Samar', emoji: '🧺', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-8', char: 'ج', name: 'Jeem', urduWord: 'جہاز', engWord: 'Jahaaz', emoji: '✈️', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-9', char: 'چ', name: 'Chey', urduWord: 'چاند', engWord: 'Chaand', emoji: '🌙', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-10', char: 'ح', name: 'Badi Hey', urduWord: 'حلوہ', engWord: 'Halwa', emoji: '🍯', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-11', char: 'خ', name: 'Khey', urduWord: 'خرگوش', engWord: 'Khargosh', emoji: '🐰', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-12', char: 'د', name: 'Daal', urduWord: 'درخت', engWord: 'Darakht', emoji: '🌳', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-13', char: 'ڈ', name: 'Ddaal', urduWord: 'ڈھول', engWord: 'Dhol', emoji: '🐬', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-14', char: 'ذ', name: 'Zaal', urduWord: 'ذخیرہ', engWord: 'Zakheera', emoji: '💎', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-15', char: 'ر', name: 'Ray', urduWord: 'ریل گاڑی', engWord: 'Rail Gaadi', emoji: '🚂', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-16', char: 'ڑ', name: 'Rray', urduWord: 'پہاڑ', engWord: 'Pahar', emoji: '🏔️', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-17', char: 'ز', name: 'Zay', urduWord: 'زرافہ', engWord: 'Zarrafa', emoji: '🦒', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-18', char: 'ژ', name: 'Zhey', urduWord: 'ژالہ باری', engWord: 'Zhala Baari', emoji: '🌨️', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-19', char: 'س', name: 'Seen', urduWord: 'سورج', engWord: 'Suraj', emoji: '☀️', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-20', char: 'ش', name: 'Sheen', urduWord: 'شہد', engWord: 'Shehad', emoji: '🍯', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-21', char: 'ص', name: 'Suad', urduWord: 'صندوق', engWord: 'Sandooq', emoji: '📦', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-22', char: 'ض', name: 'Zuad', urduWord: 'ضیافت', engWord: 'Ziyafat', emoji: '🍽️', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-23', char: 'ط', name: 'Toyen', urduWord: 'طوطا', engWord: 'Tota', emoji: '🦜', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-24', char: 'ظ', name: 'Zoyen', urduWord: 'ظروف', engWord: 'Zuroof', emoji: '🏺', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-25', char: 'ع', name: 'Ain', urduWord: 'عینک', engWord: 'Ainak', emoji: '👓', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-26', char: 'غ', name: 'Ghain', urduWord: 'غبارہ', engWord: 'Ghubara', emoji: '🎈', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-27', char: 'ف', name: 'Fay', urduWord: 'فوارہ', engWord: 'Fawwara', emoji: '⛲', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-28', char: 'ق', name: 'Qaaf', urduWord: 'قلم', engWord: 'Qalam', emoji: '🖊️', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-29', char: 'ک', name: 'Kaaf', urduWord: 'کتاب', engWord: 'Kitaab', emoji: '📖', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-30', char: 'گ', name: 'Gaaf', urduWord: 'گڑیا', engWord: 'Guriya', emoji: '🪆', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-31', char: 'ل', name: 'Laam', urduWord: 'لیمو', engWord: 'Leemu', emoji: '🍋', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-32', char: 'م', name: 'Meem', urduWord: 'مور', engWord: 'More', emoji: '🦚', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-33', char: 'ن', name: 'Noon', urduWord: 'نلکا', engWord: 'Nalka', emoji: '🚰', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-34', char: 'و', name: 'Wao', urduWord: 'ورق', engWord: 'Waraq', emoji: '📄', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
    HaroofModel(id: 'k-35', char: 'ہ', name: 'Choti Hey', urduWord: 'ہاتھی', engWord: 'Haathi', emoji: '🐘', pastelBg: Color(0xFFC5E8CF), pastelFg: Color(0xFF005229)),
    HaroofModel(id: 'k-36', char: 'ء', name: 'Hamzah', urduWord: 'چائے', engWord: 'Chaye', emoji: '☕', pastelBg: Color(0xFFE7D6FF), pastelFg: Color(0xFF4E2B7A)),
    HaroofModel(id: 'k-37', char: 'ی', name: 'Choti Yey', urduWord: 'یکہ', engWord: 'Yakka', emoji: '🐴', pastelBg: Color(0xFFC2E8FF), pastelFg: Color(0xFF004D68)),
    HaroofModel(id: 'k-38', char: 'ے', name: 'Badi Yey', urduWord: 'طوطے', engWord: 'Totay', emoji: '🦜', pastelBg: Color(0xFFFFDDB6), pastelFg: Color(0xFF643F00)),
  ];

  List<HaroofModel> get currentDataset => currentGrade == 'pg' ? pgLetters : kgLetters;

  void _openQuizDialog() {
    // Fresh reset when opening the quiz dialog so nothing is pre-selected
    setState(() {
      pgSelectedOption = null;
      pgIsCorrect = false;
      pgFeedbackMessage = null;

      kgSelectedOption = null;
      kgIsCorrect = false;
      kgFeedbackMessage = null;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final bool isPg = currentGrade == 'pg';
            final questions = isPg ? pgQuizQuestions : kgQuizQuestions;
            final currentIndex = isPg ? pgQuizIndex : kgQuizIndex;
            final selectedOption = isPg ? pgSelectedOption : kgSelectedOption;
            final isCorrect = isPg ? pgIsCorrect : kgIsCorrect;
            final feedbackMessage = isPg ? pgFeedbackMessage : kgFeedbackMessage;
            final isErrorFeedback = isPg ? pgIsErrorFeedback : kgIsErrorFeedback;

            final question = questions[currentIndex];
            final double progressPercent = (currentIndex + 1) / questions.length;

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF9F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🧪 ننھے پھولوں کا اردو امتحان (${currentIndex + 1}/${questions.length})',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF004D68)),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Color(0xFF70787E)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEAE8E2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFAA1D)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quiz Emoji Box
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFFD166), width: 2),
                        boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 10)],
                      ),
                      alignment: Alignment.center,
                      child: Text(question.emoji, style: const TextStyle(fontSize: 58)),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      question.questionTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                    ),
                    const SizedBox(height: 18),

                    // Options List
                    Column(
                      children: List.generate(question.options.length, (idx) {
                        final optText = question.options[idx];
                        bool isSelected = selectedOption == idx;
                        Color btnBg = Colors.white;
                        Color btnBorder = const Color(0xFFBFC8CE);

                        if (isSelected) {
                          if (isCorrect) {
                            btnBg = const Color(0xFFC5E8CF);
                            btnBorder = const Color(0xFF005229);
                          } else {
                            btnBg = const Color(0xFFFFD6D6);
                            btnBorder = const Color(0xFFD93737);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () {
                              if (isCorrect) return; // Prevent multiple taps once correct
                              setModalState(() {
                                setState(() {
                                  if (isPg) {
                                    pgSelectedOption = idx;
                                    if (idx == question.correctAnswerIndex) {
                                      pgIsCorrect = true;
                                      pgIsErrorFeedback = false;
                                      pgFeedbackMessage = 'شاباش! بہت خوب 🎉 (+2 Stars)';
                                      _updateDatabaseStars(2);
                                    } else {
                                      pgIsCorrect = false;
                                      pgIsErrorFeedback = true;
                                      pgFeedbackMessage = 'غلط جواب! دوبارہ کوشش کریں ❌';
                                    }
                                  } else {
                                    kgSelectedOption = idx;
                                    if (idx == question.correctAnswerIndex) {
                                      kgIsCorrect = true;
                                      kgIsErrorFeedback = false;
                                      kgFeedbackMessage = 'شاباش! بہت خوب 🎉 (+2 Stars)';
                                      _updateDatabaseStars(2);
                                    } else {
                                      kgIsCorrect = false;
                                      kgIsErrorFeedback = true;
                                      kgFeedbackMessage = 'غلط جواب! دوبارہ کوشش کریں ❌';
                                    }
                                  }
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: btnBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: btnBorder, width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    optText,
                                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D68)),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      isCorrect ? Icons.check_circle : Icons.cancel,
                                      color: isCorrect ? const Color(0xFF005229) : const Color(0xFFD93737),
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),

                    // 💬 In-Dialog Feedback Message Box
                    if (feedbackMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isErrorFeedback ? const Color(0xFFFFD6D6) : const Color(0xFFC5E8CF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isErrorFeedback ? const Color(0xFFD93737) : const Color(0xFF005229),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isErrorFeedback ? Icons.cancel : Icons.star,
                              color: isErrorFeedback ? const Color(0xFFD93737) : const Color(0xFF005229),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feedbackMessage,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isErrorFeedback ? const Color(0xFF7A1C1C) : const Color(0xFF00381D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Next Question Button
                    if (isCorrect)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFAA1D),
                            foregroundColor: const Color(0xFF2A1800),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            setModalState(() {
                              setState(() {
                                if (isPg) {
                                  if (pgQuizIndex < pgQuizQuestions.length - 1) {
                                    pgQuizIndex++;
                                  } else {
                                    pgQuizIndex = 0;
                                  }
                                  pgSelectedOption = null;
                                  pgIsCorrect = false;
                                  pgFeedbackMessage = null;
                                } else {
                                  if (kgQuizIndex < kgQuizQuestions.length - 1) {
                                    kgQuizIndex++;
                                  } else {
                                    kgQuizIndex = 0;
                                  }
                                  kgSelectedOption = null;
                                  kgIsCorrect = false;
                                  kgFeedbackMessage = null;
                                }
                              });
                            });
                          },
                          icon: const Icon(Icons.arrow_forward, size: 20),
                          label: const Text(
                            'اگلا سوال (Next Question) →',
                            style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataset = currentDataset;
    final activeItem = dataset[selectedIndex.clamp(0, dataset.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.95),
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
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEE8),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Color(0xFF004D68), size: 22),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Text('حروفِ تہجی ', style: TextStyle(fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                                Text('(Learn Haroof)', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                              ],
                            ),
                            const Text('Tap to listen & learn', style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF40484D))),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF6E5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFFFD166), width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF845400))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF004D68),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ا ب',
                                style: TextStyle(fontFamily: 'Amiri', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grade Level Tabs (Play Group vs Kindergarten)
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
                            onTap: () {
                              setState(() {
                                currentGrade = 'pg';
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentGrade == 'pg' ? const Color(0xFF006689) : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '👶 Play Group (3-4)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: currentGrade == 'pg' ? Colors.white : const Color(0xFF40484D),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentGrade = 'kg';
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentGrade == 'kg' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '🎒 Kindergarten (4-5)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: currentGrade == 'kg' ? const Color(0xFF6A4300) : const Color(0xFF40484D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🖼️ Main Active Focus Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [BoxShadow(color: Color(0x10006689), offset: Offset(0, 6), blurRadius: 16)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC2E8FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('Letter ${selectedIndex + 1} of ${dataset.length}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE8E2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(currentGrade == 'pg' ? 'PG Mode' : 'KG Mode', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF40484D))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Big Image Area
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: activeItem.pastelBg.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            activeItem.emoji,
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activeItem.char,
                              style: TextStyle(fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.bold, color: activeItem.pastelFg),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              activeItem.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        Text(
                          '${activeItem.char} سے ${activeItem.urduWord}',
                          style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                        ),
                        const SizedBox(height: 16),

                        // Audio Listen Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0EEE8),
                              foregroundColor: const Color(0xFF004D68),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            onPressed: () => _speakUrduText(activeItem.char, activeItem.urduWord),
                            icon: const Icon(Icons.volume_up, size: 20, color: Color(0xFF004D68)),
                            label: Text(
                              '🔊 Tap to Hear "${activeItem.char} سے ${activeItem.urduWord}"',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Explore Letters Grid Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('حروف منتخب کریں (Explore Letters)', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                      Text('${dataset.length} Total', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF70787E))),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🎨 Grid View
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: dataset.length,
                    itemBuilder: (context, idx) {
                      final item = dataset[idx];
                      bool isSelected = selectedIndex == idx;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = idx;
                          });
                          _speakUrduText(item.char, item.urduWord);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.pastelBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF004D68) : Colors.transparent,
                              width: isSelected ? 2.5 : 0,
                            ),
                            boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.emoji, style: const TextStyle(fontSize: 26)),
                                  const Icon(Icons.volume_up, size: 14, color: Color(0xFF70787E)),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  item.char,
                                  style: TextStyle(fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.bold, color: item.pastelFg),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 🎮 DEDICATED QUIZ BUTTON AT THE BOTTOM
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAA1D),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Color(0x30FFAA1D), offset: Offset(0, 4), blurRadius: 10)],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _openQuizDialog,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: const Text('🎮', style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'ننھے پھولوں کا اردو امتحان! 🎯',
                                    style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                  ),
                                  Text(
                                    'Match words & earn 2 stars!',
                                    style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF573600)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_forward, color: Color(0xFF845400), size: 20),
                          ),
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