// profile_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileCard extends StatelessWidget {
  final String? title; // Thêm tham số title
  final String profileImageUrl;
  final String name;
  final String? rating;
  final String ratingDetails;
  final VoidCallback? onPhonePressed;
  final VoidCallback? onCommentPressed;
  final bool iconCall;
  final bool iconLocation;

  const ProfileCard({
    super.key,
    this.title,
    required this.profileImageUrl,
    required this.name,
    this.rating,
    required this.ratingDetails,
    this.onPhonePressed,
    this.onCommentPressed,
    this.iconCall = false,
    this.iconLocation = false,
  })  : assert(
          !iconCall || onPhonePressed != null,
          'onPhonePressed must be provided when iconCall is true',
        ),
        assert(
          !iconLocation || onCommentPressed != null,
          'onCommentPressed must be provided when iconLocation is true',
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị tiêu đề nếu có
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hình ảnh hồ sơ
              ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Thông tin hồ sơ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Đánh giá
                    Row(
                      children: [
                        if (rating != null)
                          const Icon(
                            FontAwesomeIcons.solidStar,
                            size: 14,
                            color: Color(0xFFF5A623),
                          ),
                        const SizedBox(width: 4),
                        Text(
                          'Sđt: $ratingDetails',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Biểu tượng hành động
              Row(
                children: [
                  if (iconLocation)
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.mapLocation,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: onCommentPressed,
                    ),
                  if (iconCall)
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.phone,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: onPhonePressed,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
