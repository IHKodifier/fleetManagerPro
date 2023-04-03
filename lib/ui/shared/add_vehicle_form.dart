import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddVehiclePage extends ConsumerStatefulWidget {
  const AddVehiclePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends ConsumerState<AddVehiclePage> {
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController regcityController = TextEditingController();
  Vehicle state = Vehicle(id: 'not initialized', doors: 0);
  TextEditingController yearController = TextEditingController();

  late BuildContext _context;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose

    makeController.dispose();
    modelController.dispose();
    regcityController.dispose();
    regcityController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Row buttonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: OutlinedButton(
                onPressed: onCancelPressed, child: const Text('Cancel'))),
        const SizedBox(width: 12),
        Expanded(
            child: ElevatedButton.icon(
                onPressed: onSavePressed,
                icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
                label: const Text('Save'))),
      ],
    );
  }

  Future<void> onSavePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final docId = FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)?.uuid)
          .collection('vehicles')
          .doc();
      state.id = docId.id;
      var result = await FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)?.uuid)
          .collection('vehicles')
          .doc(docId.id)
          .set(state.toMap());

      // print(result.toString());
      Navigator.pop(_context);
    }
  }

  void onCancelPressed() {
    Navigator.pop(_context);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 10),
              const FormTitle(),
              MakeTextField(makeController: makeController, state: state),
              const SizedBox(height: 10),
              ModelTextField(modelController: modelController, state: state),
              const SizedBox(height: 10),
              RegTextField(regController: regController, state: state),
              const SizedBox(height: 10),
              RegCityTextField(
                regcityController: regcityController,
                state: state,
              ),
              const SizedBox(height: 10),
              YearTextField(yearController: yearController, state: state),
              const SizedBox(height: 10),
              const Divider(thickness: 2),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: [
                  ChoiceChip(
                    label: const Text('3 door'),
                    selected: (state.doors == 3),
                    onSelected: (value) {
                      setState(() {
                        state.doors = 3;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('4 door'),
                    selected: (state.doors == 4),
                    onSelected: (value) {
                      setState(() {
                        state.doors = 4;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('5 door'),
                    selected: (state.doors == 5),
                    onSelected: (value) {
                      setState(() {
                        state.doors = 5;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buttonBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class YearTextField extends StatelessWidget {
  const YearTextField({
    super.key,
    required this.yearController,
    required this.state,
  });

  final Vehicle state;
  final TextEditingController yearController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: yearController,
        decoration:
            const InputDecoration(label: Text('Year'), hintText: 'e.g. 2016'),
        onSaved: (value) {
          state.year = value;
        },
      ),
    );
  }
}

class RegCityTextField extends StatelessWidget {
  const RegCityTextField({
    super.key,
    required this.regcityController,
    required this.state,
  });

  final TextEditingController regcityController;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: regcityController,
        decoration: const InputDecoration(
            label: Text('Registration City '), hintText: 'e.g. Islamabad'),
        onSaved: (value) {
          state.regCity = value;
        },
      ),
    );
  }
}

class RegTextField extends StatelessWidget {
  const RegTextField({
    super.key,
    required this.regController,
    required this.state,
  });

  final TextEditingController regController;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: regController,
        decoration: const InputDecoration(
            label: Text('Registration '), hintText: 'e.g. AKT 057'),
        onSaved: (value) {
          state.reg = value;
        },
      ),
    );
  }
}

class ModelTextField extends StatelessWidget {
  const ModelTextField({
    super.key,
    required this.modelController,
    required this.state,
  });

  final TextEditingController modelController;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: modelController,
        decoration: const InputDecoration(
            label: Text('Model'), hintText: 'e.g. Vezel Hybrid 1.8'),
        onSaved: (value) {
          state.make = value;
        },
      ),
    );
  }
}

class MakeTextField extends StatelessWidget {
  const MakeTextField({
    super.key,
    required this.makeController,
    required this.state,
  });

  final TextEditingController makeController;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: makeController,
        decoration: const InputDecoration(
            label: Text('Make'), hintText: 'e.g. Honda, Toyota, Suzuki'),
        onSaved: (value) {
          state.make = value;
        },
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Add Vehicle',
        style: Theme.of(context).textTheme.headlineLarge);
  }
}