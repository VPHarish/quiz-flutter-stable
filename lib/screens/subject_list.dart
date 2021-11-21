import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';

class CustomListItem extends StatelessWidget {
  CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.user,
    required this.redirect,
  }) : super(key: key);

  Image thumbnail = Image(image: AssetImage("images/quiz_icon.png"));
  String title = "Title";
  String user = "Description";
  String redirect = "english";

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, devicetype) {
      return GestureDetector(
        onTap: () {
          print("yup! Works good! > " + title);
          Navigator.pushNamed(context, '/quiz_screen_casual',
              arguments: {'sub': redirect});
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: thumbnail,
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Text(
                          user,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class Context extends StatefulWidget {
  @override
  _ContextState createState() => _ContextState();
}

class _ContextState extends State<Context> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/context_background.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: Column(
              children: [
                Text(
                  "CONTENT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Audiowide'),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.88,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('content')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs.map((document) {
                          return CustomListItem(
                            thumbnail: Image(
                              height: 65,
                              image: AssetImage(
                                  "images/sub_icons/" + document['picture']),
                            ),
                            title: document['title'],
                            user: document['subtitle'],
                            redirect: document['redirect'],
                          );
                        }).toList());
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
