import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdi_marcelo/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  Map<String, dynamic> responseData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signIn(
      {String user,
      String pass,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    print(user);

    isLoading = true;
    notifyListeners();
/*
 // qdo o core falha
    onSuccess();

    isLoading = false;
    notifyListeners();*/
    var aresponse = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=WL96NWxidu5gJSjA5ZeCREXelsCFyJ0m&limit=19&rating=g");
    print(json.decode(aresponse.body));

    var response = await http.post(
      "https://apps.homolog.ituran.sp/tecnica/Autenticacao/token",
            //"http://api.homolog.ituran.sp/core/v1/Autenticacao/FazerAutenticacao",
            //"http://192.168.56.101:80/login2",
        //"http://apigateway.com:80/login2",
        //"https://apps.homolog.ituran.com.br/tecnica/Autenticacao/token",
      //"https://app-lojas-api.herokuapp.com/token/",

        headers: <String, String>{
          'Content-Type': 'application/json-patch+json',
        },
        body: jsonEncode(<String, String>{
          "username": user,
          "password": pass,
        }));

    print(response.statusCode);

    if (response.statusCode == HttpStatus.ok) {
      /*print(response.body);
      String _token = response.body;
      responseData = Map();
      responseData = json.decode(_token);*/

      String token = response.body
          .replaceAll("\\r\\n", "")
          .replaceAll("\\\"", "")
          .replaceAll("{", "")
          .replaceAll("}", "");

      var dataSp = token.split(',');
      responseData = Map();

      dataSp.forEach((element) => responseData[element
          .split(':')[0]
          .replaceAll("\"", "")
          .trimLeft()
          .trimRight()] = element.split(':')[1].replaceAll("\"", "").trim());

      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(responseData["access_token"]);
      print(decodedToken);

      await _loadCurrentUser();
      userData = {
        "userId": decodedToken["userId"],
        "userName": decodedToken["userName"],
        "accessToken": responseData["access_token"]
      };

      onSuccess();

      isLoading = false;
      notifyListeners();
    }
    else {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  bool isLoggedIn() {
    return this.userData.isNotEmpty && this.userData["user"] != "";
  }

  void signOut() async {
    userData = Map();
    responseData = Map();

    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if (userData.isEmpty && this.responseData.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(this.responseData["access_token"]);

      userData = {
        "userId": decodedToken["userId"],
        "userName": decodedToken["userName"],
        "accessToken": this.responseData["access_token"]
      };
    }
    if(userData.isNotEmpty){
      if(userData["userName"] == null && this.responseData.isNotEmpty){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(this.responseData["access_token"]);
        userData = {
          "userId": decodedToken["userId"],
          "userName": decodedToken["userName"],
          "accessToken": this.responseData["access_token"]
        };
        //userData = decodedToken["userName"];
      }
    }
    notifyListeners();
  }
}
