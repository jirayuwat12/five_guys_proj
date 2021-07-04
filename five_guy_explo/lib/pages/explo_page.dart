import 'dart:async';
import 'dart:ui';

import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_stack/swipe_stack.dart';

final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
bool explopagesave = false;
int gbindex = 0;
bool reload = false;

class ExploPage extends StatefulWidget {
  @override
  _ExploPageState createState() => _ExploPageState();
}

class _ExploPageState extends State<ExploPage> with TickerProviderStateMixin {
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

  //load data from server and save to explore_json
  updateExploJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String got = prefs.getString('got item') != null
        ? prefs.getString('got item').toString()
        : "";
    List<String> got_id_list = got.split(',');
    //API work and save to explo_json

    print("explo len" + explore_json.length.toString());
    //end API work
    //save id that got from all time
    List tmpexplo = explore_json;
    for (int i = 0; i < tmpexplo.length; i++) {
      got += ',' + tmpexplo[i]['id'];
    }
    prefs.setString('got item', got);
  }

  //generate list<SwiperItem> use in swipe card
  generateList() {
    var size = MediaQuery.of(context).size;

    List<SwiperItem> list = [];
    List tmpexplo = explore_json;

    for (int index = 0; index < tmpexplo.length; index++) {
      list.add(SwiperItem(builder: (SwiperPosition position, double progress) {
        //make tinder like card
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
                        image: NetworkImage(tmpexplo[index]['image_url']),
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
                              child: Image.network(
                                tmpexplo[index]['image_url'],
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
                            Flexible(
                              child: Container(
                                width: size.width * 0.72,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'latitude ' +
                                          tmpexplo[index]['lat'].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'longitude ' +
                                          tmpexplo[index]['lon'].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
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

  //store the ID of place that user save
  saveIdplace(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String saved = pref.getString('saved place') == null
        ? ""
        : pref.getString('saved place').toString();
    saved += ',' + id;
    pref.setString('saved place', saved);
  }

  //make body in page >>tinder card
  Widget getBody() {
    var size = MediaQuery.of(context).size;
    //use stream bc data will change when go to index%10 = 9
    final Stream<List<SwiperItem>> _list = (() async* {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<SwiperItem> list = [];
      updateExploJson();
      list = generateList();
      //API work

      //end of API work
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
          //listn to _list valiable
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
                      //know this >> cancel button
                      explopagesave = false;
                    } else {
                      //dont know >> right button
                      if (explopagesave) {
                        //save ID
                        explopagesave = false;
                        print(explore_json[index]['id']);
                        saveIdplace(explore_json[index]['id']);
                      }
                    }
                    //time to relaod
                    if (gbindex % 10 == 9) {
                      print('reloading');
                    }
                  },
                  children: snapshot.data == null ? [] : snapshot.data,
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
