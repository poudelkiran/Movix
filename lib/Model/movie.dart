import 'package:movix/Model/base_model.dart';

//* Movie List
class MovieList extends BaseModel {
  ///Properties
  int page;
  int totalPages;
  int totalMovies;
  List<Movie> movies;

  MovieList();

  @override
  BaseModel createNew() {
    return MovieList();
  }

  @override
  MovieList.fromJson(Map<String, dynamic> json) {
    this.page = json["page"] ?? 0;
    this.totalMovies = json["total_results"] ?? 0;
    this.totalPages = json["total_pages"] ?? 0;
    if (json['results'] != null) {
     this.movies = new List<Movie>.from(json["results"].map((x) => Movie.fromJson(x)));
    } else {
      this.movies = [];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  MovieList fromJson(Map<String, dynamic> map) {
    return MovieList.fromJson(map);
  }
}

//* Movie
class Movie extends BaseModel {
  int voteCount;
  int id;
  String voteAverage;
  String title;
  String posterPath;
  String overview;
  List<int> genreIds;
  String releaseDate;
  String backdropPath;
  String popularity;
  String type;

  Movie();

  @override
  BaseModel createNew() {
    return Movie();
  }

  @override
  Movie.fromJson(Map<String, dynamic> json) {
    this.voteCount = json["vote_count"] ?? 0;
    this.id = json["id"] ?? 0;
    final voteAvergae = json["vote_average"];
    this.voteAverage = voteAvergae == null ? "" : voteAvergae.toString();
    this.title = json["title"] ?? "";
    this.posterPath = json["poster_path"] ?? "";
    this.overview = json["overview"] ?? "";
    this.genreIds = json['genre_ids'].cast<int>();
    this.releaseDate = json["release_date"] ?? "";
    this.backdropPath = json["backdrop_path"] ?? "";
    final poularity = json["popularity"];
    this.popularity = poularity == null ? "" : poularity.toString();
    final isAdult = json["adult"] ?? false;
    this.type = isAdult ? "Adult" : "Family";
  }

  Movie fromJson(Map<String, dynamic> map) {
    return Movie.fromJson(map);
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}