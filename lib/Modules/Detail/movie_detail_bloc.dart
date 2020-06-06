import 'package:movix/BaseBloc/bloc.dart';
import 'package:movix/Model/cast.dart';
import 'package:movix/Model/genre.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Router/request.dart';
import 'package:movix/Router/endpoints.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc implements Bloc {
  //* Properties
  /// cast list to send stream of cast to list view.
  final castList = BehaviorSubject<List<ValueOrError<Cast>>>.seeded([]);

  /// movie genre list to send the stream of genre to the view.
  final movieGenreList = BehaviorSubject<List<Genre>>();

  /// holds list of genre that is sent from the previous page.
  List<Genre> allGeneres = [];

  /// hold the current movie.
  Movie movie;

  //* Initialization
  MovieDetailBloc(Movie movie, List<Genre> allGeneres) {
    this.movie = movie;
    this.allGeneres = allGeneres;

    getGenreFromId();
    getMovieDetails();
  }

  //* Lifecycle Methods
  @override
  void dispose() {
    movieGenreList.close();
    castList.close();
  }

  //* Custom Methods
  ///Fetch name of genres from list of genre id and add to the movieGenreList stream.
  void getGenreFromId() async {
    List<Genre> genreList = [];
    if (allGeneres.isEmpty) {
      allGeneres = await getGenreList();
    }
    movie.genreIds.forEach((id) {
      final genre =
          allGeneres.singleWhere((user) => user.id == id, orElse: () => null);
      if (genre != null) {
        genreList.add(genre);
      }
    });
    movieGenreList.add(genreList);
  }

  /// Get the list of genre from the api.
  Future<List<Genre>> getGenreList() async {
    final networkResponse =
        await Request.instance.fetchObject(Endpoints.genresUrl(), GenrePage());
    if (networkResponse.success) {
      GenrePage genrePage = networkResponse.result;
      return genrePage.genre;
    }
  }

  /// Get movie details from api of given movie id.
  /// If response from api is success, set Value else setError.
  void getMovieDetails() async {
    final networkResponse = await Request.instance
        .fetchObject(Endpoints.getCreditsUrl(movie.id), CastPage());
    networkResponse.success
        ? setValue(networkResponse)
        : setError(networkResponse);
  }

  /// Make an error according to the error from api and send to castList stream.
  void setError(NetworkingResult result) {
    final errorList = ValueOrError<Cast>(Constant.error, result.error, null);
    castList.add([errorList]);
  }

  /// Set value to the list view
  /// If list is empty, add corresponding message and send to the stream of cast list.
  /// If list is not empty, send list to the stream of cast list.
  void setValue(NetworkingResult result) {
    final cast = result.result as CastPage;
    final castList = cast.cast;
    if (castList.isEmpty) {
      final result =
          ValueOrError<Cast>(Constant.noData, Constant.noDataError, null);
      this.castList.add([result]);
    } else {
      final result =
          castList.map((value) => ValueOrError("", "", value)).toList();
      this.castList.add(result);
    }
  }
}
