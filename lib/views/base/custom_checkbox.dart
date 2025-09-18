import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final BorderRadius borderRadius;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.size = 28.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : Colors.transparent,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            width: 2,
          ),
        ),
        child: widget.value
            ? Icon(Icons.check, color: Colors.white, size: widget.size * 0.7)
            : null,
      ),
    );
  }
}
