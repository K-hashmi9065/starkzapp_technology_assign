import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_providers.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(usersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load users'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.read(usersProvider.notifier).load(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final users = state.users;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  context.push('/profile/${user.id}');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final dpr = MediaQuery.of(context).devicePixelRatio;
                            final targetWidth = (constraints.maxWidth * dpr)
                                .round();
                            final targetHeight = (constraints.maxHeight * dpr)
                                .round();
                            return Image.network(
                              // Use a higher-resolution image to avoid upscaling artifacts
                              user.imageMediumUrl,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              cacheWidth: targetWidth > 0 ? targetWidth : null,
                              cacheHeight: targetHeight > 0
                                  ? targetHeight
                                  : null,
                              headers: const {
                                'User-Agent': 'Mozilla/5.0 (Flutter)',
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) {
                                  return child;
                                }
                                return Container(color: Colors.grey.shade200);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // Log minimal error information to help diagnose failures
                                debugPrint(
                                  'Image load error: ${error.toString()}',
                                );
                                return const Center(
                                  child: Icon(Icons.broken_image),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.transparent],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.firstName}, ${user.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.city,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white70,
                          ),
                          onPressed: () => ref
                              .read(usersProvider.notifier)
                              .toggleLike(user.id),
                          icon: Icon(
                            user.liked ? Icons.favorite : Icons.favorite_border,
                            color: user.liked ? Colors.red : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
