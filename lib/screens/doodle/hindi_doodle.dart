// ============================================================================
// lib/screens/doodle/hindi_doodle.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class HindiDoodleScreen extends StatefulWidget {
  @override
  _HindiDoodleScreenState createState() => _HindiDoodleScreenState();
}

class _HindiDoodleScreenState extends State<HindiDoodleScreen> {
  List<String> hindiLetters = [
    'क',
    'ख',
    'ग',
    'घ',
    'ङ',
    'च',
    'छ',
    'ज',
    'झ',
    'ञ',
    'ट',
    'ठ',
    'ड',
    'ढ',
    'ण',
    'त',
    'थ',
    'द',
    'ध',
    'न',
    'प',
    'फ',
    'ब',
    'भ',
    'म',
    'य',
    'र',
    'ल',
    'व',
    'श',
    'ष',
    'स',
    'ह',
    'क्ष',
    'त्र',
    'ज्ञ',
  ];

  int currentLetterIndex = 0;
  List<List<Offset>> allStrokes = [];
  List<Offset> currentStroke = [];
  bool isComplete = false;

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
              _buildHeader(),
              _buildProgressBar(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'हिंदी वर्णमाला - Trace the letter!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      currentStroke = [];
                      currentStroke.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      currentStroke.add(details.localPosition);
                      _checkCompletion();
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      if (currentStroke.isNotEmpty) {
                        allStrokes.add(List.from(currentStroke));
                      }
                      currentStroke = [];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.neonGreen.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: CustomPaint(
                      painter: HindiTracingPainter(
                        letter: hindiLetters[currentLetterIndex],
                        allStrokes: allStrokes,
                        currentStroke: currentStroke,
                        isComplete: isComplete,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textWhite, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Hindi Varnamala',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          Text(
            hindiLetters[currentLetterIndex],
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.neonGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: currentLetterIndex / hindiLetters.length,
            backgroundColor: AppColors.cardDark,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Text(
            '$currentLetterIndex / ${hindiLetters.length} completed',
            style: TextStyle(color: AppColors.textGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                allStrokes.clear();
                currentStroke.clear();
                isComplete = false;
              });
            },
            icon: Icon(Icons.refresh, size: 22),
            label: Text('फिर से', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            ),
          ),
          if (isComplete)
            ElevatedButton.icon(
              onPressed: () {
                if (currentLetterIndex < hindiLetters.length - 1) {
                  setState(() {
                    currentLetterIndex++;
                    allStrokes.clear();
                    currentStroke.clear();
                    isComplete = false;
                  });
                }
              },
              icon: Icon(Icons.arrow_forward, size: 22),
              label: Text('अगला', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              ),
            ),
        ],
      ),
    );
  }

  void _checkCompletion() {
    int totalPoints = 0;
    for (var stroke in allStrokes) {
      totalPoints += stroke.length;
    }
    totalPoints += currentStroke.length;

    if (totalPoints > 50) {
      setState(() {
        isComplete = true;
      });
    }
  }
}

class HindiTracingPainter extends CustomPainter {
  final String letter;
  final List<List<Offset>> allStrokes;
  final List<Offset> currentStroke;
  final bool isComplete;

  HindiTracingPainter({
    required this.letter,
    required this.allStrokes,
    required this.currentStroke,
    required this.isComplete,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw Hindi letter template
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: 250,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = AppColors.textGray.withOpacity(0.4),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(centerX - 100, centerY - 150));

    // Draw all completed strokes
    Paint completedStrokePaint = Paint()
      ..color = isComplete ? Colors.green : AppColors.neonGreen
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var stroke in allStrokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], completedStrokePaint);
      }
    }

    // Draw current stroke
    if (currentStroke.isNotEmpty) {
      for (int i = 0; i < currentStroke.length - 1; i++) {
        canvas.drawLine(
          currentStroke[i],
          currentStroke[i + 1],
          completedStrokePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}