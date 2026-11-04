import 'dart:io';

import '../app/app.export.dart';
import '../app/app.package.export.dart';

/// Loads remote JSON through a disk copy, revalidated with ETag.
///
/// An unchanged file costs a 304 with no body. When the request fails or the
/// body doesn't parse, the last good copy is used.
class JsonCacheService {
  JsonCacheService({Dio? client, Future<Directory> Function()? directory})
      : _client = client ?? Dio(),
        _directory = directory ?? getApplicationSupportDirectory;

  final Dio _client;
  final Future<Directory> Function() _directory;
  final logger = getLogger('JsonCacheService');

  Future<T?> load<T>({
    required String url,
    required String name,
    required T Function(String body) parse,
  }) async {
    final dir = await _directory();
    final bodyFile = File('${dir.path}/json_cache_$name.json');
    final etagFile = File('${dir.path}/json_cache_$name.etag');

    final cached = await bodyFile.exists() ? await bodyFile.readAsString() : null;
    final etag = cached != null && await etagFile.exists()
        ? await etagFile.readAsString()
        : null;

    T? parseCached() {
      if (cached == null) return null;
      try {
        return parse(cached);
      } catch (error) {
        logger.e('JsonCacheService | $name - bad cached copy: $error');
        return null;
      }
    }

    try {
      var response = await _get(url, etag);
      if (response.statusCode == 304) {
        final value = parseCached();
        if (value != null) return value;
        response = await _get(url, null);
      }

      final body = response.data as String;
      final value = parse(body);
      await _save(bodyFile, body);
      final newEtag = response.headers.value(HttpHeaders.etagHeader);
      if (newEtag != null) {
        await _save(etagFile, newEtag);
      } else if (await etagFile.exists()) {
        await etagFile.delete();
      }
      return value;
    } catch (error) {
      logger.w('JsonCacheService | $name - using last copy: $error');
      return parseCached();
    }
  }

  // Plain text, because Dio would otherwise turn an application/json response
  // into a Map before it reaches [parse].
  Future<Response<dynamic>> _get(String url, String? etag) => _client.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          headers: {if (etag != null) HttpHeaders.ifNoneMatchHeader: etag},
          validateStatus: (status) => status == 200 || status == 304,
        ),
      );

  Future<void> _save(File file, String contents) async {
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(contents, flush: true);
    await temp.rename(file.path);
  }
}
