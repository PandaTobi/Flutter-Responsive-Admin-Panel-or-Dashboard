import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputTextField extends StatefulWidget {
  final IconData prefixIcon;
  final Function validationFunction;
  final TextInputType keyboardType;
  final String hint;
  final String type;

  const InputTextField({
    Key? key,
    required this.prefixIcon,
    required this.validationFunction,
    required this.keyboardType,
    required this.hint,
    this.type = "",
  }) : super(key: key);

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  TextEditingController ctrl = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            onChanged: (e) {
              if (!_validate) {
                setState(() {
                  _validate = true;
                });
              }
            },
            autovalidate: _validate,
            obscureText: widget.hint == 'Password',
            decoration: new InputDecoration(
                hintText: widget.hint,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: Theme.of(context).accentColor)),
                filled: true,
                fillColor: Colors.black,
                prefixIcon: Icon(widget.prefixIcon,
                    color: Theme.of(context).accentColor)),
            keyboardType: widget.keyboardType,
            // validator: widget.validationFunction,
            controller: ctrl,
            onTap: () async {
              if (widget.type == 'dateTime') {
                DateTime date = DateTime(1900);
                DateFormat formatter = DateFormat('dd / MM / yyyy');
                FocusScope.of(context).requestFocus(new FocusNode());

                date = (await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now()))!;
                ctrl.text = (date != null) ? formatter.format(date) : '';
              }
            }));
  }
}