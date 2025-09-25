import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachify_app/theme/app_colors.dart';

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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class OptimizedDropDownMenu<T> extends StatefulWidget {
  final List<T> list;
  final T? value;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Color fontColor;
  final double radius;
  final int initialLoadCount; // Number of items to load initially
  final int loadMoreCount; // Number of items to load when scrolling

  const OptimizedDropDownMenu({
    super.key,
    required this.list,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.fontColor = Colors.black,
    this.radius = 10,
    this.initialLoadCount = 50, // Load first 50 items
    this.loadMoreCount = 30, // Load 30 more when scrolling
  });

  @override
  State<OptimizedDropDownMenu<T>> createState() =>
      _OptimizedDropDownMenuState<T>();
}

class _OptimizedDropDownMenuState<T> extends State<OptimizedDropDownMenu<T>> {
  void _showOptimizedBottomSheet(FormFieldState<T> field) {
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OptimizedDropdownBottomSheet<T>(
        list: widget.list,
        onSelected: (item) {
          widget.onChanged?.call(item);
          field.didChange(item); // Update the form field state
          Navigator.pop(context);
        },
        fontColor: widget.fontColor,
        initialLoadCount: widget.initialLoadCount,
        loadMoreCount: widget.loadMoreCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      builder: (FormFieldState<T> field) {
        // Update field value when widget value changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (field.value != widget.value) {
            field.didChange(widget.value);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showOptimizedBottomSheet(field),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError
                        ? Theme.of(context).colorScheme.error
                        : AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.value?.toString() ?? widget.hintText ?? '',
                        style: widget.value != null
                            ? context.textTheme.labelMedium
                            : context.textTheme.labelMedium?.copyWith(
                                color: AppColors.borderColor,
                              ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.borderColor,
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OptimizedDropdownBottomSheet<T> extends StatefulWidget {
  final List<T> list;
  final ValueChanged<T> onSelected;
  final Color fontColor;
  final int initialLoadCount;
  final int loadMoreCount;

  const _OptimizedDropdownBottomSheet({
    required this.list,
    required this.onSelected,
    required this.fontColor,
    required this.initialLoadCount,
    required this.loadMoreCount,
  });

  @override
  State<_OptimizedDropdownBottomSheet<T>> createState() =>
      _OptimizedDropdownBottomSheetState<T>();
}

class _OptimizedDropdownBottomSheetState<T>
    extends State<_OptimizedDropdownBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<T> _allFilteredItems = [];
  List<T> _displayedItems = [];
  Timer? _debounceTimer;
  bool _isSearching = false;
  bool _isLoadingMore = false;
  int _currentLoadCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_scrollListener);
  }

  void _initializeData() {
    _allFilteredItems = List.from(widget.list);
    _loadInitialItems();
  }

  void _loadInitialItems() {
    setState(() {
      _currentLoadCount = widget.initialLoadCount;
      _displayedItems = _allFilteredItems.take(_currentLoadCount).toList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (_isLoadingMore || _displayedItems.length >= _allFilteredItems.length)
      return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate async loading (you can remove this delay in production)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          final newEndIndex = (_currentLoadCount + widget.loadMoreCount).clamp(
            0,
            _allFilteredItems.length,
          );
          _displayedItems = _allFilteredItems.take(newEndIndex).toList();
          _currentLoadCount = newEndIndex;
          _isLoadingMore = false;
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set searching state immediately for UI feedback
    setState(() {
      _isSearching = true;
    });

    // Debounce search to avoid too many operations
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _allFilteredItems = List.from(widget.list);
      } else {
        // Efficient search - convert to lowercase once
        final lowerQuery = query.toLowerCase();
        _allFilteredItems = widget.list.where((item) {
          return item.toString().toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Reset displayed items
      _currentLoadCount = widget.initialLoadCount;
      _displayedItems = _allFilteredItems.take(_currentLoadCount).toList();
      _isSearching = false;
    });

    // Reset scroll position
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 4,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select City',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_allFilteredItems.length} cities available',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search from ${widget.list.length} cities...',
                prefixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          const SizedBox(height: 10),

          // Results info
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Showing ${_displayedItems.length} of ${_allFilteredItems.length} results',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ),

          const SizedBox(height: 10),

          // List with virtualization
          Expanded(
            child: _displayedItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cities found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        _displayedItems.length + (_isLoadingMore ? 1 : 0),
                    itemExtent: 38, // Fixed height for better performance
                    itemBuilder: (context, index) {
                      // Loading indicator at the bottom
                      if (index == _displayedItems.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final item = _displayedItems[index];
                      return ListTile(
                        title: Text(
                          item.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.fontColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        onTap: () => widget.onSelected(item),
                        dense: true,
                      );
                    },
                  ),
          ),

          // Load more button (alternative to auto-loading)
          // if (_displayedItems.length < _allFilteredItems.length &&
          //     !_isLoadingMore)
          //   Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: OutlinedButton(
          //       onPressed: _loadMoreItems,
          //       child: Text(
          //         'Load More (${_allFilteredItems.length - _displayedItems.length} remaining)',
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

// Alternative: Quick Filter Dropdown (Group by first letter)
class QuickFilterDropDownMenu<T> extends StatelessWidget {
  final List<T> list;
  final T? value;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Color fontColor;
  final double radius;

  const QuickFilterDropDownMenu({
    super.key,
    required this.list,
    required this.value,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.fontColor = Colors.black,
    this.radius = 10,
  });

  void _showQuickFilterBottomSheet(
    BuildContext context,
    FormFieldState<T> field,
  ) {
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickFilterBottomSheet<T>(
        list: list,
        onSelected: (item) {
          onChanged?.call(item);
          field.didChange(item); // Update the form field state
          Navigator.pop(context);
        },
        fontColor: fontColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (FormFieldState<T> field) {
        // Update field value when widget value changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (field.value != value) {
            field.didChange(value);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showQuickFilterBottomSheet(context, field),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError
                        ? Theme.of(context).colorScheme.error
                        : AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value?.toString() ?? hintText ?? '',
                        style: TextStyle(
                          color: value != null
                              ? fontColor
                              : AppColors.borderColor,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.borderColor,
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _QuickFilterBottomSheet<T> extends StatefulWidget {
  final List<T> list;
  final ValueChanged<T> onSelected;
  final Color fontColor;

  const _QuickFilterBottomSheet({
    required this.list,
    required this.onSelected,
    required this.fontColor,
  });

  @override
  State<_QuickFilterBottomSheet<T>> createState() =>
      _QuickFilterBottomSheetState<T>();
}

class _QuickFilterBottomSheetState<T> extends State<_QuickFilterBottomSheet<T>>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<T>> _groupedItems = {};
  List<String> _quickFilters = [];

  @override
  void initState() {
    super.initState();
    _groupItemsByFirstLetter();
    _tabController = TabController(length: _quickFilters.length, vsync: this);
  }

  void _groupItemsByFirstLetter() {
    final Map<String, List<T>> grouped = {};

    for (final item in widget.list) {
      final firstChar = item.toString().isNotEmpty
          ? item.toString()[0].toUpperCase()
          : '#';

      if (!grouped.containsKey(firstChar)) {
        grouped[firstChar] = [];
      }
      grouped[firstChar]!.add(item);
    }

    _groupedItems = grouped;
    _quickFilters = grouped.keys.toList()..sort();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 4,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Select City',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Quick filter tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _quickFilters.map((filter) {
              return Tab(
                child: Text(
                  '$filter (${_groupedItems[filter]?.length ?? 0})',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _quickFilters.map((filter) {
                final items = _groupedItems[filter] ?? [];
                return ListView.builder(
                  itemCount: items.length,
                  itemExtent: 56,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(
                        item.toString(),
                        style: TextStyle(
                          color: widget.fontColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      onTap: () => widget.onSelected(item),
                      dense: true,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
