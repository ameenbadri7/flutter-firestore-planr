import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'home_screen.dart';

enum FormMode { LOGIN, SIGNUP }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => new _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService auth = AuthService();
  final Database db = Database();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _displayNameEditingController = TextEditingController();
  FormMode _formMode = FormMode.LOGIN;

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _displayNameEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return StreamProvider<List<Task>>.value(
              value: db.getAllTasksDueToday(user),
              child: HomeScreen(),
            );
          }));
        }
      },
    );
  }

  void toggleFormMode() {
    setState(() {
      _formMode =
          _formMode == FormMode.SIGNUP ? FormMode.LOGIN : FormMode.SIGNUP;
    });
  }

  void login() async {
    var user = await auth.signIn(
        _emailEditingController.text, _passwordEditingController.text);

    if (user != null)
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
  }

  void signUp() async {
    var user = await auth.signUp(
        _emailEditingController.text, _passwordEditingController.text);

    if (user != null) {
      await db.createUser(user.uid,
          email: _emailEditingController.text,
          displayName: _displayNameEditingController.text);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF1F2B5),
            Color(0xFF135058),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: Container(),
                ),
                SizedBox(height: 48.0),
                Visibility(
                  visible: _formMode == FormMode.SIGNUP,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: _displayNameEditingController,
                    decoration: InputDecoration(
                      hintText: 'Display Name',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: _emailEditingController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  autofocus: false,
                  controller: _passwordEditingController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(),
                    onPressed: _formMode == FormMode.LOGIN ? login : signUp,
                    padding: EdgeInsets.all(12),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      _formMode == FormMode.LOGIN ? 'Log In' : 'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FlatButton(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey[300]),
                      children: <TextSpan>[
                        TextSpan(
                            text: _formMode == FormMode.LOGIN
                                ? 'New user?'
                                : 'Already have an account?'),
                        TextSpan(
                          text: _formMode == FormMode.LOGIN
                              ? ' Sign Up'
                              : ' Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: toggleFormMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
