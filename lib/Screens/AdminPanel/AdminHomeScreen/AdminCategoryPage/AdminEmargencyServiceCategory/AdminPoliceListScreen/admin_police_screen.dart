import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Styles/ElevatedBottonStyle.dart';
import '../../../../../../Styles/TextContainerStyle.dart';

class PoliceDataModels {
  final String id; // Add ID field
  final String location;
  final String name;
  final String designation;
  final String contact;
  final String email;
  bool isCall;

  PoliceDataModels({
    required this.id,
    required this.location,
    required this.name,
    required this.designation,
    required this.email,
    required this.contact,
    this.isCall = false,
  });

  factory PoliceDataModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PoliceDataModels(
      id: doc.id,
      // Assign document ID
      location: data['location'] ?? '',
      name: data['name'] ?? '',
      designation: data['designation'] ?? '',
      email: data['email'] ?? '',
      contact: data['contact'] ?? '',
    );
  }
}

class AdminPoliceScreen extends StatefulWidget {
  @override
  _AdminPoliceScreenState createState() => _AdminPoliceScreenState();
}

class _AdminPoliceScreenState extends State<AdminPoliceScreen> {
  final List<PoliceDataModels> allCategories = [];
  List<PoliceDataModels> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('PoliceList').get();
    final categories = querySnapshot.docs
        .map((doc) => PoliceDataModels.fromFirestore(doc))
        .toList();
    setState(() {
      allCategories.addAll(categories);
      filteredCategories.addAll(categories);
    });
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = allCategories
          .where((category) =>
              category.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showCallDialog(String phoneNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Call Alert!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
          content: Text(
            'অত্যাধিক প্রয়োজন ব্যাতিত এই নম্বরে কল করা থেকে বিরত থাকুন !! $phoneNo ?',
            style: const TextStyle(fontSize: 16, fontFamily: 'kalpurush'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'বিরত থাকুন',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'kalpurush',
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _makePhoneCall(phoneNo); // Make the phone call
              },
              child: const Text(
                'ফোন করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'kalpurush',
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _makePhoneCall(String phoneNo) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNo);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  void _deleteCategory(String id, int index) async {
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
                    .collection('PoliceList')
                    .doc(id)
                    .delete();
                setState(() {
                  filteredCategories.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editCategory(PoliceDataModels category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PoliceForm(
          category: category,
          onSubmit: (updatedCategory) {
            setState(() {
              int index = filteredCategories
                  .indexWhere((cat) => cat.id == updatedCategory.id);
              if (index != -1) {
                filteredCategories[index] = updatedCategory;
                allCategories[allCategories.indexWhere(
                    (cat) => cat.id == updatedCategory.id)] = updatedCategory;
              }
            });
          },
        );
      },
    );
  }

  void _addCategory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PoliceForm(
          onSubmit: (newCategory) {
            setState(() {
              filteredCategories.add(newCategory);
              allCategories.add(newCategory);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pColor,
        title: const Text(
          "Police",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontFamily: 'kalpurush',
            color: Colors.white,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        backgroundColor: AppColors.pColor,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCategories,
              decoration: InputDecoration(
                hintText: "তথ্য খুঁজুন...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return PiliceListItem(
                  category: filteredCategories[index],
                  onMakeCall: () {
                    _showCallDialog(filteredCategories[index].contact);
                  },
                  onDelete: () {
                    _deleteCategory(filteredCategories[index].id, index);
                  },
                  onEdit: () {
                    _editCategory(filteredCategories[index]);
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

class PiliceListItem extends StatelessWidget {
  final PoliceDataModels category;
  final VoidCallback onMakeCall;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  PiliceListItem({
    required this.category,
    required this.onMakeCall,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.4),
          border: Border.all(color: AppColors.pColor, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/logos/PoliceLogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.85),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child:TextContainerStyle(category.location,const Color(0xFF0E4399))
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'kalpurush',
                              ),
                            ),
                            Text(
                              category.designation,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'kalpurush',
                              ),

                            ),
                            Row(
                              children: [
                                const Text(
                                  " মোবাইল: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),

                                ),
                                Text(
                                  category.contact,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                    fontFamily: 'kalpurush',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  " ইমেইল : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  category.email,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.blueGrey,
                                    fontFamily: 'kalpurush',
                                    fontWeight: FontWeight.w500,
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
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: onMakeCall,
                    icon: const Icon(
                      Icons.call,
                      color: AppColors.pColor,
                    ),
                    label: const Text(
                      'ফোন করুন',
                      style: TextStyle(
                        color: AppColors.pColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'kalpurush',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'মুছে ফেলুন',
                        style: TextStyle(
                          color: AppColors.pColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'kalpurush',
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        'এডিট করুন',
                        style: TextStyle(
                          color: AppColors.pColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'kalpurush',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PoliceForm extends StatefulWidget {
  final PoliceDataModels? category;
  final Function(PoliceDataModels) onSubmit;

  PoliceForm({this.category, required this.onSubmit});

  @override
  _PoliceFormState createState() => _PoliceFormState();
}

class _PoliceFormState extends State<PoliceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _contact, _designation, _location;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _name = widget.category!.name;
      _email = widget.category!.email;
      _contact = widget.category!.contact;
      _designation = widget.category!.designation;
      _location = widget.category!.location;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (widget.category == null) {
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('PoliceList').add({
          'name': _name,
          'email': _email,
          'contact': _contact,
          'location': _location,
          'designation': _designation,
        });
        widget.onSubmit(PoliceDataModels(
          id: docRef.id,
          name: _name!,
          designation: _designation!,
          contact: _contact!,
          location: _location!,
          email: _email!,
        ));
      } else {
        await FirebaseFirestore.instance
            .collection('PoliceList')
            .doc(widget.category!.id)
            .update({
          'name': _name,
          'email': _email,
          'contact': _contact,
          'location': _location,
          'designation': _designation,
        });
        widget.onSubmit(PoliceDataModels(
          id: widget.category!.id,
          name: _name!,
          designation: _designation!,
          contact: _contact!,
          location: _location!,
          email: _email!,
        ));
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.pColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.pColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      TextContainerStyle(
                          "FillUp Police Form", AppColors.pColor),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _name,
                        decoration: _inputDecoration('Name'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter your name';
                          return null;
                        },
                        onSaved: (value) => _name = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _designation,
                        decoration: _inputDecoration('Designation'),
                        onSaved: (value) => _designation = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _email,
                        decoration: _inputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter your email';
                          return null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _contact,
                        decoration: _inputDecoration('Contact'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter contact';
                          return null;
                        },
                        onSaved: (value) => _contact = value,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _location,
                        decoration: _inputDecoration('Location'),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter your location';
                          return null;
                        },
                        onSaved: (value) => _location = value,
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButtonStyle(
                              text: "Submit", onPressed: _submitForm),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
