import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/provider/currency_provider.dart';
import '../../core/services/firestore_service.dart';
import '../../model/installment_model.dart';

class AddInstallmentScreen extends StatefulWidget {
  const AddInstallmentScreen({super.key});

  @override
  State<AddInstallmentScreen> createState() => _AddInstallmentScreenState();
}

class _AddInstallmentScreenState extends State<AddInstallmentScreen> {
  final TextEditingController _installmentNameController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _categories = [
    'Phone Bill',
    'Internet',
    'Electricity',
    'Water',
    'Gas',
    'Insurance',
    'Loan',
    'Credit Card',
    'Subscription',
    'Other'
  ];

  @override
  void dispose() {
    _installmentNameController.dispose();
    _totalAmountController.dispose();
    _dueDateController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dueDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _showCurrencyPicker(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to take more space
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7, // Limit height
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: currencyProvider.availableCurrencies.map((currency) {
                      Map<String, String> info = currencyProvider.getCurrencyInfo(currency);
                      return ListTile(
                        leading: Text(
                          info['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(currency),
                        subtitle: Text(info['name']!),
                        trailing: currencyProvider.selectedCurrency == currency
                            ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                            : null,
                        onTap: () {
                          currencyProvider.setCurrency(currency);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: _categories.map((category) {
                      return ListTile(
                        title: Text(category),
                        onTap: () {
                          setState(() {
                            _categoryController.text = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addInstallment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

      final installment = InstallmentModel(
        installmentName: _installmentNameController.text.trim(),
        totalAmount: double.parse(_totalAmountController.text),
        dueDate: _selectedDate!,
        category: _categoryController.text.trim(),
        notes: _notesController.text.trim(),
        currency: currencyProvider.selectedCurrency,
        createdAt: DateTime.now(),
      );

      bool success = await _firestoreService.addInstallment(installment);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Installment added successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add installment. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Installment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Installment Name
                      const Text(
                        'Installment Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _installmentNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter installment name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'e.g. Phone Bill',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Total Amount with Currency Selector
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Consumer<CurrencyProvider>(
                              builder: (context, currencyProvider, child) {
                                return GestureDetector(
                                  onTap: () => _showCurrencyPicker(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color: Colors.grey[300]!)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          currencyProvider.currencyFlag,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          currencyProvider.selectedCurrency,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _totalAmountController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                    return 'Please enter valid amount';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Due Date
                      const Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _dueDateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select due date';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'mm/dd/yyyy',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Category
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _categoryController,
                          readOnly: true,
                          onTap: () => _showCategoryPicker(context),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select category';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select or type a category',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Notes
                      const Text(
                        'Notes (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add any relevant notes here...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Add Installment Button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addInstallment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Add Installment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}