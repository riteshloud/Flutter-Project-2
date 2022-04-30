import 'package:flutter/foundation.dart';
import 'package:demo2/helpers/strings.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const _databaseName = "demo2.db";

  static const tableGender = Strings.tableGender;
  static const tableAgeGroup = Strings.tableAgeGroup;
  static const tableGroupSegment = Strings.tableGroupSegment;
  static const tableBrandVariant = Strings.tableBrandVariant;
  static const tableProjects = Strings.tableProjects;
  static const tableProjectOutlets = Strings.tableProjectOutlets;
  static const tableProjectOutletDetail = Strings.tableProjectOutletDetail;
  static const tableProjectOutletDetailData =
      Strings.tableProjectOutletDetailData;
  static const tableOutletExecutionPhotos = Strings.tableOutletExecutionPhotos;
  static const tableOutletContacts = Strings.tableOutletContacts;
  static const tableOutletContactSales = Strings.tableOutletContactSales;
  static const tableOutletContactSalesBrandVariant =
      Strings.tableOutletContactSalesBrandsVariant;
  static const tableStocks = Strings.tableProducts;

  //GENDER, AGE GROUP, GROUP SEGMENT, BRAND VARIANT
  static const id = 'id';
  static const value = 'value';
  static const brand = 'brand';

  //PROJECT LIST
  static const title = 'title';
  static const campaignId = 'campaignId';
  static const description = 'description';
  static const categoryId = 'category_id';
  static const status = 'status';
  static const isCompleted = 'isCompleted';
  static const startDate = 'start_date';
  static const endDate = 'end_date';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const categoryName = 'category_name';
  static const totalUsersCount = 'totalUsersCount';
  static const totalSales = 'total_sales';
  static const totalQuantity = 'total_quantity';
  static const totalAmount = 'totalAmount';
  static const totalOutlet = 'total_outlet';
  static const users = 'users';

  //PROJECT OUTLETS
  static const outletUrl = 'outletUrl';
  static const address = 'address';
  static const outletName = 'outletName';
  static const outletEmail = 'outletEmail';
  static const outletContact = 'outletContact';
  static const ownerName = 'ownerName';
  static const ownerEmail = 'ownerEmail';
  static const ownerContact = 'ownerContact';
  static const personName = 'personName';
  static const personEmail = 'personEmail';
  static const personContact = 'personContact';
  static const checkInStatus = 'checkInStatus';
  static const visitationId = 'visitationId';
  static const day = 'day';
  static const projectId = 'projectId';
  static const isOffline = 'is_offline';

  //PROJECT OUTLETS
  static const outletId = 'outletId';
  static const totalSold = 'totalSold';
  static const effectiveCount = 'effectiveCount';

  //OUTLET CONTACT DETAILS
  static const isEffective = 'isEffective';
  static const userId = 'userId';
  static const isFree = 'isFree';
  static const isVerified = 'isVerified';
  static const gender = 'gender';
  static const ageGroup = 'ageGroup';
  static const groupSegment = 'groupSegment';
  static const effectiveName = 'effectiveName';
  static const effectiveEmail = 'effectiveEmail';
  static const effectiveContact = 'effectivecontact';
  static const orderTotalAmount = 'orderTotalAmount';

  //OUTLET CONTACT SALES
  static const orderId = 'orderId';
  static const productId = 'productId';
  static const quantity = 'quantity';
  static const isOutletStock = 'isOutletStock';
  static const productName = 'productName';

  //PROJECT PRODUCT
  static const name = 'name';
  static const imageUrl = 'imageUrl';
  static const amount = 'amount';
  static const stockId = 'stockId';
  static const balance = 'balance';
  static const isOutlet = 'is_outlet';
  static const isDeleted = 'is_deleted';

  static const brandVariant = 'brands_variant';

  static const tableGenderCreation = """
  CREATE TABLE IF NOT EXISTS $tableGender (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT);""";

  static const tableAgeGroupCreation = """
  CREATE TABLE IF NOT EXISTS $tableAgeGroup (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT);""";

  static const tableGroupSegmentCreation = """
  CREATE TABLE IF NOT EXISTS $tableGroupSegment (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT);""";

  static const tableBrandVarientCreation = """
  CREATE TABLE IF NOT EXISTS $tableBrandVariant (id INTEGER PRIMARY KEY AUTOINCREMENT,brand TEXT,value TEXT);""";

  static const tableProjectCreation = """
  CREATE TABLE IF NOT EXISTS $tableProjects (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,campaignId TEXT,description TEXT, category_id INTEGER,status INTEGER,isCompleted INTEGER,start_date TEXT,end_date TEXT, createdAt TEXT,updatedAt TEXT, category_name TEXT, totalUsersCount INTEGER, total_sales INTEGER, total_quantity INTEGER, totalAmount REAL, total_outlet INTEGER, users TEXT);""";

  static const tableProjectOutletCreation = """
  CREATE TABLE IF NOT EXISTS $tableProjectOutlets (id INTEGER, outletUrl TEXT,address TEXT,outletName TEXT, outletEmail TEXT,outletContact TEXT,ownerName TEXT,ownerEmail TEXT,ownerContact TEXT, personName TEXT,personEmail TEXT, personContact TEXT, status INTEGER, createdAt TEXT, updatedAt TEXT, checkInStatus TEXT, visitationId INTEGER, day TEXT,projectId INTEGER, is_offline INTEGER);""";

  static const tableProjectOutletDetailCreation = """
  CREATE TABLE IF NOT EXISTS $tableProjectOutletDetail (outletId INTEGER,projectId INTEGER,totalSold INTEGER,effectiveCount INTEGER,visitationId INTEGER,checkInStatus TEXT,createdAt TEXT, updatedAt TEXT,is_offline INTEGER);""";

  static const tableProjectOutletDetailDataCreation = """
  CREATE TABLE IF NOT EXISTS $tableProjectOutletDetailData (outletId INTEGER, projectId INTEGER, totalSold INTEGER,visitationId INTEGER,checkInStatus TEXT,is_offline INTEGER);""";

  static const tableOutletExecutionPhotosCreation = """
  CREATE TABLE IF NOT EXISTS $tableOutletExecutionPhotos (id INTEGER PRIMARY KEY AUTOINCREMENT,outletId INTEGER,projectId INTEGER,visitationId INTEGER,imageUrl TEXT,is_deleted INTEGER,is_offline INTEGER);""";

  static const tableOutletContactsCreation = """
  CREATE TABLE IF NOT EXISTS $tableOutletContacts (id INTEGER PRIMARY KEY AUTOINCREMENT,outletId INTEGER,projectId INTEGER,visitationId INTEGER,userId INTEGER,status INTEGER,isEffective INTEGER,isFree INTEGER,isVerified INTEGER,description TEXT,gender TEXT,ageGroup TEXT,groupSegment TEXT,effectiveName TEXT,effectiveEmail TEXT,effectivecontact TEXT,createdAt TEXT,updatedAt TEXT,orderTotalAmount REAL,is_offline INTEGER);""";

  static const tableOutletContactSalesCreation = """
  CREATE TABLE IF NOT EXISTS $tableOutletContactSales (id INTEGER PRIMARY KEY AUTOINCREMENT,outletId INTEGER,projectId INTEGER,visitationId INTEGER,orderId INTEGER,productId INTEGER,isEffective INTEGER,amount INTEGER,quantity INTEGER,totalAmount REAL,isOutletStock INTEGER,createdAt TEXT,updatedAt TEXT,productName TEXT,is_offline INTEGER);""";

  static const tableOutletContactSalesBrandVariantCreation = """
  CREATE TABLE IF NOT EXISTS $tableOutletContactSalesBrandVariant (id INTEGER,outletId INTEGER,projectId INTEGER,visitationId INTEGER,brands_variant TEXT,is_offline INTEGER);""";

  static const tableStockCreation = """
  CREATE TABLE IF NOT EXISTS $tableStocks (id INTEGER,title TEXT, imageUrl TEXT,name TEXT,amount REAL, stockId INTEGER, balance INTEGER, projectId INTEGER, is_outlet INTEGER);""";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    if (kDebugMode) {
      print(dbPath);
    }
    return sql.openDatabase(path.join(dbPath, _databaseName),
        onCreate: (db, version) {
      return _createDb(db);
    }, version: 1);
  }

  static void _createDb(Database db) {
    db.execute(tableGenderCreation);
    db.execute(tableAgeGroupCreation);
    db.execute(tableGroupSegmentCreation);
    db.execute(tableBrandVarientCreation);
    db.execute(tableProjectCreation);
    db.execute(tableProjectOutletCreation);
    db.execute(tableProjectOutletDetailCreation);
    db.execute(tableOutletExecutionPhotosCreation);
    db.execute(tableOutletContactsCreation);
    db.execute(tableOutletContactSalesCreation);
    db.execute(tableOutletContactSalesBrandVariantCreation);
    db.execute(tableStockCreation);
  }

  static Future<void> cleanGeneralConfigTable() async {
    try {
      final db = await database();
      await db.transaction((txn) async {
        var batch = txn.batch();
        db.execute("DELETE FROM " + tableGender);
        db.execute("DELETE FROM " + tableAgeGroup);
        db.execute("DELETE FROM " + tableGroupSegment);
        db.execute("DELETE FROM " + tableBrandVariant);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  static Future<void> clearTableData(String tableName) async {
    try {
      final db = await database();
      await db.transaction((txn) async {
        var batch = txn.batch();
        db.execute("DELETE FROM " + tableName);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getUniqueOutletData(
      String table) async {
    final db = await DBHelper.database();
    return db.rawQuery(
        "SELECT * FROM $table WHERE updatedAt IN (SELECT MAX(updatedAt) FROM $table GROUP BY id, projectId)");
  }

  static Future<List<Map<String, dynamic>>> getDataWithOutletIDandProjectID(
      String table, String outletID, String projectID) async {
    final db = await DBHelper.database();
    return db.query(table,
        where: "outletId=$outletID AND projectId=$projectID");
  }

  static Future<List<Map<String, dynamic>>>
      getAllDataWithOutletIDandProjectIDandVisitationID(String table,
          String outletID, String projectID, String visitationID) async {
    final db = await DBHelper.database();
    return db.query(table,
        where:
            "outletId=$outletID AND projectId=$projectID AND visitationId=$visitationID");
  }

  static Future<List<Map<String, dynamic>>>
      getDataWithOutletIDandProjectIDLatestRecord(
          String table, String outletID, String projectID) async {
    final db = await DBHelper.database();
    return db.query(table,
        where:
            "outletId=$outletID AND projectId=$projectID ORDER BY updatedAt DESC LIMIT 1");
  }

  static Future<List<Map<String, dynamic>>> getDataWithProjectID(
      String table, String projectID) async {
    final db = await DBHelper.database();
    return db.query(table, where: "projectId=$projectID");
  }

  static Future<List<Map<String, dynamic>>>
      getDataWithOutletIDandProjectIDandVisitationID(String table,
          String outletID, String projectID, String visitationID) async {
    final db = await DBHelper.database();
    return db.query(table,
        where:
            "outletId=$outletID AND projectId=$projectID AND visitationId=$visitationID AND is_offline=1");
  }

  static Future<List<Map<String, dynamic>>>
      getDataWithOutletIDandProjectIDWithoutVisitationID(
          String table, String outletID, String projectID) async {
    final db = await DBHelper.database();
    return db.query(table,
        where: "outletId=$outletID AND projectId=$projectID AND is_offline=1");
  }

  static Future<int> updateData(String table, int id, int outletID,
      int projectID, Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "id = ? AND outletId = ? AND projectId = ?",
        whereArgs: [id, outletID, projectID]);
    return result;
  }

  static Future<int> updateExecutionData(String table, int id, int outletID,
      int projectID, int visitationID, Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "id = ? AND outletId = ? AND projectId = ? AND visitationId = ?",
        whereArgs: [id, outletID, projectID, visitationID]);
    return result;
  }

  static Future<int> updateProjectOutletData(String table, int outletID,
      int projectID, Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "id = ? AND projectId = ?", whereArgs: [outletID, projectID]);
    return result;
  }

  static Future<int> updateProjectOutletDataWithVisitationID(
      String table,
      int outletID,
      int projectID,
      String visitationID,
      Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "id = ? AND projectId = ?  AND visitationId = ?",
        whereArgs: [outletID, projectID, visitationID]);
    return result;
  }

  static Future<int> updateOutletDetailData(String table, int outletID,
      int projectID, Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "outletId = ? AND projectId = ?",
        whereArgs: [outletID, projectID]);
    return result;
  }

  static Future<int> updateOutletDetailDataWithVisitationID(
      String table,
      int outletID,
      int projectID,
      String visitationID,
      Map<String, dynamic> mapData) async {
    final db = await DBHelper.database();
    var result = await db.update(table, mapData,
        where: "outletId = ? AND projectId = ? AND visitationId = ?",
        whereArgs: [outletID, projectID, visitationID]);
    return result;
  }

  static Future<void> clearAllTableData() async {
    await DBHelper.cleanGeneralConfigTable();
    await DBHelper.clearTableData(Strings.tableProjects);
    await DBHelper.clearTableData(Strings.tableProjectOutlets);
    await DBHelper.clearTableData(Strings.tableProjectOutletDetail);
    await DBHelper.clearTableData(Strings.tableOutletExecutionPhotos);
    await DBHelper.clearTableData(Strings.tableOutletContacts);
    await DBHelper.clearTableData(Strings.tableOutletContactSales);
    await DBHelper.clearTableData(Strings.tableOutletContactSalesBrandsVariant);
    await DBHelper.clearTableData(Strings.tableProducts);
  }
}
