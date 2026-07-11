import 'package:flutter/material.dart';

class Assignment {
  String subject;
  String homework;
  String priority;
  DateTime? dueDate;

  bool completed;
  bool isExpanded;

  Assignment({
    required this.subject,
    required this.homework,
    required this.priority,
    this.dueDate,
    this.completed = false,
    this.isExpanded = false,
  });
}

class StudentPlannerPage extends StatefulWidget {
  const StudentPlannerPage({super.key});

  @override
  State<StudentPlannerPage> createState() => _StudentPlannerPageState();
}

class _StudentPlannerPageState extends State<StudentPlannerPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController homeworkController = TextEditingController();

  String selectedPriority = "Medium";
  DateTime? selectedDate;

  final List<Assignment> assignments = [];

  @override
  void dispose() {
    subjectController.dispose();
    homeworkController.dispose();
    super.dispose();
  }

  void addAssignment() {
    if (subjectController.text.trim().isEmpty ||
        homeworkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields."),
        ),
      );
      return;
    }

    setState(() {
      assignments.add(
        Assignment(
          subject: subjectController.text.trim(),
          homework: homeworkController.text.trim(),
          priority: selectedPriority,
          dueDate: selectedDate,
        ),
      );

      subjectController.clear();
      homeworkController.clear();
      selectedPriority = "Medium";
      selectedDate = null;
    });
  }

  void deleteAssignment(int index) {
    setState(() {
      assignments.removeAt(index);
    });
  }

  Future<void> chooseDate() async {
    DateTime now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return "No due date selected";
    }
    return "${date.month}/${date.day}/${date.year}";
  }

  Color cardColor(String priority) {
    switch (priority) {
      case "High":
        return const Color(0xFFFFD6DB);
      case "Medium":
        return const Color(0xFFFFEEAE);
      case "Low":
        return const Color(0xFFD7F6D8);
      default:
        return Colors.white;
    }
  }

  IconData priorityIcon(String priority) {
    switch (priority) {
      case "High":
        return Icons.priority_high;
      case "Medium":
        return Icons.remove;
      case "Low":
        return Icons.keyboard_arrow_down;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFF8),
      appBar: AppBar(
        title: const Text("Student Planner"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF5EFF8),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: "Subject",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: homeworkController,
              decoration: InputDecoration(
                hintText: "Homework / Assignment",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(
                labelText: "Priority",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: "High", child: Text("High")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Low", child: Text("Low")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDate(selectedDate)),
                ElevatedButton(
                  onPressed: chooseDate,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Choose Date"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addAssignment,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Add Assignment"),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: assignments.isEmpty
                  ? const Center(
                      child: Text("No Assignments yet"),
                    )
                  : ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final assignment = assignments[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: 2,
                            color: cardColor(assignment.priority),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: assignment.completed,
                                        onChanged: (value) {
                                          setState(() {
                                            assignment.completed = value!;
                                          });
                                        },
                                      ),

                                      Expanded(
                                        child: Text(
                                          assignment.subject,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            decoration: assignment.completed
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),

                                      AnimatedRotation(
                                        turns: assignment.isExpanded ? 0.5 : 0,
                                        duration: const Duration(milliseconds: 250),
                                        child: IconButton(
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          onPressed: () {
                                            setState(() {
                                              assignment.isExpanded =
                                                  !assignment.isExpanded;
                                            });
                                          },
                                        ),
                                      ),

                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          deleteAssignment(index);
                                        },
                                      ),
                                    ],
                                  ),

                                  AnimatedCrossFade(
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(assignment.homework),
                                          const SizedBox(height: 10),
                                          Text("Priority: ${assignment.priority}"),
                                          const SizedBox(height: 5),
                                          Text("Due: ${formatDate(assignment.dueDate)}"),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                priorityIcon(assignment.priority),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(assignment.priority),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    crossFadeState: assignment.isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 250),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
