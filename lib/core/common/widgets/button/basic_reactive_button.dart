import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class BasicReactiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Widget? content;
  final ButtonVariant variant;

  const BasicReactiveButton({
    required this.onPressed,
    this.title = '',
    this.height,
    this.content,
    super.key,
    this.variant = ButtonVariant.defaultVariant,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        return state is ButtonLoading
            ? _buildButton(
                null,
                const CircularProgressIndicator(
                  color: AppColors.primary,
                ))
            : _buildButton(onPressed, content ?? Text(title, style: _textStyle()));
      },
    );
  }

  Widget _buildButton(VoidCallback? onPressed, Widget child) {
    final buttonHeight = height ?? 50;
    final style = ElevatedButton.styleFrom(minimumSize: Size.fromHeight(buttonHeight));

    switch (variant) {
      case ButtonVariant.outline:
        return OutlinedButton(
            onPressed: onPressed, style: style, child: _buildContent(buttonHeight, child));
      case ButtonVariant.ghost:
        return TextButton(
            onPressed: onPressed, style: style, child: _buildContent(buttonHeight, child));
      default:
        return ElevatedButton(
            onPressed: onPressed, style: style, child: _buildContent(buttonHeight, child));
    }
  }

  Widget _buildContent(double height, Widget child) {
    return Container(height: height, alignment: Alignment.center, child: child);
  }

  TextStyle _textStyle() {
    return const TextStyle(color: Colors.white, fontWeight: FontWeight.w400);
  }
}
