import 'dart:ui';

import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';
import 'package:five_guy_explo/fiveguys_sdk.dart';

import 'package:flutter/material.dart';

import 'comment_page.dart';

class TopPlacePage extends StatefulWidget {
  TopPlacePage({Key? key}) : super(key: key);

  @override
  _TopPlacePageState createState() => _TopPlacePageState();
}

class _TopPlacePageState extends State<TopPlacePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Place> data = [];

  reloaddata() async {
    data = await getTopPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: makeBody(),
    );
  }

  Widget makeBody() {
    return ListView(children: getTopThreePlace());
  }

  List<Widget> getTopThreePlace() {
    List<Widget> TopThreeList = [
      Container(
        height: 10,
      ),
      Row(
        children: [
          Container(
            width: 30,
          ),
          Text(
            'Top unknown place',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Container(
        height: 10,
      ),
    ];
    reloaddata();
    print('data len' + data.length.toString());
    for (int i = 0; i < 3; i++) {
      TopThreeList.add(GestureDetector(
        onTap: () {
          //print('before' + data['id']);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CommentPage(post_id: data[i].id.toString())));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 2),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(data[i].imageUrl),
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
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0),
                        ],
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  data[i].imageUrl,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
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
                                width: MediaQuery.of(context).size.width * 0.72,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data[i].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'latitude ' + data[i].lat.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'longitude ' + data[i].lon.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
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
        ),
      ));
    }
    return TopThreeList;
  }
}
