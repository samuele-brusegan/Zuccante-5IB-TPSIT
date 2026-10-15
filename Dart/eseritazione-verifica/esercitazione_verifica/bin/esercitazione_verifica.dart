import 'dart:io';

import 'package:esercitazione_verifica/cinema_server.dart';
import 'package:esercitazione_verifica/models.dart';

Future<void> main() async {
  final server = CinemaServer();
  final biglietti = <Biglietto>[];

  print('Benvenuto al cinema Lumière!');

  while (true) {
    print('\n===== MENU =====');
    print('1) Programmazione di oggi');
    print('2) Dettagli di un film');
    print('3) Posti liberi di una proiezione');
    print('4) Acquista un biglietto');
    print('5) Disponibilità di tutte le proiezioni');
    print('0) Esci');
    stdout.write('Scegli: ');

    final scelta = int.tryParse(stdin.readLineSync()?.trim() ?? '');

    try {
      switch (scelta) {
        case 1:
          await _mostraProgrammazione(server);
        case 2:
          await _mostraDettagliFilm(server);
        case 3:
          await _mostraPostiLiberi(server);
        case 4:
          final biglietto = await _acquistaBiglietto(server);
          if (biglietto != null) biglietti.add(biglietto);
        case 5:
          await _mostraDisponibilita(server);
        case 0:
          _stampaRiepilogo(biglietti);
          return;
        default:
          print('Scelta non valida, riprova.');
      }
    } on CinemaException catch (e) {
      print('Errore: $e');
    }
  }
}

/// Scarica la programmazione dal server.
Future<List<Proiezione>> _leggiProgrammazione(CinemaServer server) async {
  print('Caricamento programmazione...');
  return server.programmazione();
}

/// Stampa le proiezioni numerate, così che l'utente possa sceglierne una.
void _stampaProiezioni(List<Proiezione> proiezioni) {
  for (var i = 0; i < proiezioni.length; i++) {
    print('${i + 1}. ${proiezioni[i]}');
  }
}

/// Chiede all'utente il numero di una proiezione dell'elenco; restituisce
/// null se la scelta non è valida.
Proiezione? _scegliProiezione(List<Proiezione> proiezioni) {
  stdout.write('Numero della proiezione: ');
  final numero = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  if (numero == null || numero < 1 || numero > proiezioni.length) {
    print('Numero di proiezione non valido.');
    return null;
  }
  return proiezioni[numero - 1];
}

Future<void> _mostraProgrammazione(CinemaServer server) async {
  final proiezioni = await _leggiProgrammazione(server);
  print('\nProgrammazione di oggi:');
  for (var i = 0; i < proiezioni.length; i++) {
    final p = proiezioni[i];
    print('${i + 1}. ${p.film} — sala ${p.sala}, ore ${p.orario}'
        '${p.in3D ? ' (3D)' : ''}');
  }
}

Future<void> _mostraDettagliFilm(CinemaServer server) async {
  stdout.write('Titolo del film: ');
  final titolo = stdin.readLineSync()?.trim() ?? '';
  if (titolo.isEmpty) {
    print('Devi inserire un titolo.');
    return;
  }
  print('Ricerca in corso...');
  final film = await server.dettagliFilm(titolo);
  print(film);
}

Future<void> _mostraPostiLiberi(CinemaServer server) async {
  final proiezioni = await _leggiProgrammazione(server);
  _stampaProiezioni(proiezioni);
  final proiezione = _scegliProiezione(proiezioni);
  if (proiezione == null) return;
  print('Controllo posti...');
  final liberi = await server.postiLiberi(proiezione);
  print('Posti liberi (${liberi.length}): ${liberi.join(', ')}');
}

Future<Biglietto?> _acquistaBiglietto(CinemaServer server) async {
  final proiezioni = await _leggiProgrammazione(server);
  _stampaProiezioni(proiezioni);
  final proiezione = _scegliProiezione(proiezioni);
  if (proiezione == null) return null;

  stdout.write('Posto (es. A5): ');
  final posto = stdin.readLineSync()?.trim() ?? '';
  if (posto.isEmpty) {
    print('Devi inserire un posto.');
    return null;
  }

  stdout.write('Tipo di biglietto — (i)ntero, (r)idotto, (v)ip: ');
  final tipo = stdin.readLineSync()?.trim().toLowerCase() ?? '';

  print('Acquisto in corso...');
  final biglietto = await server.acquistaBiglietto(
    proiezione: proiezione,
    posto: posto,
    ridotto: tipo == 'r',
    vip: tipo == 'v',
  );
  print('Biglietto acquistato: $biglietto');
  return biglietto;
}

/// Per ogni proiezione mostra quanti posti sono ancora liberi, chiedendo i
/// dati al server tutti insieme con Future.wait.
Future<void> _mostraDisponibilita(CinemaServer server) async {
  final proiezioni = await _leggiProgrammazione(server);
  _stampaProiezioni(proiezioni);
  print('Caricamento disponibilità...');
  final postiPerProiezione = await Future.wait([
    for (final p in proiezioni) server.postiLiberi(p),
  ]);
  print('\nPosti liberi per proiezione:');
  for (var i = 0; i < proiezioni.length; i++) {
    print('${i + 1}. ${proiezioni[i]} — ${postiPerProiezione[i].length} '
        'posti liberi');
  }
}

void _stampaRiepilogo(List<Biglietto> biglietti) {
  print('\n===== RIEPILOGO =====');
  if (biglietti.isEmpty) {
    print('Nessun biglietto acquistato.');
  } else {
    for (final b in biglietti) {
      print(b);
    }
    final totale =
        biglietti.fold<double>(0, (somma, b) => somma + b.prezzo);
    print('Totale speso: €${totale.toStringAsFixed(2)}');
  }
  print('Grazie e arrivederci!');
}
