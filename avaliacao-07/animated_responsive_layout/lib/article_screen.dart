import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'home_screen.dart';
import 'news_data.dart';

class ArticleScreen extends StatefulWidget {
  final NewsArticle article;

  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _globalKey = GlobalKey();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_globalKey.currentContext != null) {
            try {
              // ✅ FORMA CORRETA (versão atualizada)
              final path = await HomeWidget.renderFlutterWidget(
                const LineChart(),
                fileName: 'screenshot.png',  // ✅ Adicione a extensão .png
                key: 'filename',
                logicalSize: _globalKey.currentContext!.size,
                pixelRatio: MediaQuery.of(_globalKey.currentContext!).devicePixelRatio,
              );
              
              setState(() {
                imagePath = path;
              });
              
              // Atualiza o widget da tela inicial
              updateHeadline(widget.article);
            } catch (e) {
              print('Erro ao renderizar widget: $e');
              // Mostra um snackbar com o erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: ${e.toString()}')),
              );
            }
          }
        },
        label: const Text('Update Homescreen'),
        icon: const Icon(Icons.refresh),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            widget.article.description,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText!),
          const SizedBox(height: 20.0),
          Center(
            key: _globalKey,
            child: const LineChart(),
          ),
          const SizedBox(height: 20.0),
          Text(widget.article.articleText!),
        ],
      ),
    );
  }
}

// Widget do gráfico simples
class LineChart extends StatelessWidget {
  const LineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: CustomPaint(
        painter: _LineChartPainter(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.25, 
        size.height * 0.2,
        size.width * 0.5, 
        size.height * 0.5
      )
      ..quadraticBezierTo(
        size.width * 0.75, 
        size.height * 0.8, 
        size.width,
        size.height * 0.3
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}