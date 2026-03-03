import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MiAppDeDescarga());
}

class MiAppDeDescarga extends StatelessWidget {
  const MiAppDeDescarga({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaSimulador(),
    );
  }
}


class PantallaSimulador extends StatefulWidget {
  const PantallaSimulador({super.key});

  @override
  State<PantallaSimulador> createState() => _PantallaSimuladorState();
}

class _PantallaSimuladorState extends State<PantallaSimulador> {
  DownloadStatus _status = DownloadStatus.notDownloaded;
  double _progress = 0.0;
  bool _isDownloading = false;

  void _iniciarDescarga() {
    setState(() {
      _status = DownloadStatus.fetchingDownload;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _status != DownloadStatus.fetchingDownload) return;
      setState(() {
        _status = DownloadStatus.downloading;
        _isDownloading = true;
      });
      _simularProgreso();
    });
  }

  void _simularProgreso() async {
    while (_isDownloading && _progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() {
        _progress += 0.02; 
      });
    }
    if (_progress >= 1.0) {
      setState(() {
        _status = DownloadStatus.downloaded;
        _isDownloading = false;
      });
    }
  }

  void _cancelarDescarga() {
    setState(() {
      _isDownloading = false;
      _status = DownloadStatus.notDownloaded;
      _progress = 0.0;
    });
  }

  void _abrirArchivo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Abriendo el archivo descargado!')),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _status = DownloadStatus.notDownloaded;
        _progress = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Botón Animado')),
      body: Center(
       
        child: SizedBox(
          width: 96,
          child: DownloadButton(
            status: _status,
            downloadProgress: _progress,
            onDownload: _iniciarDescarga,
            onCancel: _cancelarDescarga,
            onOpen: _abrirArchivo,
          ),
        ),
      ),
    );
  }
}


enum DownloadStatus { notDownloaded, fetchingDownload, downloading, downloaded }

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;
  bool get _isFetching => status == DownloadStatus.fetchingDownload;
  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14.0,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if (isDownloading || isFetching) {
      shape = const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}


@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(
                isFetching ? CupertinoColors.lightBackgroundGray : CupertinoColors.activeBlue),
            strokeWidth: 2.0,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}