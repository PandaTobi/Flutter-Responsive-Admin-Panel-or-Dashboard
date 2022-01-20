import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BrowsingPage extends StatefulWidget {
  BrowsingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BrowsingPage createState() => _BrowsingPage();
}

class _BrowsingPage extends State<BrowsingPage> {
  TextEditingController _textController = TextEditingController();

  final dbRef = FirebaseDatabase.instance.reference().child("New York City, New York");
  List<Map<dynamic, dynamic>> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New York Reports Browsing Page"),
        ),
        body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Search Here...',
                  ),
                ),
              ),
              Flexible(child: FutureBuilder(
                  future: dbRef.once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      lists.clear();
                      Map<dynamic, dynamic> values = snapshot.data.value;
                      values.forEach((key, values) {
                        lists.add(values);
                      });
                      return new ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16.0),
                          itemCount: lists.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(_textController.text);
                            String sb = "";
                            print(lists[index]["body"]);
                            for (int i = 0; i < lists[index]["body"].length; i++) {
                              if (i > 0 && (i % 24 == 0)) {
                                sb+="\n";
                              }

                              sb+=lists[index]["body"][i];
                            }

                            lists[index]["body"] = sb.toString();

                            if (_textController.text.isEmpty ||
                                lists[index]["badgeid"].toString().toLowerCase().contains(_textController.text) ||
                                lists[index]["name"].toString().toLowerCase().contains(_textController.text)){
                              return Card(
                                child: InkWell(
                                  child: Container(
                                    width: 300,
                                    // height: 110,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text(
                                              lists[index]["name"],
                                            ),
                                            subtitle: Flexible(
                                                child: Text("𝗕𝗮𝗱𝗴𝗲 𝗜𝗗: " +
                                                    lists[index]["badgeid"] + "\n" +
                                                    "𝗚𝗲𝗻𝗱𝗲𝗿: " + lists[index]["gender"] + "\n" +
                                                    "𝗥𝗮𝘁𝗶𝗻𝗴: " + lists[index]["rating"] + "/5.0" + "\n" +
                                                    "𝗧𝗶𝗺𝗲, 𝗗𝗮𝘁𝗲: " + lists[index]["time"] + "\n" +
                                                    "𝗖𝗼𝗺𝗺𝗲𝗻𝘁𝘀: \n" + lists[index]["body"],

                                                  overflow: TextOverflow.ellipsis,
                                                )
                                            )
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    }
                    return CircularProgressIndicator();
                  }), )]
        )
    );
  }
}