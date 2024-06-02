import 'package:hive/hive.dart';

part 'reservation.g.dart';

@HiveType(typeId: 0)
class Reservation extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phone;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late int people;

  @HiveField(4)
  late String drinkName;
}
