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
    } else {
      // Erro na requisição
    }
  } catch (e) {
    // Tratamento de exceções
  }
}

Future atualizarTarefa(
    String email, var pendentes, var concluidas, var token) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/tarefas');
  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final valor = [];
  for (int i = 0; i < pendentes.length; i++) {
    valor.add(
        {"titulo": pendentes[i].description, "concluida": false, "ordem": i});
  }
  for (int i = 0; i < concluidas.length; i++) {
    valor.add(
        {"titulo": concluidas[i].description, "concluida": true, "ordem": i});
  }

  // Corpo da requisição (JSON)
  final Map<String, dynamic> body = {
    'email': email,
    'valor': valor,
  };
  // Converte o body para JSON
  final String jsonBody = json.encode(body);

  try {
    // Realiza a requisição PATCH
    final response = await http.patch(url, headers: headers, body: jsonBody);

    // Verifica o código de status da resposta
    if (response.statusCode == 204) {
      // Sucesso na requisição
    } else {
      // Erro na requisição
    }
  } catch (e) {
    // Tratamento de exceções
  }
}

Future obterTarefa(String email, var token) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/tarefas');
  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    // Realiza a requisição GET
    final response = await http.get(
      url,
      headers: headers,
    );

    // Converte o body para JSON
    var jsonBody = json.decode(response.body);

    if (response.body.startsWith('{"code":"PGRST301",')) {
      return [false, jsonBody];
    } else {
      var lista = await jsonBody[0]["valor"];
      // Verifica o código de status da resposta
      if (response.statusCode == 200) {
        // Sucesso na requisição
        return [true, lista];
      } else {
        // Erro na requisição
        return [false, jsonBody];
      }
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
  State<BaseLista> createState() => ListaTarefas();
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool senhaVisivel = false; // Controle de visibilidade da senha
  bool confsenhaVisivel = false; // Controle de visibilidade da senha
  final nome = TextEditingController();
  final emailCadastro = TextEditingController();
  final senhaCadastro = TextEditingController();
  final confsenhaCadastro = TextEditingController();
  final celularCadastro = TextEditingController();
  final FocusNode senhaFocusNode = FocusNode();
  final FocusNode confSenhaFocusNode = FocusNode();

  @override
  void dispose() {
    // Libera recursos dos controladores ao desmontar o widget.
    nome.dispose();
    emailCadastro.dispose();
    senhaCadastro.dispose();
    confsenhaCadastro.dispose();
    celularCadastro.dispose();
    senhaFocusNode.dispose();
    confSenhaFocusNode.dispose();

    super.dispose();
  }

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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      'Criar usuário',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              _buildTextField(
                controller: nome,
                label: "Nome",
                icon: Icons.person,
              ),
              const SizedBox(height: 5),
              _buildTextField(
                controller: emailCadastro,
                label: "E-mail",
                icon: Icons.email,
              ),
              const SizedBox(height: 5),
              _buildTextField(
                controller: celularCadastro,
                label: "Celular",
                icon: Icons.smartphone,
              ),
              const SizedBox(height: 5),
              TextField(
                controller: senhaCadastro,
                obscureText: !senhaVisivel,
                focusNode: senhaFocusNode,
                enableInteractiveSelection: false,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Colors.white),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
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
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) {
                  // Muda o foco para o campo de confirmação de senha.
                  FocusScope.of(context).requestFocus(confSenhaFocusNode);
                },
              ),
              const SizedBox(height: 5),
              TextField(
                controller: confsenhaCadastro,
                obscureText: !confsenhaVisivel,
                focusNode: confSenhaFocusNode,
                enableInteractiveSelection: false,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Confirmar senha",
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      confsenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        confsenhaVisivel = !confsenhaVisivel;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              FloatingActionButton.extended(
                heroTag: 'cadastrar',
                backgroundColor: Colors.blueGrey,
                onPressed: _cadastrarUsuario,
                tooltip: 'Cadastrar usuário',
                enableFeedback: true,
                splashColor: Colors.brown,
                label: const Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      "Cadastrar usuário",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir campos de texto reutilizáveis.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  // Função assíncrona para criar usuário.
  Future<void> _cadastrarUsuario() async {
    final String mensagem;
    final Map<String, dynamic> resposta;

    if (senhaCadastro.text != confsenhaCadastro.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("As senhas inseridas não estão iguais!")),
        );
      }
      return;
    }

    var checar = await criarUsuario(
      nome.text,
      emailCadastro.text,
      senhaCadastro.text,
      celularCadastro.text.isEmpty ? null : celularCadastro.text,
    );

    mensagem = checar.startsWith("Usuário") ? checar : checar.substring(12);

    resposta = mensagem.length > 50 ? json.decode(mensagem) : {'name': 'John'};

    if (!mounted) return;

    if (checar.startsWith("Erro") || checar.startsWith("Ocorreu")) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resposta["message"])),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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

