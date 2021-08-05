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

  Future<bool> showCameraOptionPopUp(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              backgroundColor: Colors.white,
              title: Text("Choose One",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.photo_camera,
                          size: 64,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          imageGetAndUpload(ImageSource.camera);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.camera,
                          size: 64,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          imageGetAndUpload(ImageSource.gallery);
                        }),
                  ],
                ),
              ),
            );
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, HomePage.id),
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
                  TextEditingController fullNameController =
                      TextEditingController(
                          text: snapshot.data['data']['user_fullname']
                                  .toString() ??
                              "No Data");
                  TextEditingController emailController = TextEditingController(
                      text: snapshot.data['data']['user_email'].toString() ??
                          "No Data");
                  TextEditingController passwordController =
                      TextEditingController();
                  return Form(
                    key: _globalFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(baseUrl +
                                        "/" +
                                        snapshot.data['data']
                                                ['user_profile_image']
                                            .toString()) ??
                                    "",
                              ),
                              Positioned(
                                bottom: 0,
                                right: -12,
                                child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  child: TextButton(
                                    onPressed: () {
                                      showCameraOptionPopUp(context);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          side: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: isImageLoading == false
                                        ? SvgPicture.asset(
                                            "assets/icons/camera.svg")
                                        : CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            decoration: kLoginInputDecoration.copyWith(
                                hintText: "Email"),
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
                            keyboardType: TextInputType.text,
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
                              setState(() {
                                _isApiCallProcess = true;
                              });

                              requestModel.name =
                                  fullNameController.text.toString();
                              requestModel.email =
                                  emailController.text.toString();
                              requestModel.password =
                                  passwordController.text.toString();

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
