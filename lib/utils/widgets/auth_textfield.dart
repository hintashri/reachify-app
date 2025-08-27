import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? onChange;
  final double radius;

  const AuthTextField({
    super.key,
    this.textInputAction,
    this.prefixIcon,
    this.textInputType,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.onChange,
    this.radius = 10,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      style: context.textTheme.labelMedium,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      onChanged: onChange,
      autofillHints: null,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        hintText: hintText,
        hintStyle: context.textTheme.labelMedium?.copyWith(
          color: AppColors.borderColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Theme.of(context).disabledColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}
