import 'package:hive/hive.dart';

part 'transfers.g.dart';

@HiveType(typeId: 1)
class Transfer extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String date;

  Transfer({
    required this.name,
    required this.amount,
    required this.date,
  });
}
