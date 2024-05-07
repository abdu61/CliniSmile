import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';

class ManageDoctors extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const ManageDoctors({
    Key? key,
    required this.authService,
    required this.databaseService,
  }) : super(key: key);

  @override
  _ManageDoctorsState createState() => _ManageDoctorsState();
}

class _ManageDoctorsState extends State<ManageDoctors> {
  late Future<List<Doctor>> _doctorDocs;
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNo = '';
  String bio = '';
  String profileImageUrl = '';
  int experience = 0;
  String categoryId = 'CogReMEKrPdbrJHUkSkX';
  List<String> workingHours = List.filled(7, '');
  List<String> breakHours = List.filled(7, '');

  @override
  void initState() {
    super.initState();
    _doctorDocs = widget.databaseService.getDoctors();
  }

  void _showAddDoctorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Doctor'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: _buildFormFields(setState),
                  ),
                ),
              ),
              actions: _buildDialogActions(context),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildFormFields(StateSetter setState) {
    return <Widget>[
      _buildTextFormField('Name', (val) => setState(() => name = val)),
      _buildTextFormField('Email', (val) => setState(() => email = val)),
      _buildTextFormField(
          'Phone Number', (val) => setState(() => phoneNo = val)),
      _buildTextFormField('Bio', (val) => setState(() => bio = val)),
      _buildTextFormField(
          'Profile Image URL', (val) => setState(() => profileImageUrl = val)),
      _buildTextFormField(
          'Experience',
          (val) => setState(() => experience = int.parse(val)),
          TextInputType.number),
      ..._buildWorkingHoursFields(setState),
      ..._buildBreakHoursFields(setState),
      _buildCategoryDropdown(setState),
    ];
  }

  TextFormField _buildTextFormField(
      String labelText, Function(String) onChanged,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      onChanged: onChanged,
      validator: (val) => val!.isEmpty ? 'Enter a $labelText' : null,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
    );
  }

  List<Widget> _buildWorkingHoursFields(StateSetter setState) {
    return List<Widget>.generate(
        7,
        (i) => _buildTextFormField('Working hours for day ${i + 1}',
            (val) => setState(() => workingHours[i] = val)));
  }

  List<Widget> _buildBreakHoursFields(StateSetter setState) {
    return List<Widget>.generate(
        7,
        (i) => _buildTextFormField('Break hours for day ${i + 1}',
            (val) => setState(() => breakHours[i] = val)));
  }

  FutureBuilder<List<Category>> _buildCategoryDropdown(StateSetter setState) {
    return FutureBuilder<List<Category>>(
      future: widget.databaseService.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return DropdownButtonFormField<String>(
          value: categoryId,
          onChanged: (String? newValue) {
            setState(() {
              categoryId = newValue!;
            });
          },
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Select a category'),
            ),
            ...snapshot.data!.map<DropdownMenuItem<String>>((Category value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.name),
              );
            }).toList(),
          ],
          decoration: const InputDecoration(
            labelText: 'Category',
          ),
        );
      },
    );
  }

  List<Widget> _buildDialogActions(BuildContext context) {
    return <Widget>[
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text('Add'),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _addDoctor();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Doctor added')),
            );
          }
        },
      ),
    ];
  }

  Future<void> _addDoctor() async {
    Doctor newDoctor = Doctor(
      id: "",
      name: name,
      bio: bio,
      profileImageUrl: profileImageUrl,
      category: Category(id: categoryId, name: '', icon: ''),
      experience: experience,
      workingHours: workingHours
          .asMap()
          .map((key, value) => MapEntry(key.toString(), [value])),
      breakHours: breakHours
          .asMap()
          .map((key, value) => MapEntry(key.toString(), [value])),
    );

    await widget.databaseService.addDoctor(newDoctor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDoctorList(),
          ],
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Manage Doctors',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: _showAddDoctorDialog,
          child: const Text('Add Doctor'),
        ),
      ],
    );
  }

  Expanded _buildDoctorList() {
    return Expanded(
      child: FutureBuilder<List<Doctor>>(
        future: _doctorDocs,
        builder: (BuildContext context, AsyncSnapshot<List<Doctor>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final doc = snapshot.data![index];
              return _buildDoctorCard(doc);
            },
          );
        },
      ),
    );
  }

  Card _buildDoctorCard(Doctor doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Text(
            'Doctor Name: ${doc.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Category: ${doc.category.name}',
              style: const TextStyle(fontSize: 16)),
          trailing: _buildDeleteButton(doc),
        ),
      ),
    );
  }

  IconButton _buildDeleteButton(Doctor doc) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red, size: 24),
      onPressed: () {
        _confirmDeletion(doc);
      },
    );
  }

  void _confirmDeletion(Doctor doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this doctor?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteDoctor(doc);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Doctor deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDoctor(Doctor doc) async {
    await widget.databaseService.deleteUserById(doc.id);
    if (mounted) {
      setState(() {
        _doctorDocs = widget.databaseService.getDoctors();
      });
    }
  }
}
