// import 'package:transform/src/database/class/transform_database_class.dart';

import '../../../transform.dart';

part 'transform_database_column_type_num.dart';
part 'transform_database_column_type_string.dart';

abstract class TransformDatabaseColumnType {
  TransformDatabaseColumnType();

  String asSql(TransformDatabaseClass database);
}
