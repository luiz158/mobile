import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform.dart';

import '../utils/style.dart';

/// A choice picker component that displays a [Card] with [ListTile] as items.
class ListTileChoice<T extends Enum> extends StatelessWidget {
  const ListTileChoice({
    super.key,
    required this.choices,
    required this.selectedItem,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.onSelectedItemChanged,
  });

  final List<T> choices;
  final Enum selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final void Function(T choice) onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformCard(
      child: Column(
        children: ListTile.divideTiles(
            color: dividerColor(context),
            context: context,
            tiles: choices.map((value) {
              return ListTile(
                selected: selectedItem == value,
                trailing: selectedItem == value
                    ? defaultTargetPlatform == TargetPlatform.iOS
                        ? const Icon(CupertinoIcons.check_mark_circled_solid)
                        : const Icon(Icons.check)
                    : null,
                title: titleBuilder(value),
                subtitle: subtitleBuilder?.call(value),
                onTap: () => onSelectedItemChanged(value),
              );
            })).toList(growable: false),
      ),
    );
  }
}
