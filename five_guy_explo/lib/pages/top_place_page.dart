import 'package:five_guy_explo/theme/themecolor.dart';
import 'package:five_guy_explo/data/explore_json.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: makeBody(),
    );
  }

  Widget makeBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getTopThreePlace());
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

    return TopThreeList;
  }
}
