import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/git_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedPath;
  List<String> gitLogs = [];

  Future<void> pickRepo() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      setState(() => selectedPath = path);
      final logs = await GitService.getGitLog(path);
      setState(() => gitLogs = logs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitWave')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickRepo,
              child: const Text('Git 저장소 선택'),
            ),
            const SizedBox(height: 20),
            if (selectedPath != null) Text('선택한 경로: $selectedPath'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: gitLogs.length,
                itemBuilder: (context, index) {
                  return Text(gitLogs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
