import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddDocumentDialog extends StatefulWidget {
  final Function(String, DateTime, File) onDocumentAdded; // Pass the new document to WalletPage

  const AddDocumentDialog({super.key, required this.onDocumentAdded});

  @override
  _AddDocumentDialogState createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedFile;

  // Function to pick a PDF file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Only allow PDFs for now?
    );

    if (!mounted) return; //ensure widget is still mounted

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected or file path missing")),
      );
    }
  }

  // Function to pick a date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to save the document locally
  void _saveDocument() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title")),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a date")),
      );
      return;
    }

    if (_selectedFile == null || _titleController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a pdf file")),
      );
      return;
    }

    widget.onDocumentAdded(
      _titleController.text,
      _selectedDate!,
      _selectedFile!,
    );

    Navigator.pop(context); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Document"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Document Title"),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedDate == null
                  ? "No date selected"
                  : "Date: ${_selectedDate!.toLocal()}".split(' ')[0]),
              TextButton(
                onPressed: _pickDate,
                child: const Text("Pick Date"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedFile == null ? "No file selected" : "PDF selected"),
              TextButton(
                onPressed: _pickFile,
                child: const Text("Choose PDF"),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: _saveDocument, child: const Text("Save")),
      ],
    );
  }
}
