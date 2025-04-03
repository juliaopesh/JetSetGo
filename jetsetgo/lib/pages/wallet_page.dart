import 'dart:io';
import 'package:open_file/open_file.dart';


import 'package:flutter/material.dart';
import 'package:jetsetgo/components/navbar.dart'; // Import BottomNavBar component
import 'package:jetsetgo/components/add_document.dart'; 


class WalletPage extends StatefulWidget {
  final String tripName; // Accept trip name

  WalletPage({super.key, required this.tripName});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  //wallet items to display
  List<Map<String, dynamic>> walletItems = [];

  //function to add new document to walletItems 
    void _addDocument(String title, DateTime date, File file){
      setState((){
        walletItems.add({
          'title': title, 
          'date': date.toLocal().toString().split(' ')[0], //format date 
          'icon': Icons.picture_as_pdf, //add PDF icon!!! 
        }); 
      });
    }
    

  //function to remove item from walletItems
  void _removeItem(int index) {
    setState(() {
      walletItems.removeAt(index);
    });
  }



  // Add a selectedIndex variable to track the selected bottom nav index
  int _selectedIndex = 1;

  // Update the bottom navigation tap function to handle the navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // You can add more logic for other items if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Match home page background
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
          '${widget.tripName} - Wallet',
           style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // wrap if needed
            textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: walletItems.isEmpty
                  ? const Center(child: Text("No documents added yet."))
                  : ListView.builder(
                      itemCount: walletItems.length,
                      itemBuilder: (context, index) {
                        return WalletCard(
                          title: walletItems[index]['title'],
                          date: walletItems[index]['date'],
                          icon: walletItems[index]['icon'],
                          file: walletItems[index]['file'],
                          onDelete: () => _removeItem(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Add document button 
      floatingActionButton: SizedBox(
        width: 180,  
        height: 60, 
        child: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 222, 177, 109), 
          onPressed: (){
            //show AddDocumentDialog when the user presses the button 
            showDialog(
              context: context, 
              builder: (context) => AddDocumentDialog(
                onDocumentAdded: _addDocument, //pass function to add documents!
              ),
            );
          },

          label: Text(
            'Add Document',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),  // Bigger font
            
          ),
          icon: Icon(Icons.add, size: 28, color: Colors.white),  // Bigger icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,  // Center it at bottom

      // Bottom Navigation Bar added below the floating action button
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex, // Bind the selectedIndex with BottomNavBar
        onItemTapped: _onItemTapped, // Pass the tap handler function
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final VoidCallback onDelete;
  final File file; //to open file on tap

  const WalletCard({
    super.key,
    required this.title,
    required this.date,
    required this.icon,
    required this.onDelete,
    required this.file,
  });

  void _openPDF(BuildContext context){
    OpenFile.open(file.path); //open file w native viewer 
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPDF(context), // 👈 Tap to open
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        color: const Color.fromARGB(255, 245, 244, 246),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.red),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 28, 1, 38),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Date: $date',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
