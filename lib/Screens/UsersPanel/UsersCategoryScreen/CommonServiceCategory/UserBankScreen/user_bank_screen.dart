import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../Styles/BackGroundStyle.dart';
import '../../../../../../Utilitys/utilitys.dart';

class UserBankScreen extends StatefulWidget {
  @override
  _UserBankScreenState createState() => _UserBankScreenState();
}

class _UserBankScreenState extends State<UserBankScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _openDetailsScreen(Map<String, dynamic> data) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => BankDetailsScreen(data: data)));
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
      appBar: CustomAppBar('ব্যাংক'),
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
                    hintText: 'Search Bank by Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('banks')
                      .where('name', isGreaterThanOrEqualTo: _searchQuery)
                      .where('name',
                          isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final banks = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: banks.length,
                      itemBuilder: (context, index) {
                        final data = banks[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image:
                                            AssetImage('assets/icons/bank.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.85),
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
                                            : const Icon(Icons.account_balance,
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

class BankDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  BankDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(data['name']),
      body: Stack(
        children: [
          ScreenBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                const SizedBox(height: 15),
                _buildNameAndLocation(),
                const SizedBox(height: 15),
                _buildContactCard(context),
                const SizedBox(height: 15),
                _buildDescriptionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Icon(
                  Icons.comment_bank,
                  size: 100,
                  color: Colors.grey[700],
                ),
              ),
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

  Widget _buildNameAndLocation() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                data['name'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    data['location'],
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  '       প্রতিষ্ঠাপিত : ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  data['establishedYear'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'যোগাযোগের তথ্য',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactButton(Icons.phone, 'Call', () {
                  showCallDialog(data['contact'], context);
                }, Colors.green),
                _buildContactButton(Icons.email, 'Email', () {
                  sendEmail(data['email'], context);
                }, Colors.blue),
                _buildContactButton(Icons.language, 'Website', () {
                  launchWebsite(data['website'], context);
                }, Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String content) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label: $content',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton(
      IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ব্যাংক সম্পর্কে',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
