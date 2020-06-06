import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Modules/Detail/movie_detail_bloc.dart';
import 'package:movix/Modules/List/movie_list_bloc.dart';
import 'package:movix/Routes/route_generator.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Widgets/appBar.dart';
import 'package:movix/Widgets/error_widget.dart';
import 'package:movix/Widgets/movie_search_tile.dart';
import 'package:movix/Modules/HomePage/home_bloc.dart';

class MovieListPage extends StatefulWidget {
  MovieListBloc bloc;

  MovieListPage({this.bloc});

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColor.whiteColor,
      appBar: CustomAppBar(
          shouldShowSearchIcon: false, title: widget.bloc.movieType.title),
      body: Container(
        color: AppColor.whiteColor,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            color: AppColor.whiteColor,
            child: StreamBuilder(
                stream: widget.bloc.movieList,
                builder: (context, snapshot) {
                  ///Movie list
                  final movieList =
                      (snapshot.data as List<ValueOrError<Movie>>) ?? [];

                  ///If movie list is empty show circular progress indicator
                  ///If movie list has null value show the error cell widget
                  ///Otherwise show the data to the user
                  if (movieList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (movieList[0].value == null) {
                    return Center(
                      child: ErrorCellWidget(movieList[0]),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: refreshListView,
                      child: ListView.builder(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: movieList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return GestureDetector(
                              onTap: () =>
                                  _goToMovieDetail(movieList[index].value),
                              child: MovieSearchTile(
                                movie: movieList[index].value,
                                index: index,
                              ));
                        },
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  /// Route to the movie detail page.
  void _goToMovieDetail(Movie movie) {
    /// Navigate to the movie detail page with its blc=oc.
    final detailBloc = MovieDetailBloc(movie, widget.bloc.genreList);
    AppRoute.push(context, AppRoute.movieDetail, arguments: detailBloc);
  }

  /// Listen the scroll of the list view.
  /// If listview scroll is down and listview bottom is 200 above the max scoll extent, fetch the movie.
  /// Pagination Implementation
  _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (scrollController.offset >
          scrollController.position.maxScrollExtent - 200) {
        widget.bloc.fetchMovies();
      }
    }
  }

  Future<Null> refreshListView() async {
    await widget.bloc.getMovieFromAPI(1);
    return null;
  }
}
