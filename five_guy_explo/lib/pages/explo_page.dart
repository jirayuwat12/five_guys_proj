import 'dart:async';
import 'dart:ui';

import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:five_guy_explo/data/explore_json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_stack/swipe_stack.dart';

final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
bool save = false;
int gbindex = 0;
bool reload = false;

class ExploPage extends StatefulWidget {
  @override
  _ExploPageState createState() => _ExploPageState();
}

class _ExploPageState extends State<ExploPage> with TickerProviderStateMixin {
  late CardController controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      updateExploJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: getBody(),
      bottomSheet: makeBottomSheet(),
    );
  }

  updateExploJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String got = prefs.getString('got item') != null
        ? prefs.getString('got item').toString()
        : "";
    List<String> got_id_list = got.split(',');
    //API work and save to explo_json

    print("explo len" + explore_json.length.toString());
    //end API work
    List tmpexplo = explore_json;
    for (int i = 0; i < tmpexplo.length; i++) {
      got += ',' + tmpexplo[i]['id'];
    }
    prefs.setString('got item', got);
  }

  generateList() {
    var size = MediaQuery.of(context).size;
    List<SwiperItem> list = [];
    List tmpexplo = explore_json;
    for (int index = 0; index < tmpexplo.length; index++) {
      list.add(SwiperItem(builder: (SwiperPosition position, double progress) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(tmpexplo[index]['img']),
                        fit: BoxFit.cover),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0),
                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                tmpexplo[index]['img'],
                                width: MediaQuery.of(context).size.width * 0.7,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                              width: size.width * 0.72,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        tmpexplo[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        tmpexplo[index]['address'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        tmpexplo[index]['desc'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }));
    }
    return list;
  }

  saveIdplace(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String saved = pref.getString('saved place') == null
        ? ""
        : pref.getString('saved place').toString();
    saved += ',' + id;
    pref.setString('saved place', saved);
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    final Stream<List<SwiperItem>> _list = (() async* {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<SwiperItem> list = [];
      updateExploJson();
      list = generateList();
      /*
        request post
      */
      yield list;
      while (true) {
        await Future.delayed(Duration(seconds: 1));
        if (gbindex % 10 == 9 && reload) {
          updateExploJson();
          list = generateList();
          reload = false;
          yield list;
        } else if (gbindex % 10 != 9) {
          reload = true;
        }
      }
    })();
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: StreamBuilder<List<SwiperItem>>(
          stream: _list,
          builder: (context, snapshot) {
            return Container(
                height: size.height,
                child: SwipeStack(
                  key: _swipeKey,
                  visibleCount: 2,
                  stackFrom: StackFrom.Bottom,
                  translationInterval: 6,
                  scaleInterval: 0.03,
                  onEnd: () => debugPrint("onEnd"),
                  onSwipe: (int index, SwiperPosition position) {
                    print(gbindex);
                    gbindex++;
                    debugPrint("onSwipe $index $position");
                    if (position == SwiperPosition.Right) {
                      //know this
                      save = false;
                    } else {
                      //dont know
                      if (save) {
                        save = false;
                        print(explore_json[index]['id']);
                        saveIdplace(explore_json[index]['id']);
                      } else {}
                    }
                    if (gbindex % 10 == 9) {
                      print('almost');
                    }
                  },
                  children: snapshot.data == null ? [] : snapshot.data,
                  /*[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int index) {
                    return SwiperItem(
                        builder: (SwiperPosition position, double progress) {
                      return Material(
                          elevation: 4,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Item $index",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20)),
                                  Text("Progress $progress",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 12)),
                                ],
                              )));
                    });
                  }).toList(),*/
                )
                /*TinderSwapCard(
              totalNum: itemLength,
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height * 0.75,
              minWidth: MediaQuery.of(context).size.width * 0.75,
              minHeight: MediaQuery.of(context).size.height * 0.6,
              cardBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(tmpexplo[index]['img']),
                              fit: BoxFit.cover),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.white.withOpacity(0)),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: size.height,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.black.withOpacity(0),
                            ],
                                end: Alignment.topCenter,
                                begin: Alignment.bottomCenter)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    tmpexplo[index]['img'],
                                    width: MediaQuery.of(context).size.width * 0.7,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.72,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              tmpexplo[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              tmpexplo[index]['address'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              tmpexplo[index]['desc'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              cardController: controller = CardController(),
              swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                if (align.x < 0) {
                } else if (align.x > 0) {}
              },
              swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                if (index == (tmpexplo.length - 1)) {
                  setState(() {
                    itemLength = tmpexplo.length - 1;
                  });
                }
              },
            ),*/

                );
          }),
    );
  }

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
                    //setState(() {
                    //_swipeKey.currentState?.swipeLeft();
                    //});
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
                    //setState(() {
                    //_swipeKey.currentState?.swipeRight();
                    //});
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
                    //setState(() {
                    save = true;
                    // _swipeKey.currentState?.swipeLeft();
                    //});
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
