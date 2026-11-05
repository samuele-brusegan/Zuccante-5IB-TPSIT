class Schedule {
	Map<Sala,Movie> schedule;

	Schedule(): schedule={};

	void addMovie(Movie m, Sala s) {
		schedule.putIfAbsent(s,m);
	}
}

class Movie {
	String name;
	double dutarion_h;
	double start;

	Movie(this.name,this.dutarion_h,this.start);
}

class Sala {
	int numberId;
	List<Seat> seats;

	Sala(this.numberId, int seatNumber): seats=[] {
		for (int i = 0; i <= seatNumber; i++) {
			String char = String.fromCharCode(65+i%10);
			seats.add(Seat("${char}${i/10}"));
		}
	}
}

class Seat {
	String id; // Lettera + numero
	SeatState state;

	Seat(this.id, [this.state=SeatState.FREE]);
}

enum SeatState { FREE, OCCUPIED }
