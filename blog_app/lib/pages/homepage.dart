import 'package:blog_app/api/post_api.dart';
import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:blog_app/widgets/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/postdetails.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/util/constants.dart' as constants;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  BlogUser user;
  AuthNotifier authNotifier;
  List<Post> posts = [
    Post(
        id: '1',
        name: 'Anaikin Skywalker',
        username: 'thechosenone',
        date: 'April 22, 2019',
        title: 'Star Wars',
        content: 'May the force be with you',
        image: 'assets/anaikin.jpg',
        likes: 32,
        liked: true),
    Post(
        id: '2',
        name: 'Bruce Wayne',
        username: 'therichguy',
        date: 'January 12, 2020',
        title: 'The Dark Knight',
        content: 'I am Batman',
        image: 'assets/batman.jpg',
        likes: 20,
        liked: false),
    Post(
        id: '3',
        name: 'Vito Corleone',
        username: 'doncorleone',
        date: 'December 26, 1974',
        title: 'The Godfather',
        content: 'I am gonna make you an offer you cant refuse',
        image: 'assets/vito.jpg',
        likes: 128,
        liked: false)
  ];

  @override
  Widget build(BuildContext context) {
    authNotifier = Provider.of<AuthNotifier>(context);
    user = authNotifier.blogUser;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: (user == null || user.picUrl == null)
                          ? NetworkImage(
                              "https://swiftfs.com.au/wp-content/uploads/2017/11/blank.jpg")
                          : NetworkImage(user.picUrl),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(70.0, 15.0, 0.0, 0.0),
                child: Text(
                  user.name,
                  style: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(70.0, 30.0, 0.0, 0.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profilepage');
                    },
                    child: Text(
                      '@' + '${user.userName}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(constants.posts)
                    .orderBy(constants.timestamp, descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("An Error Occured!!"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return Center(child: Text("No Blogs Uploaded!!"));
                  }

                  return ListView.builder(
                      itemBuilder: (_, int index) {
                        // return Text(snapshot.data.documents[index]["message"]);
                        return BlogWidget(
                          post: Post.fromMap(
                              snapshot.data.documents[index].data(),
                              ),
                            uId: user.uid,
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                      reverse: false,
                      padding: EdgeInsets.all(6.0));
                },
              ),
              // BlogWidget()
            ],
          ),
        ],
      ),
    );
  }
}
