
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/prosample.dart';

// ignore: must_be_immutable
class ExPage extends StatelessWidget {
   ExPage({super.key});
TextEditingController  nameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("example profider"),
      ),
      body: Consumer<A>(builder: (context, value, child) {
        if(value.a.isEmpty)
        {
           Center(child: const Text("empty"));
        }return ListView.builder(itemBuilder: (context,index){
        
          return ListTile(title: Text(value.a[index]!),
          
          trailing: IconButton(icon: Icon( Icons.remove,),
          
          onPressed: () {
            context.read<A>().deleteData(index);
          },));
        },itemCount: value.a.length,);
      },),
       floatingActionButton: FloatingActionButton(onPressed: (){
        showalertBOx(context);
      },child: const Icon(Icons.add),),
      drawer: const Drawer(
        backgroundColor:Colors.amber,
      ),
    );
  }
//fuction for alert box

showalertBOx(context){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(title: const Text("Message for you"),
    content: SizedBox(
      height: 50,width: 100,
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
        fillColor: Colors.grey[100],filled: true),
        )),
      actions: [
        ElevatedButton(onPressed: (){

        if(nameController.text.isNotEmpty ){
          context.read<A>().addData(nameController.text);
        }
        nameController.clear();
          Navigator.pop(context);
        }, child: const Text("saved"))
      ],
    );
  },
    );
  }
}