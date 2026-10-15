/// Modello dei dati del cinema Lumière.
library;

/// Prezzo del biglietto intero, in euro.
const double prezzoIntero = 9.0;

/// Sconto applicato al biglietto ridotto (30%).
const double scontoRidotto = 0.30;

/// Supplemento per le proiezioni in 3D, in euro.
const double supplemento3D = 2.0;

/// Supplemento del biglietto VIP rispetto all'intero, in euro.
const double supplementoVip = 6.0;

/// I 20 posti di ogni sala: file A e B, numerati da 1 a 10.
final List<String> postiSala = [
  for (final fila in ['A', 'B'])
    for (var n = 1; n <= 10; n++) '$fila$n',
];

class Film {
  final String titolo;
  final String genere;
  final int durataMinuti;

  /// Valutazione media; null se il film è appena uscito e non ne ha ancora una.
  final double? valutazione;

  const Film(this.titolo, this.genere, this.durataMinuti, [this.valutazione]);

  String get valutazioneLeggibile => valutazione == null
      ? 'nessuna recensione'
      : valutazione!.toStringAsFixed(1).replaceAll('.', ',');

  @override
  String toString() =>
      '«$titolo» ($genere, $durataMinuti min) — $valutazioneLeggibile';
}

class Proiezione {
  final Film film;
  final int sala;
  final String orario;
  final bool in3D;

  /// Posti già venduti (es. 'A3'). L'insieme cambia a ogni acquisto.
  final Set<String> postiVenduti;

  Proiezione(this.film, this.sala, this.orario, this.in3D,
      [Set<String>? venduti])
      : postiVenduti = venduti ?? {};

  List<String> get postiLiberi =>
      postiSala.where((p) => !postiVenduti.contains(p)).toList();

  @override
  String toString() =>
      'sala $sala, ore $orario — «${film.titolo}»${in3D ? ' (3D)' : ''}';
}

/// Biglietto del cinema: classe astratta con una sottoclasse per tipo.
abstract class Biglietto {
  final Proiezione proiezione;
  final String posto;

  const Biglietto(this.proiezione, this.posto);

  /// Nome del tipo di biglietto, usato nel riepilogo.
  String get tipo;

  /// Prezzo calcolato secondo le regole del cinema.
  double get prezzo;

  /// Supplemento dovuto alla proiezione in 3D, uguale per ogni tipo.
  double get _supplemento => proiezione.in3D ? supplemento3D : 0.0;

  @override
  String toString() => '$tipo — «${proiezione.film.titolo}», posto $posto '
      '(sala ${proiezione.sala}, ore ${proiezione.orario}): '
      '€${prezzo.toStringAsFixed(2)}';
}

class BigliettoIntero extends Biglietto {
  const BigliettoIntero(super.proiezione, super.posto);

  @override
  String get tipo => 'Intero';

  @override
  double get prezzo => prezzoIntero + _supplemento;
}

class BigliettoRidotto extends Biglietto {
  const BigliettoRidotto(super.proiezione, super.posto);

  @override
  String get tipo => 'Ridotto';

  @override
  double get prezzo => prezzoIntero * (1 - scontoRidotto) + _supplemento;
}

/// Biglietto VIP: costa 6 euro in più dell'intero e vale solo per la prima
/// fila (fila A).
class BigliettoVip extends Biglietto {
  const BigliettoVip(super.proiezione, super.posto);

  @override
  String get tipo => 'VIP';

  @override
  double get prezzo => prezzoIntero + supplementoVip + _supplemento;
}
