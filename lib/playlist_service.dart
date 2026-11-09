import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVChannel {
  final String name;
  final String country;
  final String category;
  final String description;
  final String streamUrl;
  final String? logo;IconData get icon {
  switch (category.toLowerCase()) {
    case 'news':
      return Icons.newspaper;
    case 'sports':
      return Icons.sports;
    case 'movies':
      return Icons.movie;
    case 'music':
      return Icons.music_note;
    case 'kids':
      return Icons.child_care;
    case 'documentary':
      return Icons.rocket_launch;
    default:
      return Icons.live_tv;
  }
}

  const TVChannel({
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    required this.streamUrl,
    this.logo,
  });
}

class PlaylistService {
  static Future<List<TVChannel>> loadChannels() async {
    final content = await rootBundle.loadString(
      'assets/channels_streams.m3u',
    );

    return parseM3U(content);
  }

  static List<TVChannel> parseM3U(String content) {
    final lines = content.split(RegExp(r'\r?\n'));
    final channels = <TVChannel>[];

    String? pendingInfo;

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty || line == '#EXTM3U') {
        continue;
      }

      if (line.startsWith('#EXTINF:')) {
        pendingInfo = line;
        continue;
      }

      if (line.startsWith('#')) {
        continue;
      }

      if (pendingInfo == null) {
        continue;
      }

      final name = _extractName(pendingInfo);
      final country = _extractAttribute(pendingInfo, 'tvg-country');
      final category = _extractAttribute(pendingInfo, 'group-title');
      final logo = _extractAttribute(pendingInfo, 'tvg-logo');

      if (name.isNotEmpty) {
        channels.add(
          TVChannel(
            name: name,
            country: country.isEmpty ? 'Unknown' : country,
            category: category.isEmpty ? 'Other' : category,
            description: category.isEmpty
                ? 'Live television'
                : category,
            streamUrl: line,
            logo: logo.isEmpty ? null : logo,
          ),
        );
      }

      pendingInfo = null;
    }

    return channels;
  }

  static String _extractName(String info) {
    final comma = info.lastIndexOf(',');
    if (comma == -1 || comma == info.length - 1) {
      return 'Unknown channel';
    }
    return info.substring(comma + 1).trim();
  }

  static String _extractAttribute(String info, String key) {
    final pattern = RegExp(
      '$key="([^"]*)"'
      '|$key=([^, ]*)',
      caseSensitive: false,
    );

    final match = pattern.firstMatch(info);
    return (match?.group(1) ?? match?.group(2) ?? '').trim();
  }
}
