import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/currency_rate.dart';
import '../models/gold_rate.dart';
import '../services/api_service.dart';
import '../widgets/currency_card.dart';
import '../widgets/gold_card.dart';
import '../widgets/calculator_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CurrencyRate> _currencies = [];
  List<GoldRate> _goldRates = [];
  String? _lastUpdated;
  bool _isLoading = true;
  bool _isRefreshing = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) => _fetchData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
      if (_currencies.isEmpty) _isLoading = true;
    });

    try {
      final ratesResponse = await ApiService.fetchRates();
      final goldResponse = await ApiService.fetchGoldRates();
      
      setState(() {
        _currencies = ratesResponse.rates;
        _goldRates = goldResponse.rates;
        _lastUpdated = ratesResponse.lastUpdated;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  String _formatLastUpdated() {
    if (_lastUpdated == null) return '';
    try {
      final date = DateTime.parse(_lastUpdated!);
      final format = DateFormat('HH:mm', 'ar');
      return 'آخر تحديث: ${format.format(date.toLocal())}';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5D23),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('₤', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A5D23))),
              ),
            ),
            const SizedBox(width: 12),
            const Text('الليرة بلس', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchData,
            ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.attach_money), text: 'العملات'),
            Tab(icon: Icon(Icons.calculate), text: 'المحول'),
            Tab(icon: Icon(Icons.monetization_on), text: 'الذهب'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_lastUpdated != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: theme.colorScheme.surfaceVariant,
              child: Text(
                _formatLastUpdated(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurrenciesTab(),
                _buildCalculatorTab(),
                _buildGoldTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrenciesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'أسعار الصرف اليوم',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'أسعار العملات الأجنبية مقابل الليرة السورية',
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 16),
          ..._currencies.map((currency) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CurrencyCard(currency: currency),
          )),
          const SizedBox(height: 8),
          Text(
            'المصدر: أسعار السوق السورية',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    if (_isLoading || _currencies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'محول العملات',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'حوّل بين العملات الأجنبية والليرة السورية',
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
        const SizedBox(height: 16),
        CalculatorWidget(currencies: _currencies),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildGoldTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'أسعار الذهب في سوريا',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'أسعار الذهب للغرام الواحد بالليرة السورية',
            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          const SizedBox(height: 16),
          ..._goldRates.map((gold) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GoldCard(gold: gold),
          )),
          const SizedBox(height: 8),
          Text(
            'المصدر: أسعار الذهب العالمية',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
