import 'package:blog_app/api/post_api.dart';
import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/models/postdetails.dart';
import 'package:blog_app/pages/editprofile.dart';
import 'package:provider/provider.dart';
import 'package:blog_app/util/constants.dart' as constants;

class UserProfile extends StatefulWidget {
  String id, name, userName;
  UserProfile({this.id, this.name, this.userName});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool delete = true;
  final ScrollController _scrollController = ScrollController();
  List<Post> posts = List<Post>();
  BlogUser bUser;
  @override
  void initState() {
    super.initState();
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getList();
    });
  }

  Future<void> getUser() async {
    var doc =
        FirebaseFirestore.instance.collection(constants.users).doc(widget.id);
    var snap = await doc.get();
    setState(() {
      bUser = BlogUser.fromMap(snap.data());
    });
  }

  Future<void> getList() async {
    var col = FirebaseFirestore.instance
        .collection(constants.posts)
        .where(constants.uid, isEqualTo: widget.id);
    var snaps = await col.get();
    var list = snaps.docs.toList();
    List<Post> tempList = List();
    for (var item in list) {
      tempList.add(Post.fromMap(item.data()));
    }
    setState(() {
      posts.clear();
      posts.addAll(tempList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                        image: (bUser == null || bUser.picUrl == null)
                            ? NetworkImage(
                                "https://swiftfs.com.au/wp-content/uploads/2017/11/blank.jpg")
                            : NetworkImage(bUser.picUrl),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(70.0, 15.0, 0.0, 0.0),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(70.0, 30.0, 0.0, 0.0),
                  child: Text(
                    '@' + widget.userName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(350.0, 8.0, 0.0, 0.0),
                  child: IconButton(
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.edit_outlined,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/editprofile');
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 60.0, 0.0, 0.0),
              child: Text(
                bUser != null ? bUser.bio :"" ,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 110.0, 10.0, 0.0),
              child: Divider(
                color: Colors.black,
                height: 5.0,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 120.0, 0.0, 0.0),
              child: Text(
                'Your Blogs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 30.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 170.0),
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Container(
                            //height: 200,
                            width: 380,
                            color: Colors.white,
                            child: Stack(
                              children: <Widget>[
                                
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 45.0, 0.0, 0.0),
                                          child: Text(
                                            posts[index].name,
                                            style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                5.0, 45.0, 0.0, 0.0),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Text(
                                                '@' + posts[index].username,
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 45.0, 10.0, 0.0),
                                      child: Text(
                                        posts[index].date,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.0, 48.0, 10.0, 0.0),
                                  child: Divider(
                                    color: Colors.grey,
                                    height: 30,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      10.0, 65.0, 10.0, 0.0),
                                  child: Text(
                                    posts[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 100.0, 0.0, 10.0),
                                    child: Image.network(
                                      posts[index].image,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(2.0, 300.0, 0.0, 0.0),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          posts[index].liked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: posts[index].liked
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (!posts[index].liked) {
                                              posts[index].liked = true;
                                              posts[index].likes++;
                                            } else {
                                              posts[index].liked = false;
                                              posts[index].likes--;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        posts[index].likes.toString(),
                                        style: TextStyle(
                                            color: posts[index].liked
                                                ? Colors.red
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 340.0, 10.0, 10.0),
                                  child: Text(
                                    posts[index].content,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void deletePost(String id, int index) async {
    await deletePostById(id);

    setState(() {
      posts.removeAt(index);
    });
  }
}
