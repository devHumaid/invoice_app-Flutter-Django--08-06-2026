import 'package:flutter/foundation.dart';
import '../../data/models/invoice_model.dart';
import '../../data/repositories/invoice_repository.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepository _repo = InvoiceRepository();

  List<InvoiceModel> _invoices = [];
  bool _loading = false;
  String? _error;

  List<InvoiceModel> get invoices => _invoices;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchInvoices({bool admin = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _invoices = await _repo.getInvoices(admin: admin);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> addInvoice(Map<String, dynamic> data) async {
    final result = await _repo.createInvoice(data);
    if (result['statusCode'] == 201) await fetchInvoices();
    return result;
  }

  Future<bool> deleteInvoice(int id) async {
    final success = await _repo.deleteInvoice(id);
    if (success) await fetchInvoices();
    return success;
  }
}
