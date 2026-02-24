import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
      ),
      home: const SocialMediaUI(),
    );
  }
}

class SocialMediaUI extends StatefulWidget {
  const SocialMediaUI({super.key});

  @override
  State<SocialMediaUI> createState() => _SocialMediaUIState();
}

class _SocialMediaUIState extends State<SocialMediaUI> {
  int _selectedIndex = 0;

  // Function para sa Logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Sigurado ka ba na gusto mong lumabas?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hindi")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Naka-logout na!")),
              );
            },
            child: const Text("Oo", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("INSTAGRAM", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // NOTIFICATION BUTTON
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Wala pang bagong notifications.")),
              );
            },
          ),
          // LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: ListView(
        children: const [
          PostWidget(
            username: "MELAN",
            caption: "Enjoying my day! ☀️",
            imageUrl: "https://picsum.photos/400/300?random=1",
          ),
          VideoPostWidget(
            username: "REALYN",
            caption: "Check out this cool video! 🎥",
            videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          ),
          PostWidget(
            username: "ANGEL GRACE",
            caption: "Workout mode 💪",
            imageUrl: "https://picsum.photos/400/300?random=3",
          ),
          VideoPostWidget(
            username: "DONNA",
            caption: "Nature is beautiful 🌿",
            videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          ),
          PostWidget(
            username: "ARVI",
            caption: "Late night coding 💻",
            imageUrl: "https://picsum.photos/400/300?random=5",
          ),
          VideoPostWidget(
            username: "CYRA",
            caption: "Relaxing vibes ✨",
            videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          ),
        ],
      ),
      // BOTTOM NAVIGATION BUTTONS
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// --- COMMON ACTION BUTTONS (LIKE, COMMENT, SHARE) ---
class PostActionButtons extends StatefulWidget {
  const PostActionButtons({super.key});

  @override
  State<PostActionButtons> createState() => _PostActionButtonsState();
}

class _PostActionButtonsState extends State<PostActionButtons> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black),
          onPressed: () => setState(() => isLiked = !isLiked),
        ),
        IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
        IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
        const Spacer(),
        IconButton(
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () => setState(() => isSaved = !isSaved),
        ),
      ],
    );
  }
}

// --- WIDGET PARA SA IMAGE POST ---
class PostWidget extends StatelessWidget {
  final String username;
  final String caption;
  final String imageUrl;

  const PostWidget({super.key, required this.username, required this.caption, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$username"),
          ),
          title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.more_horiz),
        ),
        Image.network(imageUrl, width: double.infinity, height: 300, fit: BoxFit.cover),
        const PostActionButtons(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(text: "$username ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: caption),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// --- WIDGET PARA SA VIDEO POST ---
class VideoPostWidget extends StatefulWidget {
  final String username;
  final String caption;
  final String videoUrl;

  const VideoPostWidget({super.key, required this.username, required this.caption, required this.videoUrl});

  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${widget.username}"),
          ),
          title: Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.more_horiz),
        ),
        GestureDetector(
          onTap: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()),
          child: Container(
            color: Colors.black,
            height: 300,
            width: double.infinity,
            child: _controller.value.isInitialized
                ? Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
                if (!_controller.value.isPlaying)
                  const Icon(Icons.play_circle_fill, size: 60, color: Colors.white70),
              ],
            )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
        const PostActionButtons(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(text: "${widget.username} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.caption),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}