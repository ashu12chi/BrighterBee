import 'dart:async';

import 'package:brighter_bee/models/post_entry.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// @author: Nishchal Siddharth Pandey
// Oct 17, 2020
// This is helpful in inserting/updating/deleting post in db

insertPostInDb(PostEntry post) async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<sqflite.Database> database = sqflite
      .openDatabase(join(await sqflite.getDatabasesPath(), 'draft_database.db'),
          onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      "CREATE TABLE drafts(time INTEGER PRIMARY KEY, text TEXT)",
    );
  }, version: 1);

  final sqflite.Database db = await database;
  await db.insert('drafts', post.toMap(),
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
}

Future<List<PostEntry>> getPostsListFromDb() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final Future<sqflite.Database> database = sqflite.openDatabase(
      join(await sqflite.getDatabasesPath(), 'draft_database.db'),
      version: 1,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE drafts(time INTEGER PRIMARY KEY, text TEXT)",
        );
      },
    );

    final sqflite.Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('drafts');

    return List.generate(maps.length,
        (i) => PostEntry(time: maps[i]['time'], text: maps[i]['text']));
  } catch (e) {
    print('An error occurred! ' + e.toString());
  }
}

updatePostInDb(PostEntry post) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final Future<sqflite.Database> database = sqflite.openDatabase(
        join(await sqflite.getDatabasesPath(), 'draft_database.db'),
        version: 1, onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE drafts(time INTEGER PRIMARY KEY, text TEXT)",
      );
    });

    final db = await database;
    await db.update('drafts', post.toMap(),
        where: 'time = ?', whereArgs: [post.time]);
  } catch (e) {
    print('An error occurred! ' + e.toString());
  }
}

deletePostFromDb(int time) async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<sqflite.Database> database = sqflite
      .openDatabase(join(await sqflite.getDatabasesPath(), 'draft_database.db'),
          onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      "CREATE TABLE drafts(time INTEGER PRIMARY KEY, text TEXT)",
    );
  }, version: 1);

  final db = await database;
  await db.delete('drafts', where: 'time = ?', whereArgs: [time]);
}
