import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../models/reservation.dart';

class AddReservation extends StatefulWidget {
  final String drinkName;

  AddReservation({required this.drinkName});

  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
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
      ..drinkName = widget.drinkName;  // Save the drink name

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
      appBar: AppBar(
        title: Text(
          'Reservation for ${widget.drinkName}',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: GoogleFonts.poppins(),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.poppins(),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: GoogleFonts.poppins(),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Select Reservation Date'
                    : 'Reservation Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                style: GoogleFonts.poppins(),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _peopleController,
              decoration: InputDecoration(
                labelText: 'Number of People',
                labelStyle: GoogleFonts.poppins(),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: GoogleFonts.poppins(),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: _addReservation,
              child: Center(
                child: Text(
                  'Add Reservation',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.brown[600],
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
