import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_bloc_app/models/box1_data_map.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class SwipableRectangle extends StatefulWidget {
  final List<Box1Data> cards;
  const SwipableRectangle({super.key, required this.cards});

  @override
  State<SwipableRectangle> createState() => _SwipableRectangleState();
}

class _SwipableRectangleState extends State<SwipableRectangle> {
  final PageController _controller = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: width * 0.7,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          final card = widget.cards[index];

          return Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: width,
                height: width * 0.5,
                decoration: BoxDecoration(
                  gradient: AppColors.gradColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(card.icon, color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          card.title,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(card.data.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.tiles,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      card.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: widget.cards.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 6,
                          dotColor: Colors.white30,
                          activeDotColor: AppColors.tiles,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
