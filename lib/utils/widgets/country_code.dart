import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/models/country_model.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/functions/app_func.dart';
import 'package:reachify_app/utils/widgets/auth_textfield.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryModel>? onChanged;
  final List<String>? countryFilter;
  final List<CountryModel> countryList;
  final String? initialSelection;

  const CountryCodePicker({
    this.onChanged,
    this.countryFilter,
    super.key,
    this.initialSelection,
    required this.countryList,
  });

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    List<CountryModel> elements = countryList;

    countryList.sort((a, b) => a.name.compareTo(b.name));

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseCustomList = countryFilter!
          .map((criteria) => criteria.toUpperCase())
          .toList();
      elements = elements
          .where(
            (criteria) =>
                uppercaseCustomList.contains(criteria.iso2) ||
                uppercaseCustomList.contains(criteria.name) ||
                uppercaseCustomList.contains(criteria.phoneCode),
          )
          .toList();
    }

    return CountryCodePickerState(elements);
  }
}

class CountryCodePickerState extends State<CountryCodePicker> {
  CountryModel? selectedItem;
  List<CountryModel> elements = [];

  CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    final Widget internalWidget = InkWell(
      onTap: showCountryCodePickerDialog,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        child: Row(
          children: [
            Text(
              '+${selectedItem?.phoneCode ?? ''}',
              style: context.textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.borderColor),
          ],
        ),
      ),
    );
    return internalWidget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    elements = elements.map((element) => element).toList();
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
          (criteria) =>
              (criteria.iso2.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()) ||
              (criteria.phoneCode == widget.initialSelection) ||
              (criteria.name.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0],
        );
      } else {
        selectedItem = elements[0];
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
        (criteria) =>
            (criteria.iso2.toUpperCase() ==
                widget.initialSelection!.toUpperCase()) ||
            (criteria.phoneCode == widget.initialSelection) ||
            (criteria.name.toUpperCase() ==
                widget.initialSelection!.toUpperCase()),
        orElse: () => elements[0],
      );
    } else {
      selectedItem = elements[0];
    }
  }

  void showCountryCodePickerDialog() async {
    final item = await showDialog(
      context: context,
      builder: (context) =>
          CustomBackdropFilter(child: Dialog(child: SelectionDialog(elements))),
    );

    if (item != null) {
      setState(() {
        selectedItem = item;
      });

      widget.onChanged!(item);
    }
  }
}

class SelectionDialog extends StatefulWidget {
  final List<CountryModel> elements;

  const SelectionDialog(this.elements, {super.key});

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  late List<CountryModel> filteredElements;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.hardEdge,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.85,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Country',
                overflow: TextOverflow.fade,
                style: context.textTheme.labelLarge?.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                iconSize: 20,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: AuthTextField(
            prefixIcon: const Icon(Icons.search),
            onChange: (value) {
              _filterElements(value!);
            },
            hintText: 'Search Country',
          ),
        ),
        if (filteredElements.isEmpty)
          const Center(child: Text('No country found'))
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              itemBuilder: (context, index) {
                return _buildOption(filteredElements[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 10);
              },
              itemCount: filteredElements.length,
              shrinkWrap: true,
            ),
          ),
      ],
    ),
  );

  Widget _buildOption(CountryModel e) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _selectItem(e);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  '+${e.phoneCode}',
                  style: context.textTheme.labelMedium,
                ),
              ),
              Expanded(
                child: Text(
                  e.name,
                  style: context.textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where(
            (e) =>
                e.iso2.contains(s) ||
                e.phoneCode.contains(s) ||
                e.name.toUpperCase().contains(s),
          )
          .toList();
    });
  }

  void _selectItem(CountryModel e) {
    Navigator.pop(context, e);
  }
}
