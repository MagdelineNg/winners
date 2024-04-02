import 'package:hidden_gems_sg/helper/utils.dart';
import 'package:hidden_gems_sg/screens/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hidden_gems_sg/helper/interest_controller.dart';

class InterestScreenArguments {
  final String userID;
  final String userInts;

  InterestScreenArguments(this.userID, this.userInts);
}

class InterestScreen extends StatefulWidget {
  static const routeName = '/interests';
  final String userID;
  final String userInts;

  const InterestScreen(this.userID, this.userInts, {super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final InterestController _interestController = InterestController();
  final _interestsMap = Map();
  List _intList = [];

  @override
  void initState() {
    super.initState();
    buildMap();
  }

  void buildMap() {
    for (var i in placeType) {
      _interestsMap[i] = false;
    }
    _intList = widget.userInts.split(',');
  }

  void updateInterestChoices() {
    _interestsMap.forEach((key, value) {
      for (String i in _intList) {
        if (i == key) {
          _interestsMap[key] = true;
          break;
        }
      }
    });
    _intList.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    updateInterestChoices();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: SvgPicture.asset(
                'assets/img/interests-top.svg',
                width: w,
                height: w * 116 / 375, //dimensions from figma lol
              ),
            ),
            const Text(
              "what are your interests?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MadeSunflower',
                fontSize: 36,
                color: Color(0xff22254C),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.0,
                children: List<Widget>.generate(
                  placeType.length,
                  (int index) {
                    bool isSelected = _interestsMap[placeType[index]];
                    return ChoiceChip(
                      label: Text(placeType[index]),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _interestsMap[placeType[index]] =
                              selected ? true : false;
                        });
                      },
                      backgroundColor: const Color(0xfffffcec),
                      selectedColor: const Color(0xff6488E5),
                      labelStyle: avenirLtStdStyle(
                        isSelected ? Colors.white : const Color(0xff6488E5),
                      ),
                      side:
                          const BorderSide(color: Color(0xff6488E5), width: 2),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                print(widget.userID);
                _interestController.updateUserInterests(
                    _interestsMap, widget.userID);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, BaseScreen.routeName);
                }
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xffF9BE7D),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: textMinor(
                'save changes',
                const Color(0xff22254C),
              ),
            ),
            Container(height: 20),
          ],
        ),
      ),
    );
  }
}
