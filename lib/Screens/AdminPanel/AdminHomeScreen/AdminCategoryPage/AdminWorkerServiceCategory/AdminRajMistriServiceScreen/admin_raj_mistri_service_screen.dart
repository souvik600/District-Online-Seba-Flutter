import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';

class AdminRajMistriServiceScreen extends StatefulWidget {
  @override
  _AdminRajMistriServiceScreenState createState() =>
      _AdminRajMistriServiceScreenState();
}

class _AdminRajMistriServiceScreenState extends State<AdminRajMistriServiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to update RajMistri status and move data to userRajMistri collection
  Future<void> _updateRajMistriStatus(String rajMistriId, String status) async {
    try {
      // Fetch RajMistri details from adminRajMistri collection
      DocumentSnapshot rajMistriSnapshot = await _firestore
          .collection('adminRajMistri')
          .doc(rajMistriId)
          .get();

      if (!rajMistriSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('RajMistri not found.')));
        return;
      }

      // Get RajMistri data
      final rajMistriData = rajMistriSnapshot.data() as Map<String, dynamic>;

      // Update status in adminRajMistri collection
      await _firestore.collection('adminRajMistri').doc(rajMistriId).update({
        'status': status,
      });

      // If approved, add RajMistri data to userRajMistri collection
      if (status == 'Approved') {
        await _firestore.collection('userRajMistri').doc(rajMistriId).set({
          'status': 'Approved',
          'name': rajMistriData['name'],
          'specialization': rajMistriData['specialization'],
          'contact': rajMistriData['contact'],
          'location': rajMistriData['location'],
          'description': rajMistriData['description'],
          'imageUrl': rajMistriData['imageUrl'],
          'isVisible': true,  // Ensure RajMistri is visible
        });
      } else {
        // If not approved, remove RajMistri from userRajMistri collection
        await _firestore.collection('userRajMistri').doc(rajMistriId).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('RajMistri status updated to $status successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update status: $e')));
    }
  }

  // Method to delete RajMistri from adminRajMistri and userRajMistri collection
  Future<void> _deleteRajMistri(String rajMistriId) async {
    try {
      // Delete from adminRajMistri collection
      await _firestore.collection('adminRajMistri').doc(rajMistriId).delete();

      // Also delete from userRajMistri collection if exists
      await _firestore.collection('userRajMistri').doc(rajMistriId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('RajMistri deleted successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete RajMistri: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Admin - RajMistri'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('adminRajMistri')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No RajMistri services available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final rajMistriId = docs[index].id;
                          final status = data['status'] ?? 'Pending';
                          Color statusColor;

                          // Set status color based on the status value
                          if (status == 'Pending') {
                            statusColor = Colors.orange; // Pending status color
                          } else if (status == 'Approved') {
                            statusColor = Colors.green; // Approved status color
                          } else {
                            statusColor = Colors.red; // Not Approved status color
                          }

                          return Card(
                            elevation: 5,
                            color: AppColors.wColor.withOpacity(.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.pColor, width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.pColor, width: 2.0),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  data['imageUrl'] ?? '',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                DropdownButton<String>(
                                                  value: data['status'] ?? 'Pending', // Default
                                                  items: <String>['Pending', 'Approved', 'Not Approved']
                                                      .map((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      _updateRajMistriStatus(rajMistriId, newValue);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            // Delete Button
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _deleteRajMistri(rajMistriId);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8.0),
                                    // Details Section
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Name and Specialization
                                          Row(
                                            children: [
                                              const Icon(Icons.person, size: 16, color: Colors.black),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  data['name'] ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data['specialization'] ?? 'N/A',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          const Divider(),
                                          // Contact Information
                                          Row(
                                            children: [
                                              const Icon(Icons.phone, size: 16, color: Colors.blue),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  data['contact'] ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 16, color: Colors.green),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  data['location'] ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.description, size: 16, color: Colors.amber),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  data['description'] ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Status Row
                                          Row(
                                            children: [
                                              // Icon and Text Color Based on Status
                                              Icon(
                                                status == 'Pending'
                                                    ? Icons.timer
                                                    : status == 'Approved'
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: statusColor,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                status,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
