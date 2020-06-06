import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Modules/Detail/movie_detail_bloc.dart';
import 'package:movix/Modules/Search/search_bloc.dart';
import 'package:movix/Routes/route_generator.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Widgets/appBar.dart';
import 'package:movix/Widgets/error_widget.dart';
import 'package:movix/Widgets/movie_search_tile.dart';
import 'package:movix/Widgets/search_bar.dart';

class CustomSearchPage extends StatefulWidget {
  /// Bloc
  final SearchBloc bloc;
  const CustomSearchPage({Key key, this.bloc}) : super(key: key);

  @override
  _CustomSearchPageState createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage>
    with SingleTickerProviderStateMixin {
  /// Scroll controller
  ScrollController scrollController;

  /// search controller
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    /// Initialize
    scrollController = ScrollController();
    searchController = TextEditingController();

    /// Add listeners
    scrollController.addListener(_scrollListener);
    searchController.addListener(searchListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: false,
      backgroundColor: AppColor.whiteColor,
      appBar: CustomAppBar(
        shouldShowSearchIcon: false,
        backgroundColor: AppColor.searchBackgroundColor,
        isSearchEnabled: true,
        searchBar: SeachBar(controller: searchController),
      ),
      body: Container(
        height: double.infinity,
        color: AppColor.searchBackgroundColor,
        child: Container(
          margin: EdgeInsets.only(top: 20),
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
                    child: ErrorCellWidget(((ValueOrError(
                        Constant.search, Constant.searchResult, null)))),
                  );
                } else {
                  if ((movieList[0].value == null)) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: ErrorCellWidget(movieList[0]),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      // shrinkWrap: true,
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
                    );
                  }
                }
              }),
        ),
      ),
    );
  }

  /// Go to the movie details page
  _goToMovieDetail(Movie movie) {
    /// Dismiss the keyboard that was appeared.
    FocusScope.of(context).unfocus();

    /// Navigate to the movie detail page with its blc=oc.
    final homeBloc = MovieDetailBloc(movie, widget.bloc.allGeneres);
    AppRoute.push(context, AppRoute.movieDetail, arguments: homeBloc);
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

  /// Listens the on text changed event in the search bar.
  /// If the entered text is not empty, call the search api
  /// If text is empty, send empty array to the movie list stream.
  searchListener() {
    final text = searchController.text;
    widget.bloc.query.add(text);
  }
}
