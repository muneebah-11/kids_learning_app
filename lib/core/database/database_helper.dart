import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonder_kids.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // Windows / Desktop ke liye permanent documents folder use hoga taake data delete na ho
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, filePath);
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        age TEXT NOT NULL,
        class_program TEXT NOT NULL,
        language TEXT NOT NULL,
        FOREIGN KEY (parent_id) REFERENCES parents (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> registerParentAndChild({
    required String email,
    required String password,
    required String childName,
    required String age,
    required String classProgram,
    required String language,
  }) async {
    final db = await database;

    List<Map<String, dynamic>> existingParents = await db.query(
      'parents',
      where: 'email = ?',
      whereArgs: [email],
    );

    int parentId;

    if (existingParents.isNotEmpty) {
      parentId = existingParents.first['id'];
    } else {
      parentId = await db.insert('parents', {
        'email': email,
        'password': password,
      });
    }

    int childId = await db.insert('children', {
      'parent_id': parentId,
      'name': childName,
      'age': age,
      'class_program': classProgram,
      'language': language,
    });

    return childId;
  }

  // Get all children for a specific parent email
  Future<List<Map<String, dynamic>>> getChildrenForParent(String email) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT children.* FROM children
      INNER JOIN parents ON children.parent_id = parents.id
      WHERE parents.email = ?
    ''', [email]);
  }

  // Parent email se password retrieve karne ke liye
  Future<String?> getPasswordByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'parents',
      columns: ['password'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['password'] as String;
    }
    return null;
  }

  // Child profile delete karne ke liye
  Future<int> deleteChild(int childId) async {
    final db = await database;
    return await db.delete(
      'children',
      where: 'id = ?',
      whereArgs: [childId],
    );
  }
}