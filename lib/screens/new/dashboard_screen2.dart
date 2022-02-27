import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

import 'inputtextfield.dart';
import 'model.dart';

const colors = [
  primaryColor,
  Colors.green,
  Color(0xFF26E5FF),
  Color(0xFFFFCF26),
  Color(0xFFEE2727),
];

Result result = Result(
    text:
        """状元楼饭店第一次去，因为地理位置优越：在宁波市和义大道，开车过去很方便，就在路边很好找，就是去太晚没有停车位了，里面装修中式风格但是不大，挺干净的。菜是地道的宁波菜，口味纯正，醉泥螺特棒，分量也足，吃到了小时候的味道，价格不算贵性价比和其他家比可以，团购打折比较划算，推荐给大家，因为去了晚了，在大堂等了一会儿，期间有茶水喝、服务员还与你聊天，到了就餐时生意太好，人多了有点吵，上菜速度有点慢，服务员都是小跑状，样样都服务到位，点酒水还耐心的与我们解释，就这样绝对要夸一夸，特别是彭新星、洪继华（看服务牌才知道名字）也给我们宁波市形象增色，状元楼是宁波的一扇窗口，服务员的素质更体现我们宁波人的精神面貌。赞一个""",
    sections: [
      Section(name: "菜品", items: [
        Item(name: "份量", score: 1),
        Item(name: "口感", score: 1),
        Item(name: "外观", score: 1),
        Item(name: "推荐程度", score: 1),
      ]),
      Section(name: "环境", items: [
        Item(name: "装修情况", score: 1),
        Item(name: "环境声音", score: -1),
        Item(name: "就餐空间", score: 0),
        Item(name: "卫生情况", score: 1),
      ]),
      Section(name: "价格", items: [
        Item(name: "价格水平", score: 1),
        Item(name: "性价比", score: 1),
        Item(name: "折扣力度", score: 1),
      ]),
      Section(name: "服务", items: [
        Item(name: "排队等候时间", score: 0),
        Item(name: "服务人员态度", score: 1),
        Item(name: "是否容易停车", score: -1),
        Item(name: "点菜/上菜速度", score: -1),
      ]),
      Section(name: "位置", items: [
        Item(name: "交通是否便利", score: 1),
        Item(name: "距离商圈远近", score: 1),
        Item(name: "是否容易寻找", score: 1),
      ]),
    ]);

class DashboardScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Text(
              "餐饮用户评价-中文情感分析",
              style: Responsive.isMobile(context)
                  ? Theme.of(context).textTheme.headline6
                  : Theme.of(context)
                      .textTheme
                      .headline4
                      ?.apply(color: Colors.white),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 800,
              child: Row(
                children: [
                  Text('请输入要分析的文本：'),
                  TextButton(onPressed: () {}, child: Text('随机示例')),
                ],
              ),
            ),
            SizedBox(
              width: 800,
              child: InputTextField(text: result.text, buttonText: '立 即 分 析'),
            ),
            ResultView(result: result),
            SizedBox(
                height: Responsive.isMobile(context) ? defaultPadding : 50),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: result.sections
                  .asMap()
                  .map((i, e) => MapEntry(
                      i,
                      SizedBox(
                          width: 300,
                          child: SectionView(data: e, color: colors[i]))))
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultView extends StatelessWidget {
  final Result result;

  const ResultView({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: () {
                double all = result.sections
                    .map((e) => e.score())
                    .reduce((cur, element) => cur + element)
                    .toDouble();
                var datas = result.sections
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        PieChartSectionData(
                            color: colors[i],
                            value: e.score() / all * 100,
                            radius: 20,
                            title: e.name,
                            titlePositionPercentageOffset: 2)))
                    .values;
                return datas.toList();
              }(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${result.score()}",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.apply(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionView extends StatelessWidget {
  final Section data;
  final Color color;

  const SectionView({Key? key, required this.data, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: () {
              List<Widget> list = [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          child: SizedBox(
                            height: 6,
                            width: 100,
                            child: LinearProgressIndicator(
                              color: color,
                              backgroundColor: Colors.white.withOpacity(.3),
                              value: data.score() / 100,
                            ),
                          )),
                    )),
                    Text(data.score().toString())
                  ],
                ),
                SizedBox(height: defaultPadding),
              ];
              list.addAll(data.validItems.map((e) => ItemView(e)).toList());
              return list;
            }()),
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final Item data;

  ItemView(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          () {
            SvgPicture img;
            switch (data.commentType()) {
              case ItemCommentType.like:
                img = SvgPicture.asset('assets/icons/开心.svg');
                break;
              case ItemCommentType.normal:
                img = SvgPicture.asset('assets/icons/clown.svg');
                break;
              case ItemCommentType.dislike:
                img = SvgPicture.asset('assets/icons/angry.svg');
                break;
              default:
                return SizedBox();
            }
            return SizedBox(width: 20, height: 20, child: img);
          }(),
        ],
      ),
    );
  }
}
