import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Modules/Detail/movie_detail_bloc.dart';
import 'package:movix/Modules/HomePage/home_bloc.dart';
import 'package:movix/Modules/List/movie_list_bloc.dart';
import 'package:movix/Modules/Search/search_bloc.dart';
import 'package:movix/Routes/route_generator.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Utilities/Constant/images.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Utilities/styles.dart';
import 'package:movix/Widgets/appBar.dart';
import 'package:movix/Widgets/error_widget.dart';
import 'package:movix/Widgets/image_widget.dart';
import 'package:movix/Widgets/tab_bar.dart';
import 'dart:core';

class HomePage extends StatefulWidget {
  /// holds home bloc
  HomeBloc bloc;

  /// Initializer
  HomePage({this.bloc});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  /// page controller
  PageController ctrl;

  /// tab controller
  TabController tabController;

  /// hold current page of the page view
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    ctrl = PageController(viewportFraction: 0.8);
    tabController =
        TabController(length: widget.bloc.tabContents.length, vsync: this);

    /// Listener for the page controller
    ctrl.addListener(_handlePageViewScroll);

    /// Listener for the tab controller
    tabController.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        shouldShowSearchIcon: true,
        type: PageType.home,
        searchBloc: SearchBloc(widget.bloc.genreList),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.whiteColor, AppColor.whiteGradientColor])),
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              CustomTabBar(
                tabController: tabController,
                contents: widget.bloc.tabContents,
              ),
              Expanded(
                child: StreamBuilder<Object>(
                    stream: widget.bloc.movieList,
                    builder: (context, snapshot) {
                      final movieList =
                          (snapshot.data as List<ValueOrError>) ?? [];

                      ///If movie list is empty, show circular indicator
                      ///If movie list value is null, show error cell widget
                      ///otherwise show the valid data
                      if (movieList.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (movieList[0].value == null) {
                        return Center(
                          child: ErrorCellWidget(movieList[0]),
                        );
                      } else {
                        return PageView.builder(
                            itemCount:
                                movieList.length > 5 ? 5 : movieList.length,
                            scrollDirection: Axis.horizontal,
                            controller: ctrl,
                            itemBuilder: (context, int currentIndex) {
                              return _buildMoviePage(
                                  movieList[currentIndex].value,
                                  currentIndex == currentPage,
                                  currentIndex ==
                                      (movieList.length > 5
                                          ? 4
                                          : movieList.length - 1));
                            });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Tile for the page view.
  /// If is active change the effects
  /// If is last page show different content
  Widget _buildMoviePage(Movie movie, bool isActive, bool isLastPage) {
    /// blur effect
    final double blur = isActive ? 30 : 0;

    ///offset
    final double offset = isActive ? 20 : 0;

    /// top padding
    final double top = isActive ? 20 : 70;

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: !isLastPage ? () => _goToDetail(movie) : _goToList,
              child: AnimatedContainer(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.midBlackColor,
                          blurRadius: blur,
                          offset: Offset(offset, offset),
                        )
                      ]),
                  child: isLastPage
                      ? Container(
                          color: Color(0xff09111f),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(Constant.viewAll,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.mukta(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          color: Colors.white)),
                                  Image.asset(Images.viewAll)
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: ImageView(
                            networkImageUrl: movie.backdropPath,
                            imageUrlForEmptyNetworkImage:
                                Images.emptyHeaderImage,
                          ),
                        ),
                ),
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeOutQuint,
                margin:
                    EdgeInsets.only(top: top, bottom: 50, right: 10, left: 10),
              ),
            ),
          ),
          Text(isLastPage ? "" : movie.title,
              textAlign: TextAlign.center, style: Style.titleStyle),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isLastPage
                  ? SizedBox()
                  : Icon(
                      Icons.star,
                      color: AppColor.yellowishColor,
                    ),
              SizedBox(width: 10),
              Text(isLastPage ? "" : "${movie.voteAverage}",
                  style: Style.subHeaderStyle),
            ],
          )
        ],
      ),
    );
  }

  /// when tab is changed by the user
  _handleTabSelection() {
    /// trigger the index subject in the home bloc.
    widget.bloc.index.add(tabController.index);
  }

  /// handle when the page view is scrolled
  _handlePageViewScroll() {
    int next = ctrl.page.round();

    /// change the current page when scrolled in the page view.
    if (currentPage != next) {
      setState(() {
        currentPage = next;
      });
    }
  }

  /// go to the movie detail page
  _goToDetail(Movie movie) {
    ///initialize bloc
    final homeBloc = MovieDetailBloc(movie, widget.bloc.genreList);

    /// push page
    AppRoute.push(context, AppRoute.movieDetail, arguments: homeBloc);
  }

  /// go to the movie list.
  _goToList() {
    /// get type of the movie whose list is to be fetched
    final movieType = widget.bloc.tabContents[widget.bloc.index.value].type;

    /// initialize bloc for a movie list
    final movieListBloc = MovieListBloc(movieType, widget.bloc.genreList);

    /// push page with the bloc.
    AppRoute.push(context, AppRoute.movieList, arguments: movieListBloc);
  }
}
