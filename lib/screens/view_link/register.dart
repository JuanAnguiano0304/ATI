import 'package:ati/utils/links.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  String marca;
  Register({super.key, required this.marca});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _url = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo requerido';
                }
              },
              controller: _desc,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Descripción: ',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo requerido';
                }
              },
              controller: _url,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Url: ',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
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
                  ),
                  onPressed: () {
                    try {
                      if (_formKey.currentState!.validate()) {
                        Link.register(
                                widget.marca, _desc.value.text, _url.value.text)
                            .whenComplete(() {
                          _desc.clear();
                          _url.clear();
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
                child: Container(
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
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
