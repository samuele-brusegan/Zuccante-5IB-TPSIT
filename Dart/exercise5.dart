class Studente {
	List<double> _scritti = [];
	List<double> _orali   = [];
	List<double> _pratici = [];

	Studente([List<double>? _scritti, List<double>? _orali, List<double>? _pratici]){
		this._scritti = _scritti??[];
		this._orali   = _orali??[];
		this._pratici = _pratici??[];
	}

	void addGrade({double? scritto, double? orale, double? pratico}) {
		if(scritto != null) _scritti.add(scritto);
		if(orale   != null) _orali  .add(orale);
		if(pratico != null) _pratici.add(pratico);
	}

	double avarage(TipoVoti tipoLista){
		var lista;

		switch (tipoLista) {
			case TipoVoti.SCRITTO:
				lista = _scritti;
				break;
			case TipoVoti.ORALE:
				lista = _orali;
				break;
			case TipoVoti.PRATICO:
				lista = _pratici;
				break;
		}

		double somma = 0;
		for (final el in lista) {
			somma += el;
		}
		return somma/lista.length;
	}


}

enum TipoVoti{
	SCRITTO,
	ORALE,
	PRATICO
}

void main() {
	Studente s = Studente();
	s.addGrade(scritto: 10);
	s.addGrade(scritto: 5);
	s.addGrade(scritto: 0);

	s.addGrade(orale: 100);
	s.addGrade(orale: 0);
	s.addGrade(orale: 50);

	s.addGrade(pratico: 1);
	s.addGrade(pratico: 0.5);
	s.addGrade(pratico: 0);

	print(s.avarage(TipoVoti.SCRITTO));
	print(s.avarage(TipoVoti.ORALE));
	print(s.avarage(TipoVoti.PRATICO));

}