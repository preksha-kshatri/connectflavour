import 'package:flutter/material.dart';

/// Split pane layout for desktop master-detail views
class SplitPaneLayout extends StatefulWidget {
  final Widget master;
  final Widget detail;
  final double initialMasterWidth;
  final double minMasterWidth;
  final double maxMasterWidth;
  final bool resizable;
  final Axis axis;
  final Color? dividerColor;
  final double dividerThickness;

  const SplitPaneLayout({
    super.key,
    required this.master,
    required this.detail,
    this.initialMasterWidth = 300,
    this.minMasterWidth = 200,
    this.maxMasterWidth = 500,
    this.resizable = true,
    this.axis = Axis.horizontal,
    this.dividerColor,
    this.dividerThickness = 1,
  });

  @override
  State<SplitPaneLayout> createState() => _SplitPaneLayoutState();
}

class _SplitPaneLayoutState extends State<SplitPaneLayout> {
  late double _masterSize;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _masterSize = widget.initialMasterWidth;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.resizable) return;

    setState(() {
      if (widget.axis == Axis.horizontal) {
        _masterSize = (_masterSize + details.delta.dx)
            .clamp(widget.minMasterWidth, widget.maxMasterWidth);
      } else {
        _masterSize = (_masterSize + details.delta.dy)
            .clamp(widget.minMasterWidth, widget.maxMasterWidth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.axis == Axis.horizontal) {
      return Row(
        children: [
          SizedBox(
            width: _masterSize,
            child: widget.master,
          ),
          GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragStart: (_) => setState(() => _isDragging = true),
            onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
            child: MouseRegion(
              cursor: widget.resizable
                  ? SystemMouseCursors.resizeColumn
                  : SystemMouseCursors.basic,
              child: Container(
                width: widget.dividerThickness,
                decoration: BoxDecoration(
                  color: _isDragging
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                      : (widget.dividerColor ?? const Color(0xFFE0E0E0)),
                  boxShadow: _isDragging
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          Expanded(child: widget.detail),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: _masterSize,
            child: widget.master,
          ),
          GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragStart: (_) => setState(() => _isDragging = true),
            onVerticalDragEnd: (_) => setState(() => _isDragging = false),
            child: MouseRegion(
              cursor: widget.resizable
                  ? SystemMouseCursors.resizeRow
                  : SystemMouseCursors.basic,
              child: Container(
                height: widget.dividerThickness,
                color: _isDragging
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : (widget.dividerColor ?? Colors.grey.shade300),
              ),
            ),
          ),
          Expanded(child: widget.detail),
        ],
      );
    }
  }
}

/// Desktop-optimized dialog
class DesktopDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final double width;
  final double? height;
  final EdgeInsets contentPadding;

  const DesktopDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.width = 600,
    this.height,
    this.contentPadding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: content,
              ),
            ),
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Context menu for right-click actions
class ContextMenuRegion extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> menuItems;
  final bool enabled;

  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.menuItems,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || menuItems.isEmpty) {
      return child;
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: child,
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect positionRect = RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu<void>(
      context: context,
      position: positionRect,
      items: menuItems.map<PopupMenuEntry<void>>((item) {
        if (item.isDivider) {
          return const PopupMenuDivider();
        }

        return PopupMenuItem<void>(
          enabled: item.enabled,
          onTap: item.onTap,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 18),
                const SizedBox(width: 12),
              ],
              Expanded(child: Text(item.label)),
              if (item.shortcut != null) ...[
                const SizedBox(width: 24),
                Text(
                  item.shortcut!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Context menu item
class ContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? shortcut;
  final bool enabled;
  final bool isDivider;

  const ContextMenuItem({
    this.label = '',
    this.icon,
    this.onTap,
    this.shortcut,
    this.enabled = true,
    this.isDivider = false,
  });

  static const ContextMenuItem divider = ContextMenuItem(isDivider: true);
}

/// Desktop breadcrumb navigation
class Breadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final Color? color;
  final double fontSize;

  const Breadcrumbs({
    super.key,
    required this.items,
    this.color,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),
          _BreadcrumbItemWidget(
            item: items[i],
            isLast: i == items.length - 1,
            color: color,
            fontSize: fontSize,
          ),
        ],
      ],
    );
  }
}

class _BreadcrumbItemWidget extends StatefulWidget {
  final BreadcrumbItem item;
  final bool isLast;
  final Color? color;
  final double fontSize;

  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
    this.color,
    required this.fontSize,
  });

  @override
  State<_BreadcrumbItemWidget> createState() => _BreadcrumbItemWidgetState();
}

class _BreadcrumbItemWidgetState extends State<_BreadcrumbItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isLast
        ? (widget.color ?? Theme.of(context).textTheme.bodyMedium?.color)
        : Colors.grey.shade600;

    if (widget.item.onTap == null || widget.isLast) {
      return Text(
        widget.item.label,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: textColor,
          fontWeight: widget.isLast ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Text(
          widget.item.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            color:
                _isHovered ? Theme.of(context).colorScheme.primary : textColor,
            decoration: _isHovered ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb item
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}
