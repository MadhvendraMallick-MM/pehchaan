// lib/screens/classes/classes_list_screen.dart - WITH BACK BUTTON
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class ClassesListScreen extends StatefulWidget {
  @override
  _ClassesListScreenState createState() => _ClassesListScreenState();
}

class _ClassesListScreenState extends State<ClassesListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedTab = 'Classes';
  String selectedSubject = 'All Subjects';
  Set<String> savedVideoIds = {};
  
  final List<String> subjects = [
    'All Subjects',
    'Mathematics',
    'Science',
    'English',
    'Hindi',
    'Social Science',
    'Computer Science',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedVideos();
  }
  
  Future<void> _loadSavedVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedVideoIds = prefs.getStringList('savedVideos')?.toSet() ?? {};
    });
  }
  
  Future<void> _toggleSaveVideo(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (savedVideoIds.contains(videoId)) {
        savedVideoIds.remove(videoId);
      } else {
        savedVideoIds.add(videoId);
      }
    });
    await prefs.setStringList('savedVideos', savedVideoIds.toList());
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  final List<ClassVideo> allVideos = [
    ClassVideo(
      title: 'Algebra Basics - Introduction',
      instructor: 'Khan Academy',
      subject: 'Mathematics',
      level: 'Class 8',
      videoId: 'NybHckSEQBI',
      thumbnail: 'https://img.youtube.com/vi/NybHckSEQBI/maxresdefault.jpg',
    ),
    ClassVideo(
      title: 'Geometry - Triangles',
      instructor: 'Math Antics',
      subject: 'Mathematics',
      level: 'Class 9',
      videoId: '4RrMDDrNFWk',
      thumbnail: 'https://img.youtube.com/vi/4RrMDDrNFWk/maxresdefault.jpg',
    ),
    ClassVideo(
      title: 'Photosynthesis Explained',
      instructor: 'Amoeba Sisters',
      subject: 'Science',
      level: 'Class 7',
      videoId: 'UPBMG5EYydo',
      thumbnail: 'https://img.youtube.com/vi/UPBMG5EYydo/maxresdefault.jpg',
    ),
    ClassVideo(
      title: 'States of Matter',
      instructor: 'Bozeman Science',
      subject: 'Science',
      level: 'Class 6',
      videoId: 'pNLJKOz6hcU',
      thumbnail: 'https://img.youtube.com/vi/pNLJKOz6hcU/maxresdefault.jpg',
    ),
    ClassVideo(
      title: 'Grammar Fundamentals',
      instructor: 'English Lessons',
      subject: 'English',
      level: 'Class 5',
      videoId: '1u7rHvALZOk',
      thumbnail: 'https://img.youtube.com/vi/1u7rHvALZOk/maxresdefault.jpg',
    ),
    ClassVideo(
      title: 'हिंदी व्याकरण - संज्ञा',
      instructor: 'Magnet Brains',
      subject: 'Hindi',
      level: 'Class 6',
      videoId: 'pWjMvrkUqX0',
      thumbnail: 'https://img.youtube.com/vi/pWjMvrkUqX0/maxresdefault.jpg',
    ),
  ];
  
  List<ClassVideo> get filteredVideos {
    if (selectedSubject == 'All Subjects') {
      return allVideos;
    }
    return allVideos.where((v) => v.subject == selectedSubject).toList();
  }
  
  List<ClassVideo> get savedVideos {
    return allVideos.where((v) => savedVideoIds.contains(v.videoId)).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
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
            // Header with back button
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textWhite, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'My Classes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                  // Settings button (placeholder for symmetry)
                  IconButton(
                    icon: Icon(Icons.settings, color: AppColors.neonGreen, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Subject dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                ),
                child: DropdownButton<String>(
                  value: selectedSubject,
                  isExpanded: true,
                  dropdownColor: AppColors.cardDark,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.neonGreen),
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value!;
                    });
                  },
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Tab bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('Classes'),
                  _buildTab('Saved'),
                  _buildTab('Live Classes'),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Content
            Expanded(
              child: selectedTab == 'Classes'
                  ? _buildClassesList()
                  : selectedTab == 'Saved'
                      ? _buildSavedList()
                      : _buildLiveClassesPlaceholder(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTab(String title) {
    bool isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.neonGreen : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.textWhite : AppColors.textGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildClassesList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredVideos.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(filteredVideos[index]);
      },
    );
  }
  
  Widget _buildSavedList() {
    if (savedVideos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: AppColors.textGray),
            SizedBox(height: 16),
            Text(
              'No saved videos yet',
              style: TextStyle(color: AppColors.textGray, fontSize: 18),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: savedVideos.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(savedVideos[index]);
      },
    );
  }
  
  Widget _buildLiveClassesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_call, size: 80, color: AppColors.neonGreen),
          SizedBox(height: 16),
          Text(
            'Live Classes',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Live streaming classes coming soon!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGray, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVideoCard(ClassVideo video) {
    bool isSaved = savedVideoIds.contains(video.videoId);
    
    return GestureDetector(
      onTap: () => _playYouTubeVideo(video.videoId),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 130,
                height: 110,
                color: AppColors.cardDarker,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      video.thumbnail,
                      fit: BoxFit.cover,
                      width: 130,
                      height: 110,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.play_circle_outline,
                            size: 50, color: AppColors.neonGreen);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, color: AppColors.textWhite, size: 30),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            video.level,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? AppColors.neonGreen : AppColors.textGray,
                            size: 22,
                          ),
                          onPressed: () => _toggleSaveVideo(video.videoId),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      video.instructor,
                      style: TextStyle(fontSize: 13, color: AppColors.textGray),
                    ),
                    SizedBox(height: 2),
                    Text(
                      video.subject,
                      style: TextStyle(fontSize: 12, color: AppColors.mintGreen),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _playYouTubeVideo(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open video'), backgroundColor: AppColors.error),
      );
    }
  }
}

class ClassVideo {
  final String title;
  final String instructor;
  final String subject;
  final String level;
  final String videoId;
  final String thumbnail;
  
  ClassVideo({
    required this.title,
    required this.instructor,
    required this.subject,
    required this.level,
    required this.videoId,
    required this.thumbnail,
  });
}