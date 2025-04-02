import 'package:flutter/material.dart';

typedef OnSaveItinerary = void Function(String day, List<String> activities);

void showItineraryDialog({
  required BuildContext context,
  required bool isEditing,
  String? existingDay,
  List<String>? existingActivities,
  required OnSaveItinerary onSave,
}) {
  final TextEditingController dayController = TextEditingController(
    text: isEditing ? existingDay?.replaceAll(RegExp(r'\D'), '') ?? '' : '',
  );

  List<TextEditingController> timeControllers = [];
  List<TextEditingController> activityControllers = [];
  List<String> selectedAmPm = [];

  final List<String> amPmOptions = ["AM", "PM"];

  if (isEditing && existingActivities != null) {
    for (var activity in existingActivities) {
      final parts = activity.split(" - ");
      final timeParts = parts[0].split(" ");
      timeControllers.add(TextEditingController(text: timeParts[0])); // HH:MM
      selectedAmPm.add(timeParts[1]);
      activityControllers.add(TextEditingController(text: parts[1]));
    }
  } else {
    timeControllers.add(TextEditingController());
    activityControllers.add(TextEditingController());
    selectedAmPm.add("AM");
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Itinerary Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Day:", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: dayController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Enter number",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(timeControllers.length, (index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: timeControllers[index],
                                    decoration: const InputDecoration(labelText: "HH:MM"),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                DropdownButton<String>(
                                  value: selectedAmPm[index],
                                  items: amPmOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setDialogState(() {
                                      selectedAmPm[index] = newValue!;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: activityControllers[index],
                                    decoration: const InputDecoration(labelText: "Activity"),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() {
                                      timeControllers.removeAt(index);
                                      activityControllers.removeAt(index);
                                      selectedAmPm.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            );
                          }),
                          TextButton(
                            onPressed: () {
                              setDialogState(() {
                                timeControllers.add(TextEditingController());
                                activityControllers.add(TextEditingController());
                                selectedAmPm.add("AM");
                              });
                            },
                            child: const Text("+ Add Another Activity"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (dayController.text.isNotEmpty) {
                            List<String> activities = [];
                            for (int i = 0; i < timeControllers.length; i++) {
                              if (timeControllers[i].text.isNotEmpty &&
                                  activityControllers[i].text.isNotEmpty) {
                                activities.add(
                                  "${timeControllers[i].text} ${selectedAmPm[i]} - ${activityControllers[i].text}",
                                );
                              }
                            }
                            if (activities.isNotEmpty) {
                              final day = "Day ${dayController.text}";
                              onSave(day, activities);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(isEditing ? "Update" : "Add"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
