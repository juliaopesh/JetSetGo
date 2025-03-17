import 'package:flutter/material.dart';

class PackingListScreen extends StatefulWidget {
  @override
  _PackingListScreenState createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  List<Map<String, dynamic>> _packingItems = [];

  void _showAddItemDialog() {
    TextEditingController _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Item"),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: "Enter item name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  setState(() {
                    _packingItems.add({
                      "text": _textController.text.trim(),
                      "checked": false
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      _packingItems[index]["checked"] = value!;
    });
  }

  void _getAISuggestions() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fetching AI suggestions...")),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AI Suggestions"),
          content: Text("This feature provides AI-generated packing recommendations based on your trip."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Got it!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Packing List"),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _packingItems.isEmpty
                ? Text("No items yet. Tap + to add.")
                : Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _packingItems.map((item) {
                        int index = _packingItems.indexOf(item);
                        return Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: item["checked"],
                                  onChanged: (value) => _toggleCheckbox(index, value),
                                ),
                                Expanded(
                                  child: Text(
                                    item["text"],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          Positioned(
            bottom: 20,
            right: 0, // Keeps button inside screen
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Info button peeking out from left 
                GestureDetector(
                  onTap: _showInfoDialog,
                  child: ClipOval(
                    child: Container(
                      width: 30,
                      height: 30,
                      color: Colors.blue[600],
                      alignment: Alignment.center,
                      child: Icon(Icons.info, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                SizedBox(width: 5), // Small spacing to separate from the main button
                // Main AI Suggestions button
                GestureDetector(
                  onTap: _getAISuggestions,
                  child: ClipRRect(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3, // 40% of screen width
                      height: 60,
                      color: Colors.blue[800],
                      alignment: Alignment.center,
                      child: Text(
                        "Get AI Suggestions",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
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
