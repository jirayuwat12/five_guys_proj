import 'dart:async';
import 'dart:ui';

import 'package:five_guy_explo/data/explo_page_util.dart';
import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';
import 'package:five_guy_explo/fiveguys_sdk.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_stack/swipe_stack.dart';

final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
bool explopagesave = false;
int gbindex = 0;
bool reload = false;
int lastgbindex = -1;

class ExploPage extends StatefulWidget {
  @override
  _ExploPageState createState() => _ExploPageState();
}

class _ExploPageState extends State<ExploPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    updateExploJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: getBody(),
      bottomSheet: makeBottomSheet(),
    );
  }

  //generate list<SwiperItem> use in swipe card

  //store the ID of place that user save
  saveIdplace(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String saved = pref.getString('saved place') == null
        ? ""
        : pref.getString('saved place').toString();
    saved += ',' + id;
    print('saved');
    print(saved);
    pref.setString('saved place', saved);
  }

  //make body in page >>tinder card
  Widget getBody() {
    var size = MediaQuery.of(context).size;
    //use stream bc data will change when go to index%10 = 9
    final Stream<List<Place>> _list = (() async* {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Place> list = [];
      updateExploJson();
      list = listPlaceShow;
      //API work

      //end of API work
      yield list;
      while (true) {
        await Future.delayed(Duration(seconds: 1));
        if (gbindex % 2 == 0 && gbindex != lastgbindex) {
          print('reloading');
          updateExploJson();
          list = listPlaceShow;
          print(list);
          reload = false;
          lastgbindex = gbindex;
          yield list;
        }
      }
    })();
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: StreamBuilder<List<Place>>(
          //listn to _list valiable
          stream: _list,
          builder: (context, snapshot) {
            List<SwiperItem> swiperList = [];
            if (!snapshot.hasData) {
            } else {
              for (int i = 0; i < listPlaceShow.length; i++) {
                print('adding swiper item');
                swiperList.add(makeSwiperItem(i, context));
              }
            }
            return Container(
                height: size.height,
                child: SwipeStack(
                  key: _swipeKey,
                  visibleCount: 3,
                  stackFrom: StackFrom.Bottom,
                  translationInterval: 0,
                  scaleInterval: 0,
                  animationDuration: Duration(milliseconds: 200),
                  onEnd: () {
                    if (gbindex % 2 != 0) gbindex++;
                  },
                  onSwipe: (int index, SwiperPosition position) {
                    print(listPlaceShow[index].name);
                    gbindex++;
                    print("gb index now" + gbindex.toString());
                    debugPrint("onSwipe $index $position");
                    if (position == SwiperPosition.Right) {
                      //know this >> cancel button
                      explopagesave = false;
                    } else {
                      //dont know >> right button
                      unknown(listPlaceShow[index].id);
                      if (explopagesave) {
                        //save ID
                        explopagesave = false;
                        saveIdplace(listPlaceShow[index].id);
                      }
                    }
                    //time to relaod
                  },
                  children: swiperList,
                ));
          }),
    );
  }

  //button on the bottom
  Widget makeBottomSheet() {
    var size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: 120,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                shadowColor: Colors.grey,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    'assets/images/check.png',
                    width: 25,
                    height: 25,
                  ),
                  onPressed: () {
                    _swipeKey.currentState?.swipeLeft();
                  },
                ),
              ),
              Material(
                shadowColor: Colors.grey,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    'assets/images/cancel-mark.png',
                    width: 25,
                    height: 25,
                  ),
                  onPressed: () {
                    _swipeKey.currentState?.swipeRight();
                  },
                ),
              ),
              Material(
                shadowColor: Colors.grey,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    'assets/images/bookmark.png',
                    width: 25,
                    height: 25,
                  ),
                  onPressed: () {
                    explopagesave = true;
                    _swipeKey.currentState?.swipeLeft();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
