import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
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
              Color(0xFF000000),
              Color(0xFF064E3B),
              Color(0xFF10B981),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedCircle(),

                      SizedBox(height: 50),

                      Text(
                        'Digital Pehchaan',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                          letterSpacing: 1.5,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'The Street School',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.mintGreen,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),

                      SizedBox(height: 40),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Learn anything,\nanywhere',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                            height: 1.3,
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          'Quality education for every child',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGray,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textWhite,
                      foregroundColor: AppColors.primaryBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  Widget _buildAnimatedCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            children: [
              _buildPositionedIcon('👨‍🎓', 0, -110),
              _buildPositionedIcon('📚', 80, -80),
              _buildPositionedIcon('👩‍🎓', 110, 0),
              _buildPositionedIcon('🎓', -80, 80),
              _buildPositionedIcon('🎯', 0, 110),
              _buildPositionedIcon('👨‍💼', 80, 80),
              _buildPositionedIcon('🎒', -110, 0),
              _buildPositionedIcon('🔬', -80, -80),
            ],
          ),
        ),

        // CENTER LOGO USING playstore.png
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.neonGreen.withOpacity(0.3),
                AppColors.emeraldGreen.withOpacity(0.3),
              ],
            ),
            border: Border.all(
              color: AppColors.neonGreen.withOpacity(0.6),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/playstore.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionedIcon(String emoji, double x, double y) {
    return Positioned(
      left: 160 + x - 25,
      top: 160 + y - 25,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cardDark.withOpacity(0.8),
          border: Border.all(
            color: AppColors.neonGreen.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
