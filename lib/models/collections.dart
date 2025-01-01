import 'package:hive/hive.dart';

part 'collections.g.dart';

@HiveType(typeId: 0) 
class Collection {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String qp;

  @HiveField(3)
  final String uq;

  @HiveField(4)
  final String sp;

  @HiveField(5)
  final String nb;

  @HiveField(6)
  final String rt;

  @HiveField(7)
  final String rv;

  @HiveField(8)
  final String date;

  Collection({
    required this.name,
    required this.amount,
    required this.qp,
    required this.uq,
    required this.sp,
    required this.nb,
    required this.rt,
    required this.rv,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'qp': qp,
      'uq': uq,
      'sp': sp,
      'nb': nb,
      'rt': rt,
      'rv': rv,
      'date': date,
    };
  }
}
