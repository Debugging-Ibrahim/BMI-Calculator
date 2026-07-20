import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Meal {
  final int id;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;

  Meal({
    required this.id,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Recipe',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      sourceUrl: json['sourceUrl'] ?? '',
    );
  }
}

class Nutrients {
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;

  Nutrients({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      calories: (json['calories'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      carbohydrates: (json['carbohydrates'] ?? 0.0).toDouble(),
    );
  }
}

class MealPlan {
  final List<Meal> meals;
  final Nutrients nutrients;

  MealPlan({required this.meals, required this.nutrients});

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    var mealsList = json['meals'] as List? ?? [];
    List<Meal> parsedMeals = mealsList.map((m) => Meal.fromJson(m)).toList();
    Nutrients parsedNutrients = Nutrients.fromJson(json['nutrients'] ?? {});

    return MealPlan(
      meals: parsedMeals,
      nutrients: parsedNutrients,
    );
  }
}

class MealPlanService {
  static Future<MealPlan?> fetchMealPlan(double targetCalories) async {
    final apiKey = dotenv.env['SPOONACULAR_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Spoonacular API key is missing. Please add it to your .env file.');
    }

    final url = Uri.parse(
      'https://api.spoonacular.com/mealplanner/generate?timeFrame=day&targetCalories=${targetCalories.round()}&apiKey=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MealPlan.fromJson(data);
      } else {
        throw Exception('Failed to generate meal plan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching meal plan: $e');
      rethrow;
    }
  }
}
