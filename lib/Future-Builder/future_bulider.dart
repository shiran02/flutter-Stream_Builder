import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/User.dart';

class FutureEx extends StatefulWidget {
  const FutureEx({super.key});

  @override
  State<FutureEx> createState() => _FutureExState();
}

class _FutureExState extends State<FutureEx> {


  Future<List<User>> getUsers() async{
    var url  = Uri.parse("https://randomuser.me/api/?results=20");
     http.Response response;
    List<User> usersList = [];

    try{
      response = await http.get(url);

      if(response.statusCode == 200){

        Map peopleData = jsonDecode(response.body);

        List<dynamic> peoples =  peopleData["results"];
        print(peoples);

        for(var item in peoples){
          var email = item['email'];
          var name = item['name']['first'] +" "+ item['name']['second'];
          var id = item['login']['uuid'];
          var avatar = item['picture']['large'];
          User user = User(id, name, email, avatar);
          usersList.add(user);
        }

      }else{
        return Future.error("Somrthing Gone Wrong ${response.statusCode}");
      }

    }catch(e){
        Future.error(e.toString());
    }

    return usersList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("peoples Data"),),
      body: FutureBuilder(
        future: getUsers(), 
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){

              return const Center(
                child: Text(
                  "Waiting"
                ),
              );
              
          }else{

            if(snapshot.hasError){
                return Text(snapshot.error.toString());
            }else{
              //return Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context , int index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].avatar),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: (){},
                  );
                }
              );
            }
            
          }
        },

      ),
    );
  }
}