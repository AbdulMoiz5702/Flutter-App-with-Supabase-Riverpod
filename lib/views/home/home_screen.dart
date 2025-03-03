import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mediumText(title: 'Home Screen'),
      ),
      body:  Column(),
    );
  }
}
