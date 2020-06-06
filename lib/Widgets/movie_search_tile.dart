import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movix/Model/movie.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Utilities/Constant/images.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Utilities/styles.dart';
import 'package:movix/Widgets/image_widget.dart';

class MovieSearchTile extends StatelessWidget {
  final Movie movie;
  final int index;
  const MovieSearchTile({Key key, this.movie, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.lightBlackColor,
                        blurRadius: 2,
                        offset: Offset(5, 5))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //*Image
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 78,
                          height: 105,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                              child: ImageView(
                                networkImageUrl: movie.backdropPath,
                                imageUrlForEmptyNetworkImage: Images.emptyProfile,
                              )),
                        ),
                        //*Title
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  movie.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Style.titleStyle,
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    movie.releaseDate,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Style.plainBold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //* Scroe
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            Constant.imdbScore,
                            style: Style.plainBold,
                          ),
                        ),
                        Text(
                          movie.voteAverage,
                          style: GoogleFonts.mukta(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
