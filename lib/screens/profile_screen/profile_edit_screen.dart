import 'package:dd_app/screens/profile_screen/profile.dart';
import "package:flutter/material.dart";
import 'profile_pic.dart';
import 'profile_info_panel.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dd_app/api/user_details_update_api.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:dd_app/progressHUD.dart';

class ProfileEdit extends StatefulWidget {
  static const String id = "profile_edit";

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  Future<dynamic> apiData;
  UserInfoAPI userInfoAPI = new UserInfoAPI();
  UpdateDetailsRequest requestModel;

  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  bool _isApiCallProcess = false;

  @override
  void initState() {
    apiData = userInfoAPI.getUData();
    requestModel = UpdateDetailsRequest();
    super.initState();
  }

  //TODO image upload
  // File _image;
  // final picker = ImagePicker();
  // final basename = ImagePicker();
  //
  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile Update"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: FutureBuilder<dynamic>(
            future: userInfoAPI.getUData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                TextEditingController fullNameController =
                    TextEditingController(
                        text:
                            snapshot.data['data']['user_fullname'].toString() ??
                                "No Data");
                TextEditingController emailController = TextEditingController(
                    text: snapshot.data['data']['user_email'].toString() ??
                        "No Data");
                TextEditingController passwordController =
                    TextEditingController();
                TextEditingController resetPasswordController =
                    TextEditingController();
                return Form(
                  key: _globalFormKey,
                  child: Column(
                    children: [
                      // ProfilePic(
                      //   imageURL: snapshot.data['data']['user_profile_image']
                      //           .toString() ??
                      //       null,
                      // ),
                      SizedBox(height: 20),
                      TextFieldContainer(
                        textField: TextFormField(
                          controller: fullNameController,
                          textAlign: TextAlign.center,
                          decoration:
                              kLoginInputDecoration.copyWith(hintText: ""),
                          keyboardType: TextInputType.text,
                          validator: (input) =>
                              input.isEmpty ? "Enter valid name" : null,
                        ),
                      ),
                      TextFieldContainer(
                        textField: TextFormField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          decoration:
                              kLoginInputDecoration.copyWith(hintText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            Pattern pattern =
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value) || value.isEmpty)
                              return 'Enter a valid email address';
                            else
                              return null;
                          },
                        ),
                      ),
                      TextFieldContainer(
                        textField: TextFormField(
                          controller: passwordController,
                          textAlign: TextAlign.center,
                          decoration: kLoginInputDecoration.copyWith(
                            hintText: "New Password",
                          ),
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.visiblePassword,
                          maxLength: 50,
                          validator: (input) => input.length < 6 ||
                                  input.isEmpty
                              ? "Password should be at least 6 character long"
                              : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      ActionButton(
                          buttonColor: kPrimaryColor,
                          buttonText: "Update",
                          onTap: () {
                            if (validateAndSave()) {
                              setState(() {
                                _isApiCallProcess = true;
                              });

                              requestModel.name =
                                  fullNameController.text.toString();
                              requestModel.email =
                                  emailController.text.toString();
                              requestModel.password =
                                  passwordController.text.toString();

                              UserDetailsUpdate apiService =
                                  new UserDetailsUpdate();
                              apiService.login(requestModel).then((value) {
                                setState(() {
                                  _isApiCallProcess = false;
                                });

                                if (value.status) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarMessage(
                                      "Profile Update Success!",
                                      true,
                                    ),
                                  );

                                  Navigator.pushNamed(
                                    context,
                                    Profile.id,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarMessage(
                                      value.message.toString(),
                                      false,
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          textColor: Colors.white),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
