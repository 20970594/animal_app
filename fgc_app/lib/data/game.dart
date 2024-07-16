class Game{
  final int? id;
  final String name;
  final int year;
  final String genre;
  final String description;
  final String urlAccess;
  final int punctuation;
  //final String urlLogo;

const Game({
    this.id,
    required this.name,
    required this.year,
    required this.genre,
    required this.description,
    required this.urlAccess,
    required this.punctuation,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'gender': genre,
      'description': description,
      'urlAccess': urlAccess,
      'punctuation': punctuation,
    };
  }

  static Game fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as int, // Cast to int for type safety
      name: map['name'] as String, // Cast to String for type safety
      year: map['year'] as int, 
      genre: map['gender'] as String, 
      description: map['description'] as String,
      urlAccess: map['urlAccess'] as String,
      punctuation: map['punctuation'] as int,
    );
  }

  @override
  String toString() {
    return 'Game{id: $id, name: $name, year: $year, genre: $genre, description: $description, urlAccess: $urlAccess, punctuation: $punctuation}';
  }
}