import 'package:flutter/material.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Modules/Detail/movie_detail.dart';
import 'package:movix/Modules/Detail/movie_detail_bloc.dart';
import 'package:movix/Modules/HomePage/home_bloc.dart';
import 'package:movix/Modules/HomePage/home_page.dart';
import 'package:movix/Modules/List/movie_list.dart';
import 'package:movix/Modules/List/movie_list_bloc.dart';
import 'package:movix/Modules/Search/custom_search_page.dart';
import 'package:movix/Modules/Search/search_bloc.dart';

//* This is the route page that holds routing of the app

/// Route class for routing of the app
class AppRoute {
  static void toMovieDetail(Movie movie) {}

  static const String home = "/";
  static const String search = "/search";
  static const String movieDetail = "/detail";
  static const String movieList = "/movieList";

  //push named
  static push(BuildContext context, String name, {Object arguments}) {
    Navigator.of(context).pushNamed(name, arguments: arguments);
  }
}

/// Generate routes from the name.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.home:
      final bloc = HomeBloc();
        return MaterialPageRoute(builder: (_) => HomePage(bloc: bloc));
      case AppRoute.search:
        final bloc = settings.arguments as SearchBloc;
        return MaterialPageRoute(builder: (_) => CustomSearchPage(bloc: bloc,));
      case AppRoute.movieDetail:
        var bloc = settings.arguments as MovieDetailBloc;
        return MaterialPageRoute(builder: (_) => MovieDetail(bloc: bloc,));
      case AppRoute.movieList:
        final bloc = settings.arguments as MovieListBloc;
        return MaterialPageRoute(builder: (_) => MovieListPage(bloc: bloc,));
      default:
        return _errorRoute();
    }
  }
  /// Error Screen, incase if the undefined route is triggered.
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
