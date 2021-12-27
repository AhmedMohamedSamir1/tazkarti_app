import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tazkarti_system/modules/login/login_screen.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';


class BoardingModel{
  late final String image;
  late final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });

}

class OnBoardingScreen  extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);


  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  PageController boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/football_design1.jpg',
        title: 'Explore',
        body: 'View all future matches and choose whatever you wish to see'
    ),
    BoardingModel(
        image: 'assets/images/football_design12.jpg',
        title: 'Reserve',
        body: 'cheering your favourite teams by reserving a tickets for its matches',

    ),
    BoardingModel(
        image: 'assets/images/match_location1.jpg',
        title: 'location',
        body: 'Know any match location on google map',
    ),
  ];

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('104B2B'),

        title: Text(
          'welcome to tazkrti system',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.white
        ),
        ),
        actions: [
          TextButton(
            onPressed: passOnBoarding,
            child: Text(
              'SKIP',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white
              ),
            ),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller:  boardController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index)=>buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (int index){
                  if(index == boarding.length-1)
                  {
                    setState(() {
                      isLast = true;
                    });
                  }
                  else
                  {
                    setState(() {
                      isLast = false;
                    });
                  }

                },
              ),
            ),
            const SizedBox(height: 35,),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect:  ExpandingDotsEffect(
                    dotColor: Colors.green,
                    activeDotColor: HexColor('104B2B'),
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 7, // the size of specified dot expansion
                    spacing: 5, // space between dots
                  ),
                  count:boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: HexColor('104B2B'),
                  onPressed: (){
                    if(isLast)
                    {
                      passOnBoarding();
                    }
                    else
                    {
                      boardController.nextPage(
                          duration: const Duration(
                              milliseconds: 600
                          ),
                          curve: Curves.fastLinearToSlowEaseIn
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            )
          ],
        ),
      ),

    );
  }

  Widget buildBoardingItem(BoardingModel model){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(

          child: Image(
            image: AssetImage(model.image),
            //width: double.infinity,
            //fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          model.title,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          model.body,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void passOnBoarding()
  {
    CashHelper.saveData(key: "passOnBoarding", value: true).then((value) {
      if(value)
      {
        navigateAndFinish(context, LoginScreen());
      }
    });

  }
}
