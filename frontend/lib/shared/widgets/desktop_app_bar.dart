import 'package:flutter/material.dart';

/// Desktop-optimized app bar with search, menu, and actions
class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String searchHint;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double elevation;

  const DesktopAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showSearch = false,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint = 'Search...',
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // Back button or leading widget
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                tooltip: 'Back',
              )
            else if (leading != null)
              leading!,

            // Title
            if (!showSearch) ...[
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],

            const Spacer(),

            // Search bar (if enabled)
            if (showSearch) ...[
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    onSubmitted: (_) => onSearchSubmitted?.call(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(Icons.search,
                          size: 20, color: Colors.grey.shade600),
                      suffixIcon: searchController?.text.isNotEmpty ?? false
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  size: 18, color: Colors.grey.shade600),
                              onPressed: () {
                                searchController?.clear();
                                onSearchChanged?.call('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF2E7D32), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Actions
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}

/// Toolbar widget for quick actions
class DesktopToolbar extends StatelessWidget {
  final List<ToolbarAction> actions;
  final Color? backgroundColor;
  final double height;

  const DesktopToolbar({
    super.key,
    required this.actions,
    this.backgroundColor,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          ...actions.map((action) {
            if (action.isDivider) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: VerticalDivider(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              );
            }

            return Tooltip(
              message: action.tooltip ?? action.label,
              child: InkWell(
                onTap: action.onPressed,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (action.icon != null) Icon(action.icon, size: 18),
                      if (action.icon != null && action.label.isNotEmpty)
                        const SizedBox(width: 6),
                      if (action.label.isNotEmpty)
                        Text(
                          action.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Toolbar action item
class ToolbarAction {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isDivider;

  const ToolbarAction({
    this.label = '',
    this.icon,
    this.onPressed,
    this.tooltip,
    this.isDivider = false,
  });

  static const ToolbarAction divider = ToolbarAction(isDivider: true);
}

/// Desktop status bar (bottom)
class DesktopStatusBar extends StatelessWidget {
  final List<Widget> items;
  final Color? backgroundColor;
  final double height;

  const DesktopStatusBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            ...items,
          ],
        ),
      ),
    );
  }
}

/// Status bar item
class StatusBarItem extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;

  const StatusBarItem({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}
