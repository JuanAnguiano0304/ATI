import 'package:ati/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

// ignore: must_be_immutable
class UserRegister extends StatefulWidget {
  UserRegister({
    super.key,
  });

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? isSelect;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo requerido';
              }
            },
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              helperText: 'Nombre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 3,
                ),
              ),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo requerido';
              }
            },
            controller: _email,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              helperText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 3,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: GradientColors.seaBlue,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    try {
                      if (_formKey.currentState!.validate()) {
                        User.regiterUser(_name.value.text, _email.value.text)
                            .whenComplete(() {
                          _name.clear();
                          _email.clear();
                          setState(() {
                            Navigator.pop(context);
                          });
                        });
                      }
                    } catch (e) {
                      print('esto causo el error $e');
                    }

                    setState(() {});
                  },
                  child: const Text('Registrar'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: GradientColors.seaBlue,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
