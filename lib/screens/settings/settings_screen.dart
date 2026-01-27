// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';
  bool notificationsEnabled = true;
  bool soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'English';
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      soundEnabled = prefs.getBool('sound') ?? true;
    });
  }

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      selectedLanguage = language;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      notificationsEnabled = value;
    });
  }

  Future<void> _toggleSound(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', value);
    setState(() {
      soundEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundDark,
              AppColors.darkGreen,
              AppColors.emeraldGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textWhite,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    SizedBox(height: 10),

                    // App Settings Section
                    _buildSectionHeader('App Settings'),

                    _buildSettingCard(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: selectedLanguage,
                      onTap: () => _showLanguageDialog(),
                    ),

                    _buildSwitchCard(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Get updates about new classes',
                      value: notificationsEnabled,
                      onChanged: _toggleNotifications,
                    ),

                    _buildSwitchCard(
                      icon: Icons.volume_up,
                      title: 'Sound Effects',
                      subtitle: 'Enable app sounds',
                      value: soundEnabled,
                      onChanged: _toggleSound,
                    ),

                    SizedBox(height: 20),

                    // Support Section
                    _buildSectionHeader('Support'),

                    _buildSettingCard(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help with the app',
                      onTap: () => _showHelpDialog(),
                    ),

                    _buildSettingCard(
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Help us improve',
                      onTap: () => _showFeedbackDialog(),
                    ),

                    SizedBox(height: 20),

                    // About Section
                    _buildSectionHeader('About'),

                    _buildSettingCard(
                      icon: Icons.info_outline,
                      title: 'About Pehchaan',
                      subtitle: 'Learn about our initiative',
                      onTap: () => _showAboutDialog(),
                    ),

                    _buildSettingCard(
                      icon: Icons.article,
                      title: 'Terms & Conditions',
                      subtitle: 'App terms and policies',
                      onTap: () => _showTermsDialog(),
                    ),

                    SizedBox(height: 20),

                    // App Version
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'E-LearnUp',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              color: AppColors.textGray.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '© 2025 Pehchaan - The Street School',
                            style: TextStyle(
                              color: AppColors.textGray.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.neonGreen,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.neonGreen, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppColors.textGray, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textGray, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.neonGreen, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textGray, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.neonGreen,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Select Language',
          style: TextStyle(color: AppColors.textWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('हिंदी (Hindi)'),
            _buildLanguageOption('मराठी (Marathi)'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language, style: TextStyle(color: AppColors.textWhite)),
      value: language,
      groupValue: selectedLanguage,
      activeColor: AppColors.neonGreen,
      onChanged: (value) {
        _saveLanguage(value!);
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.school, color: AppColors.neonGreen, size: 28),
            SizedBox(width: 12),
            Text(
              'About Pehchaan',
              style: TextStyle(color: AppColors.neonGreen),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pehchaan - The Street School',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Mission',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pehchaan is dedicated to providing quality education to underprivileged children through street schools and digital platforms. We believe every child deserves the opportunity to learn and grow.',
                style: TextStyle(color: AppColors.textGray, height: 1.5),
              ),
              SizedBox(height: 16),
              Text(
                'Our Initiative',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Free education for street children\n• Interactive learning through technology\n• Skill development programs\n• Career guidance and mentorship\n• Community development',
                style: TextStyle(color: AppColors.textGray, height: 1.5),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Developer: Madhvendra Mallick\nEmail: 27-madhvendra.mallick@fiib.edu.in\nWebsite: https://pehchaanstreetschool.org\nPhone: +91-6395421017',
                style: TextStyle(color: AppColors.textGray, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.neonGreen, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Help & Support',
          style: TextStyle(color: AppColors.neonGreen),
        ),
        content: Text(
          'Need help? Contact us at:\n\n27-madhvendra.mallick@fiib.edu.in\n\nOr visit our help center for FAQs and tutorials.',
          style: TextStyle(color: AppColors.textWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.neonGreen)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Send Feedback',
          style: TextStyle(color: AppColors.neonGreen),
        ),
        content: Text(
          'We\'d love to hear from you!\n\nSend your feedback to:\n27-madhvendra.mallick@fiib.edu.in',
          style: TextStyle(color: AppColors.textWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.neonGreen)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(color: AppColors.neonGreen),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Terms of Use:\n\n1. This app is for educational purposes only.\n2. All content is provided as-is.\n3. We respect user privacy.\n4. No data is sold to third parties.\n5. Use the app responsibly.\n\nFor complete terms, visit our website.',
            style: TextStyle(color: AppColors.textWhite),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.neonGreen)),
          ),
        ],
      ),
    );
  }
}
