import 'package:flutter/material.dart';
import '../../models/thread_item.dart';
import '../../theme/chat_kit_theme.dart';
import 'task_widget.dart';

/// Displays a workflow with its tasks
class WorkflowWidget extends StatefulWidget {
  const WorkflowWidget({super.key, required this.item});

  final WorkflowItem item;

  @override
  State<WorkflowWidget> createState() => _WorkflowWidgetState();
}

class _WorkflowWidgetState extends State<WorkflowWidget> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.item.workflow.expanded;
  }

  @override
  void didUpdateWidget(WorkflowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.workflow.expanded != oldWidget.item.workflow.expanded) {
      _expanded = widget.item.workflow.expanded;
    }
  }

  String get _summaryText {
    final summary = widget.item.workflow.summary;
    return switch (summary) {
      CustomSummary(:final title) => title,
      DurationSummary(:final duration) => '${(duration / 1000).toStringAsFixed(1)}s',
      null => '${widget.item.workflow.tasks.length} tasks',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatKitTheme.of(context);
    final workflow = widget.item.workflow;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: theme.radius.mediumBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: theme.radius.mediumBorderRadius,
            child: Padding(
              padding: EdgeInsets.all(theme.density.paddingLarge),
              child: Row(
                children: [
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: theme.density.spacingMedium),
                  Expanded(
                    child: Text(
                      _summaryText,
                      style: theme.typography.labelLarge.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tasks
          if (_expanded && workflow.tasks.isNotEmpty) ...[
            Divider(height: 1, color: theme.colorScheme.outline),
            Padding(
              padding: EdgeInsets.all(theme.density.paddingLarge),
              child: Column(
                children: workflow.tasks.map((task) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: theme.density.spacingSmall),
                    child: TaskWidget(task: task),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
