import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/sliderModel.dart';

class SliderDetailScreen extends StatelessWidget {
  final SliderModel slider;

  const SliderDetailScreen({
    Key? key, 
    required this.slider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                slider.name ?? 'Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'slider_${slider.image}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      slider.image ?? 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slider.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Sample content - you can customize this
                  const ContentSection(
                    icon: Icons.new_releases,
                    title: 'Latest Updates',
                    content: 'Stay tuned for the latest updates in this category.',
                  ),
                  const Divider(height: 32),
                  const ContentSection(
                    icon: Icons.star,
                    title: 'Featured Content',
                    content: 'Discover our editor\'s top picks and recommendations.',
                  ),
                  const Divider(height: 32),
                  const ContentSection(
                    icon: Icons.trending_up,
                    title: 'Trending Topics',
                    content: 'See what\'s popular and trending right now.',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Add functionality to save or bookmark
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites')),
                  );
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('Save'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add functionality to explore more
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exploring more content')),
                  );
                },
                icon: const Icon(Icons.explore),
                label: const Text('Explore More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const ContentSection({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}