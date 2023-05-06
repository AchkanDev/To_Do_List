abstract class DataSource<T>{
Future <List<T>> getAll({String serachKeyWord});
Future <T> findById (id);
Future <T> createOrUpdate (T data);
Future <void> deleteAll() ;
Future <void> deleteById(id) ;
Future <void> delete(T data) ;








}