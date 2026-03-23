// شاشة المحادثات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'أحمد محمد',
      'message': 'مرحباً، هل المنتج متوفر؟',
      'time': '10:30',
      'unread': 2,
      'online': true,
      'avatar': null,
    },
    {
      'name': 'محمد علي',
      'message': 'شكراً لك على الشراء',
      'time': 'أمس',
      'unread': 0,
      'online': false,
      'avatar': null,
    },
    {
      'name': 'فاطمة أحمد',
      'message': 'هل يمكن خفض السعر؟',
      'time': 'أمس',
      'unread': 1,
      'online': true,
      'avatar': null,
    },
    {
      'name': 'خالد عمر',
      'message': 'تم إرسال الطلب',
      'time': 'الإثنين',
      'unread': 0,
      'online': false,
      'avatar': null,
    },
    {
      'name': 'سارة محمود',
      'message': 'أريد الاستفسار عن المنتج',
      'time': 'الأحد',
      'unread': 0,
      'online': true,
      'avatar': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'الدردشة',
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'بحث في المحادثات...',
                  hintStyle: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: isDark ? Colors.white40 : Colors.black38,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.goldPrimary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          
          // قائمة المحادثات
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return _buildChatTile(context, chat, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    Map<String, dynamic> chat,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = chat['unread'] as int;

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.goldPrimary.withOpacity(0.2),
            child: Text(
              (chat['name'] as String).substring(0, 1),
              style: TextStyle(
                fontFamily: 'Changa',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
          if (chat['online'] == true)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppTheme.darkBg : AppTheme.lightBg,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat['name'],
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
          color: isDark ? Colors.white : AppTheme.lightText,
        ),
      ),
      subtitle: Text(
        chat['message'],
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chat['time'],
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: isDark ? Colors.white40 : Colors.black38,
            ),
          ),
          if (unreadCount > 0) ...[
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$unreadCount',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: chat['name'],
              isOnline: chat['online'],
            ),
          ),
        );
      },
    ).animate()
     .fadeIn(delay: (index * 100).ms)
     .slideX(begin: 0.2, end: 0);
  }
}
