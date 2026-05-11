import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final IconData icon;
  final String? label;
  final String hint;
  final bool isPassword;
  final FocusNode? focusNode;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputType keyboardType;
  final bool enabled;
  final String? serverError;

  const CustomTextFormField({
    super.key,
    required this.icon,
    this.label,
    this.hint = '',
    this.isPassword = false,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.autovalidateMode,
    this.serverError,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: widget.focusNode,
          autovalidateMode: widget.autovalidateMode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          obscureText: widget.isPassword && _isHidden,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 14),
          validator: (v) => widget.validator?.call(v) ?? widget.serverError,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),

            prefixIcon: Icon(
              widget.icon,
              size: 20,
              color: Colors.black.withValues(alpha: 0.4),
            ),

            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isHidden = !_isHidden),
                  )
                : null,

            isDense: true,
            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),

            errorStyle: const TextStyle(fontSize: 12, height: 1.2),
          ),
        ),
      ],
    );
  }
}
