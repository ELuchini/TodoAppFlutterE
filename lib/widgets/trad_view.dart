import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewChart extends StatefulWidget {
  const TradingViewChart({super.key});

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<TradingViewChart> {
  // final symbolFromProv = Provider.of<ActiveTodoProvider>(context, listen: false).aTodoTitle;
  // final intervalFromProv = context.watch<ActiveTodoProvider>().aTodoTitle;
  final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(
        'https://www.tradingview.com/chart/?symbol=BTCUSD&interval=D'))
    ..setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2224065653.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
    ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TradingView BTCUSD Chart"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
