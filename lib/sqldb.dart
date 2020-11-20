
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class Numero{
int id;
String numero;

Numero(this.id,this.numero);

Map<String,dynamic> toMap(){
var map=<String,dynamic>{'id':id,'numero':numero};
return map;
}

Numero.fromMap(Map<String,dynamic> map){
  id=map['id'];
  numero=map['numero'];
}
}

class DBHelper{
  static const String DB_NAME="numero.db";
  static const String ID="id";
  static const String NUMERO="numero";
  static const String TABLE="Numero";
  static  List<Numero> nume;
  static String nume1;
  static Database _db;

Future<Database> get db async{
if(_db!=null){
  return _db;
}
_db=await initDb();
return _db;
}

initDb() async{
  io.Directory documentsDirectory=await getApplicationDocumentsDirectory();
  String path=join(documentsDirectory.path, DB_NAME);
  var db=await openDatabase(path,version: 1,onCreate: _onCreate);
  return db;
}

_onCreate(Database db,int version) async{
await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,$NUMERO TEXT)");
}

Future<Numero> save(Numero numero) async{
  var dbClient=await db;
  numero.id=await dbClient.insert(TABLE, numero.toMap());
  return numero;
/*
  await dbClient.transaction((txn) async{
var query="INSERT INTO $TABLE ($NAME) VALUES('"+employee.name+"')";
return await txn.rawInsert(query);
  });
  */
}

Future<List<Numero>> getnumeros() async{
  var dbClient=await db;
  var res=await dbClient.query("Numero");
 nume=res.isNotEmpty?res.map((e) => Numero.fromMap(e)).toList():null;
 nume1=nume[0].numero;
return nume;
}
Future<int> delete(int id) async{
  var dbClient=await db;
  return await dbClient.delete(TABLE,where:'$ID=?',whereArgs: [id]);
}

Future<int> update(Numero numero) async{
  var dbClient=await db;
  return await dbClient.update(TABLE,numero.toMap(),where: '$ID=?',whereArgs: [numero.id]);
}

Future close() async{
  var dbClient=await db;
  dbClient.close();
}
}
