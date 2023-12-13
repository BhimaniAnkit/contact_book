import 'package:hive/hive.dart';
part 'contect_data.g.dart';

@HiveType(typeId: 0)
class Contect_Data extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? contect;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? gender;
  @HiveField(4)
  String? password;
  @HiveField(5)
  String? cropImage;

  Contect_Data(this.name, this.contect, this.email, this.gender, this.cropImage, this.password);
}