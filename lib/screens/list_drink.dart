import 'dart:async';
import 'package:flutter/material.dart';
import 'drink_detail.dart';
import 'package:projek_akhir_cocktail/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DrinksScreen extends StatefulWidget {
  final String category;

  DrinksScreen({required this.category});

  @override
  _DrinksScreenState createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> {
  List<Map<String, String>> drinks = [];
  List<Map<String, String>> filteredDrinks = [];
  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchDrinks();
    searchController = TextEditingController();
  }

  Future<void> fetchDrinks() async {
    final drinksList = await ApiService.fetchDrinks(widget.category);
    setState(() {
      drinks = drinksList;
      filteredDrinks = drinks;
    });
  }

  void filterDrinks(String query) {
    List<Map<String, String>> filteredList = [];
    filteredList.addAll(drinks);
    if (query.isNotEmpty) {
      filteredList.retainWhere((drink) =>
          drink['name']!.toLowerCase().contains(query.toLowerCase()));
    }
    setState(() {
      filteredDrinks = filteredList;
    });
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterDrinks(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 15,
                right: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to the ${widget.category} Drinks!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Use the search bar below to find your favorite drink.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDrinks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        filteredDrinks[index]['name']!,
                        style: GoogleFonts.poppins(),
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            filteredDrinks[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrinkDetailScreen(
                                drinkName: filteredDrinks[index]['name']!,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Detail',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
