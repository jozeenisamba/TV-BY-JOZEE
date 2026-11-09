import 'package:flutter_test/flutter_test.dart';
import 'package:tv_by_jozee/playlist_service.dart';

void main() {
  group('PlaylistService.parseM3U', () {
    test('uses the playlist country and resolves its continent', () {
      final channels = PlaylistService.parseM3U(
        '#EXTM3U\n'
        '#EXTINF:-1 tvg-country="KE",Citizen TV\n'
        'https://example.com/citizen.m3u8\n',
      );

      expect(channels, hasLength(1));
      expect(channels.single.country, 'Kenya');
      expect(channels.single.continent, 'Africa');
    });

    test('maps known channel names and leaves unknown ones unclassified', () {
      final channels = PlaylistService.parseM3U(
        '#EXTM3U\n'
        '#EXTINF:-1,BBC News\n'
        'https://example.com/bbc.m3u8\n'
        '#EXTINF:-1,BBC Earth Czechia\n'
        'https://example.com/bbc-czechia.m3u8\n'
        '#EXTINF:-1,Unlisted Channel\n'
        'https://example.com/unlisted.m3u8\n',
      );

      expect(channels[0].country, 'United Kingdom');
      expect(channels[0].continent, 'Europe');
      expect(channels[1].country, 'Czechia');
      expect(channels[1].continent, 'Europe');
      expect(channels[2].country, 'Unknown');
      expect(channels[2].continent, 'Other / Unknown');
    });
  });
}
