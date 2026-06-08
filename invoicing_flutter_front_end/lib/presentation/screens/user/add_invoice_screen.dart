import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/item_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/item_model.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  ItemModel? _selectedItem;
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemProvider>().fetchItems();
    });
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an item'), backgroundColor: AppColors.warning),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final data = {
      'item': _selectedItem!.id,
      'customer_name': _customerNameCtrl.text.trim(),
      'customer_email': _emailCtrl.text.trim(),
      'customer_phone': _phoneCtrl.text.trim(),
      'customer_address': _addressCtrl.text.trim(),
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
    };

    final result = await context.read<InvoiceProvider>().addInvoice(data);
    if (!mounted) return;
    setState(() => _loading = false);

    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice created!'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } else {
      final body = result['body'];
      String msg = 'Failed to create invoice';
      if (body is Map) msg = body.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProv = context.watch<ItemProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item selection
              const Text('Select Item', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ItemModel>(
                    isExpanded: true,
                    hint: const Text('Choose an item'),
                    value: _selectedItem,
                    items: itemProv.items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Row(
                          children: [
                            Icon(
                              item.type == 'goods' ? Icons.inventory_2 : Icons.miscellaneous_services,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item.name)),
                            Text('₹${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedItem = val),
                  ),
                ),
              ),
              if (_selectedItem != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedItem!.typeLabel} · ${_selectedItem!.codeLabel}: ${_selectedItem!.code} · ${_selectedItem!.taxLabel}',
                        style: const TextStyle(color: AppColors.primary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              CustomTextField(
                controller: _customerNameCtrl,
                label: 'Customer Name',
                hint: 'Enter customer name',
                icon: Icons.person_outline,
                validator: (v) => Validators.required(v, 'Customer name'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailCtrl,
                label: 'Customer Email',
                hint: 'Enter customer email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneCtrl,
                label: 'Customer Phone',
                hint: 'e.g. 9876543210',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressCtrl,
                label: 'Customer Address',
                hint: 'Enter customer address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (v) => Validators.required(v, 'Address'),
              ),
              const SizedBox(height: 16),
              // Date picker
              const Text('Invoice Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_selectedItem != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text(
                        '₹${_selectedItem!.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submit, child: const Text('Create Invoice')),
            ],
          ),
        ),
      ),
    );
  }
}
