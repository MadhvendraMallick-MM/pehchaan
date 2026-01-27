// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'doodle/alphabet_doodle.dart';
import 'doodle/number_doodle.dart';
import 'doodle/hindi_doodle.dart';
import 'ai_assistant/ai_chat_screen.dart';
import 'classes/classes_list_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeContentScreen(),
    AIChatScreen(),
    ClassesListScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDarker,
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.neonGreen,
          unselectedItemColor: AppColors.textGray,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_rounded, size: 28),
              label: 'AI Explorer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded, size: 28),
              label: 'My Classes',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resource',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                            ),
                          ),
                          Text(
                            'Pehchaan - The Street School',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mintGreen,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsScreen()),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonGreen.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(Icons.settings, color: AppColors.primaryBlack, size: 24),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 35),
                  
                  // Three Doodle Boxes - BIGGER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDoodleCard(
                        context,
                        'Geometrical',
                        'ABCD...',
                        '🔤',
                        AppColors.doodlePink,
                        screenWidth,
                        () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AlphabetDoodleScreen()
                        )),
                      ),
                      _buildDoodleCard(
                        context,
                        'Hand Design',
                        '123...',
                        '🔢',
                        AppColors.doodleYellow,
                        screenWidth,
                        () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => NumberDoodleScreen()
                        )),
                      ),
                      _buildDoodleCard(
                        context,
                        'Texture',
                        'क ख ग...',
                        '🔤',
                        AppColors.doodlePurple,
                        screenWidth,
                        () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HindiDoodleScreen()
                        )),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 35),
                  
                  // AI Assistant Card - BIGGER
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AIChatScreen()
                    )),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF60A5FA),
                            Color(0xFF3B82F6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentBlue.withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get the full access in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textWhite.withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'AI Assistant',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlack,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Get it',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('🤖', style: TextStyle(fontSize: 80)),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Pre-recorded Classes Card - BIGGER
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ClassesListScreen()
                    )),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6EE7B7),
                            Color(0xFF34D399),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mintGreen.withOpacity(0.4),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get the full access in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlack.withOpacity(0.8),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Video Classes',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlack,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlack,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Get it',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('📚', style: TextStyle(fontSize: 80)),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDoodleCard(
    BuildContext context,
    String title,
    String subtitle,
    String emoji,
    Color color,
    double screenWidth,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.29,
        height: 170,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 48)),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlack,
              ),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}