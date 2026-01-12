import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A5D23),
        foregroundColor: Colors.white,
        title: const Text('سياسة الخصوصية'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'سياسة الخصوصية',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('آخر تحديث: يناير 2026', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24),
          _Section(
            title: 'مقدمة',
            content: 'مرحباً بكم في تطبيق "الليرة بلس". نحن نحترم خصوصيتكم ونلتزم بحماية بياناتكم الشخصية. توضح سياسة الخصوصية هذه كيفية جمع واستخدام المعلومات عند استخدام تطبيقنا.',
          ),
          _Section(
            title: 'المعلومات التي نجمعها',
            content: 'تطبيق "الليرة بلس" لا يجمع أي معلومات شخصية. التطبيق يعرض فقط أسعار صرف العملات وأسعار الذهب المتاحة للعموم.',
          ),
          _Section(
            title: 'الإعلانات',
            content: 'يستخدم التطبيق خدمة Google AdMob لعرض الإعلانات. قد تستخدم Google ملفات تعريف الارتباط (cookies) ومعرفات الإعلانات لتخصيص الإعلانات بناءً على اهتماماتك.',
          ),
          _Section(
            title: 'مصادر البيانات',
            content: 'أسعار الصرف: يتم جلب البيانات من مصادر سورية موثوقة.\nأسعار الذهب: يتم جلب البيانات من مصادر عالمية.',
          ),
          _Section(
            title: 'إخلاء المسؤولية',
            content: 'الأسعار المعروضة هي للأغراض المعلوماتية فقط وقد تختلف عن الأسعار الفعلية في السوق. لا نتحمل أي مسؤولية عن القرارات المالية المبنية على هذه المعلومات.',
          ),
          _Section(
            title: 'التواصل معنا',
            content: 'لأي استفسارات حول سياسة الخصوصية، يرجى التواصل معنا عبر البريد الإلكتروني.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(height: 1.6)),
        ],
      ),
    );
  }
}
