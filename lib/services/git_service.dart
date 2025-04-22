import 'dart:io';
import 'package:dart_git/dart_git.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class GitService {
  Future<String?> cloneRepository(String url) async {
    try {
      final repoName = _extractRepoName(url);

      // 앱 문서 디렉토리
      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = p.join(appDir.path, 'repos', repoName);
      final targetDir = Directory(targetPath);

      if (await targetDir.exists()) {
        return targetDir.path;
      } else {
        await targetDir.create(recursive: true);
      }

      final repo = await head(Uri.parse(url), targetDir.path);

      return repo.path;
    } catch (e) {
      print('Clone 에러: $e');
      return null;
    }
  }

  String _extractRepoName(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    return segments.isNotEmpty
        ? segments.last.replaceAll('.git', '')
        : 'unknown_repo';
  }
}
