import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/data/source/source.dart';

import '../data.dart';

class HiveTaskSource implements DataSource<Tasks> {
   final Box<Tasks> box;

  HiveTaskSource(this.box);
  @override
  Future<Tasks> createOrUpdate (Tasks data) async{
    if(data.isInBox){
      data.save();
    }
    else{
      await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete (Tasks data){
    return  data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<Tasks> findById(id) async{
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Tasks>> getAll({String serachKeyWord= " "}) async {
    if (serachKeyWord.isNotEmpty){
      return box.values.where((element) => element.name.contains(serachKeyWord)).toList();
    }else {
      return box.values.toList();
    }
  }


}