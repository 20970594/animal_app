import 'package:sqflite/sqflite.dart';
import 'package:fgc_app/data/routines.dart';

class RoutineDatabase{
  RoutineDatabase._privateConstructor();

  static final RoutineDatabase instance = RoutineDatabase._privateConstructor();

  static const _databaseName = 'routine_database.db';
  static const _databaseVersion = 1;

  // Function to open the database (or create it if it doesn't exist)
  Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    print('The versions in _databaseVersion is $_databaseVersion');
    return await openDatabase(
      '$databasePath/$_databaseName',
      onCreate: (db, version) {
        // Create the "game" table on database creation
        print('The versions in version is $version');
        db.execute('''
          CREATE TABLE routine(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            difficulty TEXT,
            objective1 TEXT,
            instructions1 TEXT,
            objective2 TEXT,
            instructions2 TEXT
            objective3 TEXT
            instructions3 TEXT),
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async  {
        // Handle database schema upgrades if needed
        // (implement logic for updating existing tables here)
        print('The versions in oldVersion is $oldVersion and newVersion is $newVersion');
        for (int version = oldVersion + 1; version <= newVersion; version++) {
          
          switch (version) {
            case 3:
              // Create a new table with the desired AUTOINCREMENT column
              print('The version is ${version} and Create a new table with the desired AUTOINCREMENT column');
              await db.execute('''
                CREATE TABLE routine_new(
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  difficulty TEXT,
                  objective1 TEXT,
                  instructions1 TEXT,
                  objective2 TEXT,
                  instructions2 TEXT
                  objective3 TEXT
                  instructions3 TEXT),
              ''');

              // Migrate data from the old table to the new table
              final oldData = await db.query('routine');
              for (final row in oldData) {
                await db.insert('routine_new', row);
              }

              // Drop the old table after successful migration
              await db.execute('DROP TABLE routine');

              // Rename the new table to the original name
              await db.execute('ALTER TABLE routine_new RENAME TO routine');
              break;
            default:
              throw Exception('Unsupported upgrade version: $version');
          }
        }
      },  
      version: 1,//This version is for determinate the OnCreate, onUpgrade or onDowngrade option. (new version)
    );
  }

  //Fcution to insert routine
  Future<void> insertRoutine(Routine routine) async {
    final database = await RoutineDatabase.instance.database;
    await database.insert(
      'routine',
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to get all Games
  Future<List<Routine>> getRoutines() async {
    final database = await RoutineDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await database.query('routine');
    return List.generate(maps.length, (i) => Routine.fromMap(maps[i]));
  }

  
}