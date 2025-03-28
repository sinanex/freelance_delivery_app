class Model {
  String? id;
  String date;
  String amount;
  String recipt;
  String fullGas;
  String emptygas;
  String shopname;
  String location;
  String type;

  Model({
    this.id,
    required this.type,
    required this.shopname,
    required this.location,
    required this.date,
    required this.amount,
    required this.recipt,
    required this.fullGas,
    required this.emptygas,
  });

  factory Model.fromJson(Map<String, dynamic> json, String id) {
    return Model(
      id: id,
      type: json['type'] ?? '',
      shopname: json['shopname'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? 'null',
      amount: json['amount'] ?? 'null',
      recipt: json['recipt'] ?? '',
      fullGas: json['fullGas'] ?? '',
      emptygas: json['emptygas'] ?? '',
    );
  }

  Map<String, dynamic> toJSon() {
    return {
      'date': date,
      'amount': amount,
      'recipt': recipt,
      'fullGas': fullGas,
      'emptygas': emptygas,
      'location': location,
      'shopname': shopname,
      'type': type,
    };
  }
}
