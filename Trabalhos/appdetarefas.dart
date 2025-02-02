import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

Future criarTarefa(String email, var valor, var token) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/tarefas');
  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  // Corpo da requisição (JSON)
  final Map<String, dynamic> body = {
    'email': email,
    'valor': valor,
  };
  // Converte o body para JSON
  final String jsonBody = json.encode(body);

  try {
    // Realiza a requisição POST
    final response = await http.post(url, headers: headers, body: jsonBody);

    // Verifica o código de status da resposta
    if (response.statusCode == 201) {
      // Sucesso na requisição
      //print('Lista de tarefas criada com sucesso: ${response.body}');
    } else {
      // Erro na requisição
    }
  } catch (e) {
    // Tratamento de exceções
  }
}

Future criarUsuario(
    String nome, String email, String senha, String? celular) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/rpc/registra_usuario');

  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Corpo da requisição (JSON)
  final Map<String, String?> body = {
    'nome': nome,
    'email': email,
    'senha': senha,
    'celular': celular,
  };

  // Converte o body para JSON
  final String jsonBody = json.encode(body);
  try {
    // Realiza a requisição POST
    final response = await http.post(url, headers: headers, body: jsonBody);

    // Verifica o código de status da resposta
    if (response.statusCode == 200) {
      // Sucesso na requisição
      //print('Login realizado com sucesso: ${response.body}');
      //final Map<String, dynamic> resposta = json.decode(response.body);

      return "Usuário criado com sucesso!";
    } else {
      // Erro na requisição
      String erro = 'Erro: ${response.statusCode} - ${response.body}';
      return erro;
    }
  } catch (e) {
    // Tratamento de exceções
    String erro = 'Ocorreu um erro: ${e.toString()}';
    return erro;
  }
}

Future fazerLogin(String email, String senha) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/rpc/fazer_login');

  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Corpo da requisição (JSON)
  final Map<String, String> body = {
    'email': email,
    'senha': senha,
  };

  // Converte o body para JSON
  final String jsonBody = json.encode(body);
  try {
    // Realiza a requisição POST
    final response = await http.post(url, headers: headers, body: jsonBody);

    // Verifica o código de status da resposta
    if (response.statusCode == 200) {
      // Sucesso na requisição
      //print('Login realizado com sucesso: ${response.body}');
      final Map<String, dynamic> resposta = json.decode(response.body);

      return resposta["token"];
    } else {
      // Erro na requisição
      String erro = 'Erro: ${response.statusCode} - ${response.body}';
      return erro;
    }
  } catch (e) {
    // Tratamento de exceções
    String erro = 'Ocorreu um erro: ${e.toString()}';
    return erro;
  }
}

class BaseLista extends StatefulWidget {
  final String title;
  final String token;
  final String email;

  const BaseLista(
      {super.key,
        required this.title,
        required this.token,
        required this.email});

  @override
  State<BaseLista> createState() => ListaTarefas(token: token, email: email);
}

class CadastroPage extends StatelessWidget {
  final nome = TextEditingController();

