import 'package:district_online_service/Screens/UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/BloodDonerListScreen/data_models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pretty_animated_buttons/widgets/pretty_neumorphic_button.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Widgets/Custom_appBar_widgets.dart';
import '../../../../../Widgets/calling_dialog.dart';
import '../../../../UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/BloodDonerListScreen/Edit_blood_doner.dart';
import '../../../../UsersPanel/UsersCategoryScreen/EmargencyServiceCategory/BloodDonerListScreen/blood_doner_form.dart';

class AdminBloodDonorScreen extends StatefulWidget {
  @override
  _AdminBloodDonorScreenState createState() => _AdminBloodDonorScreenState();
}
class _AdminBloodDonorScreenState extends State<AdminBloodDonorScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchCategory = 'name';
  List<BloodDonorModels> _donors = [];

  void _deleteDonor(String id, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('আপনি কি নিশ্চিত যে আপনি এই তথ্যটি মুছে ফেলতে চান?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('এই করার পর তথ্যটি ফিরে পাওয়া সম্ভব হবে না।'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('বাতিল করুন'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('মুছে ফেলুন'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('blood_donors')
                    .doc(id)
                    .delete();
                setState(() {
                  _donors.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showBloodDonorForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
          child: AdminBloodDonorForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Blood Donor"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              color: AppColors.pColor.withOpacity(.3),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "রক্তের গ্রুপ যোগ করুন :  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'kalpurush',
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  PrettyNeumorphicButton(
                    label: 'Click Here !!',

                    duration: Duration(microseconds: 1),
                    onPressed:_showBloodDonorForm,

                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.pColor.withOpacity(.3),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    DropdownButton<String>(
                      value: _searchCategory,
                      items: const [
                        DropdownMenuItem(
                          value: 'name',
                          child: Text('Name'),
                        ),
                        DropdownMenuItem(
                          value: 'bloodGroup',
                          child: Text('Blood Group'),
                        ),
                        DropdownMenuItem(
                          value: 'location',
                          child: Text('Location'),
                        ),
                        DropdownMenuItem(
                          value: 'age',
                          child: Text('Age'),
                        ),
                        DropdownMenuItem(
                          value: 'contact',
                          child: Text('Contact'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _searchCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('blood_donors')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                _donors = snapshot.data!.docs
                    .map((doc) => BloodDonorModels.fromFirestore(doc))
                    .toList();

                List<BloodDonorModels> filteredDonors = _donors.where((donor) {
                  switch (_searchCategory) {
                    case 'name':
                      return donor.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                    case 'bloodGroup':
                      return donor.bloodGroup
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                    case 'location':
                      return donor.location
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                    case 'age':
                      return donor.age
                          .toString()
                          .contains(_searchController.text);
                    case 'contact':
                      return donor.contact.contains(_searchController.text);
                    default:
                      return false;
                  }
                }).toList();

                return ListView.builder(
                  itemCount: filteredDonors.length,
                  itemBuilder: (context, index) {
                    BloodDonorModels donor = filteredDonors[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/icons/donorLogo.png'),
                                  fit: BoxFit.contain,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 8,
                            color: AppColors.wColor.withOpacity(.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.pColor, width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                      ),
                                      child: donor.image_url.isNotEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors.pColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Image.network(
                                                  donor.image_url,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              'assets/images/user.png',
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Flexible(
                                                child: Text(
                                                  donor.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.bColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Flexible(
                                                child: Text(
                                                  donor.location,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.bColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.cake,
                                                size: 18,
                                                color: Colors.purpleAccent,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Flexible(
                                                child: Text(
                                                  'Age: ${donor.age}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.bColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Flexible(
                                                child: Text(
                                                  donor.contact,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.bColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              // Change the icon color based on the availability
                                              Icon(
                                                Icons.circle,
                                                size: 12,
                                                color: donor.availability == 'Available' ? Colors.green : Colors.red, // Green for Available, Red for Not Available
                                              ),
                                              const SizedBox(width: 6.0),
                                              Text(
                                                donor.availability,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: donor.availability == 'Available' ? Colors.green : Colors.red, // Match the text color with the icon
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  showCallDialog(
                                                      donor.contact, context);
                                                },
                                                icon: const Icon(
                                                  Icons.call,
                                                  color: AppColors.pColor,
                                                ),
                                                label: const Text("Call"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.red.shade500,
                                          child: Text(
                                            donor.bloodGroup,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'kalpurush',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _deleteDonor(donor.id, index);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            25)),
                                              ),
                                              builder: (BuildContext context) {
                                                return EditDonarFormScreen(
                                                  donor: donor,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
    );
  }
}
