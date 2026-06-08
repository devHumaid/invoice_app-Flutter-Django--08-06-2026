class ItemModel {
  final int id;
  final String name;
  final String type;
  final String? hsnCode;
  final String? sacCode;
  final String taxType;
  final double price;
  final String? createdAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.type,
    this.hsnCode,
    this.sacCode,
    required this.taxType,
    required this.price,
    this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      hsnCode: json['hsn_code'],
      sacCode: json['sac_code'],
      taxType: json['tax_type'],
      price: double.parse(json['price'].toString()),
      createdAt: json['created_at'],
    );
  }

  String get code => type == 'goods' ? (hsnCode ?? '') : (sacCode ?? '');
  String get codeLabel => type == 'goods' ? 'HSN' : 'SAC';
  String get typeLabel => type == 'goods' ? 'Goods' : 'Service';
  String get taxLabel => taxType == 'taxable' ? 'Taxable' : 'Non-Taxable';
}
