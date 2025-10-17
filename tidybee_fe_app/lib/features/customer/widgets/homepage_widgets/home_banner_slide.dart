import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBannerSlide extends StatefulWidget {
  const HomeBannerSlide({super.key});

  @override
  State<HomeBannerSlide> createState() => _HomeBannerSlideState();
}

class _HomeBannerSlideState extends State<HomeBannerSlide> {
  int _currentIndex = 0;

  final List<String> bannerImages = [
    'lib/assets/images/cleaner1.webp',
    'lib/assets/images/cleaner2.jpg',
    'lib/assets/images/cleaner3.jpg',
    'lib/assets/images/cleaner4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slide
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true, //Auto slide into next image
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // Render images
          items: bannerImages.map((imagePath) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: bannerImages.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.orange
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
