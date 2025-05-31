import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Signin extends StatefulWidget {
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // delarasi controller input, dan feature signin
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final dio = Dio();
  final storage = FlutterSecureStorage();
  String _errorMessage = '';


  // fungsi untuk submit data login
  Future<void> _submitLogin() async {
    try {
      final reesponse = await dio.post('http://192.168.158.32:8000/api/signin', 
        data: {
          'username' : usernameController.text,
          'password' : passwordController.text
        },
        options: Options(
          headers: {
            'Accept': 'application/json'        
          }
        )
      );

      // cek apakah login berhasil
      if (reesponse.statusCode == 200) {

         //Tampung Data
         final token = reesponse.data['data']['token'];
         final user_id = reesponse.data['data']['user']['id'];
         final name = reesponse.data['data']['user']['name'];


         await storage.write(key: 'token', value: token);
         await storage.write(key: 'user_id', value: user_id.toString());
         await storage.write(key: 'name', value: name); 

         Navigator.pushReplacementNamed(context, '/main');
      }

    } on DioException catch (e) {
          // cek apakah data ada yang error atau tidak
          if (e.response?.statusCode == 422) {
            final errorData = e.response?.data;
            setState(() {
              _errorMessage = errorData['message'];
            });
          }
          else{
            setState(() {
              _errorMessage = "Terjadi kesalahan";
            });
          }
    } 
    catch (e) {
        setState(() {
          _errorMessage = "Terjadi di sisi server";
        });
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
        padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sign In", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),),
              Text("Silahkan lakukan sign in untuk mengakses fitur lainnya", style: TextStyle(fontSize: 12, color: Color(0xff3E3C3C)),),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                decoration: BoxDecoration(
                 color: Color(0xffE4EFE7),// warna background
                  borderRadius: BorderRadius.circular(16), // sudut membulat 16 pixel
                ),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Username"),
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff99BC85), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              )
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Password"),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff99BC85), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              )
                            )
                          ],
                        ),
                      ),

                      if (_errorMessage.isNotEmpty)
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Text(_errorMessage, style: TextStyle(color: Colors.red),),

                      Padding(padding: EdgeInsets.only(top: 15)),
                      ElevatedButton(
                        onPressed: () {
                          _submitLogin();
                          // Navigator.pushReplacementNamed(context, '/main');
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff99BC85),
                        ),
                        child: Text("Sign In", style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}