import 'package:fluchat/utils/navigator_utils.dart';
import 'package:fluchat/ui/home/Novelties/novelties2_view.dart';
import 'package:fluchat/ui/home/Novelties/novelties_view.dart';
import 'package:fluchat/ui/home/chat/chat_view.dart';
import 'package:fluchat/ui/home/home_cubit.dart';
import 'package:fluchat/ui/home/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logocompany.png', height: 32),
            SizedBox(width: 8), //
            Text('Nombre de la empresa'),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider(
        create: (_) => HomeCubit(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<HomeCubit, int>(builder: (context, snapshot) {
                return IndexedStack(
                  index: snapshot,
                  children: [
                    ChatView(),
                    NoveltiesView(),
                    SettingsView(),
                    //NoveltiesView2(),

                  ],
                );
              }),
            ),
            HomeNavigationBar(),
          ],
        ),
      ),
    );
  }
}

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context, listen: true);
    final navigationBarSize = 80.0;
    final buttonSize = 56.0;
    final buttonMargin = 4.0;
    final topMargin = buttonSize / 3 + buttonMargin / 3;
    final canvasColor = Theme.of(context).canvasColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        child: Container(
          height: navigationBarSize + topMargin,
          width: MediaQuery.of(context).size.width,
          color: canvasColor,
          child: Stack(
            children: [
              Positioned.fill(
                top: topMargin,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HomeNavItem(
                        text: 'Mensajes',
                        iconData: Icons.chat_bubble,
                        onTap: () => cubit.onChangeTab(0),
                        selected: cubit.state == 0,
                      ),
                      _HomeNavItem(
                        text: 'Novedades',
                        iconData: Icons.access_alarms_outlined,
                        onTap: () => cubit.onChangeTab(1),
                        selected: cubit.state == 1,
                      ),


                      _HomeNavItem(
                        text: 'Perfil',
                        iconData: Icons.settings,
                        onTap: () => cubit.onChangeTab(2),
                        selected: cubit.state == 2,
                      ),

                      //_HomeNavItem(
                       // text: 'Prueba',
                        //iconData: Icons.dangerous,
                        //onTap: () => cubit.onChangeTab(3),
                        //selected: cubit.state == 3,
                      //),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    Key? key,
    this.iconData,
    this.text,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  final IconData? iconData;
  final String? text;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).bottomNavigationBarTheme.selectedItemColor;
    final unselectedColor = Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    final color = selected ? selectedColor : unselectedColor;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color),
          Text(text ?? '', style: TextStyle(color: color)),
        ],
      ),
    );
  }
}