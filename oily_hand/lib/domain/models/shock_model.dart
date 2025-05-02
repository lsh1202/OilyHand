class ShockModel {
  final String date;
  final int count;

  ShockModel({required this.date, required this.count});

  factory ShockModel.fromJson(Map<String, dynamic> json) {
    return ShockModel(date: json['date'], count: json['count']);
  }
}
