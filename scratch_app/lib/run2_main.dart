import 'package:flutter/material.dart';
import 'package:scratch_app/run2_welcome_screen.dart';

void main(List<String> args) {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen(),);
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void handleLogin() {
    String username = usernameController.text;
    String password = passwordController.text;

    if(username.isNotEmpty && password.isNotEmpty) {
      if(username != "admin" || password != "admin"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong Username or Password!")));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen(username: username)));

      }
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Enter Username & Password!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
        
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: handleLogin, child: Text("Login")),
          ],
        ),
      )
    );
  }
}