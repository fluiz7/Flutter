import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lista de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Task {
  String description;
  bool isSelected;
  bool isDeleting;
  Completer<bool?> exclusaoCompleter;
  Completer<bool?> conclusaoCompleter;

  Task(this.description)
      : isSelected = false,
        isDeleting = false,
        exclusaoCompleter = Completer(),
        conclusaoCompleter = Completer();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> taskList = []; // Lista de tarefas pendentes
  final List<Task> completedTasks = []; // Lista de tarefas completadas
  final textController = TextEditingController();

  void _addTask(String st) {
    setState(() {
      if (st.trim() != '' && !_taskExists(st)) {
        taskList.add(Task(st.trim()));
        textController.clear();
      }
    });
  }

  void _deleteTask(int index, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        completedTasks.removeAt(index);
      } else {
        taskList.removeAt(index);
      }
    });
  }

  bool _taskExists(String st) {
    return taskList.any((task) => task.description == st.trim()) ||
        completedTasks.any((task) => task.description == st.trim());
  }

  void _startDeleteProcess(int index, bool isCompleted) {
    setState(() {
      var task = isCompleted ? completedTasks[index] : taskList[index];
      task.isDeleting = true;
    });

    var task = isCompleted ? completedTasks[index] : taskList[index];
    if (!task.exclusaoCompleter.isCompleted) {
      task.exclusaoCompleter = Completer<bool?>();
    }

    Future.any([
      Future.delayed(const Duration(seconds: 3), () => true),
      task.exclusaoCompleter.future,
    ]).then((value) {
      if (value == true) {
        _deleteTask(index, isCompleted);
      } else {
        setState(() {
          task.isDeleting = false;
          task.exclusaoCompleter = Completer<bool?>();
        });
      }
    });
  }

  void _completed(Task task, int index) {
    setState(() {
      completedTasks.insert(
          0, Task(task.description)); // Adiciona ao topo dos completados
      taskList.removeAt(index);

      if (!task.conclusaoCompleter.isCompleted) {
        task.conclusaoCompleter.complete(true);
      }
      // Recria o Completer após completar
      task.conclusaoCompleter = Completer<bool?>();
    });
  }

  Widget strikeout(String tarefa) {
    return Text(
      tarefa,
      style: const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: const Icon(Icons.format_list_numbered_outlined),
        backgroundColor: Colors.blue.shade400,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 204),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      controller: textController,
                      autofocus: true,
                      onSubmitted: _addTask,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5),
                  // Espaçamento à esquerda do botão
                  child: FloatingActionButton(
                    onPressed: () => _addTask(textController.text),
                    tooltip: 'Add text',
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white10,
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                itemCount: taskList.length + completedTasks.length,
                itemBuilder: (context, index) {
                  bool isCompletedTask = index >= taskList.length;
                  int taskIndex =
                      isCompletedTask ? index - taskList.length : index;
                  Task task = isCompletedTask
                      ? completedTasks[taskIndex]
                      : taskList[taskIndex];

                  return Container(
                    color: Colors.blue.shade200,
                    margin: const EdgeInsets.all(4),
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: isCompletedTask
                          ? DismissDirection
                              .endToStart // Só permite deletar completadas
                          : DismissDirection
                              .horizontal, // Permite marcar como feito ou deletar pendentes,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          setState(() {
                            var removedItem = task.description;
                            task.exclusaoCompleter.complete(false);
                            task.exclusaoCompleter = Completer<bool?>();
                            _deleteTask(taskIndex, isCompletedTask);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$removedItem removido'),
                                action: SnackBarAction(
                                  label: 'Desfazer',
                                  onPressed: () {
                                    setState(() {
                                      if (isCompletedTask) {
                                        completedTasks.insert(taskIndex, task);
                                      } else {
                                        taskList.insert(taskIndex, task);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                        } else if (direction == DismissDirection.startToEnd) {
                          if (!isCompletedTask) {
                            setState(() {
                              var removedItem = task.description;
                              _completed(task, taskIndex);
                              task.conclusaoCompleter.complete(true);
                              task.conclusaoCompleter = Completer<bool?>();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '$removedItem marcado como feito')),
                              );
                            });
                          }
                        }
                      },
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          return Future.any([
                            Future.delayed(
                                const Duration(seconds: 3), () => true),
                            task.exclusaoCompleter.future,
                          ]);
                        }
                        return Future.value(
                            true); // Deslizar para a direita é imediato
                      },
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          onPressed: () {
                            // Reinicia o Completer para permitir o swipe de novo
                            setState(() {
                              task.exclusaoCompleter.complete(false);
                              task.exclusaoCompleter = Completer<bool?>();
                            });
                          },
                          icon: const Icon(Icons.undo, color: Colors.white),
                        ),
                      ),

                      child: Container(
                        margin: const EdgeInsets.all(2),
                        color: task.isDeleting
                            ? Colors.red.shade400
                            : task.isSelected
                                ? Colors.green.shade200
                                : index % 2 == 0
                                    ? Colors.blue.shade50
                                    : Colors.blue.shade100,
                        child: ListTile(
                          title: isCompletedTask
                              ? strikeout(task.description)
                              : Text(task.description),
                          textColor: task.isSelected
                              ? Colors.grey.shade600
                              : Colors.black,
                          trailing: IconButton(
                            icon: task.isDeleting
                                ? const Icon(Icons.undo)
                                : const Icon(Icons.delete),
                            color: task.isDeleting
                                ? Colors.white
                                : Colors.red.shade600,
                            onPressed: () {
                              if (task.isDeleting) {
                                task.exclusaoCompleter.complete(false);
                              } else {
                                _startDeleteProcess(taskIndex, isCompletedTask);
                              }
                            },
                          ),
                          leading: isCompletedTask
                              ? const Icon(Icons.check_box)
                              : IconButton(
                                  icon: task.isSelected
                                      ? const Icon(Icons.check_box)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                  color: task.isSelected
                                      ? Colors.green
                                      : Colors.black,
                                  onPressed: () {
                                    if (!isCompletedTask) {
                                      _completed(task, taskIndex);
                                    }
                                  },
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
