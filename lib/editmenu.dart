import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';


class Editmenu extends StatefulWidget {
  const Editmenu({super.key});

  @override
  State<Editmenu> createState() => _NewmenuState();
}

class _NewmenuState extends State<Editmenu> {
    final storage = FlutterSecureStorage();
    final dio = Dio();
    final imagePicker = ImagePicker();

    File? selectedImage;
    String user_id = '';
    String token = '';

    String error_name = '';
    String error_price = '';
    String error_description = '';
    String error_image = '';

    String error = '';

    void initState() {
      super.initState();
      getDataUser();
    }

    //ambil nama user dan token login

    Future<void> getDataUser() async {
        final user_id_storage = await storage.read(key: 'user_id');
        final token_login = await storage.read(key: 'token');
        setState(() {
          user_id = user_id_storage ?? '';
          token = token_login ?? '';
        });
    }

    TextEditingController name = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController description = TextEditingController();


    
    Future<void> pickImage() async {
      final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
      }

    }

  
    Future<void> tambahData() async {
      
      setState(() {
        error_name = '';
        error_price = '';
        error_description = '';
        error_image = '';
      });

 
      try {

        final FormData formData = FormData.fromMap({
            'image': selectedImage != null ? await MultipartFile.fromFile(selectedImage!.path) : "",
            'name' : name.text,
            'price' : price.text,
            'description' : description.text,
            'user_id' : user_id
        });

        final response = await dio.post('http://192.168.158.32:8000/api/menu/update/$menu_id',
          data: formData,
          options: Options(
            headers: {
              'Accept' : 'application/json',
              'Authorization' : 'Bearer $token'
            }
          )
        );

       if (response.statusCode == 200) {
        // Navigator.pushReplacementNamed(context, '/main');
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
       }

      }on DioException catch (e) {
          if(e.response?.statusCode == 422) {
            List fields = ['name','price','description','image'];

            for (var i = 0; i < fields.length; i++) {
              var field = fields[i];

            if (e.response?.data['errors'][field] != null) {
              setState(() {
                  if (field == "name") {
                     error_name = e.response?.data['errors'][field][0];
                  }
                  if (field == "price") {
                    error_price = e.response?.data['errors'][field][0];
                  }
                  if (field == "description") {
                    error_description = e.response?.data['errors'][field][0];
                  }
                  if (field == "image") {
                    error_image = e.response?.data['errors'][field][0];
                  }
              });
            }
          }
        }
      } 
      
      catch (e) {
        setState(() {
          error = "Terjadi Kesalahan Di Sisi Server";
        });
      }

    }

    late int menu_id;
    late String menu_name = '';
    late String menu_price = '';
    late String menu_desc = '';


    void didChangeDependencies() {
      super.didChangeDependencies();

      final args = ModalRoute.of(context)!.settings.arguments as Map;
       menu_id = args['menu_id'];
       menu_name = args['menu_name'];
       menu_price = args['menu_price'];
       menu_desc = args['menu_desc'];

       name.text = menu_name;
       price.text = menu_price;
       description.text = menu_desc;

    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff99BC85),
        title: Text("EDIT MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Edit Menu", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),),
                  Text("Silahkan masukan data menu di bawah ini", style: TextStyle(fontSize: 12, color: Color(0xff3E3C3C)),),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffE4EFE7),
                borderRadius: BorderRadius.circular(16), 
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
                          GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: selectedImage != null ? Image.file(selectedImage!, fit: BoxFit.cover,) : 
                                Center(child: Text("Silahkan Masukan File"),),
                            ),
                          ),
                          if(error_image.isNotEmpty)
                          Text(error_image, style: TextStyle(color: Colors.red),),
                          SizedBox(height: 10,),
                          Text("Nama menu"),
                          TextField(
                            controller: name,
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
                          ),
                           if (error_name.isNotEmpty) 
                           Text(error_name, style: TextStyle(color: Colors.red),)
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deskirpsi"),
                          TextField(
                            controller: description,
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
                          ),
                           if (error_description.isNotEmpty) 
                           Text(error_description, style: TextStyle(color: Colors.red),)
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Harga"),
                          TextField(
                            controller: price,
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
                          ),                   
                           if (error_price.isNotEmpty) 
                           Text(error_price, style: TextStyle(color: Colors.red),)
                        ],
                      ),     
                    ),
                    
                    if(error.isNotEmpty)
                    Text(error, style: TextStyle(color: Colors.red),),

                    Padding(padding: EdgeInsets.only(top: 15)),
                    ElevatedButton(
                      onPressed: () {
                        tambahData();
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff99BC85),
                      ),
                      child: Text("Simpan", style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}