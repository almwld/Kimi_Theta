// ملف الثيم الرئيسي - يحتوي على جميع الألوان والأنماط
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الذهبية الأساسية
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF4D03F);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldAccent = Color(0xFFE5C100);
  static const Color goldShimmer = Color(0xFFF9E79F);
  
  // ألوان الحالات
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  
  // ألوان الثيم الداكن
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  
  // ألوان الثيم الفاتح
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFAFAFA);
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  
  // ألوان إضافية
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);
  static const Color overlay = Color(0x80000000);

  // الثيم الفاتح
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: goldPrimary,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      dividerColor: divider,
      shadowColor: shadow,
      
      // لون التدرج
      colorScheme: ColorScheme.light(
        primary: goldPrimary,
        secondary: goldAccent,
        surface: lightSurface,
        background: lightBg,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
        onBackground: lightText,
        onError: Colors.white,
      ),
      
      // الخطوط
      textTheme: GoogleFonts.tajawalTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: lightText,
        displayColor: lightText,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: lightSurface,
        foregroundColor: lightText,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.changa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: goldPrimary,
        ),
        iconTheme: IconThemeData(
          color: goldPrimary,
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: goldPrimary,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 11,
        ),
      ),
      
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldPrimary,
          side: BorderSide(color: goldPrimary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: goldPrimary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.tajawal(
          color: lightTextSecondary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.tajawal(
          color: lightTextSecondary,
          fontSize: 14,
        ),
        prefixIconColor: goldPrimary,
        suffixIconColor: lightTextSecondary,
      ),
      
      // البطاقات
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: lightSurface,
        margin: EdgeInsets.zero,
      ),
      
      // القوائم
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minLeadingWidth: 40,
        iconColor: goldPrimary,
        textColor: lightText,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: GoogleFonts.tajawal(
          fontSize: 13,
          color: lightTextSecondary,
        ),
      ),
      
      // الفواصل
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      
      // الرقائق
      chipTheme: ChipThemeData(
        backgroundColor: lightCard,
        disabledColor: divider,
        selectedColor: goldPrimary,
        secondarySelectedColor: goldAccent,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.tajawal(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: GoogleFonts.tajawal(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // مؤشر التحميل
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: goldPrimary,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: GoogleFonts.tajawal(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: lightSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.changa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        contentTextStyle: GoogleFonts.tajawal(
          fontSize: 15,
          color: lightTextSecondary,
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: lightSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      // TabBar
      tabBarTheme: TabBarTheme(
        labelColor: goldPrimary,
        unselectedLabelColor: lightTextSecondary,
        labelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: goldPrimary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      
      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Radio
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.grey;
        }),
      ),
    );
  }

  // الثيم الداكن
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: goldPrimary,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      dividerColor: Colors.grey.shade800,
      shadowColor: Colors.black,
      
      colorScheme: ColorScheme.dark(
        primary: goldPrimary,
        secondary: goldAccent,
        surface: darkSurface,
        background: darkBg,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
        onError: Colors.white,
      ),
      
      textTheme: GoogleFonts.tajawalTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.changa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: goldPrimary,
        ),
        iconTheme: IconThemeData(
          color: goldPrimary,
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: goldPrimary,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 11,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldPrimary,
          side: BorderSide(color: goldPrimary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: goldPrimary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.tajawal(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.tajawal(
          color: darkTextSecondary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.tajawal(
          color: darkTextSecondary,
          fontSize: 14,
        ),
        prefixIconColor: goldPrimary,
        suffixIconColor: darkTextSecondary,
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: darkSurface,
        margin: EdgeInsets.zero,
      ),
      
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minLeadingWidth: 40,
        iconColor: goldPrimary,
        textColor: darkText,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: GoogleFonts.tajawal(
          fontSize: 13,
          color: darkTextSecondary,
        ),
      ),
      
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: 1,
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        disabledColor: Colors.grey.shade800,
        selectedColor: goldPrimary,
        secondarySelectedColor: goldAccent,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.tajawal(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: GoogleFonts.tajawal(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: goldPrimary,
        linearTrackColor: Colors.grey.shade800,
        circularTrackColor: Colors.grey.shade800,
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: GoogleFonts.tajawal(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      dialogTheme: DialogTheme(
        backgroundColor: darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.changa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        contentTextStyle: GoogleFonts.tajawal(
          fontSize: 15,
          color: darkTextSecondary,
        ),
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      tabBarTheme: TabBarTheme(
        labelColor: goldPrimary,
        unselectedLabelColor: darkTextSecondary,
        labelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: goldPrimary,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
      
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return goldPrimary;
          }
          return Colors.grey;
        }),
      ),
    );
  }

  // تدرجات لونية
  static LinearGradient get goldGradient => LinearGradient(
    colors: [goldPrimary, goldLight, goldAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get goldGradientReverse => LinearGradient(
    colors: [goldAccent, goldLight, goldPrimary],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static LinearGradient get darkGradient => LinearGradient(
    colors: [darkSurface, darkBg],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get cardGradient => LinearGradient(
    colors: [goldDark, goldPrimary, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ظلال
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: shadow,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get heavyShadow => [
    BoxShadow(
      color: shadow,
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get goldShadow => [
    BoxShadow(
      color: goldPrimary.withOpacity(0.3),
      blurRadius: 15,
      offset: Offset(0, 6),
    ),
  ];
}
