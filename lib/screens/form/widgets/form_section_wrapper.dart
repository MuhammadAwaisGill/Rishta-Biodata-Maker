import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class FormSectionWrapper extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  const FormSectionWrapper({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<FormSectionWrapper> createState() => _FormSectionWrapperState();
}

class _FormSectionWrapperState extends State<FormSectionWrapper> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    // Note: No Riverpod needed here!
    // This widget just displays whatever children are passed to it.

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: AppSizes.md), // Added margin for spacing between cards
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: _isExpanded
                ? AppColors.primary.withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
            blurRadius: _isExpanded ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _isExpanded
              ? AppColors.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (v) => setState(() => _isExpanded = v),
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _isExpanded
                  ? AppColors.primary.withOpacity(0.12)
                  : AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.icon,
              color: AppColors.primary,
              size: AppSizes.iconMd,
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _isExpanded ? AppColors.primary : AppColors.textDark,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _isExpanded ? AppColors.primary : AppColors.textMuted,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.xs,
            AppSizes.md,
            AppSizes.md,
          ),
          // When a child is hidden in the parent, widget.children
          // length changes, and ExpansionTile handles it automatically.
          children: widget.children,
        ),
      ),
    );
  }
}