import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movix/BaseBloc/bloc_provider.dart';
import 'package:movix/Model/cast.dart';
import 'package:movix/Model/genre.dart';
import 'package:movix/Model/value_or_error.dart';
import 'package:movix/Modules/Detail/movie_detail_bloc.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Utilities/Constant/images.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Utilities/styles.dart';
import 'package:movix/Widgets/appBar.dart';
import 'package:movix/Widgets/error_widget.dart';
import 'package:movix/Widgets/image_widget.dart';

class MovieDetail extends StatefulWidget {
  /// Movie detail bloc
  final MovieDetailBloc bloc;

  /// Initializer
  const MovieDetail({Key key, this.bloc}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.whiteColor,
      appBar: CustomAppBar(
        shouldShowSearchIcon: false,
      ),
      body: BlocProvider(
        bloc: widget.bloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ImageContent(),
            SizedBox(height: 30),
            TitleContent(),
            SizedBox(height: 10),
            GenreListContainer(),
            SizedBox(
              height: 30,
            ),
            ScrollingContents(),
          ],
        ),
      ),
    );
  }
}

class ScrollingContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Constant.plotSummary,
                style: GoogleFonts.mukta(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                    BlocProvider.of<MovieDetailBloc>(context).movie.overview,
                    style: Style.plainText),
              ),
              SizedBox(height: 20.0),
              CastCrewContent(),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class CastCrewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Constant.castAndCrew,
            style: GoogleFonts.mukta(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          SizedBox(height: 10),
          //Now list view of the photos
          SizedBox(
            height: 120,
            child: StreamBuilder<Object>(
                stream: BlocProvider.of<MovieDetailBloc>(context).castList,
                builder: (context, snapshot) {
                  ///Cast and crew list
                  final castAndCrewList =
                      snapshot.data as List<ValueOrError> ?? [];

                  ///If list is empty, show circular progress indicator
                  ///If list has value which is null show the error cell widget with the error values
                  ///Otherwise show the data to the user
                  if (castAndCrewList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (castAndCrewList[0].value == null) {
                    return Center(
                      child: ErrorCellWidget(castAndCrewList[0]),
                    );
                  } else {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: castAndCrewList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return GestureDetector(
                              onTap: () => _onCrewPhotoTapped(
                                  castAndCrewList[index].value, context),
                              child: PhotoView(
                                  data: castAndCrewList[index].value));
                        });
                  }
                }),
          )
        ],
      ),
    );
  }

  void _onCrewPhotoTapped(Cast cast, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    padding: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              cast.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.mukta(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                            Text(
                              cast.character,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.mukta(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Round Image
                Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: ImageView(
                            networkImageUrl: cast.profilePath,
                            imageUrlForEmptyNetworkImage: Images.emptyProfile,
                          )),
                    ))
              ],
            ),
          );
        });
  }
}

class PhotoView extends StatelessWidget {
  final Cast data;

  PhotoView({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 200,
        width: 110.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 70.0,
              width: 70.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ImageView(
                  networkImageUrl: data.profilePath,
                  imageUrlForEmptyNetworkImage: Images.emptyProfile,
                ),
              ),
            ),
            Text(data.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Style.plainText),
            Opacity(
                opacity: 0.5,
                child: Text(data.character,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Style.plainText)),
          ],
        ));
  }
}

//* Genre List Widget
class GenreListContainer extends StatelessWidget {
  const GenreListContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: StreamBuilder<Object>(
          stream: BlocProvider.of<MovieDetailBloc>(context).movieGenreList,
          builder: (context, snapshot) {
            return Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                runSpacing: 10,
                children: snapshot.hasData
                    ? (snapshot.data as List<Genre>)
                        .map((item) => GenreCard(title: item.name))
                        .toList()
                        .cast<Widget>()
                    : [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ]);
          }),
    );
  }
}

//* Genre Card
/// Design to show genres in listview.
class GenreCard extends StatelessWidget {
  final String title;

  GenreCard({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.black26)),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Text(title, style: Style.plainText),
      ),
    );
  }
}

//* Description Content
class TitleContent extends StatelessWidget {
  const TitleContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///movie detail bloc
    final movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(movieDetailBloc.movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Style.titleStyle),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Opacity(
                          opacity: .5,
                          child: Text(movieDetailBloc.movie.releaseDate,
                              style: Style.plainText),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Opacity(
                            opacity: .5,
                            child: Text(movieDetailBloc.movie.type,
                                style: Style.plainText)),
                        SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: AppColor.tabBarButtonColor,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: AppColor.whiteColor,
                  ),
                  onPressed: () {
                    final snackBar =
                        SnackBar(content: Text(Constant.availableSoon));
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                ))
          ],
        ),
      ),
    );
  }
}

//* Top Image content
class ImageContent extends StatelessWidget {
  const ImageContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetaiBloc = BlocProvider.of<MovieDetailBloc>(context);
    return Column(
      children: <Widget>[
        ///Mathiko image bhayeko container
        Container(
          height: (MediaQuery.of(context).size.width / 1.35) + 40,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width / 1.35,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: ImageView(
                      networkImageUrl: movieDetaiBloc.movie.backdropPath,
                      imageUrlForEmptyNetworkImage: (Images.emptyHeaderImage)),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(45, 0, 0, 0),

                  /// Container showing rating
                  child: Container(
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          bottomLeft: Radius.circular(45)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 25.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 9, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            generateIcons(
                                Icon(
                                  Icons.star,
                                  color: AppColor.yellowishColor,
                                  size: 30.0,
                                ),
                                "${movieDetaiBloc.movie.voteAverage}/10",
                                "${movieDetaiBloc.movie.popularity}"),
                            generateIcons(
                                Icon(
                                  Icons.star_border,
                                  size: 30.0,
                                ),
                                Constant.rateThis,
                                ""),
                            generateIcons(
                                Icon(
                                  Icons.comment,
                                  size: 30.0,
                                ),
                                Constant.metaScore,
                                "${movieDetaiBloc.movie.voteCount} critic review")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget generateIcons(Icon icon, String firstText, String secondText) {
    return Column(
      children: <Widget>[
        icon,
        Text(firstText, style: Style.plainBold),
        Opacity(opacity: 0.5, child: Text(secondText)),
      ],
    );
  }
}
