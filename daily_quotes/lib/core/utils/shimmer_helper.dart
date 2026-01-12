import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper {
  static Widget buildBasicShimmer({double width = double.infinity, double height = 20, double radius = 4}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  static Widget buildQuoteCardShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Match HomeView padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          buildBasicShimmer(width: 40, height: 40, radius: 20), // Match Icon size 40
          const SizedBox(height: 12), // Match spacing
          
          // Lines of text (mimic 18px font)
          buildBasicShimmer(height: 16, width: 220),
          const SizedBox(height: 8),
          buildBasicShimmer(height: 16, width: 260),
          const SizedBox(height: 8),
          buildBasicShimmer(height: 16, width: 140),
          
          const SizedBox(height: 12), // Match spacing
          
          // Author
          buildBasicShimmer(height: 12, width: 100),
          
          const SizedBox(height: 24), // Match spacing
          
          // Buttons (Centered Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBasicShimmer(width: 50, height: 50, radius: 25), // Share Button circle
              const SizedBox(width: 32),
              buildBasicShimmer(width: 50, height: 50, radius: 25), // Save Button circle
            ],
          )
        ],
      ),
    );
  }
}
