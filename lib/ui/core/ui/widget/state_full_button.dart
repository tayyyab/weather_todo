import 'package:flutter/material.dart';

class StateFullButton extends StatefulWidget {
  const StateFullButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Icon? icon;
  final Future<void> Function() onPressed;

  @override
  State<StateFullButton> createState() => _StateFullButtonState();
}

class _StateFullButtonState extends State<StateFullButton> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: widget.icon,
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await widget.onPressed();
        setState(() {
          loading = false;
        });
      },
      label: loading
          ? SizedBox(
              width: 24,
              height: 24,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(widget.label),
    );
  }
}
