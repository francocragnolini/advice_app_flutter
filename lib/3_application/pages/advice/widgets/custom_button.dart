import 'package:flutter/material.dart';

// modificaciones para widget testing
// el boton debe recibir el bloc provider via constructor en el onTap function
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onTap});

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkResponse(
      // onTap: onTap?.call(),
      onTap: () => onTap?.call(),
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: themeData.colorScheme.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Get Advice",
              style: themeData.textTheme.headline1,
            ),
          ),
        ),
      ),
    );
  }
}
