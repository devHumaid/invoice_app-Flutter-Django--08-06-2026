import 'dart:convert';
import '../models/invoice_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/app_constants.dart';

class InvoiceRepository {
  Future<List<InvoiceModel>> getInvoices({bool admin = false}) async {
    final endpoint = admin
        ? AppConstants.adminInvoicesEndpoint
        : AppConstants.invoicesEndpoint;
    final response = await ApiClient.get(endpoint);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => InvoiceModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load invoices');
  }

  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> data) async {
    final response = await ApiClient.post(AppConstants.invoicesEndpoint, data, auth: true);
    return {'statusCode': response.statusCode, 'body': jsonDecode(response.body)};
  }

  Future<bool> deleteInvoice(int id) async {
    final response = await ApiClient.delete('/invoices/$id/delete/');
    return response.statusCode == 200;
  }
}
