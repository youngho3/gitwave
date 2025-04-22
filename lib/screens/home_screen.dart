import 'package:flutter/material.dart';
import '../services/git_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GitService _gitService = GitService();
  String _cloneStatus = '저장소를 선택하세요.';
  List<String> _clonedRepos = [];

  void _showRepoUrlDialog() async {
    final TextEditingController _urlController = TextEditingController();

    final String? repoUrl = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('저장소 URL 입력'),
            content: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: '예: https://github.com/사용자명/저장소명',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  final url = _urlController.text.trim();
                  if (url.isNotEmpty) {
                    Navigator.pop(context, url);
                  }
                },
                child: const Text('확인'),
              ),
            ],
          ),
    );

    if (repoUrl != null && repoUrl.isNotEmpty) {
      setState(() {
        _cloneStatus = '클론 중...';
      });

      final clonedPath = await _gitService.cloneRepository(repoUrl);

      setState(() {
        if (clonedPath != null) {
          if (!_clonedRepos.contains(clonedPath)) {
            _clonedRepos.add(clonedPath);
          }
          _cloneStatus = '✅ 클론 성공: $clonedPath';
        } else {
          _cloneStatus = '❌ 클론 실패';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitWave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showRepoUrlDialog,
              child: const Text('저장소 선택'),
            ),
            const SizedBox(height: 16),
            Text(_cloneStatus, style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _clonedRepos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(_clonedRepos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
