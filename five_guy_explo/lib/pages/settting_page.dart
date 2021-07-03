import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                  backgroundImage: NetworkImage(
                      'https://tipsmake.com/data/thumbs/how-to-hide-facebook-profile-picture-thumb-EhRnrBzAY.jpg'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Peter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 02,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Change avatar.'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Change name.'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
