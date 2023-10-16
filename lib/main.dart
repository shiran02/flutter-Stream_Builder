import 'dart:async';

import 'package:flutter/material.dart';

import 'Future-Builder/future_bulider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const FutureEx(),
    );
  }
}





class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Stream Controller ......................................

  StreamController _controller = StreamController();


  addStreamData() async{
    for(var i = 0;i<10 ;i++){
      await Future.delayed(Duration(seconds: 2));
      _controller.sink.add(i);
    }
  }

  Stream<int> addStreamData2() async*{
    for(int i =0 ; i<10 ; i++){
      await Future.delayed(Duration(seconds: 2));
      yield i;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addStreamData2();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Stream Tutorial'),
      ),
      body: Center(
        child: StreamBuilder(
        //  stream: _controller.stream,
        stream: addStreamData2(),
          builder: (context,snapshot){

            if(snapshot.hasError){
              return Text("Error");
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }

            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Stream Item'
                ),

                Text(
                  '${snapshot.data}'
                ),
              ],
            );


          },
        ),
      ),
    );
  }
}
