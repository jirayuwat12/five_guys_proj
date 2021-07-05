import 'package:five_guy_explo/data/avatarurlList.dart';
import 'package:five_guy_explo/fiveguys_sdk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  final String post_id;
  CommentPage({Key? key, required this.post_id}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commments;
  String user_avatar_url = "";
  String user_name = "";
  List<String> saved_id = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //API get data
    get_comments();
    get_avatar_url();
    get_user_name();
    get_saved_post();
  }

  set_saved_post(String i) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('saved place', i);
  }

  get_saved_post() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String idpost = pref.getString('saved place') == null
        ? ""
        : pref.getString('saved place').toString();
    print('idpos = ' + idpost);
    saved_id = idpost.split(',');
  }

  sentComment(String comment) async {}

  get_user_name() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user_name = pref.getString('user name') == null
        ? 'Peter'
        : pref.getString('user name').toString();
  }

  get_avatar_url() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int i = pref.getInt('avatar order') == null
        ? 0
        : pref.getInt('avatar order')!.toInt();
    user_avatar_url = avatarURL[i];
  }

  Place data = new Place(
      id: '', name: '', imageUrl: '', unknown: 0, lat: 0, lon: 0, comments: []);
  get_comments() async {
    List<Place> l = await getPlacesByID([widget.post_id]);
    setState(() {
      data = l[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    // print(widget.post_id);
    get_comments();
    get_avatar_url();
    get_user_name();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff00C3FF)),
          backgroundColor: Colors.white,
          title: Text(
            // widget.post_id,
            data.name,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  //print(saved_id);
                  String rem = "";
                  for (int i = 0; i < saved_id.length; i++) {
                    if (saved_id[i].toString() != widget.post_id.toString() &&
                        saved_id[i] != "") rem += "," + saved_id[i].toString();
                  }
                  set_saved_post(rem);
                  print('rem = ' + rem);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: ListView(
            children: makebody()
              ..add(Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          minRadius: 20,
                          backgroundImage: NetworkImage(user_avatar_url),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //username
                                Text(
                                  user_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide()),
                                          //focusedBorder: InputBorder.none,
                                          //enabledBorder: InputBorder.none,
                                          //errorBorder: InputBorder.none,
                                          //disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                          hintText: "what are u thinking"),
                                      controller: commentController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      elevation: 2,
                                      color: Color(0xff00C3FF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "enter",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Future<String> retid = comment(
                                            userName: user_name,
                                            date: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            text: commentController.text,
                                            placeID: widget.post_id,
                                            avatarUrl: user_avatar_url);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))));
  }

  List<Widget> makebody() {
    List<Widget> ret = [];
    for (int i = 0; i < data.comments.length; i++) {
      ret.add(makeCommentCard(
          data.comments[i].avatarUrl,
          data.comments[i].userName,
          data.comments[i].date,
          data.comments[i].text,
          data.comments[i].like,
          data.comments[i].id));
    }
    return ret;
  }

  Padding makeCommentCard(String avartar_url, String name, int date,
      String text, int numlikes, String cmtid) {
    bool clickalbe = true;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                minRadius: 20,
                backgroundImage: NetworkImage(avartar_url),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //username
                      Text(
                        name + ' ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      //date
                      Text(DateTime.fromMillisecondsSinceEpoch(date)
                              .day
                              .toString() +
                          '-' +
                          DateTime.fromMillisecondsSinceEpoch(date)
                              .month
                              .toString() +
                          '-' +
                          DateTime.fromMillisecondsSinceEpoch(date)
                              .year
                              .toString()),
                    ],
                  ),
                  //text
                  Text(
                    text,
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    numlikes.toString() + ' likes',
                    style: TextStyle(),
                  )
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                like(cmtid, 1);
              },
              icon: Icon(Icons.thumb_up, color: Color(0xff00C3FF)),
            ),
          ],
        ),
      ),
    );
  }
}
