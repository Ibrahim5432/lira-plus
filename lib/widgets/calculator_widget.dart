import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/currency_rate.dart';

class CalculatorWidget extends StatefulWidget {
  final List<CurrencyRate> currencies;

  const CalculatorWidget({super.key, required this.currencies});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final TextEditingController _amountController = TextEditingController(text: '1');
  String _selectedCurrency = 'USD';
  bool _isFromSyp = false;
  final _numberFormat = NumberFormat('#,###.##', 'ar');

  CurrencyRate? get _currentCurrency {
    try {
      return widget.currencies.firstWhere((c) => c.currencyCode == _selectedCurrency);
    } catch (e) {
      return widget.currencies.isNotEmpty ? widget.currencies.first : null;
    }
  }

  double get _result {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    final currency = _currentCurrency;
    if (currency == null) return 0;

    if (_isFromSyp) {
      return amount / currency.sellRate;
    } else {
      return amount * currency.buyRate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                labelText: 'اختر العملة',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              ),
              items: widget.currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency.currencyCode,
                  child: Row(
                    children: [
                      Text(currency.flagEmoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text('${currency.currencyCode} - ${currency.currencyNameAr}'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'المبلغ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      suffixText: _isFromSyp ? 'ل.س' : _selectedCurrency,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () => setState(() => _isFromSyp = !_isFromSyp),
                  icon: const Icon(Icons.swap_vert),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5D23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4A5D23).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4A5D23).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'النتيجة',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isFromSyp 
                        ? '${_numberFormat.format(_result)} $_selectedCurrency'
                        : '${_numberFormat.format(_result)} ل.س',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A5D23),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isFromSyp
                  ? 'من الليرة السورية إلى $_selectedCurrency'
                  : 'من $_selectedCurrency إلى الليرة السورية',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
