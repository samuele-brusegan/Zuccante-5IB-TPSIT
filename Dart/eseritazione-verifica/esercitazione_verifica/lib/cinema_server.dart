import 'models.dart';

/// Errore restituito dal server del cinema.
class CinemaException implements Exception {
  final String message;
  const CinemaException(this.message);

  @override
  String toString() => message;
}

class FilmNonTrovatoException extends CinemaException {
  FilmNonTrovatoException(String titolo)
      : super('Il film «$titolo» non è in programmazione.');
}

class ProiezioneNonValidaException extends CinemaException {
  const ProiezioneNonValidaException()
      : super('La proiezione indicata non è in programmazione.');
}

class PostoNonValidoException extends CinemaException {
  PostoNonValidoException(String posto) : super('Il posto $posto non esiste.');
}

class PostoOccupatoException extends CinemaException {
  PostoOccupatoException(String posto)
      : super('Il posto $posto è già occupato.');
}

class PostoNonVipException extends CinemaException {
  PostoNonVipException(String posto)
      : super('Il biglietto VIP vale solo per la prima fila: '
            'il posto $posto non è in fila A.');
}

/// Simula il server del cinema Lumière: i dati restano privati e ogni
/// operazione restituisce un Future che risponde dopo un breve ritardo.
class CinemaServer {
  final List<Proiezione> _proiezioni = [
    Proiezione(
      const Film('Il ritorno del falco', 'Avventura', 128, 4.2),
      1,
      '18:00',
      false,
      {'A3', 'A4', 'B7'},
    ),
    Proiezione(
      const Film('Il ritorno del falco', 'Avventura', 128, 4.2),
      1,
      '21:00',
      true,
      {'A1', 'A2', 'B5', 'B6', 'B10'},
    ),
    Proiezione(
      const Film('Notte a Bologna', 'Commedia', 95, 3.8),
      2,
      '19:30',
      false,
      {'A8', 'B1', 'B2'},
    ),
    Proiezione(
      const Film('Orbita zero', 'Fantascienza', 141),
      2,
      '22:00',
      true,
      {'A5', 'A6'},
    ),
  ];

  /// La programmazione del giorno, dopo un secondo.
  Future<List<Proiezione>> programmazione() => Future.delayed(
      const Duration(seconds: 1), () => List.unmodifiable(_proiezioni));

  /// I dettagli di un film dato il titolo, dopo mezzo secondo.
  /// Lancia [FilmNonTrovatoException] se il film non è in programmazione.
  Future<Film> dettagliFilm(String titolo) =>
      Future.delayed(const Duration(milliseconds: 500), () {
        for (final p in _proiezioni) {
          if (p.film.titolo.toLowerCase() == titolo.trim().toLowerCase()) {
            return p.film;
          }
        }
        throw FilmNonTrovatoException(titolo.trim());
      });

  /// I posti ancora liberi di una proiezione.
  Future<List<String>> postiLiberi(Proiezione proiezione) =>
      Future.delayed(const Duration(milliseconds: 500), () {
        _verificaProiezione(proiezione);
        return proiezione.postiLiberi;
      });

  /// Acquista un biglietto, dopo un secondo, segnando il posto come venduto.
  /// Lancia un'eccezione se il posto non esiste o è già occupato.
  Future<Biglietto> acquistaBiglietto({
    required Proiezione proiezione,
    required String posto,
    bool ridotto = false,
    bool vip = false,
  }) =>
      Future.delayed(const Duration(seconds: 1), () {
        _verificaProiezione(proiezione);
        if (ridotto && vip) {
          throw const CinemaException(
              'Un biglietto non può essere sia ridotto sia VIP.');
        }
        final p = posto.trim().toUpperCase();
        if (!postiSala.contains(p)) throw PostoNonValidoException(posto);
        if (vip && !p.startsWith('A')) throw PostoNonVipException(p);
        if (proiezione.postiVenduti.contains(p)) {
          throw PostoOccupatoException(p);
        }
        proiezione.postiVenduti.add(p);
        return vip
            ? BigliettoVip(proiezione, p)
            : ridotto
                ? BigliettoRidotto(proiezione, p)
                : BigliettoIntero(proiezione, p);
      });

  void _verificaProiezione(Proiezione proiezione) {
    if (!_proiezioni.contains(proiezione)) {
      throw const ProiezioneNonValidaException();
    }
  }
}
