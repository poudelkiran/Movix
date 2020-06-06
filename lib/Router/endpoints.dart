import 'package:movix/Utilities/Constant/api_constants.dart';

class Endpoints {
  
  /// return url to fetch now playing movies of a specific page.
  static String nowPlayingMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/now_playing?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  /// return url to fetch all the credits of given movie.
  static String getCreditsUrl(int id) {
    return '$TMDB_API_BASE_URL' + '/movie/$id/credits?api_key=$TMDB_API_KEY';
  }

  /// return url to fetch all popular movies of a specific page.
  static String popularMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/popular?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  /// returns url to fetch all upcoming movies of a specific page.
  static String upcomingMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/upcoming?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  /// returns url to fetch list of genres of a movie.
  static String genresUrl() {
    return '$TMDB_API_BASE_URL/genre/movie/list?api_key=$TMDB_API_KEY&language=en-US';
  }

  /// returns url to fetch all movies of a given genre of a specific page.
  static String getMoviesForGenre(int genreId, int page) {
    return '$TMDB_API_BASE_URL/discover/movie?api_key=$TMDB_API_KEY'
        '&language=en-US'
        '&sort_by=popularity.desc'
        '&include_adult=false'
        '&include_video=false'
        '&page=$page'
        '&with_genres=$genreId';
  }

  /// returns url to fetch reviews of a specific page.
  static String movieReviewsUrl(int movieId, int page) {
    return '$TMDB_API_BASE_URL/movie/$movieId/reviews?api_key=$TMDB_API_KEY'
        '&language=en-US&page=$page';
  }

  /// returns url to search a movie from a query of a specific page.
  static String movieSearchUrl(String query, int page) {
    return "$TMDB_API_BASE_URL/search/movie?query=$query&page=$page&api_key=$TMDB_API_KEY";
  }

  /// return urls to search person from a query.
  static String personSearchUrl(String query) {
    return "$TMDB_API_BASE_URL/search/person?query=$query&api_key=$TMDB_API_KEY";
  }

  /// returns urls to get perons info from id.
  static getPerson(int personId) {
    return "$TMDB_API_BASE_URL/person/$personId?api_key=$TMDB_API_KEY&append_to_response=movie_credits";
  }
}
