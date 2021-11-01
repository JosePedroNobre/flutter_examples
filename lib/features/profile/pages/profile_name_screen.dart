import 'dart:io';

import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class ProfileNameScreen extends StatefulWidget {
  final String name;
  ProfileNameScreen({this.name});
  @override
  _ProfileNameScreenState createState() => _ProfileNameScreenState();
}

class _ProfileNameScreenState extends State<ProfileNameScreen> {
  TextEditingController _firstNamecontroller;
  TextEditingController _lastNamecontroller;
  final ImagePicker _imagePicker = ImagePicker();
  CameraController _controller;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _firstNamecontroller = TextEditingController(text: widget.name);
    _lastNamecontroller = TextEditingController();
    _controller = CameraController(
      CameraDescription(),
      ResolutionPreset.medium,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(children: [
            _buildProfilePicture(),
            SizedBox(height: 35),
            _buildFirstNameInputField(),
            SizedBox(height: 30),
            _buildLastNameInputField(),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: isButtonEnabled
                  ? () {
                      _firstNamecontroller.text; // get name
                      _lastNamecontroller.text; // get last name
                    }
                  : null,
              child: Text("Save changes"),
            )
          ]),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Edit profile",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ));
  }

  _buildProfilePicture() {
    return GestureDetector(
      onTap: () => showModal(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                  width: 110,
                  height: 110,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://ca.slack-edge.com/T98QU4R61-U01DN89BEEM-b6fffa918e09-512")))),
              SvgPicture.asset("images/ic_edit.svg")
            ],
          ),
        ),
      ),
    );
  }

  _buildFirstNameInputField() {
    return SenseiTextField(
      preffixIcon: null,
      onTextChange: (value) {
        if (value.isNotEmpty && _lastNamecontroller.text.isNotEmpty) {
          setState(() {
            isButtonEnabled = true;
          });
        } else {
          setState(() {
            isButtonEnabled = false;
          });
        }
      },
      textInputType: TextInputType.name,
      label: "Name",
      errorText: null,
      textEditingController: _firstNamecontroller,
      validator: (value) {
        return null;
      },
    );
  }

  _buildLastNameInputField() {
    return SenseiTextField(
      preffixIcon: null,
      onTextChange: (value) {
        if (value.isNotEmpty && _firstNamecontroller.text.isNotEmpty) {
          setState(() {
            isButtonEnabled = true;
          });
        } else {
          setState(() {
            isButtonEnabled = false;
          });
        }
      },
      textInputType: TextInputType.name,
      label: "Last name",
      errorText: null,
      textEditingController: _lastNamecontroller,
      validator: (value) {
        return null;
      },
    );
  }

  openPhotoGallery() async {
    Navigator.pop(context);
    _imagePicker
        .getImage(source: ImageSource.gallery, imageQuality: 60)
        .asStream()
        .listen(
      (pickedImage) {
        File image = File(pickedImage.path);
        // TODO api call to update picture
        print(image);
      },
    );
  }

  openCamera() async {
    Navigator.pop(context);
    var file = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    print(file);
  }

  deletePhoto() async {
    // TODO api call to delete picture
    Navigator.pop(context);
  }

  void showModal(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              cancelButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text("Cancel",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff278ded),
                          fontSize: 20,
                        )),
                  ),
                ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Choose Photo from Library'),
                  onPressed: () {
                    openPhotoGallery();
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text('Take a photo'),
                  onPressed: () => openCamera(),
                ),
                CupertinoActionSheetAction(
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
