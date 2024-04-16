class AmountMoney {
  final int amount;
  final String currency;

  AmountMoney({required this.amount,required this.currency});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}