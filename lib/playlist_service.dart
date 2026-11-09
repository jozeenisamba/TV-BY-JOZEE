import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVChannel {
  final String name;
  final String country;
  final String category;
  final String description;
  final String streamUrl;
  final String? logo;

  String get continent => PlaylistService.continentForCountry(country);

  IconData get icon {
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
  static const Map<String, String> _countryAliases = {
    'us': 'United States',
    'usa': 'United States',
    'united states of america': 'United States',
    'gb': 'United Kingdom',
    'uk': 'United Kingdom',
    'britain': 'United Kingdom',
    'kr': 'South Korea',
    'kp': 'North Korea',
    'ke': 'Kenya',
    'ug': 'Uganda',
    'za': 'South Africa',
    'ng': 'Nigeria',
    'gh': 'Ghana',
    'fr': 'France',
    'de': 'Germany',
    'es': 'Spain',
    'it': 'Italy',
    'nl': 'Netherlands',
    'pl': 'Poland',
    'tr': 'Turkey',
    'qa': 'Qatar',
    'ae': 'United Arab Emirates',
    'cn': 'China',
    'jp': 'Japan',
    'in': 'India',
    'th': 'Thailand',
    'ru': 'Russia',
    'ua': 'Ukraine',
    'tz': 'Tanzania',
    'cd': 'Democratic Republic of the Congo',
    'ci': 'Côte d’Ivoire',
    'cz': 'Czechia',
    'ir': 'Iran',
    'sy': 'Syria',
    've': 'Venezuela',
    'bo': 'Bolivia',
    'br': 'Brazil',
    'mx': 'Mexico',
    'ca': 'Canada',
    'au': 'Australia',
    'nz': 'New Zealand',
    'ar': 'Argentina',
    'turkiye': 'Turkey',
    'türkiye': 'Turkey',
  };

  static const Map<String, String> _countryContinents = {
    'algeria': 'Africa',
    'angola': 'Africa',
    'botswana': 'Africa',
    'cameroon': 'Africa',
    'egypt': 'Africa',
    'ethiopia': 'Africa',
    'ghana': 'Africa',
    'ivory coast': 'Africa',
    'côte d’ivoire': 'Africa',
    'kenya': 'Africa',
    'libya': 'Africa',
    'morocco': 'Africa',
    'mozambique': 'Africa',
    'namibia': 'Africa',
    'nigeria': 'Africa',
    'rwanda': 'Africa',
    'senegal': 'Africa',
    'somalia': 'Africa',
    'south africa': 'Africa',
    'sudan': 'Africa',
    'tanzania': 'Africa',
    'tunisia': 'Africa',
    'uganda': 'Africa',
    'zambia': 'Africa',
    'zimbabwe': 'Africa',
    'china': 'Asia',
    'india': 'Asia',
    'indonesia': 'Asia',
    'iran': 'Asia',
    'iraq': 'Asia',
    'israel': 'Asia',
    'japan': 'Asia',
    'malaysia': 'Asia',
    'pakistan': 'Asia',
    'philippines': 'Asia',
    'qatar': 'Asia',
    'saudi arabia': 'Asia',
    'singapore': 'Asia',
    'south korea': 'Asia',
    'taiwan': 'Asia',
    'thailand': 'Asia',
    'turkey': 'Asia',
    'united arab emirates': 'Asia',
    'vietnam': 'Asia',
    'austria': 'Europe',
    'belgium': 'Europe',
    'croatia': 'Europe',
    'czechia': 'Europe',
    'hungary': 'Europe',
    'denmark': 'Europe',
    'finland': 'Europe',
    'france': 'Europe',
    'germany': 'Europe',
    'greece': 'Europe',
    'ireland': 'Europe',
    'italy': 'Europe',
    'netherlands': 'Europe',
    'norway': 'Europe',
    'poland': 'Europe',
    'portugal': 'Europe',
    'romania': 'Europe',
    'russia': 'Europe',
    'serbia': 'Europe',
    'spain': 'Europe',
    'sweden': 'Europe',
    'switzerland': 'Europe',
    'ukraine': 'Europe',
    'united kingdom': 'Europe',
    'canada': 'North America',
    'cuba': 'North America',
    'dominican republic': 'North America',
    'jamaica': 'North America',
    'mexico': 'North America',
    'united states': 'North America',
    'argentina': 'South America',
    'bolivia': 'South America',
    'brazil': 'South America',
    'chile': 'South America',
    'colombia': 'South America',
    'ecuador': 'South America',
    'peru': 'South America',
    'uruguay': 'South America',
    'venezuela': 'South America',
    'australia': 'Oceania',
    'fiji': 'Oceania',
    'new zealand': 'Oceania',
    'papua new guinea': 'Oceania',
  };

  static final List<(String, RegExp)> _explicitCountryMatchers = [
    for (final country in _countryContinents.keys)
      (
        _formatCountryName(country),
        RegExp('\\b${RegExp.escape(country)}\\b', caseSensitive: false),
      ),
    ('United States', RegExp(r'\b(?:us|usa)\b', caseSensitive: false)),
    ('United Kingdom', RegExp(r'\b(?:uk|britain)\b', caseSensitive: false)),
    ('Turkey', RegExp(r'\b(?:turkiye|türkiye)\b', caseSensitive: false)),
  ];

  static final List<(String, RegExp)> _channelCountryMatchers = [
    (
      'Kenya',
      RegExp(
        r'\b(?:citizen tv|ntv kenya|ktn|kbc|k24|kameme)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Tanzania',
      RegExp(
        r'\b(?:azam tv|tbc|itv tanzania|clouds tv|wasafi)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Uganda',
      RegExp(
        r'\b(?:ntv uganda|nbs tv|bukedde|ubc tv|bbs terefayina)\b',
        caseSensitive: false,
      ),
    ),
    (
      'South Africa',
      RegExp(
        r'\b(?:sabc|etv south africa|soweto tv|mzansi)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Nigeria',
      RegExp(
        r'\b(?:channels tv|ait nigeria|silverbird|wazobia)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Ghana',
      RegExp(r'\b(?:joy news|tv3 ghana|ghone|adom tv)\b', caseSensitive: false),
    ),
    (
      'United States',
      RegExp(r'\b(?:bbc america|bbc earth us)\b', caseSensitive: false),
    ),
    ('Romania', RegExp(r'\bantena 3 cnn\b', caseSensitive: false)),
    (
      'United Kingdom',
      RegExp(
        r'\b(?:bbc|itv|channel [45]|sky news|gb news|talktv)\b',
        caseSensitive: false,
      ),
    ),
    (
      'France',
      RegExp(
        r'\b(?:france 2|france 3|france 24|tf1|m6)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Germany',
      RegExp(
        r'\b(?:deutsche welle|dw deutsch|ard|zdf)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Spain',
      RegExp(r'\b(?:rtve|antena 3|la sexta|telecinco)\b', caseSensitive: false),
    ),
    (
      'Italy',
      RegExp(
        r'\b(?:rai [1-5]|rai news|mediaset italia)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Netherlands',
      RegExp(r'\b(?:npo [1-3]|rtl nederland)\b', caseSensitive: false),
    ),
    ('Poland', RegExp(r'\b(?:tvp|polsat|tvn poland)\b', caseSensitive: false)),
    (
      'Russia',
      RegExp(
        r'\b(?:rt news|channel one russia|russia 1|ntv russia)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Turkey',
      RegExp(
        r'\b(?:trt [1-6]|atv turkey|show tv turkey|kanal d turkey)\b',
        caseSensitive: false,
      ),
    ),
    ('Qatar', RegExp(r'\b(?:al jazeera|bein sports)\b', caseSensitive: false)),
    (
      'United Arab Emirates',
      RegExp(r'\b(?:dubai tv|abu dhabi tv|sharjah tv)\b', caseSensitive: false),
    ),
    (
      'China',
      RegExp(r'\b(?:cgtn|cctv[- ]?\d|hunan tv)\b', caseSensitive: false),
    ),
    (
      'Japan',
      RegExp(
        r'\b(?:nhk|fuji tv|tv tokyo|tv asahi|nippon tv)\b',
        caseSensitive: false,
      ),
    ),
    (
      'South Korea',
      RegExp(r'\b(?:kbs|mbc korea|sbs korea|arirang)\b', caseSensitive: false),
    ),
    (
      'India',
      RegExp(
        r'\b(?:zee|sony max|sony sab|colors tv|ndtv|aaj tak|doordarshan)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Thailand',
      RegExp(
        r'\b(?:thai pbs|ch[3-8] thailand|workpoint tv)\b',
        caseSensitive: false,
      ),
    ),
    (
      'United States',
      RegExp(
        r'\b(?:abc news|cbs news|nbc news|cnn|msnbc|fox news|pbs|espn)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Canada',
      RegExp(
        r'\b(?:cbc|ctv news|global news canada|tva nouvelles)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Mexico',
      RegExp(
        r'\b(?:televisa|tv azteca|canal de las estrellas)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Brazil',
      RegExp(
        r'\b(?:tv globo|globo news|sbt brasil|record tv brazil)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Argentina',
      RegExp(
        r'\b(?:telefe|canal 13 argentina|tv publica argentina)\b',
        caseSensitive: false,
      ),
    ),
    (
      'Australia',
      RegExp(
        r'\b(?:abc australia|sbs australia|seven network|nine network)\b',
        caseSensitive: false,
      ),
    ),
    (
      'New Zealand',
      RegExp(r'\b(?:tvnz|maori television)\b', caseSensitive: false),
    ),
  ];

  static Future<List<TVChannel>> loadChannels() async {
    final content = await rootBundle.loadString('assets/channels_streams.m3u');

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
      final country = _resolveCountry(
        _extractAttribute(pendingInfo, 'tvg-country'),
        name,
      );
      final category = _extractAttribute(pendingInfo, 'group-title');
      final logo = _extractAttribute(pendingInfo, 'tvg-logo');

      if (name.isNotEmpty) {
        channels.add(
          TVChannel(
            name: name,
            country: country.isEmpty ? 'Unknown' : country,
            category: category.isEmpty ? 'Other' : category,
            description: category.isEmpty ? 'Live television' : category,
            streamUrl: line,
            logo: logo.isEmpty ? null : logo,
          ),
        );
      }

      pendingInfo = null;
    }

    return channels;
  }

  static String continentForCountry(String country) {
    final normalized = _normalizeCountry(country).toLowerCase();
    return _countryContinents[normalized] ?? 'Other / Unknown';
  }

  static String _resolveCountry(String country, String channelName) {
    final normalized = _normalizeCountry(country);
    if (normalized.isNotEmpty && normalized.toLowerCase() != 'unknown') {
      return normalized;
    }

    for (final (matchedCountry, pattern) in _explicitCountryMatchers) {
      if (pattern.hasMatch(channelName)) {
        return matchedCountry;
      }
    }

    for (final (matchedCountry, pattern) in _channelCountryMatchers) {
      if (pattern.hasMatch(channelName)) {
        return matchedCountry;
      }
    }
    return 'Unknown';
  }

  static String _normalizeCountry(String country) {
    final value = country.trim();
    if (value.isEmpty) return '';
    return _countryAliases[value.toLowerCase()] ?? value;
  }

  static String _formatCountryName(String country) {
    return country
        .split(' ')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
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
