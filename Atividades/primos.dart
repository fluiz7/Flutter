import 'dart:io';

void main() {
  String? input = stdin.readLineSync();
  int? numero = int.tryParse(input ?? '');

  int cont = 1;
  List primos = [2, 3, 5, 7, 11];

  if (input == '') {
    print("Entrada vazia!");
    return;
  }

  if (numero is! int) {
    double? float = double.tryParse(input ?? '');
    if (float is double) {
      print("Não é inteiro!");
      return;
    } else {
      for (int i = 0; i < input!.length; i++) {
        int? check = int.tryParse(input[i]);

        if (check is int) {
          print("Formato numérico inválido!");
          return;
        } else {
          print("Não é um número!");
          return;
        }
      }
    }
  }

  if (numero != null) {
    if (numero.isNegative) {
      print("Número negativo!");
      return;
    }
    for (int i = 0; i < 5; i++) {
      if (primos[i] == numero) {
        break;
      } else {
        if (numero % primos[i] == 0) {
          print("Não é primo!");
          cont += 1;
          break;
        }
      }
    }
  }

  if (cont < 2) {
    print("É primo!");
  }
}
