import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:five_guy_explo/data/avatarurlList.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final settringformkey = GlobalKey<FormState>();
  final nameinpsetting = TextEditingController();
  String user_name = "Peter";
  int avatarOrder = 0;
  @override
  void initState() {
    // TODO: implement initState
    get_username();
    get_avatar_order();
    super.initState();
  }

  get_avatar_order() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    avatarOrder = pref.getInt('avatar order') == null
        ? 0
        : pref.getInt('avatar order')!.toInt();
  }

  set_avatar_order() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('avatar order', avatarOrder);
  }

  get_username() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('user name') == null)
      user_name = "Peter";
    else
      user_name = pref.getString('user name').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: CircleAvatar(
                  minRadius: 100,
                  backgroundImage: NetworkImage(avatarURL[avatarOrder]),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  user_name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Form(
                              key: settringformkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(avatarURL.length,
                                        (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(index);
                                          setState(() {
                                            avatarOrder = index;
                                            set_avatar_order();
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(avatarURL[index]),
                                        ),
                                      );
                                    }),
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
                                        "Submit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (nameinpsetting.text != "") {
                                          savename(nameinpsetting.text);
                                          nameinpsetting.clear();
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Card(
                color: const Color(0xff00C3FF),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Change avatar.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Form(
                              key: settringformkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                          hintText: "Enter Your name"),
                                      controller: nameinpsetting,
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
                                        "Submit or Back",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (nameinpsetting.text != "") {
                                          savename(nameinpsetting.text);
                                          nameinpsetting.clear();
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Card(
                elevation: 2,
                color: Color(0xff00C3FF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Change name.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  savename(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user name', name);
    setState(() {
      user_name = name;
    });
  }
}
