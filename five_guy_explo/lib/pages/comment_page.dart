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
    user_avatar_url = pref.getString('avatar url') == null
        ? 'https://tipsmake.com/data/thumbs/how-to-hide-facebook-profile-picture-thumb-EhRnrBzAY.jpg'
        : pref.getString('avatar url').toString();
  }

  get_comments() async {}

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    print(widget.post_id);
    get_comments();
    get_avatar_url();
    get_user_name();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xff00C3FF)),
          backgroundColor: Colors.white,
          title: Text(
            widget.post_id,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  print(saved_id);
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
        body: ListView(children: [
          makeCommentCard(
              'https://mpics.mgronline.com/pics/Images/564000005840801.JPEG',
              'Peter',
              '20-2-64',
              'Very good',
              109),
          makeCommentCard(
              'https://media.vanityfair.com/photos/5f5245d91e10df7a77868af6/master/pass/avatar-the-last-airbender.jpg',
              'Jhon',
              '21-2-64',
              'Not bad',
              50),
          Padding(
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "enter",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {},
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
          ),
        ]));
  }

  Padding makeCommentCard(
      String avartar_url, String name, String date, String text, int numlikes) {
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
                      Text(date),
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
          ],
        ),
      ),
    );
  }
}
