import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _controller;
  bool _isLoading = true;

  _WebviewScreenState() {
    debugPrint('WebviewScreen constructor called');
  }

  @override
  void initState() {
    super.initState();
    debugPrint('WebviewScreen initState called');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WebviewScreen build called');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null && await _controller!.canGoBack()) {
          _controller!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () async {
              if (_controller != null && await _controller!.canGoBack()) {
                _controller!.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text('WebView', style: GoogleFonts.montserrat(color: textColor)),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('https://fposttestb.xyz/testing.html')),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                supportMultipleWindows: true,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                transparentBackground: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                userAgent: 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Mobile Safari/537.36',
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onLoadStart: (controller, url) {
                debugPrint('WebView onLoadStart: url = $url');
                setState(() => _isLoading = true);
              },
              onLoadStop: (controller, url) {
                debugPrint('WebView onLoadStop: url = $url');
                setState(() => _isLoading = false);
              },
              onLoadError: (controller, url, code, message) {
                debugPrint('WebView load error: $code $message url=$url');
              },
              onLoadHttpError: (controller, url, statusCode, description) {
                debugPrint('WebView HTTP error: $statusCode $description url=$url');
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  setState(() => _isLoading = false);
                }
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                debugPrint('WebView shouldOverrideUrlLoading: $url');
                if (_isExternalScheme(url)) {
                  await _launchExternal(url);
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onCreateWindow: (controller, createWindowRequest) async {
                final url = createWindowRequest.request.url.toString();
                debugPrint('WebView onCreateWindow: $url');
                if (_isExternalScheme(url)) {
                  await _launchExternal(url);
                  return true;
                }
                // Открывать target="_blank" в этом же окне
                if (url.isNotEmpty) {
                  controller.loadUrl(urlRequest: createWindowRequest.request);
                  return true;
                }
                return false;
              },
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  bool _isExternalScheme(String url) {
    return url.startsWith('tg:') ||
        url.startsWith('tg://') ||
        url.startsWith('whatsapp://') ||
        url.startsWith('viber://') ||
        url.startsWith('line://') ||
        url.startsWith('tel:') ||
        url.startsWith('mailto:') ||
        url.startsWith('intent://');
  }

  Future<void> _launchExternal(String url) async {
    if (url.startsWith('intent://')) {
      final fallbackUrl = _extractFallbackUrl(url);
      if (fallbackUrl != null && await canLaunchUrl(Uri.parse(fallbackUrl))) {
        await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
      return;
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  String? _extractFallbackUrl(String intentUrl) {
    final fallbackMatch = RegExp(r'browser_fallback_url=([^;]+)').firstMatch(intentUrl);
    if (fallbackMatch != null) {
      final url = Uri.decodeComponent(fallbackMatch.group(1)!);
      return url;
    }
    return null;
  }
}
