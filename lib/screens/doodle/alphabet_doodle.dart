// lib/screens/doodle/alphabet_doodle.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class AlphabetDoodleScreen extends StatefulWidget {
  @override
  _AlphabetDoodleScreenState createState() => _AlphabetDoodleScreenState();
}

class _AlphabetDoodleScreenState extends State<AlphabetDoodleScreen> {
  List<String> letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];
  
  int currentLetterIndex = 0;
  List<List<Offset>> allStrokes = []; // Store multiple stroke paths
  List<Offset> currentStroke = []; // Current stroke being drawn
  bool isComplete = false;
  int completedLetters = 0;
  
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
                  'Trace the letter with your finger!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
              
              // Drawing Canvas
              Expanded(
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      // Start new stroke, don't clear old ones
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
                      // Save the completed stroke
                      if (currentStroke.isNotEmpty) {
                        allStrokes.add(List.from(currentStroke));
                      }
                      currentStroke = [];
                      _checkCompletion();
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
                      painter: LetterTracingPainter(
                        letter: letters[currentLetterIndex],
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
            'Alphabet Tracing',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          Text(
            '${letters[currentLetterIndex]}',
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
            value: completedLetters / letters.length,
            backgroundColor: AppColors.cardDark,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Text(
            '$completedLetters / ${letters.length} completed',
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
            ),
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
            label: Text('Try Again', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          if (isComplete)
            ElevatedButton.icon(
              onPressed: _moveToNextLetter,
              icon: Icon(Icons.arrow_forward, size: 22),
              label: Text('Next Letter', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
  
  void _moveToNextLetter() {
    if (currentLetterIndex < letters.length - 1) {
      setState(() {
        currentLetterIndex++;
        completedLetters++;
        allStrokes.clear();
        currentStroke.clear();
        isComplete = false;
      });
    } else {
      _showCompletionDialog();
    }
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🎉 Congratulations!',
          style: TextStyle(color: AppColors.neonGreen, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'You have completed all letters!\nGreat job!',
          style: TextStyle(color: AppColors.textWhite, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done', style: TextStyle(color: AppColors.neonGreen, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class LetterTracingPainter extends CustomPainter {
  final String letter;
  final List<List<Offset>> allStrokes;
  final List<Offset> currentStroke;
  final bool isComplete;
  
  LetterTracingPainter({
    required this.letter,
    required this.allStrokes,
    required this.currentStroke,
    required this.isComplete,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw letter outline/template
    _drawLetterTemplate(canvas, letter, centerX, centerY);
    
    // Draw all completed strokes (they stay on screen)
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
    
    // Draw current stroke being drawn
    if (currentStroke.isNotEmpty) {
      Paint currentStrokePaint = Paint()
        ..color = AppColors.neonGreen
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      for (int i = 0; i < currentStroke.length - 1; i++) {
        canvas.drawLine(currentStroke[i], currentStroke[i + 1], currentStrokePaint);
      }
    }
    
    if (isComplete) {
      _drawSuccessIndicator(canvas, size);
    }
  }
  
  void _drawLetterTemplate(Canvas canvas, String letter, double x, double y) {
    // Draw large semi-transparent letter as guide
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
    textPainter.paint(canvas, Offset(x - 100, y - 150));
  }
  
  void _drawSuccessIndicator(Canvas canvas, Size size) {
    Paint successPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width - 50, 50), 30, successPaint);
    
    Paint checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(Offset(size.width - 60, 50), Offset(size.width - 50, 60), checkPaint);
    canvas.drawLine(Offset(size.width - 50, 60), Offset(size.width - 35, 40), checkPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}