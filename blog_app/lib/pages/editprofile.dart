import 'dart:io';
import 'package:blog_app/api/post_api.dart';
import 'package:blog_app/models/blog_user.dart';
import 'package:blog_app/notifier/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File imageFile;
  BlogUser user;
  String imagePath;
  AuthNotifier authnotifier;
  String _username, _email, _password, _name, _bio = "";

  _openGallery(BuildContext context) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    var picture = File(pickedFile.path);
    this.setState(() {
      imageFile = picture;
      imagePath = picture.path;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    var picture = File(pickedFile.path);
    this.setState(() {
      imageFile = picture;
      imagePath = picture.path;
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Remove'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authnotifier = Provider.of<AuthNotifier>(context);
    user = authnotifier.blogUser;
    print("user : ${user.toMap()}");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(245.0, 20.0, 0.0, 0.0),
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
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
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
                        onTap: () {
                          _showChoiceDialog(context);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(96.0, 95.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera_rounded,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            _showChoiceDialog(context);
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'NAME',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                    autofocus: true,
                    initialValue: user == null ? "NULL" : user.name,
                    validator: (name) {
                      Pattern pattern =
                          r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)";
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(name))
                        return 'Invalid name';
                      else
                        return null;
                    },
                    onSaved: (name) => _name = name,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'USERNAME',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                    initialValue: user == null || user.userName == null
                        ? ""
                        : user.userName,
                    validator: (name) {
                      Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(name))
                        return 'Invalid username';
                      else
                        return null;
                    },
                    onSaved: (name) => _username = name,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'BIO',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                    initialValue:
                        user == null || user.bio == null ? "" : user.bio,
                    validator: (name) {
                      return null;
                    },
                    onSaved: (bio) => _bio = bio,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        await updateUserProfile();
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
                          'SAVE',
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
                  // Text(imageFile.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateUserProfile() async {
    user.name = _name;
    user.userName = _username;
    user.bio = _bio;
    // user.picUrl = imagePath == null ? user.picUrl : imagePath ;
    bool result;
    if (imagePath == null)
      result = await uploadProfile(user);
    else {
      user.picUrl = imageFile.path;
      result = await uploadProfileWithImage(user, imagePath);
    }
    if (result) {
      Navigator.pop(context);
    }
  }
}
