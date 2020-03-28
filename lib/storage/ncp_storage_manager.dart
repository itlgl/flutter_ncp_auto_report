//import 'package:sqflite/sqflite.dart';
//
//class NcpStorageManager {
//  Future<Database> openDb() async {
//    return await openDatabase('ncp_report.db',
//        version: 1,
//        onCreate: (Database db, int version) async {
//          await db.execute('CREATE TABLE tbl_person_info ('
//              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//              'name TEXT,'
//              'departmentId INTEGER,'
//              'subDepartment TEXT,'
//              'mobile TEXT,'
//              'symptomsOne INTEGER,'
//              'symptomsOneFamily INTEGER,'
//              'contactWuhan INTEGER,'
//              'addressPresent TEXT,'
//              'attentionFlag INTEGER,'
//              'attentionInfo TEXT,'
//              'workTraffic TEXT,'
//              'yesterdayTrail TEXT,'
//              'livingFamilyTrail TEXT,'
//              'latestReportTime INTEGER'
//              ')');
//
////          await db.execute('CREATE TABLE tbl_report_history ('
////              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
////              'reportMillis INTEGER,'
////              'reportDate TEXT,'
////              'reportResult INTEGER,'
////              'name TEXT,'
////              'departmentId INTEGER,'
////              'subDepartment TEXT,'
////              'mobile TEXT,'
////              'symptomsOne INTEGER,'
////              'symptomsOneFamily INTEGER,'
////              'contactWuhan INTEGER,'
////              'addressPresent TEXT,'
////              'attentionFlag INTEGER,'
////              'attentionInfo TEXT,'
////              'workTraffic TEXT,'
////              'yesterdayTrail TEXT,'
////              'livingFamilyTrail TEXT'
////              ')');
//        });
//  }
//
//
//}
