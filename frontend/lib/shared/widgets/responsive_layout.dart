import 'package:flutter/material.dart';
import 'package:connectflavour/core/utils/platform_utils.dart';

/// A responsive grid widget that adapts to different screen sizes
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = PlatformUtils.getGridColumns(constraints.maxWidth);

        return GridView.builder(
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// A widget that centers content with a max width on desktop
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: PlatformUtils.getMaxContentWidth(screenWidth),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

/// Adaptive padding based on screen size
class AdaptivePadding extends StatelessWidget {
  final Widget child;

  const AdaptivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double padding;
    if (PlatformUtils.isSmallScreen(width)) {
      padding = 16.0;
    } else if (PlatformUtils.isMediumScreen(width)) {
      padding = 24.0;
    } else {
      padding = 32.0;
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

/// Two-pane layout for desktop (master-detail pattern)
class TwoPaneLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final double masterPanelWidth;

  const TwoPaneLayout({
    super.key,
    required this.master,
    required this.detail,
    this.masterPanelWidth = 350,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) {
          // Show only one pane on smaller screens
          return master;
        }

        return Row(
          children: [
            SizedBox(
              width: masterPanelWidth,
              child: master,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: detail),
          ],
        );
      },
    );
  }
}
