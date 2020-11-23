import 'package:blog_app/api/post_api.dart';
import 'package:blog_app/models/postdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogWidget extends StatefulWidget {
  final Post post;
  final String uId;
  BlogWidget({this.post, this.uId});

  @override
  _BlogWidgetState createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  @override
  void initState() {
    super.initState();
    getLike();
  }

  Future<void> getLike() async {
    bool likes = await get_like(widget.post.id);
    if (likes) {
      setState(() {
        widget.post.liked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("post : ${widget.post.toMap()}");
    // return Text("hello");

    return Container(
        padding: EdgeInsets.only(top: 70.0),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Center(
            child: Container(
                //height: 200,
                width: 380,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                              child: Text(
                                widget.post.name,
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            Container(
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    '@' + widget.post.username,
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Flexible(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.fromLTRB(20, 5.0, 2.0, 0.0),
                            child: Text(
                              widget.post.date,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
                      child: Divider(
                        color: Colors.grey,
                        height: 30,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 0.0),
                      child: Text(
                        widget.post.title,
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
                        padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 10.0),
                        child: Image.network(
                          widget.post.image,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(2.0, 260.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              widget.post.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  widget.post.liked ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              if (!widget.post.liked) {
                                setState(() {
                                  widget.post.liked = true;
                                  widget.post.likes += 1;
                                });
                              print("liked : ${widget.post.liked}\n");

                                await likePost(widget.post.id, widget.uId);
                                // await likePost(posts[index].id, "id");
                              } else {
                                setState(() {
                                  widget.post.liked = false;
                                  widget.post.likes -= 1;
                                });

                                await unLikePost(widget.post.id, widget.uId);
                              }
                            },
                          ),
                          Text(
                            widget.post.likes.toString(),
                            style: TextStyle(
                                color: widget.post.liked
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 300.0, 10.0, 10.0),
                      child: Text(
                        widget.post.content,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
