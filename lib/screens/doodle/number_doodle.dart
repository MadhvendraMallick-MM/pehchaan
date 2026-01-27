// lib/screens/doodle/number_doodle.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class NumberDoodleScreen extends StatefulWidget {
  @override
  _NumberDoodleScreenState createState() => _NumberDoodleScreenState();
}

class _NumberDoodleScreenState extends State<NumberDoodleScreen> {
  int currentNumber = 1;
  List<List<Offset>> allStrokes = []; // Multiple strokes
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
                  'Trace number $currentNumber',
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
                      painter: NumberTracingPainter(
                        number: currentNumber,
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
            'Number Tracing',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          Text(
            '$currentNumber',
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
            value: (currentNumber - 1) / 100,
            backgroundColor: AppColors.cardDark,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Text(
            '$currentNumber / 100 completed',
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
            label: Text('Try Again', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            ),
          ),
          if (isComplete)
            ElevatedButton.icon(
              onPressed: () {
                if (currentNumber < 100) {
                  setState(() {
                    currentNumber++;
                    allStrokes.clear();
                    currentStroke.clear();
                    isComplete = false;
                  });
                }
              },
              icon: Icon(Icons.arrow_forward, size: 22),
              label: Text('Next', style: TextStyle(fontSize: 16)),
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

class NumberTracingPainter extends CustomPainter {
  final int number;
  final List<List<Offset>> allStrokes;
  final List<Offset> currentStroke;
  final bool isComplete;
  
  NumberTracingPainter({
    required this.number,
    required this.allStrokes,
    required this.currentStroke,
    required this.isComplete,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw number template
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: number.toString(),
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
    textPainter.paint(canvas, Offset(centerX - 80, centerY - 150));
    
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
        canvas.drawLine(currentStroke[i], currentStroke[i + 1], completedStrokePaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

