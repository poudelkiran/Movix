import 'package:movix/BaseBloc/bloc.dart';
import 'package:movix/Model/genre.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Modules/HomePage/home_bloc.dart';
import 'package:movix/Router/request.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:rxdart/rxdart.dart';

/// Movie List Bloc for movie list page
class MovieListBloc implements Bloc {

  //* Properties
  /// send the stream of movie list to the list view.
  final movieList = BehaviorSubject<List<ValueOrError<Movie>>>.seeded([]);

  MovieType movieType; 

  /// holds current page number
  int currentPage = 1; 

  /// holds total page for a given list
  int totalPage;

  /// holds boolean to check if api is running or not.
  bool isApiRunning = true;

  List<Genre> genreList;
  /// Initialization
  MovieListBloc(MovieType movieType, List<Genre> genreList) {
    this.movieType = movieType;
    this.genreList = genreList;
    getMovieFromAPI(currentPage);
  }

  @override
  void dispose() {
    movieList.close();
  }

  /// Fetch movie from the api of given page.
  void getMovieFromAPI(int page) async {
    isApiRunning = true;
    final apiUrl = movieType.getApi(page);
    final networkResponse = await Request.instance.fetchObject(apiUrl, MovieList());
    isApiRunning = false;
    /// Check success or failure and set value or error accordingly.
    networkResponse.success ? setValue(networkResponse) : setError(networkResponse);
  }

  /// If error is received from network response, then set error to the listview.
  void setError(NetworkingResult result) {
    final errorList = ValueOrError<Movie>(Constant.error, result.error, null);
    movieList.add([errorList]);
  }

  /// If success is return from network response, then set value to the list view.
  void setValue(NetworkingResult result) {
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
          ValueOrError<Movie>(Constant.noData, Constant.noDataError, null);
          //If the array have previous value then append it here. However, dont append if the current page is 1.
          if (this.movieList.value.length > 0 && this.currentPage != 1) {
            List<ValueOrError<Movie>> newList = List.from(this.movieList.value)..addAll([result]);//(this.movieList.value).add(result);
          this.movieList.add(newList); 
          return;     
          }
      this.movieList.add([result]);
    } 
    /// If list is not empty, send desired data.
    else {
      final result = allMovies.map((value) => ValueOrError("", "", value)).toList();
          /// Check if movieList contains previous array of movies or not, If current page is 1 donot append previous datas.
          /// If contains list of movies then append new fetched movie with the previous movie and send data and return the app.
          if (this.movieList.value.length > 0 && this.currentPage != 1) {
            List<ValueOrError<Movie>> newList = List.from(this.movieList.value)..addAll(result);
          this.movieList.add(newList); 
          return;     
          }
      this.movieList.add(result);
    }
  }

  /// Fetch movie of new page during scrolling listview. (Pagination Implementation).
  /// Fetch movie from new page which is equal to current Page + 1.
  /// Fetch if new page is less than or equal to total page of current list view and isCurrent page is not loading.
  /// change current page to new page.
  void fetchMovies() {
    final newPage = currentPage + 1;
    if (newPage <= totalPage  && !isApiRunning) {
      isApiRunning = true;
      getMovieFromAPI(newPage);
    }
  }
}
