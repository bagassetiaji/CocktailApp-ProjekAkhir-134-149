import 'package:flutter/material.dart';
import 'package:projek_akhir_cocktail/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_reservation.dart';  // Import the AddReservation screen

class DrinkDetailScreen extends StatefulWidget {
  final String drinkName;

  DrinkDetailScreen({required this.drinkName});

  @override
  _DrinkDetailScreenState createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  Map<String, dynamic> drinkDetail = {};

  @override
  void initState() {
    super.initState();
    fetchDrinkDetail();
  }

  Future<void> fetchDrinkDetail() async {
    final drinkDetails = await ApiService.fetchDrinkDetail(widget.drinkName);
    setState(() {
      drinkDetail = drinkDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.drinkName,
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (drinkDetail['strDrinkThumb'] != null)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        drinkDetail['strDrinkThumb'],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              if (drinkDetail['strAlcoholic'] != null && drinkDetail['strGlass'] != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Type: ${drinkDetail['strAlcoholic']}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Glass: ${drinkDetail['strGlass']}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      drinkDetail['strInstructions'] ?? '',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildIngredientList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReservation(drinkName: widget.drinkName),
                      ),
                    );
                  },
                  child: Text(
                    'Reserve This Drink',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientList() {
    List<Widget> ingredientWidgets = [];
    for (int i = 1; i <= 15; i++) {
      final ingredient = drinkDetail['strIngredient$i'];
      final measure = drinkDetail['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredientWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '$ingredient: $measure',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    }
    return ingredientWidgets;
  }
}
