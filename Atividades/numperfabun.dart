import 'dart:io';

void main() {
  String? input = stdin.readLineSync();
  List<int> numeros = [];
  List<int> range = [];
  List<int> abundantes = [];
  List doMaior = [];
  List maiores = [];
  bool encontrado = true;
  bool outroEncontro = false;

  if (input != null) {
    List teste = input.split(" ");
    if (teste.length == 1) {
      print("Por favor forneça dois números inteiros positivos.");
      return;
    } else {
      for (int i = 0; i < 2; i++) {
        int? letra = int.tryParse(teste[i]);
        if (letra == null) {
          print("Por favor forneça dois números inteiros positivos.");
          return;
        }
        numeros.add(int.parse(teste[i]));
      }
    }
  }

  if (checkNum(numeros)) {
    for (int i = numeros[0]; i <= numeros[1]; i++) {
      range.add(i);
    }
  } else {
    return;
  }

  for (int i = 0; i < range.length; i++) {
    if (numPerfeito(range[i])[0]) {
      print("${range[i]} é um número perfeito.");
      print("Fatores: ${numPerfeito(range[i])[1]}");
      encontrado = false;
    }
    if (numAbundante(range[i])[0]) {
      abundantes.add(range[i]);
      maiores.add(numAbundante(range[i])[1]);
      doMaior.add(numAbundante(range[i])[2]);
      outroEncontro = true;
    }
  }
  if (encontrado) {
    print(
        "Nenhum número perfeito encontrado na faixa entre ${numeros[0]} e ${numeros[1]}.");
  }

  if (!outroEncontro) {
    print(
        "Nenhum número abundante encontrado na faixa entre ${numeros[0]} e ${numeros[1]}.");
  }

  if (outroEncontro) {
    int maiorValor = maior(maiores);

    print("Maior número abundante: ${abundantes[maiorValor]}");
    print("Fatores: ${doMaior[maiorValor]}");
    print("Soma dos fatores: ${maiores[maiorValor]}");
  }
  ;
}

bool checkNum(List lista) {
  if (lista[0] > lista[1]) {
    print("O primeiro número deve ser menor ou igual ao segundo.");
    return false;
  } else {
    if (lista.length == 1) {
      print("Por favor forneça dois números inteiros positivos.");
      return false;
    } else {
      if ((lista[0] is int || lista[1] is int) &&
          !(lista[0] >= 0 && lista[1] >= 0)) {
        print("Por favor forneça dois números inteiros positivos.");
        return false;
      }
    }
  }
  return true;
}

List numPerfeito(int num) {
  List<int> divisores = [];
  int soma = 0;

  for (int i = 1; i < num; i++) {
    if (num % i == 0) {
      divisores.add(i);
    }
  }

  for (int i = 0; i < divisores.length; i++) {
    soma += divisores[i];
  }

  if (num == soma) {
    return [true, divisores];
  } else {
    return [false, divisores];
  }
}

List numAbundante(int num) {
  List<int> divisores = [];
  int soma = 0;

  for (int i = 1; i < num; i++) {
    if (num % i == 0) {
      divisores.add(i);
    }
  }

  for (int i = 0; i < divisores.length; i++) {
    soma += divisores[i];
  }

  if (num < soma) {
    return [true, soma, divisores];
  } else {
    return [false, soma, divisores];
  }
}

int maior(List num) {
  int index = 0;
  for (int i = 1; i < num.length; i++) {
    if (num[i] > num[index]) {
      index = i;
    }
  }
  return index;
}
