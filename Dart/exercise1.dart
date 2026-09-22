//import "dart:io";

void main() {
  print("Inserisci il tuo nome: ");
  //var name = stdin.readNextLineSync();
  var name = "John Smith";

  print("Inserisci la tua eta': ");
  //var age = stdin.readNextLineSync();
  var age = 30;

  if (age < 100) {
    print(
      "Ciao ${name}, ti mancano ${100 - age} anni per raggiungere il secolo",
    );
  }
}
