import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


    final storage = FlutterSecureStorage();
    final dio = Dio();

    String name = '';
    String token = '';

    void initState() {
      super.initState();
      getDataUser();
    }

    //ambil nama user dan token login

    Future<void> getDataUser() async {
        final name_user = await storage.read(key: 'name');
        final token_login = await storage.read(key: 'token');
        setState(() {
          name = name_user ?? '';
          token = token_login ?? '';
        });
    }

    //logout

    Future<void> signout() async {
      await dio.get('http://192.168.158.32:8000/api/signout',
      options: Options(
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
      ));

      await storage.delete(key: 'token');
      await storage.delete(key: 'user_id');
      await storage.delete(key: 'name');

      Navigator.pushReplacementNamed(context, '/signin');

    }



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff99BC85),
        title: Text("PROFILE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),
                    ),
                    Text(
                      "Informasi akun anda",
                      style: TextStyle(fontSize: 12, color: Color(0xff3E3C3C)),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 60)),
                Center(
                  child: Column(
                    children: [
                      Image.network(
                        "https://i.pinimg.com/736x/15/0f/a8/150fa8800b0a0d5633abc1d1c4db3d87.jpg",
                        width: 100,
                        height: 100,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffE4EFE7),
                            ),
                            child: Text("Admin", style: TextStyle(fontSize: 12, color: Color(0xff99BC85)),),
                          )
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 50)),
                      ElevatedButton(
                        onPressed: (){
                           signout();
                        }, 
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xff99BC85)),
                        child: Text("Sign Out", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

    );
  }
}