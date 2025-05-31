import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

   final dio = Dio();
   final storage = FlutterSecureStorage();
    
    String token = '';
    List data_menus = [];

    
   void initState() {
    super.initState();
      getAllData();
   }

   Future<void> getAllData() async {
     await getDataUser();
     await getDataMenu();
   }


   Future<void> getDataUser() async {
    final token_storage = await storage.read(key: 'token');
    setState(() {
      token = token_storage ?? '';
    });
   }

   Future<void> getDataMenu() async {
    try {
      final response = await dio.get("http://192.168.158.32:8000/api/menu",
      options: Options(
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        }
      )    
      );

      setState(() {
        data_menus = response.data['data'];
      });

    } catch (e) {
      print("Terjadi Error");
      print(e);
    }
   }



   //DELETE MENU
   Future<void> deleteMenu(int id) async {
    try {
      await dio.get("http://192.168.158.32:8000/api/menu/delete/$id",
         options: Options(
          headers: {
            'Accept' : 'application/json',
            'Authorization' : 'Bearer $token'
          }
         )
      );

      setState(() {
        getDataMenu();
      });

    } catch (e) {
      print("Error");
      print(e);
    }
   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff99BC85),
        title: Text("HOME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Home", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),),
                        Text("Semua menu yang tersedia", style: TextStyle(fontSize: 12, color: Color(0xff3E3C3C)),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/newmenu');
                      }, 
                      child: Text("New Menu+", style: TextStyle(color: Colors.white)), 
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xff99BC85)),
                    ),
                  ),
                ),
              ],
            ),

               ...data_menus.map((data_menu) => 
                 
                  CardProduk(
                      id: data_menu['id'],
                      image: data_menu['image'],
                      nama: data_menu['name'],
                      price: data_menu['price'].toString(),
                      description: data_menu['description'],
                      deleteMenu: () => deleteMenu(data_menu['id']), //DELETE MENU

                  )
               )
          ],
        ),
      ),
    );
  }
}


class CardProduk extends StatelessWidget {
  const CardProduk({this.id = 0, this.image = '', this.nama = '', this.price = '', this.description = '', required this.deleteMenu});
  
  final int id;
  final String image;
  final String nama;
  final String price;
  final String description;
  final VoidCallback deleteMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
             Padding(padding: EdgeInsets.only(top: 20)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pushNamed(context, '/editmenu', arguments: {
                        'menu_id': id,
                        'image': image,
                        'menu_name': nama,
                        'menu_price': price,
                        'menu_desc': description
                      });
                    }, icon: Icon(Icons.edit, size: 14, color: Color(0xff99BC85),) ),
                    IconButton(onPressed: (){
                      deleteMenu();
                    }, icon: Icon(Icons.delete, size: 14, color: Colors.red,) ),
                  ],
                ),
                Card(
                  color: Color(0xffE4EFE7),
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(15), 
                    child: Row(
                      children: [
                        Image.network("http://192.168.158.32:8000/images/$image", width: 100,),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nama, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff3E3C3C)),),
                              Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff3E3C3C),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                              Text(price, style: TextStyle(fontSize: 15, color: Color(0xff99BC85), fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}