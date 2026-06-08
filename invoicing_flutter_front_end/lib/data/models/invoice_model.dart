import 'item_model.dart';

class InvoiceModel {
  final int id;
  final String createdBy;
  final int? itemId;
  final ItemModel? itemDetail;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String date;
  final double totalAmount;
  final String? createdAt;

  InvoiceModel({
    required this.id,
    required this.createdBy,
    this.itemId,
    this.itemDetail,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.date,
    required this.totalAmount,
    this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      createdBy: json['created_by']?.toString() ?? '',
      itemId: json['item'],
      itemDetail: json['item_detail'] != null
          ? ItemModel.fromJson(json['item_detail'])
          : null,
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      customerAddress: json['customer_address'],
      date: json['date'],
      totalAmount: double.parse(json['total_amount'].toString()),
      createdAt: json['created_at'],
    );
  }
}
