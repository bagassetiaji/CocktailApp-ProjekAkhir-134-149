import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['drinks'];
      return categoryList.map<String>((e) => e['strCategory']).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Map<String, String>>> fetchDrinks(String category) async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> drinkList = data['drinks'];
      return drinkList
          .map<Map<String, String>>((e) => {'name': e['strDrink'], 'image': e['strDrinkThumb']})
          .toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  static Future<Map<String, dynamic>> fetchDrinkDetail(String drinkName) async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$drinkName'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> drinkList = data['drinks'];
      return drinkList[0];
    } else {
      throw Exception('Failed to load drink detail');
    }
  }
}
