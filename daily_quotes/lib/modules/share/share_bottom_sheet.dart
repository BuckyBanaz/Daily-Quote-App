import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../../data/models/quote_model.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareSheet extends StatefulWidget {
  final Quote quote;

  const ShareSheet({Key? key, required this.quote}) : super(key: key);

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag Handle
          Container(
            width: 40, 
            height: 4, 
            decoration: BoxDecoration(
              color: Colors.grey.shade300, 
              borderRadius: BorderRadius.circular(2)
            )
          ),
          
          const SizedBox(height: 16),
          
          // Header with Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, size: 20, color: Colors.grey.shade400),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade50,
                  padding: const EdgeInsets.all(8)
                ),
              ),
            ],
          ),

          // Title
          Text(
            "Share Quote",
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Choose how you'd like to share this",
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 24),

          // Quote Preview Card (Animated)
          _buildAnimatedItem(
            delay: 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              ),
              child: Column(
                children: [
                  Icon(Icons.format_quote_rounded, size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    widget.quote.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "- ${widget.quote.author.toUpperCase()}",
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Buttons (Animated Staggered)
          _buildAnimatedItem(
            delay: 1,
            child: _ShareButton(
              label: "Copy Text",
              icon: Icons.copy,
              color: Colors.black87,
              backgroundColor: Colors.grey.shade50,
              onTap: () {
                Clipboard.setData(ClipboardData(text: "${widget.quote.text}\n- ${widget.quote.author}"));
                Get.back();
                Get.snackbar("Copied", "Quote copied to clipboard", snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedItem(
            delay: 2,
            child: _ShareButton(
              label: "System Share",
              icon: Icons.ios_share,
              color: Colors.white,
              backgroundColor: const Color(0xFF26A69A), // Teal/Primary
              onTap: () {
                 Share.share("${widget.quote.text}\n- ${widget.quote.author}");
                 Get.back();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required int delay, required Widget child}) {
    // delay is an index multiplier (0, 1, 2...)
    final double start = delay * 0.1; 
    final double end = start + 0.4;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2), // Slide up from slight offset
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        )),
        child: child,
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ShareButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
           boxShadow: backgroundColor != Colors.grey.shade50 ? [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4)
            )
          ] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: color.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}
