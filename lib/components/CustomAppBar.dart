import 'package:flutter/material.dart';
import 'package:servicio_tecnico/components/SwitchModeTheme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.styleTitle,
    this.colorBackground = Colors.transparent,
    required this.showSwitch, 
    this.showIcon,
  });

  final String title;
  final TextStyle? styleTitle;
  final Color? colorBackground;
  final bool showSwitch;
  final bool? showIcon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: colorBackground,
      toolbarHeight: 200,
      title: Text(
        title,
        style: styleTitle,
      ),
      leading: showIcon == true ? const BackButton(color: Colors.white) : null,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [if (showSwitch) const SwitchModeTheme()],
          ),
        )
      ],
    );
  }
}
