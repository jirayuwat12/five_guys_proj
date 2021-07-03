import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';

bool save = false;

class ExploPage extends StatefulWidget {
  @override
  _ExploPageState createState() => _ExploPageState();
}

class _ExploPageState extends State<ExploPage> with TickerProviderStateMixin {
  late CardController controller;

  List itemsTemp = [];
  int itemLength = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      //load data to explo json here
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: makeBody(),
      bottomSheet: makeBottomSheet(),
    );
  }

  Widget makeBody() {
    int nowpos = 0;
    String nowid = "";
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Container(
        height: size.height,
        child: TinderSwapCard(
          totalNum: itemLength,
          stackNum: 3,
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
                          image: AssetImage(itemsTemp[index]['img']),
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
                                itemsTemp[index]['img'],
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
                                          itemsTemp[index]['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          itemsTemp[index]['address'],
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
                                          itemsTemp[index]['desc'],
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
              nowpos = -1;
            } else if (align.x > 0) {
              nowpos = 1;
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            nowid = itemsTemp[index]['id'];
            if (save) {
              print('save');
              saveIdPlace(nowid);
            } else {
              print('not save');
            }
            if (index == (itemsTemp.length - 1)) {
              //out of the list
              setState(() {
                itemLength = itemsTemp.length - 1;
              });
            }
            save = false;
          },
        ),
      ),
    );
  }

  saveIdPlace(String placeID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic saved = pref.getString('saved_place');
    if (saved == null) saved = "";
    saved = saved + ',' + placeID;
    pref.setString('saved_place', saved);
    print(saved);
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
                    setState(() {
                      controller.triggerLeft();
                    });
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
                    setState(() {
                      controller.triggerRight();
                    });
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
                    setState(() {
                      save = true;
                      controller.triggerLeft();
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
