import 'package:flutter/material.dart';
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
    final largeUrl = user.imageLargeUrl.isNotEmpty
        ? user.imageLargeUrl
        : 'https://randomuser.me/api/portraits/women/43.jpg';

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Thumbnail image (loads first)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final w = (constraints.maxWidth * dpr).round();
                    final h = (constraints.maxHeight * dpr).round();
                    return Image.network(
                      user.imageThumbnailUrl,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      cacheWidth: w > 0 ? w : null,
                      cacheHeight: h > 0 ? h : null,
                      headers: const {'User-Agent': 'Mozilla/5.0 (Flutter)'},
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          'Profile thumb image error: ${error.toString()}',
                        );
                        return Container(color: Colors.grey.shade200);
                      },
                    );
                  },
                ),
                // Higher quality image (loads second with fade effect)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final dpr = MediaQuery.of(context).devicePixelRatio;
                    final w = (constraints.maxWidth * dpr).round();
                    final h = (constraints.maxHeight * dpr).round();
                    return Image.network(
                      largeUrl,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      cacheWidth: w > 0 ? w : null,
                      cacheHeight: h > 0 ? h : null,
                      headers: const {'User-Agent': 'Mozilla/5.0 (Flutter)'},
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              opacity: frame == null ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: child,
                            );
                          },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          'Profile image load error: ${error.toString()}',
                        );
                        return const SizedBox.shrink();
                      },
                    );
                  },
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        user.city,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
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
