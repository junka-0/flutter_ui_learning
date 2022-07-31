import 'package:flutter/material.dart';
import 'package:flutter_ui_learning/config/router.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            for (final route in AppRouter.routes)
              if (route.name != AppRouter.menu.name)
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pushNamed(route.name ?? '');
                      },
                      child: Text(route.name ?? ''),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