class ListaTarefas extends State<BaseLista>
    with SingleTickerProviderStateMixin {
  bool listaVazia = false;
  bool inicio = true;
  late String token;
  late String email;
  List<Task> taskList = []; // Lista de tarefas pendentes
  List<Task> completedTasks = []; // Lista de tarefas completadas
  final textController = TextEditingController();
  final animatedKey = GlobalKey<AnimatedListState>();
  late Task tarefa;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;


  @override
  void initState() {
    super.initState();
    // Inicializando as variáveis com os valores recebidos do widget.
    token = widget.token;
    email = widget.email;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Configura o Tween para rotacionar apenas um ângulo pequeno (exemplo: 0.1 volta)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Inverte a animação para retornar ao ponto inicial
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    // Libera recursos dos controladores ao desmontar o widget.
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Função para iniciar a rotação manualmente
  void _startRotation(bool direcao) {
    if (direcao) {
      _controller.forward(from: 0);
    } else {
      _controller.forward(from: 0);
    }
  }

  void _mostrarDialogoExpirado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Impede que o diálogo seja fechado clicando fora dele
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text("Acesso expirado!"),
            content: const Text(
                "Você será redirecionado para a página de login novamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                        const LoginPage()), // Redireciona para o login
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = MediaQuery.of(context).size.height * 0.07;
    double itemWidth = MediaQuery.of(context).size.width * 0.07;

    setState(() {
      if (inicio) {
        tarefa = Task("TEXTO");
        tarefa.origem = true;
      }
      obterTarefa(email, token).then((onValue) {
        onValue == null ? onValue = [true, null] : onValue = onValue;
        if (onValue[0]) {
          var listaSalva = onValue[1];
          listaSalva == null ? listaVazia = true : listaVazia = false;
          if (listaVazia) {
            criarTarefa(email, [], token);
            atualizarTarefa(email, taskList, completedTasks, token);
            inicio = false;
          } else {
            if (listaSalva.length == 0) {
              atualizarTarefa(email, taskList, completedTasks, token);
            } else {
              for (int i = 0; i < listaSalva.length; i++) {
                if (taskList.isEmpty &&
                    completedTasks.isEmpty &&
                    inicio &&
                    listaSalva.isNotEmpty) {
                  setState(() {
                    inicio = false;
                    for (int i = 0; i < listaSalva.length; i++) {
                      if (listaSalva[i]["concluida"]) {
                        completedTasks.add(Task(listaSalva[i]["titulo"]));
                        animatedKey.currentState?.insertItem(taskList.length,
                            duration: const Duration(milliseconds: 0));
                      } else {
                        taskList.insert(listaSalva[i]["ordem"],
                            Task(listaSalva[i]["titulo"]));
                        animatedKey.currentState?.insertItem(
                            taskList.length - 1,
                            duration: const Duration(seconds: 0));
                      }
                    }
                  });
                } else {
                  atualizarTarefa(email, taskList, completedTasks, token);
                }
              }
            }
          }
        } else {
          if (onValue[1]["message"] == "JWT expired") {
            _mostrarDialogoExpirado();
          }
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            splashColor: Colors.black87,
            enableFeedback: true,
            highlightColor: Colors.deepPurpleAccent,
            splashRadius: 30.0,
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                    const LoginPage()), // Redireciona para o login
              );
            },
            icon: const Icon(Icons.logout)),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.deepPurple,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(7),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(width: 204),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: "Pagar a conta de luz",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                          ),
                          controller: textController,
                          autofocus: true,
                          onSubmitted: _addTask,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                      // Espaçamento à esquerda do botão
                      child: FloatingActionButton(
                        onPressed: () => _addTask(textController.text),
                        tooltip: 'Adicionar tarefa',
                        heroTag: "adicionar",
                        splashColor: Colors.deepPurpleAccent,
                        enableFeedback: true,
                        backgroundColor: Colors.deepPurple.shade400,
                        elevation: 0,
                        shape: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius:
                            BorderRadius.all(Radius.circular(18))),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ])),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.indigo.shade400,
                  gradient: LinearGradient(
                      colors: [Colors.indigo.shade400, Colors.indigoAccent]),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2)),
              child: Stack(children: [
                AnimatedList(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  key: animatedKey,
                  initialItemCount: taskList.length + completedTasks.length,
                  itemBuilder: (context, index, animation) {
                    bool isCompletedTask = index >= taskList.length;
                    int taskIndex =
                    isCompletedTask ? index - taskList.length : index;
                    Task task = isCompletedTask
                        ? completedTasks[taskIndex]
                        : taskList[taskIndex];
                    if (isCompletedTask) {
                      task.isCompleted = true;
                    } else {
                      task.isCompleted = false;
                    }
                    return SizeTransition(
                        sizeFactor: animation,
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 8, left: 8, top: 3, bottom: 3),
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            // Permite marcar como feito ou deletar pendentes,
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                setState(() {
                                  var removedItem = task.description;
                                  task.exclusaoCompleter.complete(false);
                                  task.exclusaoCompleter = Completer<bool?>();
                                  tarefa = task;
                                  _deleteTask(taskIndex, isCompletedTask);
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$removedItem removido'),
                                      action: SnackBarAction(
                                        label: 'Desfazer',
                                        onPressed: () {
                                          setState(() {
                                            if (isCompletedTask) {
                                              completedTasks.insert(
                                                  taskIndex, task);
                                            } else {
                                              taskList.insert(taskIndex, task);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                });
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                if (!isCompletedTask) {
                                  setState(() {
                                    var removedItem = task.description;
                                    tarefa = task;
                                    _completed(task, taskIndex);
                                    task.conclusaoCompleter.complete(true);
                                    task.conclusaoCompleter =
                                        Completer<bool?>();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$removedItem marcado como feito')),
                                    );
                                  });
                                } else {
                                  setState(() {
                                    var removedItem = task.description;
                                    tarefa = task;
                                    _uncompleted(task, taskIndex);
                                    strikeout(tarefa.description);
                                    task.conclusaoCompleter.complete(false);
                                    task.conclusaoCompleter =
                                        Completer<bool?>();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$removedItem desmarcado como feito')),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child:
                              const Icon(Icons.check, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: IconButton(
                                onPressed: () {
                                  // Reinicia o Completer para permitir o swipe de novo
                                  setState(() {
                                    task.exclusaoCompleter.complete(false);
                                    task.exclusaoCompleter = Completer<bool?>();
                                  });
                                },
                                icon:
                                const Icon(Icons.undo, color: Colors.white),
                              ),
                            ),

                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black, width: 2),
                                  color: task.isDeleting
                                      ? Colors.red.shade400
                                      : task.isSelected
                                      ? Colors.green.shade200
                                      : index % 2 == 0
                                      ? Colors.deepPurple.shade300
                                      : Colors.deepPurple.shade400,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: ListTile(
                                title: isCompletedTask
                                    ? strikeout(task.description)
                                    : Text(task.description),
                                titleTextStyle: const TextStyle(fontSize: 16),
                                horizontalTitleGap: 10,
                                textColor: task.isSelected
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                                trailing: SizedBox(
                                  width: 28,
                                  height: 48,
                                  child: IconButton(
                                    icon: task.isDeleting
                                        ? const Icon(Icons.undo)
                                        : const Icon(Icons.delete),
                                    color: task.isDeleting
                                        ? Colors.white
                                        : Colors.black54,
                                    onPressed: () {
                                      if (task.isDeleting) {
                                        task.exclusaoCompleter.complete(false);
                                      } else {
                                        _startDeleteProcess(
                                            taskIndex, isCompletedTask);
                                      }
                                    },
                                  ),
                                ),
                                leading: SizedBox(
                                  width: 28, // Largura fixa
                                  height: 48, // Altura fixa (opcional)
                                  child: Checkbox(
                                    value: task.isCompleted,
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    onChanged: (bool? isChecked) {
                                      setState(() {
                                        if (isChecked ?? false) {
                                          // Chama a função de completar a tarefa
                                          tarefa = task;
                                          _completed(task, taskIndex);
                                          _startRotation(
                                              true); // Inicia a animação de rotação, se necessário
                                        } else {
                                          // Chama a função para "descompletar" a tarefa
                                          tarefa = task;
                                          _uncompleted(task, taskIndex);
                                          _startRotation(
                                              false); // Inicia a animação de rotação, se necessário
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
                AnimatedPositioned(
                  duration: const Duration(seconds: 0),
                  curve: Curves.easeInOut,
                  top: tarefa.position * itemHeight,
                  child: SizedBox(
                    height: itemHeight,
                    width: itemWidth*100,
                    child: Visibility(
                        visible: tarefa.moving,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.indigo.shade400,
                              Colors.indigoAccent
                            ]),
                          ),
                          child: const Text(""),
                        )),
                  ),
                ),
                AnimatedPositioned(
                  duration: tarefa.origem
                      ? const Duration(seconds: 0)
                      : const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  //top: task.position,
                  top: tarefa.origem
                      ? tarefa.position * itemHeight
                      : tarefa.moving
                      ? tarefa.isCompleted
                      ? (taskList.length - 1.0) *
                      itemHeight // Posição final na lista de completados
                      : (taskList.length) * itemHeight
                      : tarefa.position * itemHeight,
                  // Posição final na lista de pendentes

                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: tarefa.moving,
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 8, left: 8, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: tarefa.isDeleting
                                ? Colors.red.shade400
                                : tarefa.isSelected
                                ? Colors.green.shade200
                                : tarefa.position % 2 == 0
                                ? Colors.deepPurple.shade300
                                : Colors.deepPurple.shade400,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          title: tarefa.isCompleted
                              ? strikeout(tarefa.description)
                              : Text(tarefa.description),
                          titleTextStyle: const TextStyle(fontSize: 16),
                          horizontalTitleGap: 10,
                          textColor: tarefa.isSelected
                              ? Colors.grey.shade600
                              : Colors.black87,
                          trailing: SizedBox(
                            width: 28,
                            height: 48,
                            child: IconButton(
                              icon: tarefa.isDeleting
                                  ? const Icon(Icons.undo)
                                  : const Icon(Icons.delete),
                              color: tarefa.isDeleting
                                  ? Colors.white
                                  : Colors.black54,
                              onPressed: () {},
                            ),
                          ),
                          leading: SizedBox(
                            width: 28, // Largura fixa
                            height: 48, // Altura fixa (opcional)
                            child: Checkbox(
                              value: tarefa.isCompleted,
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              onChanged: (bool? isChecked) {
                                setState(() {
                                  if (isChecked ?? false) {
                                    null;
                                  } else {
                                    null;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
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
        animatedKey.currentState?.insertItem(taskList.length - 1,
            duration: const Duration(seconds: 1));
      }
    });
  }

  void _deleteTask(int index, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        completedTasks.removeAt(index);
        index = taskList.length + index;
      } else {
        taskList.removeAt(index);
      }
      animatedKey.currentState?.removeItem(
        index,
            (context, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: Card(
              margin: const EdgeInsets.only(
                  right: 8, left: 8, top: 3, bottom: 3),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: tarefa.isDeleting
                          ? Colors.red.shade400
                          : tarefa.isSelected
                          ? Colors.green.shade200
                          : tarefa.position % 2 == 0
                          ? Colors.deepPurple.shade300
                          : Colors.deepPurple.shade400,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    title: tarefa.isCompleted
                        ? strikeout(tarefa.description)
                        : Text(tarefa.description),
                    titleTextStyle: const TextStyle(fontSize: 16),
                    horizontalTitleGap: 10,
                    textColor: tarefa.isSelected
                        ? Colors.grey.shade600
                        : Colors.black87,
                    trailing: SizedBox(
                      width: 28,
                      height: 48,
                      child: IconButton(
                        icon: tarefa.isDeleting
                            ? const Icon(Icons.undo)
                            : const Icon(Icons.delete),
                        color:
                        tarefa.isDeleting ? Colors.white : Colors.black54,
                        onPressed: () {},
                      ),
                    ),
                    leading: SizedBox(
                      width: 28, // Largura fixa
                      height: 48, // Altura fixa (opcional)
                      child: Checkbox(
                        value: tarefa.isCompleted,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        onChanged: (bool? isChecked) {
                          setState(() {
                            if (isChecked ?? false) {
                              null;
                            } else {
                              null;
                            }
                          });
                        },
                      ),
                    ),
                  )),
            ),
          );
        },
        duration: const Duration(seconds: 1),
      );
    });
  }

  void _completed(Task task, int index) {
    setState(() {
      task.position = index.toDouble();
      task.origem = true;
      task.isCompleted = true;

      if (index + 1 == taskList.length) {
        task.moving = false;
        task.tilt = false;

        setState(() {
          animatedKey.currentState?.removeItem(
            index,
                (context, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: const Card(
                  child: SizedBox(
                    height: 66,
                  ),
                ),
              );
            },
            duration: const Duration(milliseconds: 0),
          );
          completedTasks.insert(0, Task(task.description));
          taskList.removeAt(index);
          animatedKey.currentState?.insertItem(taskList.length,
              duration: const Duration(milliseconds: 0));
        });
      } else if (taskList.length > 1) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            task.origem = false;
            task.isCompleted = true;
          });
        });
        setState(() {
          task.moving = true;
          task.tilt = true;
        });
        Future.delayed(const Duration(milliseconds: 1600), () {
          setState(() {
            task.isCompleted = true;

            animatedKey.currentState?.removeItem(
              index,
                  (context, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: const Card(
                    child: SizedBox(
                      height: 66,
                    ),
                  ),
                );
              },
              duration: const Duration(milliseconds: 300),
            );
            task.moving = false;
            task.tilt = false;
            completedTasks.insert(0, Task(task.description));
            taskList.removeAt(index);
            animatedKey.currentState?.insertItem(taskList.length,
                duration: const Duration(milliseconds: 200));
          });
        });
      } else {
        task.moving = false;
        task.tilt = false;

        setState(() {
          animatedKey.currentState?.removeItem(
            index,
                (context, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: const Card(
                  child: SizedBox(
                    height: 66,
                  ),
                ),
              );
            },
            duration: const Duration(milliseconds: 0),
          );
          completedTasks.insert(0, Task(task.description));
          taskList.removeAt(index);
          animatedKey.currentState?.insertItem(taskList.length,
              duration: const Duration(milliseconds: 0));
        });
      }

      if (!task.conclusaoCompleter.isCompleted) {
        task.conclusaoCompleter.complete(true);
      }
      // Recria o Completer após completar
      task.conclusaoCompleter = Completer<bool?>();
    });
  }

  void _uncompleted(Task task, int index) {
    setState(() {
      task.origem = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          task.origem = false;
          task.isCompleted = false;
        });
      });
      if (index == 0) {
        setState(() {
          animatedKey.currentState?.removeItem(
            index,
                (context, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: const Card(
                  child: SizedBox(
                    height: 66,
                  ),
                ),
              );
            },
            duration: const Duration(milliseconds: 0),
          );
          task.moving = false;
          task.tilt = false;
          animatedKey.currentState?.insertItem(taskList.length,
              duration: const Duration(milliseconds: 0));

          taskList.add(Task(task.description));
          completedTasks.removeAt(index);
        });
      } else {
        task.isCompleted = false;
        task.position = (taskList.length + index)
            .toDouble(); // Posição final ao descompletar
        task.moving = true;
        task.tilt = true;

        Future.delayed(const Duration(milliseconds: 1400), () {
          setState(() {
            animatedKey.currentState?.removeItem(
              taskList.length + index,
                  (context, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: const Card(
                    child: SizedBox(
                      height: 66,
                    ),
                  ),
                );
              },
              duration: const Duration(milliseconds: 300),
            );
            task.moving = false;
            task.tilt = false;

            animatedKey.currentState?.insertItem(taskList.length,
                duration: const Duration(milliseconds: 200));

            taskList.add(Task(task.description));
            completedTasks.removeAt(index);
          });
        });
        if (!task.conclusaoCompleter.isCompleted) {
          task.conclusaoCompleter.complete(false);
        }
        // Recria o Completer após completar
        task.conclusaoCompleter = Completer<bool?>();
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
        tarefa = task;
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
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
                    color: Colors.deepPurple,
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
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 5),
              TextField(
                controller: senhaLogin,
                obscureText: !senhaVisivel,
                // Controla visibilidade
                enableInteractiveSelection: false,
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
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'login',
                    backgroundColor: Colors.deepPurple,
                    onPressed: () async {
                      final String mensagem;
                      final Map<String, dynamic> resposta;

                      final atualContexto = context;
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

                      if (!atualContexto.mounted) return;

                      if (token.startsWith("Erro")) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(atualContexto).showSnackBar(
                          SnackBar(content: Text(resposta["message"])),
                        );
                      } else if (token.startsWith("Ocorreu")) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(atualContexto).showSnackBar(
                          SnackBar(content: Text(resposta["message"])),
                        );
                      } else {
                        Navigator.pushReplacement(
                          atualContexto,
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
                    backgroundColor: Colors.deepPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastroPage(),
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
  bool isCompleted;
  bool isDeleting;
  bool origem;
  bool moving;
  double position; // Nova propriedade para posição vertical
  bool tilt; // Nova propriedade para inclinação
  Completer<bool?> exclusaoCompleter;
  Completer<bool?> conclusaoCompleter;

  Task(this.description)
      : isSelected = false,
        isDeleting = false,
        isCompleted = false,
        moving = false,
        position = 0.0,
  // Inicializa a posição
        tilt = false,
        origem = false,
  // Inicializa sem inclinação
        exclusaoCompleter = Completer(),
        conclusaoCompleter = Completer();
}
