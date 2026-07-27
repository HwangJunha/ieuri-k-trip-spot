import 'package:flutter/material.dart';

/// Shared text field for the auth screens (spec §5.5): a labeled, outlined
/// input with optional obscuring and a show/hide toggle. Reused by login,
/// sign-up, and password-reset so their fields stay consistent.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscure = false,
    this.showToggle = false,
    this.showLabel,
    this.hideLabel,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  /// When true the input starts obscured (a password field).
  final bool obscure;

  /// Whether to render the eye toggle. Only meaningful with [obscure].
  final bool showToggle;
  final String? showLabel;
  final String? hideLabel;

  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        border: const OutlineInputBorder(),
        suffixIcon: widget.obscure && widget.showToggle
            ? IconButton(
                icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                tooltip: _obscured ? widget.showLabel : widget.hideLabel,
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
