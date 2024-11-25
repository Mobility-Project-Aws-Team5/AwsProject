import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'my_database.dart';

class MysqlDb extends MyDatabase {
  late MySQLConnection _conn;

  String getName() {
    return "MySQL";
  }

  MysqlDb(this._conn);

  static Future<MyDatabase> initializeDB() async {
    // 데이터베이스를 엽니다.

    var conn = await MySQLConnection.createConnection(
        host: '192.168.2.2',
        port: 3306,
        userName: 'test',
        password: 'test',
        databaseName: 'computer');

    await conn.connect();

    return MysqlDb(conn);
  }

  Future<List<Map<String, dynamic>>> selectAll() async {
    List<Map<String, dynamic>> list = [];
    var result = await _conn.execute('select * from users');
    for (var row in result.rows) {
      list.add(row.assoc());
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> selectUser(String name) async {
    List<Map<String, dynamic>> list = [];
    var result = await _conn
        .execute('select * from users where name = :name', {"name": name});
    for (var row in result.rows) {
      list.add(row.assoc());
    }
    return list;
  }

  Future<void> insertUser(String name, int age) async {
    await _conn.execute('insert into users(name, age) values(:name, :age)',
        {"name": name, "age": age});
  }

  Future<void> updateUser(String name, int age) async {
    await _conn.execute('update users set age = :age where name = :name',
        {"age": age, "name": name});
  }

  Future<void> deleteUser(String name) async {
    await _conn.execute('delete from users where name = :name', {"name": name});
  }

  Future<void> deleteAll() async {
    await _conn.execute('delete from users');
  }

  Future<void> close() async {
    await _conn.close();
  }
  
}