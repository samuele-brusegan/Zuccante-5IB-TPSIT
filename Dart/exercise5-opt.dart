class Studente {
	//Mappa TIPO, Lista voti
	Map<TipoVoti, List<double>> _voti = {
		TipoVoti.SCRITTO: [],
		TipoVoti.PRATICO: [],
		TipoVoti.ORALE: []
	};

	Studente([List<double>? scritti, List<double>? orali, List<double>? pratici]) {
		this._voti[TipoVoti.SCRITTO] = scritti??[];
		this._voti[TipoVoti.PRATICO] = pratici??[];
		this._voti[TipoVoti.ORALE]   = orali  ??[];
	}
	
	void addGrade(TipoVoti type, double voto) {
		this._voti[type]?.add(voto);
	}

	double average(TipoVoti type){
		List<double> lista = _voti[type] ?? [];
		double somma = 0;
		lista.forEach((voto) {somma += voto;});
		return somma/lista.length;
	}
}

class Classgroup {
	List<Studente> studenti;
	Classgroup([List<Studente>? studenti]): this.studenti=studenti??[];

	double classAverage(TipoVoti type){
		double somma = 0;
		studenti.forEach((studente) {somma += studente.average(type);});
		return somma / studenti.length;
	}

}

enum TipoVoti{
	SCRITTO,
	ORALE,
	PRATICO
}

void main() {
	Studente s = Studente();
	s.addGrade(TipoVoti.SCRITTO, 10);
	s.addGrade(TipoVoti.SCRITTO, 5);
	s.addGrade(TipoVoti.SCRITTO, 0);

	s.addGrade(TipoVoti.ORALE, 100);
	s.addGrade(TipoVoti.ORALE, 0);
	s.addGrade(TipoVoti.ORALE, 50);

	s.addGrade(TipoVoti.PRATICO, 1);
	s.addGrade(TipoVoti.PRATICO, 0.5);
	s.addGrade(TipoVoti.PRATICO, 0);

	print(s.average(TipoVoti.SCRITTO));
	print(s.average(TipoVoti.ORALE));
	print(s.average(TipoVoti.PRATICO));

}
