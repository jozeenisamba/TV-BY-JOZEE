
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TVByJozeeApp());
}

const Color bg = Color(0xFF080B12);
const Color panel = Color(0xFF111827);
const Color panel2 = Color(0xFF1B2433);
const Color accent = Color(0xFFE50932);
const Color gold = Color(0xFFFFC928);

class TVChannel {
  final String name;
  final String country;
  final String category;
  final String description;
  final String streamUrl;
  final IconData icon;

  const TVChannel({
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    required this.streamUrl,
    required this.icon,
  });
}

const List<TVChannel> channels = [
  TVChannel(
    name: 'BBC News',
    country: 'United Kingdom',
    category: 'News',
    description: 'International news and current affairs',
    streamUrl: '',
    icon: Icons.public,
  ),
  TVChannel(
    name: 'Al Jazeera',
    country: 'Qatar',
    category: 'News',
    description: 'Global news and documentaries',
    streamUrl: '',
    icon: Icons.language,
  ),
  TVChannel(
    name: 'France 24',
    country: 'France',
    category: 'News',
    description: 'International news from France',
    streamUrl: '',
    icon: Icons.newspaper,
  ),
  TVChannel(
    name: 'DW News',
    country: 'Germany',
    category: 'News',
    description: 'News and information from Germany',
    streamUrl: '',
    icon: Icons.public,
  ),
  TVChannel(
    name: 'NASA TV',
    country: 'United States',
    category: 'Documentary',
    description: 'Space, science and exploration',
    streamUrl: '',
    icon: Icons.rocket_launch,
  ),
  TVChannel(
    name: 'CGTN',
    country: 'China',
    category: 'News',
    description: 'International news',
    streamUrl: '',
    icon: Icons.travel_explore,
  ),
  TVChannel(
    name: 'Euronews',
    country: 'Europe',
    category: 'News',
    description: 'European and international news',
    streamUrl: '',
    icon: Icons.public,
  ),
];

class TVByJozeeApp extends StatelessWidget {
  const TVByJozeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV BY JOZEE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.dark(
          primary: accent,
          secondary: gold,
          surface: panel,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TVHomePage(),
    );
  }
}

class TVHomePage extends StatefulWidget {
  const TVHomePage({super.key});

  @override
  State<TVHomePage> createState() => _TVHomePageState();
}

