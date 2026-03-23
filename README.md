# Flex Yemen - فليكس اليمن

<p align="center">
  <img src="assets/images/app_icon.png" width="120" alt="Flex Yemen Logo">
</p>

<p align="center">
  <strong>منصة التجارة الإلكترونية اليمنية الأولى</strong>
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Flutter-3.19+-blue.svg" alt="Flutter Version"></a>
  <a href="#"><img src="https://img.shields.io/badge/Dart-3.0+-blue.svg" alt="Dart Version"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
</p>

---

## 📱 نظرة عامة

Flex Yemen هو تطبيق تجارة إلكترونية يمني متكامل يهدف إلى ربط البائعين والمشترين في اليمن بمنصة حديثة وسهلة الاستخدام. يوفر التطبيق مجموعة واسعة من الميزات تشمل:

- 🛒 **سوق إلكتروني متكامل** - شراء وبيع المنتجات بكل سهولة
- 💰 **محفظة إلكترونية** - إدارة الأموال وإجراء المعاملات المالية
- 💬 **محادثات فورية** - التواصل المباشر بين البائعين والمشترين
- 📍 **الموقع الجغرافي** - البحث عن المنتجات حسب الموقع
- 🔔 **إشعارات فورية** - متابعة آخر التحديثات والعروض

## ✨ الميزات الرئيسية

### للمشترين
- تصفح آلاف المنتجات في مختلف الفئات
- البحث المتقدم مع فلترة حسب السعر والموقع
- إضافة المنتجات إلى المفضلة
- سلة تسوق ذكية
- تتبع الطلبات
- تقييم المنتجات والبائعين

### للبائعين
- إضافة منتجات بسهولة مع صور متعددة
- إدارة المخزون والطلبات
- متابعة الإحصائيات والمبيعات
- التواصل مع العملاء
- عروض وخصومات

### المحفظة الإلكترونية
- إيداع وسحب الأموال
- تحويل الأموال بين المستخدمين
- دفع الفواتير
- شحن الرصيد
- شراء بطاقات الهدايا

## 🛠️ التقنيات المستخدمة

- **Flutter** - إطار عمل متعدد المنصات
- **Dart** - لغة البرمجة
- **Supabase** - قاعدة البيانات والمصادقة
- **Hive** - التخزين المحلي
- **Provider** - إدارة الحالة
- **Firebase** - الإشعارات والتحليلات

## 📋 المتطلبات

- Flutter 3.19 أو أحدث
- Dart 3.0 أو أحدث
- Android SDK 21+ / iOS 12+

## 🚀 التثبيت والتشغيل

### 1. استنساخ المشروع

```bash
git clone https://github.com/yourusername/flex_yemen.git
cd flex_yemen
```

### 2. تثبيت الاعتماديات

```bash
flutter pub get
```

### 3. إعداد ملف البيئة

```bash
cp .env.example .env
```

قم بتحرير ملف `.env` وإضافة مفاتيحك:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key
```

### 4. تشغيل التطبيق

```bash
flutter run
```

## 📁 هيكل المشروع

```
lib/
├── core/           # الثوابت والأدوات المساعدة
├── models/         # نماذج البيانات
├── providers/      # موفري الحالة
├── services/       # الخدمات
├── screens/        # الشاشات
├── widgets/        # الويدجات المشتركة
├── theme/          # الثيمات والألوان
└── routes/         # المسارات
```

## 🏗️ البناء للإنتاج

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🤝 المساهمة

نرحب بمساهماتكم! يرجى اتباع الخطوات التالية:

1. Fork المشروع
2. إنشاء فرع جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push إلى الفرع (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## 📄 الترخيص

هذا المشروع مرخص بموجب [MIT License](LICENSE).

## 📞 التواصل

- البريد الإلكتروني: support@flexyemen.com
- الموقع: https://flexyemen.com
- تويتر: [@FlexYemen](https://twitter.com/flexyemen)

---

<p align="center">
  صنع بـ ❤️ في اليمن
</p>
