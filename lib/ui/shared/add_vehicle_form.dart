import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
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
  TextEditingController yearController = TextEditingController();
  Vehicle state = Vehicle(id: 'not initialized', doors: 0);

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
      // state.driven ??= 0;
      // state.driven = state.driven ?? 0;
      // state.driven= _
      state.images = [];
      FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)?.uuid)
          .collection('vehicles')
          .doc(docId.id)
          .set(state.toMap())
          .then((value) {
        //  SystemNavigator.pop();
        Navigator.pop(context);
      });

      // print(result.toString());
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
              const SizedBox(height: 12),
              const FormTitle(),
              MakeTextField(Controller: makeController, state: state),
              const SizedBox(height: 6),
              ModelTextField(controller: modelController, state: state),
              const SizedBox(height: 12),


              DrivenSpinBox(state: state),
              const SizedBox(height: 6),
              RegTextField(controller: regController, state: state),
              const SizedBox(height: 6),
              RegCityTextField(controller: regcityController, state: state),
              const SizedBox(height: 6),
              YearTextField(yearController: yearController, state: state),
              const SizedBox(height: 6),
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

class DrivenSpinBox extends StatelessWidget {
  final Vehicle state;
  const DrivenSpinBox({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // width: 200,
      child: SpinBox(
        min: 0,
        max: 1000000,
        step: 100,
        value: state.driven?.toDouble() ?? 0.0,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          // labelText: 'Driven',
          suffix: Text('Km'),
        ),
        incrementIcon: Icon(
          Icons.add_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
        decrementIcon: Icon(
          Icons.remove_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
      onSubmitted: (p0) => state.driven= p0.toInt(),
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
      height: 80,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: yearController,
        decoration: InputDecoration(
          label: const Text('Year'),
          hintText: 'e.g. 2016',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        maxLength: 4,
        onSaved: (value) {
          state.year = value;
        },
        validator: (String? value) {
          print('validating year of regitration value = $value');
          if (value!.isEmpty) {
            return 'enter Year of Vehicle Registration';
          }
          return null;
        },
      ),
    );
  }
}

class RegCityTextField extends StatelessWidget {
  const RegCityTextField({
    super.key,
    required this.controller,
    required this.state,
  });

  final TextEditingController controller;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller,
        maxLength: 15,
        decoration: InputDecoration(
          label: const Text('Registration City '),
          hintText: 'e.g. Islamabad',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        onSaved: (value) {
          state.regCity = value;
        },
        validator: (value) {
          print('validating City of regitration vaue = $value');
          if (value!.isEmpty) {
            return 'city of Registration is required';
          }
          return null;
        },
      ),
    );
  }
}

class RegTextField extends StatelessWidget {
  const RegTextField({
    super.key,
    required this.controller,
    required this.state,
  });

  final TextEditingController controller;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller,
        maxLength: 8,
        decoration: InputDecoration(
          label: const Text('Registration '),
          hintText: '   e.g. AJ 047',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        onSaved: (value) {
          state.reg = value;
        },
        validator: (value) {
          print('validating regitration number  value = $value');
          if (value!.isEmpty) {
            return 
              'Registration Number of vahicle is required'
              ;
          }
          return null;
          
        },
      ),
    );
  }
}

class ModelTextField extends StatelessWidget {
  const ModelTextField({
    super.key,
    required this.controller,
    required this.state,
  });

  final TextEditingController controller;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        controller: controller,
        maxLength: 12,
        decoration: InputDecoration(
          label: const Text('Model'),
          hintText: 'e.g. Vezel Hybrid 1.8',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        onSaved: (value) {
          print('validating regitration vaue = $value');
          state.model = value;
        },
        validator: (value) {
          print('validating model value = $value');

          if (value!.isEmpty) {
            return 'name of the model is required';
          }
          return null;
        },
      ),
    );
  }
}

class MakeTextField extends StatelessWidget {
  const MakeTextField({
    super.key,
    required this.Controller,
    required this.state,
  });

  final TextEditingController Controller;
  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        controller: Controller,
        decoration: InputDecoration(
          label: const Text('Make'),
          hintText: 'e.g. Honda, Toyota, Suzuki',
          hintStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        maxLength: 8,
        onSaved: (value) {
          state.make = value;
        },
        validator: (value) {
          print('validating MAKE  field value = $value');
          if (value!.isEmpty) {
            return 'make of the vehicle is required';
          }
          return null;
          
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
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge);
  }
}
