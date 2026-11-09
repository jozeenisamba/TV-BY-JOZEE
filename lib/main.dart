import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'playlist_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TVByJozeeApp());
}

const Color bg = Color(0xFF080B12);
const Color panel = Color(0xFF111827);
const Color panel2 = Color(0xFF1B2433);
const Color accent = Color(0xFFE50932);
const Color gold = Color(0xFFFFC928);

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
        colorScheme: const ColorScheme.dark(
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
  String countrySearchText = '';
  String? selectedCountry;

  List<TVChannel> channels = [];
  bool loadingChannels = true;
  String? playlistError;

  final Set<String> favorites = {};
  final TextEditingController searchController = TextEditingController();
  final TextEditingController countrySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPlaylist();
  }

  Future<void> loadPlaylist() async {
    try {
      final loadedChannels = await PlaylistService.loadChannels();

      if (!mounted) return;

      setState(() {
        channels = loadedChannels;
        loadingChannels = false;
        playlistError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingChannels = false;
        playlistError = 'Imeshindikana kusoma playlist.';
      });
    }
  }

  List<String> get categories {
    final groups = channels
        .map((channel) => channel.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    groups.sort();
    return ['All', ...groups];
  }

  List<TVChannel> get filteredChannels {
    return channels.where((channel) {
      final categoryMatch =
          selectedCategory == 'All' || channel.category == selectedCategory;

      final query = searchText.toLowerCase();

      final searchMatch =
          channel.name.toLowerCase().contains(query) ||
          channel.country.toLowerCase().contains(query) ||
          channel.category.toLowerCase().contains(query);

      final countryMatch =
          selectedCountry == null || channel.country == selectedCountry;

      return categoryMatch && searchMatch && countryMatch;
    }).toList();
  }

  List<TVChannel> get favoriteChannels {
    return channels
        .where((channel) => favorites.contains(channel.name))
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    countrySearchController.dispose();
    super.dispose();
  }

  void openChannel(TVChannel channel) {
    if (channel.streamUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stream link haijaunganishwa.')),
      );
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PlayerPage(channel: channel)));
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
      selectedCountry = null;
      selectedCategory = 'All';
      searchText = '';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: panel,
        title: const Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              child: Image(
                image: AssetImage('assets/images/jozee_logo.png'),
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'TV BY JOZEE',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh channels',
            onPressed: () {
              setState(() {
                loadingChannels = true;
                playlistError = null;
              });
              loadPlaylist();
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (wide) _sideNavigation(),
          Expanded(child: _mainContent()),
        ],
      ),
      bottomNavigationBar: wide ? null : _bottomNavigation(),
    );
  }

  Widget _sideNavigation() {
    return Container(
      width: 210,
      color: panel,
      child: Column(
        children: [
          const SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/jozee_logo.png',
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'TV BY JOZEE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 30),
          _navItem(0, Icons.home, 'Home'),
          _navItem(1, Icons.live_tv, 'Live TV'),
          _navItem(2, Icons.favorite, 'Favorites'),
          _navItem(3, Icons.public, 'By Region'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              '${channels.length} Channels',
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final active = selectedTab == index;

    return ListTile(
      selected: active,
      selectedTileColor: accent.withValues(alpha: 0.15),
      leading: Icon(icon, color: active ? accent : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.white70,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => changeTab(index),
    );
  }

  Widget _bottomNavigation() {
    return NavigationBar(
      backgroundColor: panel,
      selectedIndex: selectedTab,
      indicatorColor: accent.withValues(alpha: 0.2),
      onDestinationSelected: changeTab,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.live_tv), label: 'Live TV'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        NavigationDestination(icon: Icon(Icons.public), label: 'By Region'),
      ],
    );
  }

  Widget _mainContent() {
    if (loadingChannels) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: accent),
            SizedBox(height: 15),
            Text('Inapakia TV channels...'),
          ],
        ),
      );
    }

    if (playlistError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: accent, size: 50),
            const SizedBox(height: 12),
            Text(playlistError!),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  loadingChannels = true;
                  playlistError = null;
                });
                loadPlaylist();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Jaribu tena'),
            ),
          ],
        ),
      );
    }

    if (channels.isEmpty) {
      return const Center(
        child: Text('Hakuna channels zilizopatikana kwenye playlist.'),
      );
    }

    switch (selectedTab) {
      case 2:
        return _favoritesPage();
      case 3:
        return _countriesPage();
      default:
        return _homePage();
    }
  }

  Widget _homePage() {
    final list = filteredChannels;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedTab == 1 ? 'LIVE TV' : 'WELCOME TO TV BY JOZEE',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${channels.length} television channels available',
                style: const TextStyle(color: Colors.white60),
              ),
              if (selectedCountry != null) ...[
                const SizedBox(height: 10),
                Chip(
                  avatar: const Icon(Icons.flag, size: 18),
                  label: Text(selectedCountry!),
                  onDeleted: () {
                    setState(() => selectedCountry = null);
                  },
                ),
              ],
              const SizedBox(height: 18),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() => searchText = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search channels...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: panel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              _categoryList(),
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('Hakuna channel zilizopatikana.'))
              : _channelGrid(list),
        ),
      ],
    );
  }

  Widget _categoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final active = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: active,
              selectedColor: accent,
              backgroundColor: panel2,
              onSelected: (_) {
                setState(() => selectedCategory = category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _channelGrid(List<TVChannel> list) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final count = width >= 1100
            ? 5
            : width >= 750
            ? 4
            : width >= 500
            ? 3
            : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            return _channelCard(list[index]);
          },
        );
      },
    );
  }

  Widget _channelCard(TVChannel channel) {
    final isFavorite = favorites.contains(channel.name);

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => openChannel(channel),
      child: Container(
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(child: Icon(channel.icon, size: 48, color: accent)),
            ),
            Text(
              channel.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              channel.country,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.circle, color: Colors.red, size: 8),
                const SizedBox(width: 5),
                const Text('LIVE', style: TextStyle(fontSize: 10)),
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
                    size: 19,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoritesPage() {
    final list = favoriteChannels;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'MY FAVORITES',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('Bado hujaongeza channel yoyote.'))
              : _channelGrid(list),
        ),
      ],
    );
  }

  Widget _countriesPage() {
    final grouped = <String, Map<String, int>>{};
    for (final channel in channels) {
      final continent = channel.continent;
      final countryCounts = grouped.putIfAbsent(continent, () => {});
      countryCounts.update(
        channel.country,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    const continentOrder = [
      'Africa',
      'Asia',
      'Europe',
      'North America',
      'South America',
      'Oceania',
      'Other / Unknown',
    ];
    final continents = grouped.keys.toList()
      ..sort((a, b) {
        final aIndex = continentOrder.indexOf(a);
        final bIndex = continentOrder.indexOf(b);
        return (aIndex == -1 ? continentOrder.length : aIndex).compareTo(
          bIndex == -1 ? continentOrder.length : bIndex,
        );
      });
    final query = countrySearchText.trim().toLowerCase();
    final visibleContinents = continents.where((continent) {
      return continent.toLowerCase().contains(query) ||
          grouped[continent]!.keys.any(
            (country) => country.toLowerCase().contains(query),
          );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CONTINENTS & COUNTRIES',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: countrySearchController,
                onChanged: (value) {
                  setState(() => countrySearchText = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search continent or country...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: panel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: visibleContinents.isEmpty
              ? const Center(child: Text('Hakuna bara au nchi iliyopatikana.'))
              : ListView(
                  padding: const EdgeInsets.only(bottom: 12),
                  children: visibleContinents.map((continent) {
                    final countryCounts = grouped[continent]!;
                    final countries = countryCounts.keys.where((country) {
                      return query.isEmpty ||
                          continent.toLowerCase().contains(query) ||
                          country.toLowerCase().contains(query);
                    }).toList()..sort();
                    final continentCount = countryCounts.values.fold<int>(
                      0,
                      (total, count) => total + count,
                    );

                    return Card(
                      color: panel,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: ExpansionTile(
                        leading: const Icon(Icons.public, color: accent),
                        title: Text(continent),
                        subtitle: Text(
                          '${countries.length} countries · '
                          '$continentCount channels',
                        ),
                        children: countries.map((country) {
                          return ListTile(
                            contentPadding: const EdgeInsets.fromLTRB(
                              68,
                              0,
                              20,
                              0,
                            ),
                            leading: const Icon(Icons.flag_outlined),
                            title: Text(country),
                            trailing: Text(
                              '${countryCounts[country]} channels',
                            ),
                            onTap: () {
                              setState(() {
                                selectedCountry = country;
                                selectedTab = 1;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
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
  late VideoPlayerController controller;
  bool initialized = false;
  String? playerError;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.channel.streamUrl),
    );

    try {
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        initialized = true;
      });

      await controller.play();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        playerError = 'Imeshindikana kucheza stream hii.';
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: panel, title: Text(widget.channel.name)),
      body: Center(
        child: playerError != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  playerError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : initialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.channel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  IconButton(
                    iconSize: 45,
                    color: gold,
                    onPressed: () {
                      setState(() {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      });
                    },
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: accent),
                  SizedBox(height: 15),
                  Text('Connecting to stream...'),
                ],
              ),
      ),
    );
  }
}
