import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/presentation/chat/cubits/chats_container_cubit.dart';

class ChatsContainer extends StatelessWidget {
  const ChatsContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ChatsContainerCubit(),
        child: BlocBuilder<ChatsContainerCubit, ChatsContainerState>(
          builder: (context, state) {
            return child;
          },
        ));
  }
}
