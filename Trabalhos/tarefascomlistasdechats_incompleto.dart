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

Future criarConversa(var token) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/rpc/cria_conversa');
  // Headers da requisição
  final Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  try {
    // Realiza a requisição POST
    final response = await http.post(url, headers: headers, body: '{}');

    // Verifica o código de status da resposta
    if (response.statusCode == 200) {
      // Sucesso na requisição
      return response.body;
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

Future obterConversas(var token) async {
  // URL do endpoint
  final url = Uri.https('barra.cos.ufrj.br:443', '/rest/conversas');
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
      var lista = await jsonBody;
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
  final String lista;
  final bool doChat;
  final bool substituir;

  const BaseLista(
      {super.key,
        required this.title,
        required this.token,
        required this.email,
        required this.lista,
        required this.doChat,
        required this.substituir});

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
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  void _onScroll() {
    setState(() {
      // Atualiza as posições das tarefas com base no deslocamento
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    // Libera recursos dos controladores ao desmontar o widget.
    textController.dispose();
    _controller.dispose();
    _scrollController.dispose();
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
    double itemHeight = MediaQuery.of(context).size.height * 0.0768;
    double itemWidth = MediaQuery.of(context).size.width;

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
            if (taskList.isEmpty && completedTasks.isEmpty && inicio) {
              setState(() {
                List novaTarefa = widget.lista.split('\n');
                List<Task> novaTask = [];
                for (int i = 0; i < novaTarefa.length; i++) {
                  novaTask.add(Task(novaTarefa[i]));
                }
                if (widget.doChat && inicio && widget.substituir) {
                  for (int i = 0; i < novaTask.length; i++) {
                    taskList.add(novaTask[i]);
                    animatedKey.currentState?.insertItem(taskList.length - 1,
                        duration: const Duration(milliseconds: 0));
                  }
                } else {
                  if (listaSalva.isNotEmpty) {
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
                  }
                  if (widget.doChat && !widget.substituir) {
                    for (int i = 0; i < novaTask.length; i++) {
                      taskList.add(novaTask[i]);
                      animatedKey.currentState?.insertItem(taskList.length - 1,
                          duration: const Duration(milliseconds: 0));
                    }
                  }
                }
                inicio = false;
              });
            } else {
              atualizarTarefa(email, taskList, completedTasks, token);
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
      drawer: userAccount(context, email, token, lista: true),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
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
                  controller: _scrollController,
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
                              right: 8, left: 8, top: 3, bottom: 0),
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
                                    _startRotation(true);
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
                                    _startRotation(false);
                                    strikeout(tarefa.description);
                                    task.conclusaoCompleter.complete(false);
                                    task.conclusaoCompleter =
                                        Completer<bool?>();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
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
                              height: itemHeight,
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
                  top: tarefa.position * itemHeight - _scrollOffset,
                  child: Container(
                    height: itemHeight * 1.02,
                    width: itemWidth,
                    margin: EdgeInsets.only(
                        right: 8,
                        left: 4,
                        top: 3 * tarefa.position + 2.5,
                        bottom: 0),
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
                  top: tarefa.origem
                      ? tarefa.position * itemHeight - _scrollOffset
                      : tarefa.moving
                      ? tarefa.isCompleted
                      ? (taskList.length) * itemHeight -
                      _scrollOffset // Posição final na lista de completados
                      : (taskList.length) * itemHeight - _scrollOffset
                      : tarefa.position * itemHeight - _scrollOffset,
                  // Posição final na lista de pendentes

                  left: 0,
                  right: 0,

                  child: Visibility(
                    visible: tarefa.moving,
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        height: itemHeight,
                        width: itemWidth,
                        margin: const EdgeInsets.only(
                            right: 8, left: 8, top: 0, bottom: 0),
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
              margin:
              const EdgeInsets.only(right: 8, left: 8, top: 3, bottom: 3),
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
                      height: 66.5,
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
                    height: 66.5,
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
                            builder: (context) => BasedeChats(
                              title: "Chat",
                              token: mensagem,
                              email: emailLogin.text,
                              uuid: 'i',
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

class BaseChat extends StatefulWidget {
  final String title;
  final String token;
  final String email;
  final String uuid;

  const BaseChat(
      {super.key,
        required this.title,
        required this.token,
        required this.email,
        required this.uuid});

  @override
  State<BaseChat> createState() => ChatScreen();
}

class ChatScreen extends State<BaseChat> {
  late String token;
  late String email;
  late String uuid;
  bool inicio = true;
  bool listaVazia = false;
  bool isleft = true;
  bool _dialogShown = false; // Flag para controlar o estado do diálogo
  bool _dialogCheck = true;
  List conversas = [];
  List waitingList = [];
  bool button = false;

  final textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    // Libera recursos dos controladores ao desmontar o widget.
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Inicializando as variáveis com os valores recebidos do widget.
    token = widget.token;
    email = widget.email;
    uuid = widget.uuid;
  }

  void _scroll() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
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

  void _mostrarDialogoConcluido(String lista) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Impede que o diálogo seja fechado clicando fora dele
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text("Lista de tarefas gerada!"),
            content: const Text("O que você pretende fazer?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _dialogCheck = true;
                  });
                  Navigator.pop(context); // Fecha o diálogo
                },
                child: const Text("Continuar o Chat"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BaseLista(
                        title: "Lista de Tarefas",
                        token: token,
                        email: email,
                        lista: lista,
                        doChat: true,
                        substituir: true,
                      ),
                    ),
                  );
                },
                child: const Text(
                    "Substituir a lista de tarefas existente por esta nova"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BaseLista(
                        title: "Lista de Tarefas",
                        token: token,
                        email: email,
                        lista: lista,
                        doChat: true,
                        substituir: false,
                      ),
                    ),
                  );
                },
                child: const Text("Adicionar estas tarefas à lista existente"),
              )
            ],
          ),
        );
      },
    );
  }

  Future _enviarResposta(String uuid, String resposta) async {
    final atualContexto = context;
    // URL do endpoint
    final url = Uri.https('barra.cos.ufrj.br:443', '/rest/rpc/envia_resposta');
    // Headers da requisição
    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // Corpo da requisição (JSON)
    final Map<String, dynamic> body = {
      'conversa_id': uuid,
      'resposta': resposta,
    };
    // Converte o body para JSON
    final String jsonBody = json.encode(body);
    textController.clear();
    try {
      // Realiza a requisição POST

      final response = await http.post(url, headers: headers, body: jsonBody);

      // Verifica o código de status da resposta
      if (response.statusCode == 200) {
        return '';
        // Sucesso na requisição
      } else {
        // Erro na requisição
        String erro =
            'Erro: ${response.statusCode} - ${json.decode(response.body)["message"]}';
        if (!atualContexto.mounted) return;
        ScaffoldMessenger.of(atualContexto).clearSnackBars();
        ScaffoldMessenger.of(atualContexto).showSnackBar(
          SnackBar(content: Text(erro)),
        );
        return erro;
      }
    } catch (e) {
      // Tratamento de exceções
    }
  }

  void sendButton(String st) {
    if (conversas.length == waitingList.length) {
      if (mounted) {
        setState(() {
          conversas.add(json.decode('{"papel": "usuario", "conteudo": "$st"}'));
          conversas.add(
              json.decode('{"papel": "assistente", "conteudo": "  ...   "}'));
          _scroll();
        });
      }
      _enviarResposta(uuid, st).then((onValue) {
        if (mounted && onValue.startsWith("Erro")) {
          setState(() {
            conversas.removeAt(conversas.length - 1);
            conversas.removeAt(conversas.length - 1);
          });
        }
      });

      setState(() {
        _scroll();
        button = true;
      });
      if (mounted) {
        setState(() {
          _dialogShown = false;
          _dialogCheck = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (button) {
      _scroll();
      Future.delayed(const Duration(milliseconds: 300), () {
        button = false;
      });
    }
    if (mounted) {
      setState(() {
        obterConversas(token).then((onValue) {
          onValue == null ? onValue = [true, null] : onValue = onValue;
          if (onValue[0]) {
            var listaSalva = onValue[1];
            listaSalva.isEmpty ? listaVazia = true : listaVazia = false;

            if (listaVazia) {
              criarConversa(token).then((onValue) {
                if (mounted) {
                  setState(() {
                    uuid = onValue;
                    inicio = false;
                  });
                }
              });
            } else {
              if (!_dialogShown || !_dialogCheck) {
                if (mounted) {
                  setState(() {
                    waitingList = onValue[1][0]['mensagens'];
                    uuid = onValue[1][0]["id"];
                  });
                }
                if (waitingList.length >= conversas.length) {
                  if (mounted) {
                    setState(() {
                      conversas = onValue[1][0]['mensagens'];
                    });
                  }
                }
              }
              if (inicio) {
                _scroll();
                Future.delayed(const Duration(milliseconds: 300), () {
                  inicio = false;
                });
              }
            }
          } else {
            if (onValue[1]["message"] == "JWT expired") {
              _mostrarDialogoExpirado();
            }
          }
          if (conversas.isNotEmpty) {
            if (conversas[conversas.length - 1]["papel"] == "assistente" &&
                conversas[conversas.length - 1]["conteudo"].contains('\n') &&
                !inicio) {
              if (!_dialogShown && !_dialogCheck) {
                _dialogShown = true;
                _dialogCheck = false;
                _mostrarDialogoConcluido(
                    conversas[conversas.length - 1]["conteudo"]);
              }
            }
          }
        });
      });
    }

    return Scaffold(
      drawer: userAccount(context, email, token, chat: true),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.deepPurple,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade400,
                        gradient: LinearGradient(colors: [
                          Colors.indigo.shade400,
                          Colors.indigoAccent
                        ]),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: conversas.length,
                      itemBuilder: (context, index) {
                        if (conversas[index]['papel'] == 'assistente') {
                          isleft = true;
                        } else {
                          isleft = false;
                        }
                        return Align(
                          alignment: isleft
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Callout(
                            triangleSize: isleft ? 20 : 10,
                            triangleHeight: 8,
                            backgroundColor:
                            isleft ? Colors.grey[300]! : Colors.blue,
                            isLeft: isleft,
                            position: isleft ? "left" : "right",
                            child: Text(
                              conversas[index]['conteudo'],
                              style: isleft
                                  ? const TextStyle(color: Colors.black)
                                  : const TextStyle(color: Colors.white),
                            ), // Seta no lado esquerdo inferior inclinada
                          ),
                        );
                      },
                    ))),
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 204),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        labelText: "Mensagem ChatGPT",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                            BorderSide(color: Colors.black, width: 2)),
                      ),
                      controller: textController,
                      autofocus: true,
                      showCursor: true,
                      onSubmitted: sendButton,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                  // Espaçamento à esquerda do botão
                  child: FloatingActionButton(
                    onPressed: () {
                      sendButton(textController.text);
                    },
                    tooltip: 'Adicionar tarefa',
                    heroTag: "adicionar",
                    splashColor: Colors.deepPurpleAccent,
                    enableFeedback: true,
                    backgroundColor: Colors.deepPurple.shade400,
                    elevation: 0,
                    shape: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalloutPainter extends CustomPainter {
  final double triangleSize;
  final double triangleHeight;
  final String position;
  final Color backgroundColor;
  final bool isLeft; // Define se o balão é da esquerda ou direita

  CalloutPainter({
    required this.triangleSize,
    required this.triangleHeight,
    required this.position,
    required this.backgroundColor,
    this.isLeft = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Path balloonPath = Path();

    // Definir o corpo do balão (retângulo arredondado)
    const double margin = 10;
    const double radius = 8;
    final double bodyHeight = size.height - triangleHeight - margin;

    balloonPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(margin, margin, size.width - 2 * margin, bodyHeight),
      const Radius.circular(radius),
    ));

    // Desenhar a seta na parte de baixo com inclinação para fora
    final Path trianglePath = Path();

    if (position == "left") {
      // Seta no lado esquerdo inferior, inclinada para a esquerda (obtusa)
      trianglePath.moveTo(
          margin + 10, bodyHeight + margin); // Base esquerda da seta
      trianglePath.lineTo(margin + 10 + triangleSize,
          bodyHeight + margin); // Base direita da seta
      trianglePath.lineTo(
          margin - 10, size.height); // Ponta da seta inclinada para fora
    } else if (position == "right") {
      // Seta no lado direito inferior, inclinada para a direita (obtusa)
      trianglePath.moveTo(size.width - margin - 10 - triangleSize,
          bodyHeight + margin); // Base esquerda da seta
      trianglePath.lineTo(size.width - margin - 10,
          bodyHeight + margin); // Base direita da seta
      trianglePath.lineTo(size.width + 10 - margin,
          size.height); // Ponta da seta inclinada para fora
    } else {
      // Seta no centro inferior (isósceles)
      double centerX = (size.width - triangleSize) / 2;
      trianglePath.moveTo(
          centerX, bodyHeight + margin); // Base esquerda da seta
      trianglePath.lineTo(
          centerX + triangleSize, bodyHeight + margin); // Base direita da seta
      trianglePath.lineTo(
          centerX + triangleSize / 2, size.height); // Ponta da seta (centro)
    }

    balloonPath.addPath(trianglePath, Offset.zero);

    // Desenhar o balão e a seta
    canvas.drawShadow(balloonPath, Colors.black, 6, false);
    canvas.drawPath(balloonPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Callout extends StatelessWidget {
  final Widget child;
  final double triangleSize;
  final double triangleHeight;
  final String position;
  final Color backgroundColor;
  final bool isLeft;

  const Callout({
    super.key,
    required this.child,
    this.triangleSize = 20,
    this.triangleHeight = 10,
    this.position = "left",
    this.backgroundColor = Colors.white,
    this.isLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CalloutPainter(
        triangleSize: triangleSize,
        triangleHeight: triangleHeight,
        position: position,
        backgroundColor: backgroundColor,
        isLeft: isLeft,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
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

Widget userAccount(BuildContext context, String email, var token,
    {lista = false, chat = false, outra = false}) {
  final atualContexto = context;
  var draw = Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(email.split('@')[0].toUpperCase()),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            child: Text(
              email[0].toUpperCase(),
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.list,
          ),
          title: const Text('Lista de Tarefas'),
          onTap: () {
            lista
                ? Navigator.pop(context)
                : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BaseLista(
                  title: "Lista de Tarefas",
                  token: token,
                  email: email,
                  lista: '',
                  doChat: false,
                  substituir: false,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.chat,
          ),
          title: const Text('Chat'),
          onTap: () {
            chat
                ? Navigator.pop(context)
                : obterConversas(token).then((onValue) {
              final uuid = onValue[1][0]["id"];
              if (!atualContexto.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BaseChat(
                    title: "Chat",
                    token: token,
                    email: email,
                    uuid: uuid,
                  ),
                ),
              );
            });
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.chat_bubble,
          ),
          title: const Text('Iniciar outra conversa'),
          onTap: () {
            criarConversa(token).then((onValue) {
              final uuid = onValue;
              if (!atualContexto.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BaseChat(
                    title: "Chat",
                    token: token,
                    email: email,
                    uuid: uuid,
                  ),
                ),
              );
            });
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
          ),
          title: const Text('Logout'),
          splashColor: Colors.black87,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                  const LoginPage()), // Redireciona para o login
            );
          },
        ),
      ],
    ),
  );
  return draw;
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


