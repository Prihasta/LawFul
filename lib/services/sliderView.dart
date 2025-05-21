import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/sliderModel.dart';



class SliderDetailView extends StatelessWidget {
  final SliderModel slider;

  const SliderDetailView({Key? key, required this.slider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(slider.name ?? "Slider Details"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image with animation
            Hero(
              tag: 'slider_${slider.image}',
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(slider.image ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    slider.name ?? "News Details",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    slider.description ?? 
                    "This is a detailed view of the news content. Here you can find more information about the news article, including key insights, background information, and more context about the topic.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional content sections
                  const ContentSection(
                    icon: Icons.access_time,
                    title: "Latest Updates",
                    content: "Stay informed with the most recent developments and updates on this topic.",
                  ),
                  
                  const Divider(height: 32),
                  
                  const ContentSection(
                    icon: Icons.info_outline,
                    title: "Background Information",
                    content: "Learn about the history and context behind this news story.",
                  ),
                  
                  const Divider(height: 32),
                  
                  const ContentSection(
                    icon: Icons.people_outline,
                    title: "Key Figures",
                    content: "Find out about the important people involved in this news story.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.share,
                "Share",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sharing news...")),
                  );
                },
              ),
              _buildActionButton(
                context,
                Icons.bookmark_border,
                "Save",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("News saved to bookmarks")),
                  );
                },
              ),
              _buildActionButton(
                context,
                Icons.comment_outlined,
                "Comment",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Comments section")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}