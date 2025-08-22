import 'package:flutter/material.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:get/get.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  final List<T> list;
  final T? value;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Color fontColor;
  final double radius;

  const CustomDropDownButton({
    super.key,
    required this.list,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.fontColor = Colors.black,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: list
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                '$e',
                style: context.textTheme.labelMedium?.copyWith(
                  color: fontColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          )
          .toList(),
      value: value,
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return list.map((T value) {
          return Text(
            '$value',
            style: context.textTheme.labelMedium?.copyWith(
              color: fontColor,
              letterSpacing: 1.2,
            ),
          );
        }).toList();
      },
      validator: validator,
      borderRadius: BorderRadius.circular(radius),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.borderColor,
      ),
      isExpanded: true,
      hint: Text(
        hintText ?? '',
        style: context.textTheme.labelMedium?.copyWith(
          color: AppColors.borderColor,
        ),
      ),
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }
}
