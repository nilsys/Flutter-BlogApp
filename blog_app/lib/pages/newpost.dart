import 'dart:io';
import 'package:blog_app/api/post_api.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  File imageFile;
  String _title, _content = '';
  bool _active = true;
  AuthNotifier authNotifier;
  _openGallery(BuildContext context) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var picture = File(pickedFile.path);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    var picture = File(pickedFile.path);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Make a Choice!',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'New Post',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(212.0, 20.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'TITLE',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                      validator: (title) {
                        if (title.isEmpty)
                          return 'Title cant be empty';
                        else
                          return null;
                      },
                      onSaved: (title) => _title = title,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'CONTENT',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                      validator: (content) {
                        if (content.isEmpty)
                          return 'Content cant be empty';
                        else
                          return null;
                      },
                      onSaved: (content) => _content = content,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: Container(
                        width: 160.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'Select Image',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    InkWell(
                      onTap: () async {
                        if (!_active) {
                          showSnackBar("Post Uploaded!!");
                          return;
                        }
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          bool result = await uploadPost(
                              _title, _content, imageFile, authNotifier.blogUser);
                          if (result) {
                            showSnackBar("Post Uploaded!!");
                            setState(() {
                              _active = false;
                            });
                          } else {
                            showSnackBar("An Error Occured!!");
                            setState(() {
                              _active = true;
                              ;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: 120.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            'UPLOAD',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                    imageFile == null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              imageFile,
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String snackBarText) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        snackBarText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      backgroundColor: Colors.lightBlue,
    ));
  }
}
