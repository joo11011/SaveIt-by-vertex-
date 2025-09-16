import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/installment_view_model.dart';
import '../../model/installment_model.dart';
import '../../services/firebase_service.dart';
import '../Add_installments_screen/Add_installments_screen.dart';
import '../Home_screen/Home_screen.dart';
import 'dart:async';

class InstallmentsScreen extends StatefulWidget {
  const InstallmentsScreen({super.key});

  @override
  State<InstallmentsScreen> createState() => _InstallmentsScreenState();
}

class _InstallmentsScreenState extends State<InstallmentsScreen>
    with TickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService(); // Create an instance
  bool _alarmEnabled = true;
  late AnimationController _alarmController;
  late Animation<double> _alarmAnimation;
  StreamSubscription? _installmentsSubscription;
  List<InstallmentViewModel> _allInstallments = [];
  bool _isLoading = true;
  String? _error;

  List<InstallmentViewModel> get upcomingInstallments =>
      _allInstallments.where((i) => !i.isPaid).toList();

  List<InstallmentViewModel> get paidInstallments =>
      _allInstallments.where((i) => i.isPaid).toList();

  @override
  void initState() {
    super.initState();
    _setupAnimationController();
    _loadInstallments();
  }

  void _setupAnimationController() {
    _alarmController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _alarmAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _alarmController, curve: Curves.elasticInOut),
    );

    if (_alarmEnabled) {
      _alarmController.repeat(reverse: true);
    }
  }

  void _loadInstallments() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _installmentsSubscription = _firebaseService.getInstallmentsStream()
          .listen(
            (installments) {
              if (mounted) {
                setState(() {
                  _allInstallments = installments
                      .map((model) => _mapToViewModel(model))
                      .toList();
                  _isLoading = false;
                });
              }
            },
            onError: (error) {
              if (mounted) {
                setState(() {
                  _error = error.toString();
                  _isLoading = false;
                });
              }
            },
          );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  InstallmentViewModel _mapToViewModel(InstallmentModel model) {
    return InstallmentViewModel(
      id: model.id,
      title: model.installmentName,
      dueDate: model.dueDate,
      amount: model.totalAmount,
      isPaid: model.isPaid,
      icon: model.icon ?? Icons.attach_money,
      iconColor: model.iconColor ?? Colors.orange,
      timeStatus: model.timeStatus ?? '',
      category: model.category ?? '',
      notes: model.notes ?? '',
      createdAt: model.createdAt,
    );
  }

  @override
  void dispose() {
    _alarmController.dispose();
    _installmentsSubscription?.cancel();
    super.dispose();
  }

  void _toggleAlarm() {
    setState(() {
      _alarmEnabled = !_alarmEnabled;
      if (_alarmEnabled) {
        _alarmController.repeat(reverse: true);
      } else {
        _alarmController.stop();
        _alarmController.reset();
      }
    });
  }

  void _toggleInstallmentStatus(int index, String listType) async {
    final installment = listType == 'upcoming'
        ? upcomingInstallments[index]
        : paidInstallments[index];

    if (installment.id != null) {
      final newIsPaid = !installment.isPaid;
      await _firebaseService.updateInstallmentStatus(installment.id!, newIsPaid);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _addNewInstallment() async {
    final result = await Navigator.of(context).push<InstallmentModel>(
      MaterialPageRoute(builder: (context) => const AddInstallmentScreen()),
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('installment_added'.tr)));
    }
  }

  Future<void> _editInstallment(InstallmentViewModel installment) async {
    final result = await Navigator.of(context).push<InstallmentModel>(
      MaterialPageRoute(
        builder: (context) => AddInstallmentScreen(
          installmentToEdit: InstallmentModel(
            id: installment.id,
            installmentName: installment.title,
            totalAmount: installment.amount,
            dueDate: installment.dueDate,
            category: installment.category,
            notes: installment.notes,
            currency: 'SAR',
            isPaid: installment.isPaid,
            createdAt: installment.createdAt,
            icon: installment.icon,
            iconColor: installment.iconColor,
            timeStatus: installment.timeStatus,
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('installment_updated'.tr)));
    }
  }

  void _deleteInstallmentFromUI(InstallmentViewModel installment) async {
    print('Delete button tapped for installment: ${installment.title}');

    if (installment.id != null) {
      print('Deleting installment with ID: ${installment.id}');
      try {
        await _firebaseService.deleteInstallment(installment.id!);
        print('Successfully deleted from Firebase');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('installment_deleted'.tr)));
        }
      } catch (e) {
        print('Error deleting installment: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
        }
      }
    } else {
      print('Installment ID is null, cannot delete');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('cannot_delete'.tr)));
      }
    }
  }

  Widget _buildAlarmIcon() {
    return AnimatedBuilder(
      animation: _alarmAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _alarmEnabled ? 1.0 + (_alarmAnimation.value * 0.1) : 1.0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _alarmEnabled ? Colors.orange : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: _alarmEnabled
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.alarm,
              color: _alarmEnabled ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    final totalAmount = _allInstallments.fold(0.0, (sum, i) => sum + i.amount);
    final paidAmount = paidInstallments.fold(0.0, (sum, i) => sum + i.amount);
    final remainingAmount = totalAmount - paidAmount;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 226, 188, 17), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'total_installments'.tr,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${totalAmount.toStringAsFixed(2)} SAR',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'paid'.tr,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${paidAmount.toStringAsFixed(2)} SAR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'remaining'.tr,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${remainingAmount.toStringAsFixed(2)} SAR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentCard(
    InstallmentViewModel installment,
    int index,
    String listType,
  ) {
    return GestureDetector(
      onTap: () => _editInstallment(installment),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: installment.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                installment.icon,
                color: installment.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    installment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, y').format(installment.dueDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (installment.timeStatus.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      installment.timeStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: installment.timeStatus == 'Due Tomorrow'
                            ? Colors.red
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${installment.amount.toStringAsFixed(2)} SAR',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Done button
                    GestureDetector(
                      onTap: () => _toggleInstallmentStatus(index, listType),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: !installment.isPaid ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          !installment.isPaid ? 'Done' : 'Undo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Alarm toggle next to Done button
                    GestureDetector(
                      onTap: () => _toggleAlarm(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _alarmEnabled
                              ? Colors.orange
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: _alarmEnabled
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.alarm,
                          color: _alarmEnabled
                              ? Colors.white
                              : Colors.grey[600],
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete/Archive button
                    GestureDetector(
                      onTap: () => _deleteInstallmentFromUI(installment),
                      child: Icon(
                        !installment.isPaid
                            ? Icons.delete_outline
                            : Icons.archive_outlined,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: _loadInstallments,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Get.offAll(() => const HomeScreen());
          },
        ),
        title: Text(
          'installments'.tr,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: _addNewInstallment,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'upcoming_installments'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (upcomingInstallments.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'no_upcoming_installments'.tr,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...upcomingInstallments.asMap().entries.map(
                (entry) =>
                    _buildInstallmentCard(entry.value, entry.key, 'upcoming'),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'paid_installments'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (paidInstallments.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'no_paid_installments'.tr,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...paidInstallments.asMap().entries.map(
                (entry) =>
                    _buildInstallmentCard(entry.value, entry.key, 'paid'),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}