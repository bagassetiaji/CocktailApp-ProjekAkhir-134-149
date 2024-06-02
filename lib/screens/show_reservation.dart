import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../models/reservation.dart';

class ShowReservation extends StatefulWidget {
  final String drinkName;

  ShowReservation({required this.drinkName});

  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<ShowReservation> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  final _peopleController = TextEditingController();
  final _reservationsBox = Hive.box<Reservation>('reservationsBox');

  void _addReservation() {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final date = _selectedDate;
    final people = int.tryParse(_peopleController.text);

    if (name.isEmpty || phone.isEmpty || date == null || people == null) {
      _showNotification('Failed to add: Incomplete or incorrect data', Colors.red);
      return;
    }

    final reservation = Reservation()
      ..name = name
      ..phone = phone
      ..date = date
      ..people = people
      ..drinkName = widget.drinkName;

    try {
      _reservationsBox.add(reservation);
      _nameController.clear();
      _phoneController.clear();
      setState(() {
        _selectedDate = null;
      });
      _peopleController.clear();
      _showNotification('Successfully added', Colors.green);
    } catch (e) {
      _showNotification('Failed to add: $e', Colors.red);
    }
  }

  void _deleteReservation(int index) {
    try {
      final reservation = _reservationsBox.getAt(index);
      _reservationsBox.deleteAt(index);
      _showNotification('Successfully deleted: ${reservation!.name}', Colors.green);
    } catch (e) {
      _showNotification('Failed to delete: $e', Colors.red);
    }
  }

  void _showNotification(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Reservation!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
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
                  'Find your Reservation.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
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
          Padding(
            padding: const EdgeInsets.only(top: 220, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _reservationsBox.listenable(),
                    builder: (context, Box<Reservation> box, _) {
                      if (box.values.isEmpty) {
                        return Center(
                          child: Text(
                            'No reservations added.',
                            style: GoogleFonts.poppins(color: Colors.black87),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final reservation = box.getAt(index);
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reservation!.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Phone: ${reservation.phone}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    'Date: ${reservation.date.toLocal().toString().split(' ')[0]}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    'People: ${reservation.people}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    'Drink: ${reservation.drinkName}',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => _deleteReservation(index),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
