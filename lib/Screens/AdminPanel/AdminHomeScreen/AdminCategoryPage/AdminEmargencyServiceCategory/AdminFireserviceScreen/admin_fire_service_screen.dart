import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:district_online_service/Utilitys/utilitys.dart';
import 'package:flutter/material.dart';
import '../../../../../../AppColors/AppColors.dart';
import '../../../../../../Styles/TextContainerStyle.dart';
import '../../../../../../Widgets/Custom_appBar_widgets.dart';

class FireServiceModels{
  final String id;
  final String name;
  final String designation;
  final String location;
  final String contact;
  bool isCall;

  FireServiceModels({
      required this.id,
      required this.name,
      required this.designation,
      required this.location,
      required this.contact,
      this.isCall = false,
  });

  factory FireServiceModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FireServiceModels(
      id: doc.id,
      name: data['name'] ?? '',
      designation: data['designation'] ?? '',
      contact: data['contact'] ?? '',
      location: data['location'] ?? '',
    );
  }
}
class AdminFireServiceScreen extends StatefulWidget {
  const AdminFireServiceScreen({super.key});

  @override
  State<AdminFireServiceScreen> createState() => _AdminFireServiceScreenState();
}

class _AdminFireServiceScreenState extends State<AdminFireServiceScreen> {
  final List<FireServiceModels> allCategories = [];
  List<FireServiceModels> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('FireService').get();
    final categories = querySnapshot.docs.map((doc) => FireServiceModels.fromFirestore(doc)).toList();
    setState(() {
      allCategories.addAll(categories);
      filteredCategories.addAll(categories);
    });
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = allCategories
          .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteCategory(String id, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('আপনি কি নিশ্চিত যে আপনি এই তথ্যটি মুছে ফেলতে চান?'),
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
                await FirebaseFirestore.instance.collection('FireService').doc(id).delete();
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
  void _editCategory(FireServiceModels category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FireServiceForm(
          category: category,
          onSubmit: (updatedCategory) {
            setState(() {
              int index = filteredCategories.indexWhere((cat) => cat.id == updatedCategory.id);
              if (index != -1) {
                filteredCategories[index] = updatedCategory;
                allCategories[allCategories.indexWhere((cat) => cat.id == updatedCategory.id)] =
                    updatedCategory;
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
        return FireServiceForm(
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
      appBar:CustomAppBar("ফায়ার সার্ভিস"),
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
                return FireServiceListItem(
                  category: filteredCategories[index],
                  onMakeCall: () {
                    showCallDialog(filteredCategories[index].contact,context);
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
class FireServiceListItem extends StatelessWidget {
  final FireServiceModels category;
  final VoidCallback onMakeCall;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  FireServiceListItem({
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
                        'assets/logos/fireservicelogo.png',
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
                      Center(child: TextContainerStyle(category.name, Colors.deepPurple)),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "ধরন : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
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
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  " অবস্থান: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    fontFamily: 'kalpurush',
                                    color: Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    category.location,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'kalpurush',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  " মোবাইল: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
                                    fontWeight: FontWeight.w400,
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
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
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
class FireServiceForm extends StatefulWidget {
  final FireServiceModels? category;
  final Function(FireServiceModels) onSubmit;

  FireServiceForm({this.category, required this.onSubmit});

  @override
  _FireServiceFormState createState() => _FireServiceFormState();
}

class _FireServiceFormState extends State<FireServiceForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _contact, _designation, _location;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _name = widget.category!.name;
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
        DocumentReference docRef = await FirebaseFirestore.instance.collection('FireService').add({
          'name': _name,
          'designation': _designation,
          'contact': _contact,
          'location': _location,
        });
        widget.onSubmit(FireServiceModels(
          id: docRef.id,
          name: _name!,
          designation: _designation!,
          contact: _contact!,
          location: _location!,
        ));
      } else {
        await FirebaseFirestore.instance.collection('FireService').doc(widget.category!.id).update({
          'name': _name,
          'designation': _designation,
          'contact': _contact,
          'location': _location,
        });
        widget.onSubmit(FireServiceModels(
          id: widget.category!.id,
          name: _name!,
          designation: _designation!,
          contact: _contact!,
          location: _location!,
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
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextContainerStyle("FillUp Polli Biddut Form", AppColors.pColor),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _name,
                  decoration: _inputDecoration('Heading Name'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your heading name';
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
                    if (value!.isEmpty) return 'Please enter location';
                    return null;
                  },
                  onSaved: (value) => _location = value,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

