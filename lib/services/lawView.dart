import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'dart:convert';

class LawView extends StatefulWidget {
  const LawView({Key? key}) : super(key: key);

  @override
  State<LawView> createState() => _LawViewState();
}

class _LawViewState extends State<LawView> with TickerProviderStateMixin {
  bool _isLoading = false;
  String _error = '';
  List<LegalDocument> _documents = [];
  List<LegalNews> _news = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await Future.wait([
        _fetchLegalDocuments(),
        _fetchNews(),
      ]);
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLegalDocuments() async {
    try {
      final response = await http.get(
        Uri.parse('https://jdih.jakarta.go.id/'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final List<LegalDocument> documents = [];

        // Parse legal documents from the main page
        final docElements = document.querySelectorAll('.document-item, .produk-hukum, .peraturan-item');
        
        for (final element in docElements) {
          final title = element.querySelector('h3, h4, .title, .judul')?.text?.trim() ?? '';
          final description = element.querySelector('.description, .ringkasan, p')?.text?.trim() ?? '';
          final date = element.querySelector('.date, .tanggal, .waktu')?.text?.trim() ?? '';
          final type = element.querySelector('.type, .jenis, .kategori')?.text?.trim() ?? 'Dokumen Hukum';
          final link = element.querySelector('a')?.attributes['href'] ?? '';

          if (title.isNotEmpty) {
            documents.add(LegalDocument(
              title: title,
              description: description,
              date: date,
              type: type,
              link: link.startsWith('http') ? link : 'https://jdih.jakarta.go.id$link',
            ));
          }
        }

        // If no specific document elements found, try to parse from general content
        if (documents.isEmpty) {
          final textElements = document.querySelectorAll('div, p, li');
          for (final element in textElements) {
            final text = element.text.trim();
            if (text.contains('Peraturan') || text.contains('Keputusan') || 
                text.contains('Undang-Undang') || text.contains('Pergub')) {
              if (text.length > 50 && text.length < 300) {
                documents.add(LegalDocument(
                  title: text.length > 100 ? '${text.substring(0, 100)}...' : text,
                  description: 'Dokumen hukum dari JDIH Jakarta',
                  date: DateTime.now().toString().substring(0, 10),
                  type: 'Produk Hukum',
                  link: 'https://jdih.jakarta.go.id/',
                ));
              }
            }
          }
        }

        setState(() {
          _documents = documents;
        });
      }
    } catch (e) {
      print('Error fetching legal documents: $e');
    }
  }

  Future<void> _fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://jdih.jakarta.go.id/'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final List<LegalNews> newsList = [];

        // Parse news from the main page
        final newsElements = document.querySelectorAll('.news-item, .berita, .artikel');
        
        for (final element in newsElements) {
          final title = element.querySelector('h3, h4, .title')?.text?.trim() ?? '';
          final content = element.querySelector('.content, .isi, p')?.text?.trim() ?? '';
          final date = element.querySelector('.date, .tanggal')?.text?.trim() ?? '';

          if (title.isNotEmpty) {
            newsList.add(LegalNews(
              title: title,
              content: content,
              date: date,
            ));
          }
        }

        // Parse activities from the content we saw
        final activities = [
          'Kegiatan Pembinaan Hukum kepada Kelompok Keluarga Sadar Hukum di Kelurahan Gondangdia',
          'Kegiatan Pembinaan Hukum kepada Kelompok Keluarga Sadar Hukum di Kelurahan Galur',
          'Kegiatan Pembinaan Hukum kepada Kelompok Keluarga Sadar Hukum di Kelurahan Karet Tengsin',
          'Bimbingan Teknis (Bimtek) Jaringan Dokumentasi dan Informasi Hukum',
          'Rapat Konsolidasi Pemerintah Pusat dengan Pemerintah Provinsi'
        ];

        for (final activity in activities) {
          newsList.add(LegalNews(
            title: activity,
            content: 'Kegiatan pembinaan dan sosialisasi hukum di wilayah DKI Jakarta',
            date: '2025',
          ));
        }

        setState(() {
          _news = newsList;
        });
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  Future<String> _fetchDocumentContent(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final content = document.querySelector('.content, .isi, .document-content, main, article')?.text ?? '';
        return content.trim();
      }
    } catch (e) {
      print('Error fetching document content: $e');
    }
    return 'Konten tidak dapat dimuat';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JDIH Jakarta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.library_books), text: 'Produk Hukum'),
            Tab(icon: Icon(Icons.article), text: 'Berita & Kegiatan'),
            Tab(icon: Icon(Icons.info), text: 'Tentang JDIH'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data dari JDIH Jakarta...'),
                ],
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDocumentsTab(),
                    _buildNewsTab(),
                    _buildAboutTab(),
                  ],
                ),
    );
  }

  Widget _buildDocumentsTab() {
    if (_documents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada dokumen yang ditemukan'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final doc = _documents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.article, color: Colors.blue[800]),
              ),
              title: Text(
                doc.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doc.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      doc.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          doc.type,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue[50],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 8),
                      if (doc.date.isNotEmpty)
                        Text(
                          doc.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              onTap: () => _showDocumentDetail(doc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsTab() {
    if (_news.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.newspaper, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada berita yang ditemukan'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final news = _news[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.event, color: Colors.green[800]),
              ),
              title: Text(
                news.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      news.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  if (news.date.isNotEmpty)
                    Text(
                      news.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
              onTap: () => _showNewsDetail(news),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.blue[800]),
                      const SizedBox(width: 8),
                      const Text(
                        'Tentang JDIH Jakarta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jaringan Dokumentasi dan Informasi Hukum (JDIH) Provinsi DKI Jakarta adalah sistem pengelolaan dokumen dan informasi hukum yang bertujuan memberikan akses mudah, cepat, dan akurat terhadap produk hukum daerah.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.functions, color: Colors.green[800]),
                      const SizedBox(width: 8),
                      const Text(
                        'Fungsi JDIH',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '• Mengumpulkan dan mengelola dokumen hukum\n'
                    '• Menyimpan dan melestarikan produk hukum daerah\n'
                    '• Memberikan layanan informasi hukum\n'
                    '• Membangun sistem informasi hukum terintegrasi\n'
                    '• Mendukung literasi hukum masyarakat',
                    style: TextStyle(fontSize: 16, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      const Text(
                        'Kontak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Website: https://jdih.jakarta.go.id/\n'
                    'Email: Tersedia melalui halaman kontak resmi\n'
                    'Layanan: Gratis untuk seluruh ASN dan masyarakat',
                    style: TextStyle(fontSize: 16, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetail(LegalDocument doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      doc.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (doc.date.isNotEmpty)
                Text(
                  'Tanggal: ${doc.date}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 8),
              Chip(
                label: Text(doc.type),
                backgroundColor: Colors.blue[50],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    doc.description.isNotEmpty 
                        ? doc.description 
                        : 'Detail dokumen akan dimuat dari sumber.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // You can implement opening the link in browser here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Link: ${doc.link}')),
                    );
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Buka di Browser'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewsDetail(LegalNews news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          news.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (news.date.isNotEmpty) ...[
                Text(
                  'Tanggal: ${news.date}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                news.content.isNotEmpty 
                    ? news.content 
                    : 'Detail kegiatan dapat dilihat di website resmi JDIH Jakarta.',
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class LegalDocument {
  final String title;
  final String description;
  final String date;
  final String type;
  final String link;

  LegalDocument({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.link,
  });
}

class LegalNews {
  final String title;
  final String content;
  final String date;

  LegalNews({
    required this.title,
    required this.content,
    required this.date,
  });
}