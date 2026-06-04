class ChangeLogEntry {
  const ChangeLogEntry({
    required this.name,
    required this.studentId,
    required this.summary,
    required this.files,
  });

  final String name;
  final String studentId;
  final String summary;
  final List<String> files;
}
