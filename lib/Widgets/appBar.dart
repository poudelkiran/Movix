//* Custom App Bar
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movix/Modules/Search/search_bloc.dart';
import 'package:movix/Routes/route_generator.dart';
import 'package:movix/Utilities/Constant/constants.dart';
import 'package:movix/Widgets/search_bar.dart';

enum PageType { home, other }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool shouldShowSearchIcon;
  final Color backgroundColor;
  final bool isSearchEnabled;
  final PageType type;
  final String title;
  final SeachBar searchBar;
  final SearchBloc searchBloc;
  CustomAppBar(
      {this.shouldShowSearchIcon,
      this.backgroundColor = Colors.transparent,
      this.isSearchEnabled = false,
      this.type = PageType.other,
      this.title = "",
      this.searchBar, this.searchBloc});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: !widget.isSearchEnabled
          ? Center(
              child: Text(
              widget.title,
              style: GoogleFonts.mukta(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.black),
            ))
          : widget.searchBar,
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.transparent,
      ),
      leading: Builder(
        builder: (context) {
          switch (widget.type) {
            case PageType.home:
              return new IconButton(
                icon: new Icon(Icons.menu, color: Colors.black45),
                onPressed: showAlert,
              );
            default:
              return new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Colors.black45),
                onPressed: () => _goBack(),
              );
          }
        },
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _goToSearch();
              },
              child: widget.shouldShowSearchIcon
                  ? Icon(Icons.search, size: 35.0, color: Colors.black45)
                  : SizedBox(height: 0),
            ))
      ],
    );
  }

  ///Go to the search view
  _goToSearch() {
    AppRoute.push(context, AppRoute.search, arguments: widget.searchBloc);
  }

  ///Show snackBar
  showAlert() {
    final snackBar = SnackBar(content: Text(Constant.availableSoon));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _goBack() {
    /// Dismiss the keyboard when appeared and go back.
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }
}
