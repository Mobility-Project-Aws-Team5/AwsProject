abstract class MyDatabase{
  static Future<MyDatabase> iniitializeDB() {
    throw UnimplementedError();
  }

  String getName();

  Future<List<Map<String,dynamic>>> selectAll();
  Future<List<Map<String,dynamic>>> selectUser(String name);
  Future<void> insertUser(String name, int age);
  Future<void> updateUser(String name, int age);
  Future<void> deleteUser(String name);
  Future<void> deleteAll();
  Future<void> close();
}