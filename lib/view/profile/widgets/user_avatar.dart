
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;

  const UserAvatar( {
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.66;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: iconSize,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
