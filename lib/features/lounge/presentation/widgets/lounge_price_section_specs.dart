import 'package:flutter/material.dart';
import 'package:gamecircle/core/utils/string_utils.dart';
import 'package:gamecircle/core/widgets/buttons/custom_outline_button.dart';
import 'package:gamecircle/features/lounges/data/models/spec_model.dart';
import 'package:gamecircle/features/lounges/domain/entities/lounge.dart';
import 'package:gamecircle/features/lounges/domain/entities/section_information.dart';
import 'package:gamecircle/features/lounges/domain/entities/spec.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoungePriceSectionsSpecs extends StatefulWidget {
  final Lounge lounge;

  LoungePriceSectionsSpecs({required this.lounge});

  @override
  _LoungePriceSectionsSpecsState createState() =>
      _LoungePriceSectionsSpecsState();
}

class _LoungePriceSectionsSpecsState extends State<LoungePriceSectionsSpecs> {
  List<SectionInformation?>? get sectionInformation =>
      widget.lounge.sectionInformation;

  late SectionInformation? currentSection;

  @override
  void initState() {
    super.initState();
    currentSection = sectionInformation?.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildPackages(context),
        _buildSectionButtons(),
        _buildPrice(),
        _buildSpecsTable(),
      ],
    );
  }

  Column _buildPackages(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: widget.lounge.packages!
                  .map(
                    (package) => Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Theme.of(context).chipTheme.backgroundColor,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Text(package?.hours?.toString() ?? '',
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: Text(
                                    "LBP ${StringUtils().addCommaToNumber(package?.hours?.toString() ?? '')}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ))
                            ],
                          ),
                        )),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionButtons() {
    final buttons = <Widget>[];
    Widget sectionButtons;

    if (sectionInformation!.length > 0) {
      for (int i = 0; i < sectionInformation!.length; i++) {
        buttons.add(
          Padding(
            padding: sectionInformation!.length == 1
                ? const EdgeInsets.only(right: 0)
                : const EdgeInsets.only(right: 8),
            child: CustomOutlineButton(
              borderColor: currentSection?.name == sectionInformation?[i]?.name
                  ? Theme.of(context).accentColor
                  : Theme.of(context).hintColor,
              onPressed: () {
                currentSection = sectionInformation?[i];

                if (mounted) setState(() {});
              },
              child: Text(
                sectionInformation?[i]?.name ?? '',
                style: TextStyle(
                    color: currentSection?.name == sectionInformation?[i]?.name
                        ? Theme.of(context).accentColor
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
      }
      sectionButtons = Row(
        mainAxisAlignment: MainAxisAlignment.center, //Centering buttons.
        children: buttons,
      );
    } else {
      sectionButtons = Container();
    }
    return sectionButtons;
  }

  _buildPrice() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        //Added row to center content.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            //Main price & packages container.
            color: Theme.of(context).accentColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  //Padding the text because container color is needed.
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "LBP ${StringUtils().addCommaToNumber(sectionInformation?.first?.price?.toString() ?? '')}",
                        // "LBP ${StringUtils().addCommaToNumber(_controller.section.price.toString())}",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      Text(
                        "/hr",
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSpecsTable() {
    String gpu;
    String monitor;
    String keyboard;
    String headset;
    String mouse;
    String chair;
    if (currentSection?.specs != null && currentSection!.specs!.isNotEmpty) {
      gpu = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.gpu,
            orElse: () => SpecModel(id: 0, name: "Unknown", type: SpecType.gpu),
          ))?.name ??
          '';
      monitor = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.monitor,
            orElse: () =>
                SpecModel(id: 0, name: "Unknown", type: SpecType.monitor),
          ))?.name ??
          '';
      keyboard = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.keyboard,
            orElse: () =>
                SpecModel(id: 0, name: "Unknown", type: SpecType.keyboard),
          ))?.name ??
          '';
      headset = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.headset,
            orElse: () =>
                SpecModel(id: 0, name: "Unknown", type: SpecType.headset),
          ))?.name ??
          '';
      mouse = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.mouse,
            orElse: () =>
                SpecModel(id: 0, name: "Unknown", type: SpecType.mouse),
          ))?.name ??
          '';
      chair = (currentSection!.specs!.firstWhere(
            (element) => element?.type == SpecType.chair,
            orElse: () =>
                SpecModel(id: 0, name: "Unknown", type: SpecType.chair),
          ))?.name ??
          '';
    } else {
      gpu = monitor = keyboard = headset = mouse = chair = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 16, right: 16),
      child: Column(
        children: <Widget>[
          _SpecRow(icon: MdiIcons.expansionCard, name: gpu),
          _SpecRow(icon: MdiIcons.monitor, name: monitor),
          _SpecRow(icon: MdiIcons.keyboard, name: keyboard),
          _SpecRow(icon: MdiIcons.headphones, name: headset),
          _SpecRow(icon: MdiIcons.mouse, name: mouse),
          _SpecRow(icon: MdiIcons.chairRolling, name: chair)
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String name;
  final IconData icon;

  const _SpecRow({
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).textTheme.headline6!.color,
            size: 24,
          ),
          Text(
            name == '' ? "-" : name,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
