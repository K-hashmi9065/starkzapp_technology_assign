import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersProvider);
    final user = state.users.firstWhere((e) => e.id == widget.userId);

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blurred background to avoid showing a pixelated full-screen image
                LayoutBuilder(
                  builder: (context, constraints) {
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final w = (constraints.maxWidth * dpr).round();
                    final h = (constraints.maxHeight * dpr).round();
                    return ImageFiltered(
                      imageFilter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Image.network(
                        user.imageLargeUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        cacheWidth: w > 0 ? w : null,
                        cacheHeight: h > 0 ? h : null,
                        headers: const {'User-Agent': 'Mozilla/5.0 (Flutter)'},
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                            'Profile bg image error: ${error.toString()}',
                          );
                          return Container(color: Colors.grey.shade200);
                        },
                      ),
                    );
                  },
                ),
                // Foreground photo rendered at a size that won't upscale beyond its source
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final dpr = MediaQuery.of(context).devicePixelRatio;
                      // RandomUser "large" is ~128x128px. Render near that in logical px to avoid upscaling.
                      final logicalMaxWidth = constraints.maxWidth.clamp(
                        0.0,
                        220.0,
                      );
                      final physicalTargetWidth = (logicalMaxWidth * dpr)
                          .round();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          user.imageLargeUrl,
                          fit: BoxFit.contain,
                          filterQuality:
                              FilterQuality.none, // avoid blur from smoothing
                          cacheWidth: physicalTargetWidth > 0
                              ? physicalTargetWidth
                              : null,
                          headers: const {
                            'User-Agent': 'Mozilla/5.0 (Flutter)',
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                              'Profile image load error: ${error.toString()}',
                            );
                            return const SizedBox.shrink();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${user.firstName}, ${user.age}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(usersProvider.notifier).toggleLike(user.id);
                        },
                        icon: Icon(
                          user.liked ? Icons.favorite : Icons.favorite_border,
                          color: user.liked ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    user.city,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
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
