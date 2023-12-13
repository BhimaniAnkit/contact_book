import 'dart:io';
import 'package:contact_book/contect_data.dart';
import 'package:contact_book/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class contect_add extends StatefulWidget {
  Contect_Data? cd;

  contect_add([this.cd]);

  @override
  State<contect_add> createState() => _contect_addState();
}

class _contect_addState extends State<contect_add> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController contect_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  var gender = "None";
  TextEditingController password_controller = TextEditingController();
  File? file;
  var image;
  var cropImage;

  @override
  void initState() {
    super.initState();
    if (widget.cd != null) {
      name_controller.text = widget.cd!.name!;
      contect_controller.text = widget.cd!.contect!;
      email_controller.text = widget.cd!.email!;
      gender = widget.cd!.gender!;
      if (widget.cd!.cropImage != "null") {
        cropImage = widget.cd!.cropImage;
        file = File(cropImage);
      }
    }
    setState(() {});
  }

  get_image() async {
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    await Future.delayed(Duration.zero);
    if (image != null) {
      cropImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
      );
    }
    if (cropImage != null) {
      setState(() {
        file = File(cropImage.path);
      });
    }
  }

  select_image() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    await Future.delayed(Duration.zero);
    if (image != null) {
      cropImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
      );
    }
    if (cropImage != null) {
      setState(() {
        file = File(cropImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return contect_list();
                            },
                          ), (route) => true);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.5),
                        splashColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                title: Text(
                                  "Choose Option",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                content: SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          get_image();
                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          elevation: 10,
                                          color: Colors.white70,
                                          shadowColor: Colors.grey,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Camera",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          select_image();
                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          elevation: 10,
                                          color: Colors.white70,
                                          shadowColor: Colors.grey,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Gallary",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            image: (file != null)
                                ? DecorationImage(
                                    image: FileImage(file!), fit: BoxFit.fill)
                                : null,
                          ),
                          child: (file == null)
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 120,
                                  color: Colors.black45,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: name_controller,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),
                            allow: true)
                      ],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: contect_controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: "Contect",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 30,
                            color: Colors.grey,
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: email_controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            size: 30,
                            color: Colors.grey,
                          )),
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          fillColor: MaterialStatePropertyAll(Colors.black),
                          value: "Male",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Male",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor: MaterialStatePropertyAll(Colors.black),
                          value: "Female",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Female",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor: MaterialStatePropertyAll(Colors.black),
                          value: "Other",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Other",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor: MaterialStatePropertyAll(Colors.black),
                          value: "None",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "None",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: password_controller,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),
                            allow: true)
                      ],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: "password",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(
                          MediaQuery.of(context).size.width * 0.95,
                          MediaQuery.of(context).size.height * 0.06)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                    ),
                    onPressed: () {
                      if (name_controller.text != "" &&
                          contect_controller != "") {
                        if (widget.cd != null) {
                          widget.cd!.name = name_controller.text;
                          widget.cd!.contect = contect_controller.text;
                          widget.cd!.email = email_controller.text;
                          widget.cd!.gender = gender;
                          widget.cd!.password = password_controller.text;

                          if (widget.cd!.cropImage != "null") {
                            if (widget.cd!.cropImage != cropImage.toString()) {
                              widget.cd!.cropImage = cropImage.path.toString();
                            } else {
                              widget.cd!.cropImage = cropImage;
                            }
                          } else {
                            String cropimage = (cropImage == null)
                                ? cropImage.toString()
                                : cropImage.path.toString();
                            widget.cd!.cropImage = cropimage;
                          }
                          widget.cd!.save();
                          setState(() {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return contect_list();
                              },
                            ), (route) => false);
                          });
                        } else {
                          String name = name_controller.text;
                          String contect = contect_controller.text;
                          String email = email_controller.text;
                          String password = password_controller.text;
                          String cropimage = (cropImage == null)
                              ? cropImage.toString()
                              : cropImage.path.toString();
                          Contect_Data cd = Contect_Data(name, contect, email,
                              gender, password, cropimage);
                          contect_list.contect.add(cd);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return contect_list();
                            },
                          ), (route) => false,);
                        }
                      }
                      else{
                        Fluttertoast.showToast(msg: "Please Fill All Required Fields");
                      }
                    },
                    child: Text("Save",style: TextStyle(fontSize: 20),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
