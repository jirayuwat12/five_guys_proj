import 'package:flutter/material.dart';
import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/pages/explo_page.dart';
import 'package:five_guy_explo/pages/top_place_page.dart';
import 'package:five_guy_explo/pages/saved_place_page.dart';
import 'package:five_guy_explo/pages/settting_page.dart';

class RootPage extends StatefulWidget {
  RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      appBar: makeAppBar(),
      body: makeBody(),
    );
  }

  AppBar makeAppBar() {
    List buttonlists = [
      pageIndex == 0
          ? "assets/images/home_act.png"
          : "assets/images/home_unact.png",
      pageIndex == 1
          ? "assets/images/star_act.png"
          : "assets/images/star_unact.png",
      pageIndex == 2
          ? "assets/images/bookmark_act.png"
          : "assets/images/try_error_1.png",
      pageIndex == 3
          ? "assets/images/settings_act.png"
          : "assets/images/settings_unact.png",
    ];
    //#00C3FF

    return AppBar(
      backgroundColor: MainColor,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(buttonlists.length, (index) {
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset(
                buttonlists[index],
                width: 25,
                height: 25,
              ),
              onPressed: () {
                setState(() {
                  pageIndex = index;
                });
              },
            );
          }),
        ),
      ),
    );
  }

  Widget makeBody() {
    return IndexedStack(
      index: pageIndex,
      children: [ExploPage(), TopPlacePage(), SavedPlacePage(), SettingPage()],
    );
  }
}
