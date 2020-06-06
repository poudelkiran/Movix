import 'package:movix/BaseBloc/bloc.dart';
import 'package:movix/Model/genre.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Router/endpoints.dart';
import 'package:movix/Router/request.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:rxdart/rxdart.dart';

/// Movie List Bloc for movie list page
class SearchBloc implements Bloc {
  //* Properties
  /// send the stream of movie list to the list view.
  final movieList = BehaviorSubject<List<ValueOrError<Movie>>>.seeded([]);

  /// holds current page number
  int currentPage = 1;

  /// holds total page for a given list
  int totalPage;

  /// holds boolean to check if api is running or not.
  bool isApiRunning = true;

  /// query that was typed by the user in the search bar.
  final query = BehaviorSubject<String>();

  /// holds all the genres.
  List<Genre> allGeneres = [];

  /// Initialization
  SearchBloc(this.allGeneres) {
    _observeEvents();
  }

  /// listen all the events.
  _observeEvents() {
    /// listens the query subject, if any changes is found, call the getMovieFromAPI() after the specified duration.
    query
        .skip(1)
        .throttleTime(Duration(milliseconds: 100))
        .listen((searchQuery) async {
      getMovieFromAPI(searchQuery, 1);
    });
  }

  //* Dispose
  /// Dispose
  @override
  void dispose() {
    movieList.close();
    query.close();
  }

  //* Custom Methods
  /// Fetch movie from the api of given page.
  void getMovieFromAPI(String query, int page) async {
    /// If the entered query is empty, send empty list to the listview.
    if (query.trim().isEmpty) {
      sendResult([]);
      return;
    }
    isApiRunning = true;
    final apiUrl = Endpoints.movieSearchUrl(query, page);
    final networkResponse =
        await Request.instance.fetchObject(apiUrl, MovieList());
    isApiRunning = false;

    /// Check success or failure and set value or error accordingly.
    networkResponse.success
        ? _setValue(networkResponse)
        : _setError(networkResponse);
  }

  /// If error is received from network response, then set error to the listview.
  void _setError(NetworkingResult result) {
    final errorList = ValueOrError<Movie>(Constant.error, result.error, null);
    movieList.add([errorList]);
  }

  /// If success is return from network response, then set value to the list view.
  void _setValue(NetworkingResult result) {
    final movies = result.result as MovieList;

    ///Get total page from movielist
    totalPage = movies.totalPages;

    /// get current page from the given page.
    currentPage = movies.page;

    ///Get list of movies
    final allMovies = movies.movies;

    /// If list is empty, send error with valid message
    if (allMovies.isEmpty) {
      final result =
          ValueOrError<Movie>(Constant.noData, Constant.noSearchResult, null);
      //If the array have previous value then append it here. However, dont append if the current page is 1.
      if (this.movieList.value.length > 0 && this.currentPage != 1) {
        List<ValueOrError<Movie>> newList = List.from(this.movieList.value)
          ..addAll([result]); //(this.movieList.value).add(result);
        sendResult(newList);
        return;
      }
      sendResult([result]);
    }

    /// If list is not empty, send desired data.
    else {
      final result =
          allMovies.map((value) => ValueOrError("", "", value)).toList();

      /// Check if movieList contains previous array of movies or not, If current page is 1 donot append previous datas.
      /// If contains list of movies then append new fetched movie with the previous movie and send data and return the app.
      if (this.movieList.value.length > 0 && this.currentPage != 1) {
        List<ValueOrError<Movie>> newList = List.from(this.movieList.value)
          ..addAll(result);
        sendResult(newList);
        return;
      }
      sendResult(result);
    }
  }

  void sendResult(List<ValueOrError<Movie>> list) {
    if (query.value.isEmpty) {
      movieList.add([]);
    } else {
      movieList.add(list);
    }
  }

  /// Fetch movie of new page during scrolling listview. (Pagination Implementation).
  /// Fetch movie from new page which is equal to current Page + 1.
  /// Fetch if new page is less than or equal to total page of current list view and isCurrent page is not loading.
  /// change current page to new page.
  void fetchMovies() {
    final newPage = currentPage + 1;
    if (newPage <= totalPage && !isApiRunning) {
      isApiRunning = true;
      getMovieFromAPI(query.value, newPage);
    }
  }
}
