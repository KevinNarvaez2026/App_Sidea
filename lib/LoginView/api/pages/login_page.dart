import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/download_callbacks.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../../../NavBar.dart';
import '../../../RFCDescargas/services/Variables.dart';
import '../ProgressHUD.dart';
import '../api/api_service.dart';
import '../model/login_model.dart';

class LoginPageHD extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageHD> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 20),
                          blurRadius: 90)
                    ],
                  ),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 190,
                          width: MediaQuery.of(context).size.width * 0.43,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            image: DecorationImage(
                              image: AssetImage('assets/splash.png'),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(26)),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => loginRequestModel.email = input,
                          validator: (input) =>
                              input == '' ? "Ingresa un usuario" : null,
                          decoration: new InputDecoration(
                            hintText: "Usuario",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) =>
                              loginRequestModel.password = input,
                          validator: (input) =>
                              input.length < 3 ? "Contraseña no valida" : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Contraseña",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),

                            // suffixIcon: IconButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       hidePassword = !hidePassword;
                            //     });
                            //   },
                            //   color: Theme.of(context)
                            //       .accentColor
                            //       .withOpacity(0.9),
                            //   icon: Icon(hidePassword
                            //       ? Icons.visibility_off
                            //       : Icons.visibility),
                            // ),
                          ),
                        ),
                        SizedBox(height: 39),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 22, horizontal: 50),
                          onPressed: () {
                            if (validateAndSave()) {
                           

                              setState(() {
                            
                                 isApiCallProcess = true;
                              });

                              APIService apiService = new APIService();
                              apiService.login(loginRequestModel).then((value) {
                                if (value != null) {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NavBar()));
                                    isApiCallProcess = false;
                                  });

                                  if (value.token.isNotEmpty) {
                                    final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Bienvenido " +
                                            getIt<AuthModel>().usuario));

                                    // SnackBar(
                                    //   elevation: 0,
                                    //   behavior: SnackBarBehavior.floating,
                                    //   backgroundColor: Colors.transparent,
                                    //   content: AwesomeSnackbarContent(
                                    //     title: 'Bienvenido! ',
                                    //     message: 'Descarga tus Actas y RFC!',
                                    //     contentType: ContentType.success,
                                    //   ),
                                    // );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    // scaffoldKey.currentState
                                    //.showSnackBar(snackBar);
                                  }
                                }
                              });
                            }
                          },
                          child: Text(
                            "Iniciar sesion",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
