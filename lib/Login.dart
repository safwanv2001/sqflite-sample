import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txt1controller = TextEditingController();
  TextEditingController txt2controller = TextEditingController();
  bool a = true;
  String? path;
  Database? database;
  inits()async{
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'sqflite.db');
    database = await openDatabase(path!, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)');
        });
  }

  signIn() async {
    List<Map<String, Object?>>? users = await database?.rawQuery(
        "SELECT id FROM Users WHERE username='${txt1controller
            .text}' AND password='${txt2controller.text}'");
    print(users);
    if(users!.isNotEmpty){
      print('success');
    }
    else{print('error');}
  }
  signUp()async{
   int? result=await database?.rawInsert("INSERT INTO Users(username, password) VALUES('${txt1controller.text}','${txt2controller.text}')");
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$result');
    txt1controller.clear();
    txt2controller.clear();
  }
  @override
  void initState() {
   inits();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 191, 255, 100),
      body: SingleChildScrollView(
        child: Center(
            child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.cyan])),
            ),
            Positioned(
                top: 120,
                left: a==true?140:125,
                child: Text(
                  a == true ? 'Login' : 'Sign UP',
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                )),
            Positioned(
                height: 700,
                bottom: 0,
                left: 0,
                child: Lottie.asset('assets/lottie/lottie1.json')),
            Positioned(
                top: 200,
                left: 50,
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 90, 8, 0),
                        child: TextField(
                          controller: txt1controller,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(0, 204, 255, 100),
                                      style: BorderStyle.solid,
                                      width: 2)),
                              labelText: 'username',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 40),
                        child: TextField(
                          controller: txt2controller,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: Color.fromRGBO(0, 204, 255, 100))),
                              labelText: 'password',
                              labelStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: a==true?signIn:signUp,
                        child: Container(
                            width: 190,
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(0, 79, 152, 90),
                                  Color.fromRGBO(75, 156, 211, 90)
                                ])),
                            child: Center(
                              child: Text(
                                a == true ? 'Login' : 'SignUp',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )),
            Positioned(
                bottom: 20,
                left: 180,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        if(a==true){a=false;}
                        else{a=true;}
                      });
                    },
                    child: Text(a == true ? 'SignUp?' : 'Login?',style: const TextStyle(color: Colors.white),)))
          ],
        )),
      ),
    );
  }
}
