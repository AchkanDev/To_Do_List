import 'package:flutter/material.dart';
import 'package:to_do_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T>{
  late final DataSource<T> localDataSource;
  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) async{
    final T item =await  localDataSource.createOrUpdate(data);
    notifyListeners();
    return item;
  }

  @override
  Future<void> delete(data) async{
    await localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async{
   await localDataSource.deleteAll();
   notifyListeners();
  }

  @override
  Future<void> deleteById(id) async{
    await localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String serachKeyWord = ""}) {
    return localDataSource.getAll(serachKeyWord: serachKeyWord);
  }

}