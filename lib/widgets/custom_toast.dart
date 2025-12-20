import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback? onDismiss;

  const CustomToast({
    super.key,
    required this.message,
    this.isError = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isError
                  ? Colors.redAccent.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: isError
                ? Colors.redAccent.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isError ? Colors.red.shade50 : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.close_rounded : Icons.check_rounded,
                color: isError ? Colors.redAccent : Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static helper to show the toast
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60, // Top margin
        left: 20,
        right: 20,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.easeOutBack,
                ),
              ),
          child: Center(
            child: CustomToast(message: message, isError: isError),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto remove after duration
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
