import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoScreen extends StatefulWidget {


  InfoScreen({ super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<Item> items = [
    Item(
      headerValue: 'Pulsaciones por Minuto',
      expandedValue: <String>[
        'Braquicardia: < 60 BPMs - ROJO',
        'Estado Normal: entre 60 y 120 BPMs - VERDE',
        'Taquicardia: > 120 BPMs - NARANJA',
        'PELIGRO: > 180 BPMs - ROJO'
      ],
    ),
    Item(
      headerValue: 'Nivel de O2',
      expandedValue: <String>[
        'Hipoxemia: < 90% - ROJO',
        'Nivel normal: entre 90% y 100% - VERDE',
      ],
    ),
    Item(
      headerValue: 'Presión Arterial',
      expandedValue: <String>[
        'Presión demasiado baja: < 50/40 mmHg - ROJO',
        'Hipotensión: < 90/60 mmHg - AMARILLO',
        'Presión normal: entre 90/60 y 130/80 mmHg - VERDE',
        'Prehipertensión: entre 130/80 y 140/90 mmHg - NARANJA',
        'Hipertensión: > 140/90 mmHg - ROJO',
      ],
    ),
    Item(
      headerValue: 'Azúcar en Sangre',
      expandedValue: <String>[
        'Hipoglucemia: < 70 mg/dl - ROJO',
        'Nivel normal en ayunas: entre 70 y 100 mg/dl - VERDE',
        'Pre-diabetes: entre 100 y 125 mg/dl - NARANJA',
        'Diabetes: > 125 mg/dl - ROJO',
      ],
    ),
  ];


  @override
  Widget build(BuildContext context) {



      return Scaffold(
        appBar: AppBar(
          title: Text('Información'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  items[index].isExpanded = !isExpanded;
                });
              },
              children: items.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.headerValue),
                    );
                  },
                  body: Column(
                    children: item.expandedValue.map<Widget>((String text) {
                      return ListTile(
                        title: Text(text),
                      );
                    }).toList(),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ),
      );
    }


  }


class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  List<String> expandedValue;
  String headerValue;
  bool isExpanded;
}

