import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../AppColors/AppColors.dart';

class AdminElectricianServiceScreen extends StatefulWidget {
  @override
  _AdminElectricianServiceScreenState createState() =>
      _AdminElectricianServiceScreenState();
}

class _AdminElectricianServiceScreenState extends State<AdminElectricianServiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to update electrician status and move data to userElectrician collection
  Future<void> _updateElectricianStatus(String electricianId, String status) async {
    try {
      // Fetch electrician details from adminElectrician collection
      DocumentSnapshot electricianSnapshot = await _firestore
          .collection('adminElectrician')
          .doc(electricianId)
          .get();

      if (!electricianSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Electrician not found.')));
        return;
      }

      // Get electrician data
      final electricianData = electricianSnapshot.data() as Map<String, dynamic>;

      // Update status in adminElectrician collection
      await _firestore.collection('adminElectrician').doc(electricianId).update({
        'status': status,
      });

      // If approved, add electrician data to userElectrician collection
      if (status == 'Approved') {
        await _firestore.collection('userElectrician').doc(electricianId).set({
          'status': 'Approved',
          'name': electricianData['name'],
          'specialization': electricianData['specialization'],
          'contact': electricianData['contact'],
          'location': electricianData['location'],
          'description': electricianData['description'],
          'imageUrl': electricianData['imageUrl'],
          'isVisible': true,  // Ensure electrician is visible
        });
      } else {
        // If not approved, remove electrician from userElectrician collection
        await _firestore.collection('userElectrician').doc(electricianId).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Electrician status updated to $status successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update status: $e')));
    }
  }

  // Method to delete electrician from adminElectrician and userElectrician collection
  Future<void> _deleteElectrician(String electricianId) async {
    try {
      // Delete from adminElectrician collection
      await _firestore.collection('adminElectrician').doc(electricianId).delete();

      // Also delete from userElectrician collection if exists
      await _firestore.collection('userElectrician').doc(electricianId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Electrician deleted successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete electrician: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Admin - Electrician'),
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
                        .collection('adminElectrician')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No electrician services available.',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final electricianId = docs[index].id;
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
                                                      _updateElectricianStatus(electricianId, newValue);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            // Delete Button
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                _deleteElectrician(electricianId);
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