class _TVHomePageState extends State<TVHomePage> {
  int selectedTab = 0;
  String selectedCategory = 'All';
  String searchText = '';
  TVChannel? selectedChannel;
  final Set<String> favorites = {};
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'News',
    'Sports',
    'Movies',
    'Music',
    'Entertainment',
    'Documentary',
    'Kids',
  ];

  List<TVChannel> get filteredChannels {
    return channels.where((channel) {
      final categoryMatch = selectedCategory == 'All' ||
          channel.category == selectedCategory;
      final query = searchText.toLowerCase();
      final searchMatch = channel.name.toLowerCase().contains(query) ||
          channel.country.toLowerCase().contains(query);
      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openChannel(TVChannel channel) {
    setState(() => selectedChannel = channel);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerPage(channel: channel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTV = width >= 900;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isTV) _sideNavigation(),
            Expanded(
              child: Column(
                children: [
                  _topBar(isTV),
                  Expanded(child: _mainContent(isTV)),
                  if (!isTV) _bottomNavigation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(bool isTV) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 35 : 18,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        children: [
          if (!isTV) ...[
            const Icon(Icons.live_tv, color: accent, size: 30),
            const SizedBox(width: 9),
          ],
          const Text(
            'TV BY ',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const Text(
            'JOZEE',
            style: TextStyle(
              color: accent,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          if (isTV)
            const Text(
              'YOUR WORLD. YOUR TV.',
              style: TextStyle(
                color: Colors.white54,
                letterSpacing: 2,
                fontSize: 11,
              ),
            ),
          const SizedBox(width: 18),
          const Icon(Icons.wifi, color: Colors.greenAccent, size: 18),
        ],
      ),
    );
  }

  Widget _sideNavigation() {
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.live_tv_outlined, 'Live TV'),
      (Icons.favorite_outline, 'Favorites'),
      (Icons.public, 'Countries'),
    ];

    return Container(
      width: 190,
      color: panel,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'EXPLORE',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++)
            _navItem(items[i].$1, items[i].$2, i),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'TV BY JOZEE © 2026',
              style: TextStyle(color: Colors.white30, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final active = selectedTab == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Focus(
        child: Builder(
          builder: (context) {
            final focused = Focus.of(context).hasFocus;
            return InkWell(
              autofocus: index == 0,
              onTap: () => setState(() => selectedTab = index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: focused
                      ? accent.withValues(alpha: 0.35)
                      : active
                          ? accent.withValues(alpha: 0.16)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: focused ? accent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: active ? accent : Colors.white70),
                    const SizedBox(width: 12),
                    Text(label),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _mainContent(bool isTV) {
    if (selectedTab == 2) return _favoritesPage(isTV);
    if (selectedTab == 3) return _countriesPage(isTV);

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: isTV ? 35 : 18,
        vertical: 22,
      ),
      children: [
        _heroBanner(isTV),
        const SizedBox(height: 28),
        _sectionTitle('EXPLORE CHANNELS', 'Discover television worldwide'),
        const SizedBox(height: 15),
        _searchBox(),
        const SizedBox(height: 18),
        _categoryList(),
        const SizedBox(height: 25),
        _sectionTitle('LIVE CHANNELS', '${filteredChannels.length} channels'),
        const SizedBox(height: 15),
        _channelGrid(isTV),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'TV BY JOZEE • ENTERTAINMENT WITHOUT BORDERS',
            style: TextStyle(color: Colors.white30, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _heroBanner(bool isTV) {
    return Container(
      height: isTV ? 260 : 205,
      padding: EdgeInsets.all(isTV ? 32 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF751027), Color(0xFF25101D), Color(0xFF121827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'WELCOME TO TV BY JOZEE',
                  style: TextStyle(
                    color: gold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'THE WORLD\\nAT YOUR FINGERTIPS.',
                  style: TextStyle(
                    fontSize: isTV ? 32 : 24,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'News • Sports • Movies • Music • More',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isTV)
            const Icon(
              Icons.live_tv,
              size: 105,
              color: Colors.white24,
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: searchController,
      onChanged: (value) => setState(() => searchText = value),
      decoration: InputDecoration(
        hintText: 'Search channels or countries...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: panel,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _categoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final active = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ChoiceChip(
              label: Text(category),
              selected: active,
              selectedColor: accent,
              backgroundColor: panel,
              onSelected: (_) {
                setState(() => selectedCategory = category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _channelGrid(bool isTV) {
    if (filteredChannels.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Center(
          child: Text('No channels found.'),
        ),
      );
    }

    final columns = isTV ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredChannels.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 13,
        mainAxisSpacing: 13,
        childAspectRatio: isTV ? 1.45 : 0.95,
      ),
      itemBuilder: (context, index) {
        final channel = filteredChannels[index];
        return _channelCard(channel, isTV);
      },
    );
  }

  Widget _channelCard(TVChannel channel, bool isTV) {
    final isFavorite = favorites.contains(channel.name);

    return Focus(
      child: Builder(
        builder: (context) {
          final focused = Focus.of(context).hasFocus;
          return InkWell(
            onTap: () => openChannel(channel),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: focused ? panel2 : panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: focused ? gold : Colors.white10,
                  width: focused ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isTV ? 48 : 39,
                        height: isTV ? 48 : 39,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.17),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          channel.icon,
                          color: accent,
                          size: isTV ? 25 : 21,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favorites.remove(channel.name);
                            } else {
                              favorites.add(channel.name);
                            }
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? accent : Colors.white54,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    channel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    channel.country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.circle, color: accent, size: 8),
                      SizedBox(width: 5),
                      Text(
                        'CHANNEL',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _favoritesPage(bool isTV) {
    final favoriteChannels = channels
        .where((channel) => favorites.contains(channel.name))
        .toList();

    return ListView(
      padding: EdgeInsets.all(isTV ? 35 : 18),
      children: [
        _sectionTitle('MY FAVORITES', 'Your saved channels'),
        const SizedBox(height: 20),
        if (favoriteChannels.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(45),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 55, color: accent),
                  SizedBox(height: 12),
                  Text('No favorite channels yet'),
                  Text(
                    'Select the heart icon on a channel to save it.',
                    style: TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...favoriteChannels.map(
            (channel) => ListTile(
              leading: const Icon(Icons.live_tv, color: accent),
              title: Text(channel.name),
              subtitle: Text(channel.country),
              onTap: () => openChannel(channel),
            ),
          ),
      ],
    );
  }

  Widget _countriesPage(bool isTV) {
    final countries = channels.map((c) => c.country).toSet().toList();

    return ListView(
      padding: EdgeInsets.all(isTV ? 35 : 18),
      children: [
        _sectionTitle('COUNTRIES', 'Explore channels by country'),
        const SizedBox(height: 20),
        ...countries.map(
          (country) => Card(
            color: panel,
            child: ListTile(
              leading: const Icon(Icons.public, color: gold),
              title: Text(country),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15),
              onTap: () {
                setState(() {
                  searchText = country;
                  searchController.text = country;
                  selectedTab = 0;
                  selectedCategory = 'All';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigation() {
    return NavigationBar(
      backgroundColor: panel,
      indicatorColor: accent.withValues(alpha: 0.25),
      selectedIndex: selectedTab,
      onDestinationSelected: (index) {
        setState(() => selectedTab = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.live_tv),
          label: 'Live TV',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.public),
          label: 'Countries',
        ),
      ],
    );
  }
}

class PlayerPage extends StatefulWidget {
  final TVChannel channel;

  const PlayerPage({super.key, required this.channel});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController? controller;
  String? errorMessage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.channel.streamUrl.isNotEmpty) {
      initializePlayer();
    }
  }

  Future<void> initializePlayer() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final player = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.streamUrl),
      );
      controller = player;
      await player.initialize();
      await player.play();
      if (mounted) setState(() => loading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          errorMessage = 'Unable to play this stream.';
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = controller;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(widget.channel.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: panel,
                  child: player != null && player.value.isInitialized
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(player),
                            VideoProgressIndicator(
                              player,
                              allowScrubbing: true,
                            ),
                          ],
                        )
                      : Center(
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: accent,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.live_tv,
                                      color: accent,
                                      size: 55,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      errorMessage ??
                                          'Stream link haijaunganishwa.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.channel.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.channel.description,
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 15),
              if (player != null && player.value.isInitialized)
                IconButton(
                  iconSize: 48,
                  color: gold,
                  onPressed: () {
                    setState(() {
                      player.value.isPlaying ? player.pause() : player.play();
                    });
                  },
                  icon: Icon(
                    player.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                  ),
                ),
              if (widget.channel.streamUrl.isEmpty)
                const Text(
                  'Ongeza stream URL halali ili channel hii icheze live.',
                  style: TextStyle(color: gold, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
