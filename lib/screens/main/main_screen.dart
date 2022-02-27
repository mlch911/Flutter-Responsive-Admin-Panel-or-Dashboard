import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/new/dashboard_screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';
import '../new/inputtextfield.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: DashboardScreen2(),
            ),
          ],
        ),
      ),
      floatingActionButton: FlatButton(
          color: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '预测不准 ?',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.apply(fontWeightDelta: 3),
            ),
          ),
          onPressed: () {
            YYDialog? dialog;
            dialog = YYAlertDialogWithDivider(
                context: context,
                confirm: () {
                  dialog?.dismiss();
                });
          }),
    );
  }
}

YYDialog YYAlertDialogWithDivider(
    {required BuildContext context, VoidCallback? confirm = null}) {
  return YYDialog().build(context)
    ..borderRadius = defaultPadding
    ..backgroundColor = bgColor
    ..barrierColor = Colors.black.withOpacity(.6)
    ..widget(ReportView(onTapButton: confirm))
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
}

class ReportView extends StatefulWidget {
  final VoidCallback? onTapButton;

  const ReportView({Key? key, this.onTapButton}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReportView(onTapButton);
  }
}

class _ReportView extends State<ReportView> {
  var type = 0;
  var types = ['属性提取失败', '情感分析错误', '其它'];
  final VoidCallback? onTapButton;

  _ReportView(this.onTapButton);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isMobile(context) ? 400 : 800,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: defaultPadding),
            Text("情感分析错误反馈", style: Theme.of(context).textTheme.headline5),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: RedioView(texts: types),
            ),
            Row(
              children: [
                SizedBox(width: defaultPadding),
                Text("请描述具体内容：", style: TextStyle(fontSize: 17)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: InputTextField(
                buttonText: '提  交',
                buttonAlignment: MainAxisAlignment.center,
                onTapButton: onTapButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedioView extends StatefulWidget {
  int selected;
  List<String> texts;

  RedioView({Key? key, required this.texts, this.selected = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RedioView(texts: texts, selected: selected);
  }
}

class _RedioView extends State<RedioView> {
  int selected;
  final List<String> texts;

  _RedioView({required this.texts, this.selected = 0});

  @override
  Widget build(BuildContext context) {
    var views = () {
      return texts
          .asMap()
          .map((i, e) => MapEntry(i, [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      value: i,
                      onChanged: (value) {
                        setState(() {
                          this.selected = value as int;
                        });
                      },
                      groupValue: this.selected,
                    ),
                    Text(texts[i], style: TextStyle(fontSize: 17)),
                  ],
                ),
              ]))
          .values
          .expand((element) => element)
          .toList();
    }();
    if (Responsive.isMobile(context)) {
      return Column(children: views);
    } else {
      return Wrap(children: views, spacing: 20);
    }
  }
}