class BasedeChats extends StatefulWidget {
  final String title;
  final String token;
  final String email;
  final String uuid;

  const BasedeChats(
      {super.key,
        required this.title,
        required this.token,
        required this.email,
        required this.uuid});

  @override
  State<BasedeChats> createState() => ChatsScreen();
}

class ChatsScreen extends State<BasedeChats> {
  late String token;
  late String email;
  late String uuid;
  bool inicio = true;
  bool listaVazia = false;
  bool isleft = true;
  bool _dialogShown = false; // Flag para controlar o estado do diálogo
  bool _dialogCheck = true;
  List conversas = [];
  List waitingList = [];
  bool button = false;

  final textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    // Libera recursos dos controladores ao desmontar o widget.
    textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Inicializando as variáveis com os valores recebidos do widget.
    token = widget.token;
    email = widget.email;
    uuid = widget.uuid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Chats")),
      drawer: userAccount(context, email, token, lista: true),
      body: FutureBuilder<List>(
        future: apiService.getChats(widget.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar chats"));
          }
          final chats = snapshot.data ?? [];
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ListTile(
                title: Text(chat['id']),
                onTap: () {
                  // Acessar o chat
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BaseChat(
                        title: "Chat ${chat['id']}",
                        token: widget.token,
                        email: widget.email,
                        uuid: chat['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Tarefa {
  final String id;
  final Map<String, dynamic> atributos;

  Tarefa({required this.id, required this.atributos});

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(id: json['id'], atributos: json['atributos']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'atributos': atributos};
}

class Chat {
  final String id;
  final Map<String, dynamic> atributos;

  Chat({required this.id, required this.atributos});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(id: json['id'], atributos: json['atributos']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'atributos': atributos};
}

class ApiService {
  final baseUrl = Uri.http('barra.cos.ufrj.br:443', '/rest/tarefas');
  List conversas = [];
  List conversasDecode = [];


  //Future<List<Tarefa>> getTarefas() async {
  // Faça a requisição ao endpoint tarefasv2
  //}

  Future<List> getChats(token) async {

    // Faça a requisição ao endpoint conversas
    return await obterConversas(token).then((onValue) {
      conversasDecode = onValue[1];
      for (int i = 0 ; i < onValue.length ; i++ ) {
        conversas.add(conversasDecode[i]);
      }
      return conversas;
    });
  }

  Future<void> criarTarefa(Tarefa tarefa) async {
    // Método para criar tarefa
  }

  Future<void> apagarTarefa(String id) async {
    // Método para apagar tarefa
  }

// Outros métodos necessários...
}
