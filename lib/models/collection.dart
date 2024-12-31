class Collection {
  String name;
  double amount;
  DateTime date;

  Collection({required this.name, required this.amount, required this.date});
}

class BankTransfer {
  double amount;
  DateTime date;

  BankTransfer({required this.amount, required this.date});
}