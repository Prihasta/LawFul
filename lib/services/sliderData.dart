import 'package:flutter_application_1/model/sliderModel.dart';

List<SliderModel> getSliders() {
  return [
    SliderModel(
      image: "images/business.jpg", 
      name: "Business News",
      description: "Stay updated with the latest business trends, market analysis, and economic forecasts."
    ),
    SliderModel(
      image: "images/entertainment.jpg", 
      name: "Entertainment",
      description: "Discover the latest movies, music, celebrities, and entertainment events from around the world."
    ),
    SliderModel(
      image: "images/health.jpg", 
      name: "Health & Wellness",
      description: "Tips and advice for maintaining a healthy lifestyle, medical breakthroughs, and fitness guidance."
    ),
    SliderModel(
      image: "images/science.jpg", 
      name: "Science Discoveries",
      description: "Explore fascinating scientific discoveries, research breakthroughs, and technological innovations."
    ),
    SliderModel(
      image: "images/sports.jpg", 
      name: "Sports Coverage",
      description: "Get the latest scores, player updates, and coverage of sporting events from around the globe."
    ),
    SliderModel(
      image: "images/tech.jpg", 
      name: "Technology",
      description: "The newest gadgets, software updates, and digital trends shaping our future."
    ),
  ];
}