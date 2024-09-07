import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/widgets/appbar/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/logo/logo.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/home/domain/usecases/logout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
        title: Logo(),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailure) {
              var snackbar = SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            if (state is ButtonSuccess) {
              AppNavigator.pushAndRemove(context, const WelcomePage());
            }
          },
          child: Center(
            child: Column(
              children: [
                const Text("Home Page"),
                Builder(builder: (context) {
                  return BasicReactiveButton(
                    onPressed: () {
                      context.read<ButtonStateCubit>().execute(usecase: Logout());
                    },
                    title: "Logout",
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
