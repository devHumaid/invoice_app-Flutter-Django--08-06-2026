import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/item_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/validators.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _hsnCtrl = TextEditingController();
  final _sacCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String _type = 'goods';
  String _taxType = 'taxable';
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hsnCtrl.dispose();
    _sacCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'type': _type,
      'tax_type': _taxType,
      'price': _priceCtrl.text.trim(),
      if (_type == 'goods') 'hsn_code': _hsnCtrl.text.trim(),
      if (_type == 'service') 'sac_code': _sacCtrl.text.trim(),
    };

    final result = await context.read<ItemProvider>().addItem(data);
    if (!mounted) return;
    setState(() => _loading = false);

    if (result['statusCode'] == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } else {
      final body = result['body'];
      String msg = 'Failed to add item';
      if (body is Map) msg = body.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameCtrl,
                label: 'Item Name',
                hint: 'Enter item name',
                icon: Icons.label_outline,
                validator: (v) => Validators.required(v, 'Item name'),
              ),
              const SizedBox(height: 20),
              // Type selection
              const Text('Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      label: 'Goods',
                      icon: Icons.inventory_2_outlined,
                      selected: _type == 'goods',
                      onTap: () => setState(() => _type = 'goods'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      label: 'Service',
                      icon: Icons.miscellaneous_services_outlined,
                      selected: _type == 'service',
                      onTap: () => setState(() => _type = 'service'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Conditional HSN / SAC
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _type == 'goods'
                    ? CustomTextField(
                        key: const ValueKey('hsn'),
                        controller: _hsnCtrl,
                        label: 'HSN Code',
                        hint: 'Enter 6-digit HSN code',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: (v) => Validators.hsnSac(v, 'HSN'),
                      )
                    : CustomTextField(
                        key: const ValueKey('sac'),
                        controller: _sacCtrl,
                        label: 'SAC Code',
                        hint: 'Enter 6-digit SAC code',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: (v) => Validators.hsnSac(v, 'SAC'),
                      ),
              ),
              const SizedBox(height: 20),
              // Tax type
              const Text('Tax Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      label: 'Taxable',
                      icon: Icons.percent,
                      selected: _taxType == 'taxable',
                      onTap: () => setState(() => _taxType = 'taxable'),
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      label: 'Non-Taxable',
                      icon: Icons.money_off,
                      selected: _taxType == 'non_taxable',
                      onTap: () => setState(() => _taxType = 'non_taxable'),
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _priceCtrl,
                label: 'Price (₹)',
                hint: 'Enter price',
                icon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.price,
              ),
              const SizedBox(height: 32),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submit, child: const Text('Add Item')),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _TypeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(color: selected ? color : AppColors.divider, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : AppColors.textGrey),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textGrey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
