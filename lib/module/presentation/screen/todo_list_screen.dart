import 'package:flutter/material.dart';

import '../../domain/entity/todo_entity.dart';
import '../../domain/use_case/app_use_case.dart';
import '../../external/colors/app_colors.dart';
import '../../external/constant/app_constant.dart';
import '../../external/libraries/libraries.dart';
import '../view_model/todo_list_view_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TodoListViewModel? _viewModel;

  @override
  void initState() {
    _viewModel = TodoListViewModel(
      useCase: GetIt.I.get<AppUseCase>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel!,
      child: Consumer<TodoListViewModel>(
        builder: (_, __, ___) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("To-Do List"),
              elevation: 0,
            ),
            body: _viewModel!.todoList == null || _viewModel!.todoList!.isEmpty
                ? _buildEmptyState()
                : _buildList(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showInputText(),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  RefreshIndicator _buildList() {
    return RefreshIndicator(
      onRefresh: () => _getData(),
      child: ListView.separated(
        itemBuilder: (context, index) {
          final data = _viewModel!.todoList![index];

          return ListTile(
            title: Text(
              data.todo,
              style: TextStyle(
                color: data.isDone ? AppColors.grey1 : AppColors.black,
                decoration: data.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: CircleAvatar(
              child: data.isDone
                  ? const Icon(Icons.check)
                  : Text(data.todo.substring(0, 1).toUpperCase()),
            ),
            onTap: () => _doneTodo(data),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount:
            _viewModel!.todoList == null ? 0 : _viewModel!.todoList!.length,
      ),
    );
  }

  _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      alignment: const Alignment(0, -0.3),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.list_alt_rounded,
          size: MediaQuery.of(context).size.width * 0.4,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        Text(
          "Data masih kosong. Tekan Tombol di bawah ini untuk menambahkan data",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
        )
      ]),
    );
  }

  _showInputText() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              const Text(
                "Add new To-Do",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ]),
            Row(children: [
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _viewModel!.inputController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Ex: Create new to-do",
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _insertData(),
                child: const Text("TAMBAH"),
              ),
              const SizedBox(width: 12),
            ]),
          ]),
        );
      },
    );
  }

  _getData() async {
    final state = await _viewModel!.getAll();

    state.when(
      success: () {},
      clientError: () => _showMessage(
        AppConstant.clientError,
        () => _getData(),
      ),
      serverError: () => _showMessage(
        AppConstant.serverError,
        () => _getData(),
      ),
      networkError: () => _showMessage(
        AppConstant.networkError,
        () => _getData(),
      ),
    );
  }

  _insertData() async {
    if (_viewModel!.inputController.text.isEmpty) {
      _showDialogMessage();

      return;
    }

    final state = await _viewModel!.insertTodo();

    state.when(
      success: () {
        _viewModel!.inputController.clear();
        Navigator.pop(context);
        _getData();
      },
      clientError: () => _showMessage(
        AppConstant.clientError,
        () => _getData(),
      ),
      serverError: () => _showMessage(
        AppConstant.serverError,
        () => _getData(),
      ),
      networkError: () => _showMessage(
        AppConstant.networkError,
        () => _getData(),
      ),
    );
  }

  _doneTodo(TodoEntity data) async {
    final state = await _viewModel!.doneTodo(data);

    state.when(
      success: () => _getData(),
      clientError: () => _showMessage(
        AppConstant.clientError,
        () => _getData(),
      ),
      serverError: () => _showMessage(
        AppConstant.serverError,
        () => _getData(),
      ),
      networkError: () => _showMessage(
        AppConstant.networkError,
        () => _getData(),
      ),
    );
  }

  _showMessage(String message, Function() onTap) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 100),
        action: SnackBarAction(
          label: "Refresh",
          onPressed: onTap,
        ),
      ),
    );
  }

  _showDialogMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: const Text("ERROR!!!"),
          content: const Text("Cannot add empty value. Please add some text."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
