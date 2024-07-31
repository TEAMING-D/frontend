class FileItem {
  final String name;
  final String uploader;
  final DateTime uploadDate;
  final String size;

  FileItem({
    required this.name,
    required this.uploader,
    required this.uploadDate,
    required this.size,
  });

  bool get isExpired => uploadDate.isBefore(DateTime.now().subtract(Duration(days: 30)));
}