  final emailCadastro = TextEditingController();
  final senhaCadastro = TextEditingController();
  final confsenhaCadastro = TextEditingController();
  final celularCadastro = TextEditingController();
  CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: '',
      backgroundImage: 'https://i.imgur.com/XZcScC0.gif',
      height: 540,
      bodyContent: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    height: 80,
                    width: 280,
                    padding: const EdgeInsets.only(bottom: 45),
                    child: const DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            boxShadow: [BoxShadow(color: Colors.black54)],
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: Center(
                            child: Text(
                              'Criar usuário',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                  ),
                  TextField(
                    controller: nome,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.white,
                      //icon: Icon(Icons.person),
                      //iconColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: emailCadastro,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: Colors.white,
                      //icon: Icon(Icons.email),
                      //iconColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: celularCadastro,
                    decoration: const InputDecoration(
                      labelText: "Celular",
                      prefixIcon: Icon(Icons.smartphone),
                      prefixIconColor: Colors.white,
                      //icon: Icon(Icons.smartphone),
                      //iconColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    autofocus: false,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: senhaCadastro,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.password_sharp),
                      prefixIconColor: Colors.white,
                      //icon: Icon(Icons.password),
                      //iconColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    autofocus: false,
                  ),
                  const SizedBox(height: 5),
                  TextField(

                    controller: confsenhaCadastro,
                    decoration: const InputDecoration(
                      labelText: "Confirmar Senha",
                      prefixIcon: Icon(Icons.password_rounded),
                      prefixIconColor: Colors.white,
                      //icon: Icon(Icons.password_outlined),
                      //iconColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    autofocus: false,
                  ),
                  const SizedBox(height: 15),
                  FloatingActionButton.extended(
                    heroTag: 'cadastrar', // Tag única para o FAB de adicionar
                    backgroundColor: Colors.blueGrey,
                    onPressed: () async {
                      final String mensagem;
                      final Map<String, dynamic> resposta;
                      if (senhaCadastro.text == confsenhaCadastro.text) {
                        var checar = await criarUsuario(
                            nome.text,
                            emailCadastro.text,
                            senhaCadastro.text,
                            celularCadastro.text.isEmpty ? null : celularCadastro.text);
                        checar.substring(0, 7) == "Usuário"
                            ? mensagem = checar
                            : mensagem = checar.substring(12, checar.length);

                        mensagem.length > 50
                            ? resposta = json.decode(mensagem)
                            : resposta = {'name': 'John'};

                        if (checar.substring(0, 4) == "Erro") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(resposta["message"])),
                          );
                        } else {
                          if (checar.substring(0, 6) == "Ocorreu") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(resposta["message"])),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(mensagem)),
                            );
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "As senhas inseridas não estão iguais!")),
                        );
                      }
                    },
                    tooltip: 'Cadastrar usuário',
                    enableFeedback: true,
                    splashColor: Colors.brown,
                    label: const Row(
                      children: [
                        Icon(Icons.person_add, color: Colors.white),
                        SizedBox(width: 4),
                        Text("Cadastrar usuário",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

// Classe base para todas as páginas personalizáveis
class CustomPage extends StatelessWidget {
  final String title;
  final Widget bodyContent;
  final double height;
  final String backgroundImage;

  final textController = TextEditingController();

  CustomPage({
    super.key,
    required this.title,
    required this.bodyContent,
    required this.height,
    this.backgroundImage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      resizeToAvoidBottomInset: true, // Ajusta o layout automaticamente

      body: Center(
        child: Container(
          height: height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: backgroundImage.isNotEmpty
                ? DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(backgroundImage),
            )
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          margin: const EdgeInsets.all(12),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: bodyContent,
        ),
      ),
    );
  }
}

class ListaTarefas extends State<BaseLista> {
  final String token;
  final String email;

  final List<Task> taskList = []; // Lista de tarefas pendentes

  final List<Task> completedTasks = []; // Lista de tarefas completadas
  final textController = TextEditingController();
  ListaTarefas({required this.token, required this.email});

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

  Widget strikeout(String tarefa) {
    return Text(
      tarefa,
      style: const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.green),
    );
  }

  void _addTask(String st) {
    setState(() {
      if (st.trim() != '' && !_taskExists(st)) {
        taskList.add(Task(st.trim()));
        textController.clear();
        //var valor = {
        //  "titulo" : st.trim(),
        //  "concluida" : "false",
        //  "ordem" : "1"
        //};
        //criarTarefa(email, valor, token);
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

  void _deleteTask(int index, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        completedTasks.removeAt(index);
      } else {
        taskList.removeAt(index);
      }
    });
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

  bool _taskExists(String st) {
    return taskList.any((task) => task.description == st.trim()) ||
        completedTasks.any((task) => task.description == st.trim());
  }
}

// Página de Login utilizando a CustomPage
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailLogin = TextEditingController();
  final TextEditingController senhaLogin = TextEditingController();
  bool senhaVisivel = false; // Controle de visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: '',
      backgroundImage: 'https://art.pixilart.com/84e41d824c52e3e.gif',
      height: 380,
      bodyContent: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Container(
                height: 80,
                width: 280,
                padding: const EdgeInsets.only(bottom: 45),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    boxShadow: [BoxShadow(color: Colors.black54)],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      'Efetuar Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              TextField(
                controller: emailLogin,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Colors.white,
                  labelText: "E-mail",
                  //icon: Icon(Icons.email),
                  //iconColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: senhaLogin,
                obscureText: !senhaVisivel, // Controla visibilidade
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.password),
                  prefixIconColor: Colors.white,
                  //icon: const Icon(Icons.password),
                  //iconColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        senhaVisivel = !senhaVisivel;
                      });
                    },
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'login',
                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () async {
                      final String mensagem;
                      final Map<String, dynamic> resposta;
                      var token = await fazerLogin(
                        emailLogin.text,
                        senhaLogin.text,
                      );
                      token.length <= 100
                          ? mensagem = token.substring(12)
                          : mensagem = token;

                      mensagem.length <= 100
                          ? resposta = json.decode(mensagem)
                          : resposta = {'name': 'John'};

                      if (token.startsWith("Erro")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(resposta["message"])),
                        );
                      } else if (token.startsWith("Ocorreu")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(resposta["message"])),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BaseLista(
                              title: "Lista de Tarefas",
                              token: mensagem,
                              email: emailLogin.text,
                            ),
                          ),
                        );
                      }
                    },
                    tooltip: 'Fazer login',
                    enableFeedback: true,
                    splashColor: Colors.deepPurple,
                    label: const Row(
                      children: [
                        Icon(Icons.login, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Fazer login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  FloatingActionButton.extended(
                    heroTag: 'criar',
                    backgroundColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastroPage(),
                        ),
                      );
                    },
                    tooltip: 'Cadastrar Usuário',
                    enableFeedback: true,
                    splashColor: Colors.deepPurple,
                    label: const Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Criar usuário",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Modular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.indigo,
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginPage(), // Página inicial (Login)
    );
  }
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
