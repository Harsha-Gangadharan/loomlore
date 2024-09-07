import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class A with ChangeNotifier{
  List<String?> a=[];
  addData(String name){
    a.add(name);
    notifyListeners();
  }
  deleteData(index){
    a.removeAt(index);
    notifyListeners();
  }

}