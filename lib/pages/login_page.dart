import 'package:flutter/material.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'card_store.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();

    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if (model.isLoading)
              return Center(child: CircularProgressIndicator(),);

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(50.0, 120.0, 50.0, 50.0),
                      child: Container(
                        width: 240.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage("images/new_ituran_logo.png"),
                                alignment: Alignment.center)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Usuário",
                          labelStyle: TextStyle(
                              color: Colors.grey, fontSize: 16.0),
                          border: OutlineInputBorder(),
                          hoverColor: Colors.grey,
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        controller: _userController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Informe o usuário";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Senha",
                            labelStyle: TextStyle(
                                color: Colors.grey, fontSize: 16.0),
                            border: OutlineInputBorder(),
                            hoverColor: Colors.grey,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            )),
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Informe a senha";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Container(
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              model.signIn(user: _userController.text, pass: _passwordController.text , onSuccess: _onSuccess, onFail: _onFail);
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }

  void _onSuccess() async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CardStore()));

    /*Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => CardStore()));*/
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
