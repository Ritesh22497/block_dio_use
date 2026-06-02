// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String dbName = 'reels.db';
  static const int dbVersion = 1;
  static const String videosTable = 'videos';

  static const int preloadAhead = 2;
  static const int preloadBehind = 1;
  static const String demoVideoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

static const List<Map<String, String>> demoVideos = [
  {
    'title': 'Video 1',
    'username': 'creator_1',
    'caption': 'Demo Reel 1',
    'audio': 'Original Audio',
    'url': demoVideoUrl,
    'category': 'Trending',
    'color': '0xFF2196F3',
  },
  {
    'title': 'Video 2',
    'username': 'creator_2',
    'caption': 'Demo Reel 2',
    'audio': 'Original Audio',
    'url': demoVideoUrl,
    'category': 'Travel',
    'color': '0xFFFF5722',
  },
  {
    'title': 'Video 3',
    'username': 'creator_3',
    'caption': 'Demo Reel 3',
    'audio': 'Original Audio',
    'url': demoVideoUrl,
    'category': 'Music',
    'color': '0xFF4CAF50',
  },
];
// static const List<Map<String, String>> demoVideos = [
//   {
//     'title': 'Video 1',
//     'username': 'user1',
//     'caption': 'Demo Video',
//     'audio': 'Audio',
//     'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
//     'category': 'Demo',
//     'color': '0xFF2196F3',
//   },
// ];
  // Demo video URLs (free, no auth, public domain)
  static const List<Map<String, String>> demoVideos2 = [
    {
      'title': 'Big Buck Bunny',
      'username': 'blender_studio',
      'caption': '🐰 The classic open-source animated film. A big friendly bunny deals with a rodent bully 🎬 #animation #blender #classic',
      'audio': 'Big Buck Bunny OST',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'category': 'Animation',
      'color': '0xFF6C63FF',
    },
    {
      'title': 'Elephant Dream',
      'username': 'orange_open',
      'caption': '🐘 The first open movie by Blender Foundation. Surreal and dreamlike journey 🌙 #surreal #art #openfilm',
      'audio': 'Elephant Dream Soundtrack',
      'url': "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      'category': 'Art',
      'color': '0xFFFF6584',
    },
    {
      'title': 'For Bigger Blazes',
      'username': 'google_ads',
      'caption': '🔥 Feel the heat. Premium cinematic content for bigger screens 🎥 #cinematic #fire #hd',
      'audio': 'Epic Cinematic',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'category': 'Cinematic',
      'color': '0xFFFF8C42',
    },
    {
      'title': 'For Bigger Escapes',
      'username': 'travel_vibes',
      'caption': '✈️ Adventure awaits. Pack your bags and discover the world 🌍 #travel #adventure #explore',
      'audio': 'Adventure Beats',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'category': 'Travel',
      'color': '0xFF43C6AC',
    },
    {
      'title': 'For Bigger Fun',
      'username': 'fun_clips',
      'caption': '😂 When the fun is BIGGER than expected! Drop a 🎉 if you want more 🤩 #fun #vibes #trending',
      'audio': 'Happy Beats',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'category': 'Fun',
      'color': '0xFFFFD93D',
    },
    {
      'title': 'For Bigger Joyrides',
      'username': 'speed_freaks',
      'caption': '🏎️ Zero to 100 in style. This is what speed looks like 💨 #racing #cars #speed',
      'audio': 'Fast Lane',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'category': 'Speed',
      'color': '0xFF4ECDC4',
    },
    {
      'title': 'For Bigger Meltdowns',
      'username': 'drama_reel',
      'caption': '😤 Sometimes you just need to let it all out. Relatable? 💥 #drama #mood #relatable',
      'audio': 'Dramatic Symphony',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'category': 'Drama',
      'color': '0xFFE84393',
    },
    {
      'title': 'Subaru Outback',
      'username': 'auto_world',
      'caption': '🚗 Go anywhere. Do anything. The Subaru Outback — built for adventure 🏔️ #cars #suv #adventure',
      'audio': 'Road Trip Vibes',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'category': 'Auto',
      'color': '0xFF667EEA',
    },
    {
      'title': 'Tears of Steel',
      'username': 'blender_vfx',
      'caption': '⚡ Humans vs machines. The future is now. Open movie by Blender Institute 🤖 #scifi #vfx #future',
      'audio': 'Tears of Steel OST',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'category': 'Sci-Fi',
      'color': '0xFF2196F3',
    },
    {
      'title': 'Volkswagen GTI',
      'username': 'car_culture',
      'caption': '🔥 The GTI. Fast. Sharp. Iconic. This is German engineering at its finest 🇩🇪 #vw #gti #carculture',
      'audio': 'GTI Official',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
      'category': 'Review',
      'color': '0xFFFF5722',
    },
  ];
}
