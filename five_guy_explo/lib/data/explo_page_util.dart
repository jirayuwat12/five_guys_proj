import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_stack/swipe_stack.dart';

import '../fiveguys_sdk.dart';

List<Place> tmpexplo = [];
List<Place> listPlaceShow = [];
updateExploJson() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String got_post = pref.getString('got item') == null
      ? ""
      : pref.getString('got item').toString();
  List<String> got_post_list = got_post.split(',');

  tmpexplo = await getPlaces(got_post_list);

  tmpexplo.forEach((element) {
    got_post += ',' + element.id;
    listPlaceShow.add(element);
  });
  print('listPlaceShow');
  print(listPlaceShow);
  print('listPlaceShow end');
  pref.setString('got item', got_post);
}

SwiperItem makeSwiperItem(int index, context) {
  Size size = MediaQuery.of(context).size;
  return SwiperItem(builder: (SwiperPosition position, double progress) {
    //make tinder like card
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [
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
                    image: NetworkImage(
                      listPlaceShow[index].imageUrl == null
                          ? 'https://img.freepik.com/free-photo/cement-wall-floor-copy-space_53876-30237.jpg?size=626&ext=jpg'
                          : listPlaceShow[index].imageUrl,
                    ),
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
                            listPlaceShow[index].imageUrl == null
                                ? 'https://img.freepik.com/free-photo/cement-wall-floor-copy-space_53876-30237.jpg?size=626&ext=jpg'
                                : listPlaceShow[index].imageUrl,
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
                                      listPlaceShow[index].name,
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
                                      listPlaceShow[index].lat.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'longitude ' +
                                      listPlaceShow[index].lon.toString(),
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
  });
}
