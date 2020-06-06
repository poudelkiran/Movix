import 'package:movix/BaseBloc/bloc.dart';
import 'package:movix/Model/genre.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Router/endpoints.dart';
import 'package:movix/Router/request.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc implements Bloc {
  //* Properties
  /// list of movie to be populated in list view
  final movieList = BehaviorSubject<List<ValueOrError<Movie>>>.seeded([]);

  /// selected index of tab controller
  final index = BehaviorSubject<int>.seeded(0);

  /// hold list of genre fetched from the api.
  List<Genre> genreList = [];

  /// hold all tab contents to be shown in the page.
  List<TabBarContents> tabContents;

  //* Initialization
  HomeBloc() {
    // getGenreList();
    tabContents = _createTabContents();
    observeEvents();
  }

  /// create contents of tab and stores in tabcontents.
  List<TabBarContents> _createTabContents() {
    final contents = [
      TabBarContents(MovieType.inTheater, null),
      TabBarContents(MovieType.upcoming, null),
      TabBarContents(MovieType.topRated, null)
    ];
    return contents;
  }

  /// listen events.
  void observeEvents() {
    index.listen(_handleTabSelection);
  }

  /// get list of genres from the api.
  /// If success, store it to the genre list.
  void getGenreList() async {
    final networkResponse =
        await Request.instance.fetchObject(Endpoints.genresUrl(), GenrePage());
    if (networkResponse.success) {
      GenrePage genrePage = networkResponse.result;
      genreList = genrePage.genre;
    }
  }

  /// Handle tab selection when the tab is selected in the view.
  void _handleTabSelection(int index) {
    if (genreList.isEmpty) {
      getGenreList();
    }
    if (tabContents[index].movie == null) {
      fetchMovies(tabContents[index].type.getApi(1));
    } else {
      movieList.add(tabContents[index].movie);
    }
  }

  /// Fetch movies from the api.
  /// If response from network is success, set value.
  /// If response is failure, set failure.
  fetchMovies(String apiUrl) async {
    final networkResponse =
        await Request.instance.fetchObject(apiUrl, MovieList());
    networkResponse.success
        ? setValue(networkResponse)
        : setError(networkResponse);
  }

  /// Make error from response and send it to movie list subject.
  void setError(NetworkingResult result) {
    final errorList = ValueOrError<Movie>(Constant.error, result.error, null);
    movieList.add([errorList]);
  }

  /// If list is empty, make error otherwise send list to the movie list subject.
  void setValue(NetworkingResult result) {
    final movies = result.result as MovieList;
    final listOfMovies = movies.movies;
    if (listOfMovies.isEmpty) {
      final result =
          ValueOrError<Movie>(Constant.noData, Constant.noDataError, null);
      movieList.add([result]);
    } else {
      final result =
          listOfMovies.map((value) => ValueOrError("", "", value)).toList();
      tabContents[index.value].movie = result;
      movieList.add(result);
    }
  }

  //* Dispose
  @override
  void dispose() {
    movieList.close();
    index.close();
  }
}

/// Individual content of the tabbar
class TabBarContents {
  MovieType type;
  List<ValueOrError<Movie>> movie;

  TabBarContents(this.type, this.movie);
}

/// Type of the movie
enum MovieType { inTheater, upcoming, topRated }

extension MovieTypeExtension on MovieType {
  /// Get the title for individual tab bar.
  // ignore: missing_return
  String get title {
    switch (this) {
      case MovieType.inTheater:
        return "In Theater";
      case MovieType.upcoming:
        return "Upcoming";
      case MovieType.topRated:
        return "Top Rated";
    }
  }
  /// get the Api to be called for the individual tabbar content.
  // ignore: missing_return
  String getApi(int page) {
    switch (this) {
      case MovieType.inTheater:
        return Endpoints.nowPlayingMoviesUrl(page);
      case MovieType.upcoming:
        return Endpoints.upcomingMoviesUrl(page);
      case MovieType.topRated:
        return Endpoints.popularMoviesUrl(page);
    }
  }
}
