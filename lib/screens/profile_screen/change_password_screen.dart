import 'package:dd_app/screens/home_screen/home_page.dart';
import "package:flutter/material.dart";
import 'package:dd_app/api/user_info_api.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dd_app/api/user_details_update_api.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:dd_app/globals.dart' as global;
// ignore: implementation_imports
import 'package:flutter/src/painting/binding.dart';

SharedPreferences localStorage;

class ChangePasswordScreen extends StatefulWidget {
  static const String id = "change_password";

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  Future<dynamic> apiData;
  UserInfoAPI userInfoAPI = new UserInfoAPI();
  UpdateDetailsRequest requestModel;

  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  bool _isApiCallProcess = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  //http client
  Dio dio = new Dio();

  @override
  void initState() {
    apiData = userInfoAPI.getUData(context);
    requestModel = UpdateDetailsRequest();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Image pic and upload
  File _image;
  final picker = ImagePicker();
  bool isImageLoading = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        global.isNewImageUploaded = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage(File imageFile) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      dio.options.headers = {
        'Authorization': "Bearer ${localStorage.get('Authorization')}",
        'Customer-ID': "${localStorage.get('Customer-ID')}",
      };

      FormData formData = FormData.fromMap(
          {"profileImage": await MultipartFile.fromFile(imageFile.path)});

      final response =
          await dio.post(baseUrl + userDetailsUpdateExt, data: formData);
      print("upload image response data ${response.data}");
      print(
          "status of the resutl: ${json.decode(response.toString())['status']} <--");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } on DioError catch (e) {
      return Exception(e);
    }
  }

  imageGetAndUpload(ImageSource source) {
    getImage(source).then((value) {
      setState(() {
        isImageLoading = true;
      });
      uploadImage(_image).then((value) {
        setState(() {
          isImageLoading = false;
        });
        if (value['status'].toString() == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarMessage(
              "Image Upload Successfully",
              true,
            ),
          );
          setState(() {
            imageCache.clear();
            imageCache.clearLiveImages();
          });
        }
      }).whenComplete(() => {
            setState(() {
              isImageLoading = false;
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Profile Update"),
      ),
      body: Container(
        width: _width,
        height: _height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: FutureBuilder<dynamic>(
              future: userInfoAPI.getUData(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Form(
                    key: _globalFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        TextFieldContainer(
                          textField: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            textAlign: TextAlign.center,
                            decoration: kLoginInputDecoration.copyWith(
                              hintText: "New Password",
                            ),
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            maxLength: 50,
                            validator: (input) => input.length < 6 ||
                                    input.isEmpty
                                ? "Password should be at least 6 character long"
                                : null,
                          ),
                        ),
                        TextFieldContainer(
                          textField: TextFormField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            textAlign: TextAlign.center,
                            decoration: kLoginInputDecoration.copyWith(
                              hintText: "Confirm Password",
                            ),
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            maxLength: 50,
                            validator: (input) => input !=
                                    confirmPasswordController.text
                                ? "Password should be at least 6 character long"
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        ActionButton(
                            buttonColor: kPrimaryColor,
                            buttonText: "Update",
                            onTap: () {
                              setState(() {
                                _isApiCallProcess = true;
                              });

                              // requestModel.name =
                              //     fullNameController.text.toString();
                              // requestModel.email =
                              //     emailController.text.toString();
                              requestModel.password =
                                  confirmPasswordController.text.toString();

                              UserDetailsUpdate userDetailsUpdate =
                                  UserDetailsUpdate();
                              userDetailsUpdate
                                  .login(requestModel)
                                  .then((value) {
                                setState(() {
                                  _isApiCallProcess = false;
                                });

                                if (value.status.toString() == "true") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarMessage(
                                      "Profile Update Success!",
                                      true,
                                    ),
                                  );

                                  Navigator.pushNamed(context, HomePage.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarMessage(
                                      value.message.toString(),
                                      false,
                                    ),
                                  );
                                }
                              });
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
