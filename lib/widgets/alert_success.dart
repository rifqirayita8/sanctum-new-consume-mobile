import 'package:flutter/material.dart';
import 'package:sanctum_mobile/widgets/button_confirm.dart';

class AlertConfirm extends StatefulWidget {
  final String titleText;
  final String descText;
  final String confirmText;
  final String route;
  const AlertConfirm(
      {required this.titleText,
      required this.descText,
      required this.confirmText,
      required this.route,
      super.key});

  @override
  State<AlertConfirm> createState() => _AlertConfirmState();
}

class _AlertConfirmState extends State<AlertConfirm> {
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!_isNavigated) {
        Navigator.pushNamed(context, widget.route);
      }
    });
  }

  void _navigateToPage() {
    if (!_isNavigated) {
      _isNavigated = true;
      Navigator.pushNamed(context, widget.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            color: Colors.brown,
            shape: BoxShape.circle,
          ),
        ),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.titleText,
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                  fontSize: 22,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              widget.descText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ButtonConfirm(
                width: 160,
                height: 40,
                text: widget.confirmText,
                colorText: Colors.white,
                borderColor: Colors.blue[50]!,
                buttonColor: Colors.blue[400]!,
                onPressed: _navigateToPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
