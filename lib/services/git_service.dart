import 'dart:io';

class GitService {
  static Future<List<String>> getGitLog(String path) async {
    final result = await Process.run('git', [
      'log',
      '--pretty=oneline',
    ], workingDirectory: path);
    if (result.exitCode == 0) {
      return (result.stdout as String).trim().split('\n');
    } else {
      throw Exception('Git log 실패: ${result.stderr}');
    }
  }
}
