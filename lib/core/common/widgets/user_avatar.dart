import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum UserAvatarSize { small, medium, large }

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final String name;
  final UserAvatarSize size;

  const UserAvatar(
      {super.key,
      this.imageUrl,
      required this.name,
      this.size = UserAvatarSize.small,
      this.imageFile});

  double _getAvatarRadius() {
    switch (size) {
      case UserAvatarSize.small:
        return 24.r;
      case UserAvatarSize.medium:
        return 36.r;
      case UserAvatarSize.large:
        return 48.r;
      default:
        return 24.r;
    }
  }

  double _getFontSize() {
    switch (size) {
      case UserAvatarSize.small:
        return 14.sp;
      case UserAvatarSize.medium:
        return 24.sp;
      case UserAvatarSize.large:
        return 36.sp;
      default:
        return 12.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _getAvatarRadius(),
      backgroundColor: Colors.grey[400],
      backgroundImage: imageUrl != null
          ? NetworkImage(imageUrl!)
          : imageFile != null
              ? FileImage(imageFile!)
              : null,
      child: imageUrl == null && imageFile == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontSize: _getFontSize()),
            )
          : null,
    );
  }
}
