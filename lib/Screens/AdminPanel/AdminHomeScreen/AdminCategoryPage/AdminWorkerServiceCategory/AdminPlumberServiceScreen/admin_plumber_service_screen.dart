import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';

class AdminPlumberServiceScreen extends StatefulWidget {
  @override
  _AdminPlumberServiceScreenState createState() =>
      _AdminPlumberServiceScreenState();
}

class _AdminPlumberServiceScreenState extends State<AdminPlumberServiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to update plumber status and move data to userPlumber collection
  Future<void> _updatePlumberStatus(String plumberId, String status) async {
    try {
      // Fetch plumber details from adminPlumber collection
      DocumentSnapshot plumberSnapshot = await _firestore
          .collection('adminPlumber')
          .doc(plumberId)
          .get();

      if (!plumberSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Plumber not found.')));
        return;
      }

      // Get plumber data
      final plumberData = plumberSnapshot.data() as Map<String, dynamic>;

      // Update status in adminPlumber collection
      await _firestore.collection('adminPlumber').doc(plumberId).update({
        'status': status,
      });

      // If approved, add plumber data to userPlumber collection
      if (status == 'Approved') {
        await _firestore.collection('userPlumber').doc(plumberId).set({
          'status': 'Approved',
          'name': plumberData['name'],
          'specialization': plumberData['specialization'],
          'contact': plumberData['contact'],
          'location': plumberData['location'],
          'description': plumberData['description'],
          'imageUrl': plumberData['imageUrl'],
          'isVisible': true,  // Ensure plumber is visible
        });
      } else {
        // If not approved, remove plumber from userPlumber collection
        await _firestore.collection('userPlumber').doc(plumberId).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Plumber status updated to $status successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update status: $e')));
    }
  }

  // Method to delete plumber from adminPlumber and userPlumber collection
  Future<void> _deletePlumber(String plumberId) async {
    try {
      // Delete from adminPlumber collection
      await _firestore.collection('adminPlumber').doc(plumberId).delete();

      // Also delete from userPlumber collection if exists
      await _firestore.collection('userPlumber').doc(plumberId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Plumber deleted successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete plumber: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Admin - Plumber'),
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
                        .collection('adminPlumber')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No plumber services available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final plumberId = docs[index].id;
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
                                                      _updatePlumberStatus(plumberId, newValue);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            // Delete Button
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _deletePlumber(plumberId);
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
