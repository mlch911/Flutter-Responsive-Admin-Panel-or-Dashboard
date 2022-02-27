import 'package:flutter/material.dart';

import '../../constants.dart';

class InputTextField extends StatelessWidget {
  final String text;
  final String placeholder;
  final String buttonText;
  final MainAxisAlignment buttonAlignment;
  final VoidCallback? onTapButton;

  const InputTextField(
      {Key? key,
      this.text = '',
      this.placeholder = '请输入内容',
      required this.buttonText,
      this.buttonAlignment = MainAxisAlignment.end,
      this.onTapButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: text),
          maxLines: 8,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: placeholder,
            fillColor: secondaryColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: buttonAlignment,
          children: [
            Container(
              margin: EdgeInsets.only(top: defaultPadding / 2),
              child: SizedBox(
                height: 50,
                width: 150,
                child: FlatButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Text(
                    buttonText,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.apply(fontWeightDelta: 3),
                  ),
                  onPressed: onTapButton ?? () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
