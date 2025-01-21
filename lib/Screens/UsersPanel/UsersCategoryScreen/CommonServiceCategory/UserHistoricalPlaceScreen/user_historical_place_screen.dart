import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../Styles/BackGroundStyle.dart';
import '../../../../../../Utilitys/utilitys.dart';

class UserHistoricalPlaceScreen extends StatefulWidget {
  @override
  _UserHistoricalPlaceScreenState createState() =>
      _UserHistoricalPlaceScreenState();
}

class _UserHistoricalPlaceScreenState extends State<UserHistoricalPlaceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _openDetailsScreen(Map<String, dynamic> data) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => HistoricalPlaceDetailsScreen(data: data)));
  }

  // Search function
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('দর্শনীয় স্থান'),
      body: Stack(
        children: [
          ScreenBackground(context),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Historical Place by Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('HistoricalPlace')
                      .where('name', isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                          isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final HistoricalPlaces = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: HistoricalPlaces.length,
                      itemBuilder: (context, index) {
                        final data = HistoricalPlaces[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              // Background Image
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/history-place.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              // Card with transparent background
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.85),
                                // Semi-transparent background
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.pColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: data['image'] != null
                                            ? Image.network(
                                                data['image'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Icons.local_hospital,
                                                size: 50),
                                        title: Text(
                                          data['name'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: AppColors.pColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.red,
                                            ),
                                            Text(data['location']),
                                          ],
                                        ),
                                        onTap: () => _openDetailsScreen(data),
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_sharp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoricalPlaceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  HistoricalPlaceDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        data['name'],
      ),
      body: Stack(
        children: [
          ScreenBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section with Gradient Overlay
                _buildImageSection(),
                const SizedBox(height: 10),
                // Hospital Name & Location
                _buildHistoricalPlaceNameAndLocation(),
                const SizedBox(height: 10),
                // Contact Info Card (Phone, Email, Website)
                _buildContactCard(context),
                const SizedBox(height: 10),
                // Description Card
                _buildDescriptionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Image Section with Gradient Overlay
  Widget _buildImageSection() {
    return Stack(
      children: [
        data['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  data['image'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Icon(
                  Icons.local_hospital,
                  size: 100,
                  color: Colors.grey[700],
                ),
              ),
        // Gradient Overlay for Image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Hospital Name and Location
  // Hospital Name and Location
  Widget _buildHistoricalPlaceNameAndLocation() {
    return Card(
      elevation: 12,
      color: AppColors.pColor.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // Center text in the Card
        children: [
          const SizedBox(height: 5),
          // Hospital Name
          Center(
            child: Text(
              data['name'],
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor),
            ),
          ),
          const SizedBox(height: 5),
          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.red,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  data['location'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Contact Info Card with Buttons at the Bottom
  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: 12,
      color: AppColors.sdColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Title
            const Center(
              child: Text(
                'Contact Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pColor),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Information List with Icons
            _buildContactItem(Icons.phone, 'Phone', data['contact']),
            const SizedBox(height: 15),

            _buildContactItem(Icons.email, 'Email', data['email']),
            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => launchWebsite(data['website'], context),
              child:
                  _buildContactItem(Icons.language, 'Website', data['website']),
            ),

            const SizedBox(height: 20),

            // Buttons at the Bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call Button
                _buildContactButton(
                    Icons.phone,
                    'Call',
                    () => showCallDialog(data['contact'], context),
                    Colors.green),

                // Email Button
                _buildContactButton(Icons.email, 'Email',
                    () => sendEmail(data['email'], context), Colors.blue),

                // Website Button
                _buildContactButton(
                    Icons.language,
                    'Website',
                    () => launchWebsite(data['website'], context),
                    Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each contact item (Phone, Email, Website)
  Widget _buildContactItem(IconData icon, String title, String content) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$title: $content',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Contact Buttons (Call, Email, Website)
  Widget _buildContactButton(
      IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 8,
      ),
    );
  }

  // Description Card
  Widget _buildDescriptionCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Title
            const Center(
              child: Text(
                'About Historical ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pColor),
              ),
            ),
            const SizedBox(height: 10),
            // Description Text
            Text(
              data['description'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
