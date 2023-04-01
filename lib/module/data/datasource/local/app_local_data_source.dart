import 'dart:convert';

import '../../../domain/entity/todo_entity.dart';
import '../../../external/constant/app_constant.dart';
import '../../../external/encryption/aes.dart';
import '../../../external/libraries/libraries.dart';

abstract class AppLocalDataSource {
  Future<List<TodoEntity>> getAll();

  Future<bool> insertTodo(TodoEntity params);

  Future<bool> doneTodo(TodoEntity params);
}

class AppLocalDataSourceImpl extends AppLocalDataSource {
  @override
  Future<List<TodoEntity>> getAll() async {
    final data = json.decode(await _load());
    final result =
        List<TodoEntity>.from(data.map((x) => TodoEntity.fromJson(x)));

    return result;
  }

  @override
  Future<bool> insertTodo(TodoEntity params) async {
    final list = await getAll();
    list.add(params);

    return await _save(list);
  }

  @override
  Future<bool> doneTodo(TodoEntity params) async {
    final list = await getAll();
    int index = list.indexWhere((el) => el.id == params.id);

    /// Update selected
    final newValue = TodoEntity(
      id: params.id,
      todo: params.todo,
      isDone: true,
    );

    /// Replace with new value
    list.replaceRange(index, index + 1, [newValue]);

    return await _save(list);
  }

  Future<bool> _save(List<TodoEntity> order) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      String base64 = AesEncryption.encryptData(json.encode(order));
      sharedPreferences.setString(AppConstant.prefsTodo, base64);

      return true;
    } catch (e) {
      return false;
    }
  }

  _load() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AppConstant.prefsTodo) == null ||
        sharedPreferences.getString(AppConstant.prefsTodo)!.isEmpty) {
      return "[]";
    }

    String base64 = sharedPreferences.getString(AppConstant.prefsTodo)!;
    String string = AesEncryption.decryptData(base64);

    return string;
  }
}
