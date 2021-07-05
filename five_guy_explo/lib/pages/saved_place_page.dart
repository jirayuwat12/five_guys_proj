import 'dart:convert';
import 'dart:ui';
import 'package:five_guy_explo/fiveguys_sdk.dart';
import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';
import 'package:five_guy_explo/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlacePage extends StatefulWidget {
  SavedPlacePage({Key? key}) : super(key: key);

  @override
  _SavedPlacePageState createState() => _SavedPlacePageState();
}

class _SavedPlacePageState extends State<SavedPlacePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: FutureBuilder(
        future: _getList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //print("data = " + snapshot.data.toString());
          if (snapshot.hasData) {
            //print("inif =" + snapshot.data.toString());
            return buildCard(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  List<Place> data = [];
  Widget buildCard(String list) {
    if (list == "")
      return Center(
        child: Text('no saved'),
      );
    List<String> listID = [];
    String temp = "";
    for (int i = 1; i <= list.length; i++) {
      if (i == list.length || list[i] == ',') {
        listID.add(temp);
        temp = "";
      } else {
        temp += list[i];
      }
    }
    print("list ID like now");
    print(listID);
    List<Widget> cardlist = [];
    getdata(listID);

    for (int i = 0; i < data.length; i++) {
      // List<Place> data = await getdata(listID[i]);
      //testt
      print('data get from like list');
      print(data);
      cardlist.add(GestureDetector(
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
    //while (listID.length != cardlist.length)
    //  Future.delayed(Duration(seconds: 1));
    return ListView(
      children: cardlist,
    );
  }

  getdata(List<String> id) async {
    //data.clear();
    data = await getPlacesByID(id);
    // for (int i = 0; i < id.length; i++) {
    //   List<Place> l = await getPlacesByID([id[i]]);
    //   data.add(l[0]);
    // }
  }

  Future<String> _getList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    dynamic list = pref.getString('saved place');
    //print("temp = " + temp);

    List<String> listID = [];
    String temp = "";
    for (int i = 1; i <= list.length; i++) {
      if (i == list.length || list[i] == ',') {
        listID.add(temp);
        temp = "";
      } else {
        temp += list[i];
      }
    }
    getdata(listID);
    print("list ID like now");
    print(listID);
    return list;
  }
}
