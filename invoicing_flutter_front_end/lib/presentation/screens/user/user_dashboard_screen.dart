import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/item_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../../core/constants/app_theme.dart';
import 'add_item_screen.dart';
import 'add_invoice_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemProvider>().fetchItems();
      context.read<InvoiceProvider>().fetchInvoices();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${auth.user?.name ?? 'User'} 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2), text: 'Items'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Invoices'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ItemsTab(),
          _InvoicesTab(),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (_, __) => FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: () {
            if (_tabController.index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddInvoiceScreen()));
            }
          },
          icon: const Icon(Icons.add),
          label: Text(_tabController.index == 0 ? 'Add Item' : 'Add Invoice'),
        ),
      ),
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab();

  @override
  Widget build(BuildContext context) {
    final itemProv = context.watch<ItemProvider>();

    if (itemProv.loading) return const Center(child: CircularProgressIndicator());
    if (itemProv.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textGrey),
            const SizedBox(height: 12),
            const Text('No items yet', style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Tap + to add your first item', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ItemProvider>().fetchItems(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itemProv.items.length,
        itemBuilder: (_, i) {
          final item = itemProv.items[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: icon  +  name  +  price ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.type == 'goods'
                              ? Icons.inventory_2
                              : Icons.miscellaneous_services,
                          color: item.type == 'goods'
                              ? AppColors.primary
                              : AppColors.pillBg,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ✅ Expanded prevents overflow on long names
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // ── Bottom row: badges  +  delete ──
                  Row(
                    children: [
                      // ✅ Wrap badges in Expanded so they never overflow
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _Badge(label: item.typeLabel, color: AppColors.primary),
                            _Badge(
                              label: '${item.codeLabel}: ${item.code}',
                              color: AppColors.cardBg,
                            ),
                            _Badge(
                              label: item.taxLabel,
                              color: item.taxType == 'taxable'
                                  ? AppColors.success
                                  : AppColors.textGrey,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Item'),
                              content: Text('Delete "${item.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.error),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await context.read<ItemProvider>().deleteItem(item.id);
                          }
                        },
                        child: const Icon(Icons.delete_outline,
                            color: AppColors.error, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class _InvoicesTab extends StatelessWidget {
  const _InvoicesTab();

  @override
  Widget build(BuildContext context) {
    final invProv = context.watch<InvoiceProvider>();

    if (invProv.loading) return const Center(child: CircularProgressIndicator());
    if (invProv.invoices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textGrey),
            SizedBox(height: 12),
            Text('No invoices yet', style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
            SizedBox(height: 8),
            Text('Tap + to create your first invoice', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<InvoiceProvider>().fetchInvoices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invProv.invoices.length,
        itemBuilder: (_, i) {
          final inv = invProv.invoices[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text('#${inv.id}',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inv.customerName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(inv.customerEmail,
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Text(
                        '₹${inv.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(inv.itemDetail?.name ?? 'N/A',
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(inv.date, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Invoice'),
                              content: Text('Delete invoice #${inv.id}?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await context.read<InvoiceProvider>().deleteInvoice(inv.id);
                          }
                        },
                        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
