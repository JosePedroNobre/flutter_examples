import 'package:customer/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SenseiSlider extends StatefulWidget {
  final List<Widget> widgets;
  final Function onSkip;
  final Function onNext;

  SenseiSlider({@required this.widgets, this.onSkip, this.onNext});

  @override
  _SenseiSliderState createState() => _SenseiSliderState();
}

class _SenseiSliderState extends State<SenseiSlider> {
  final controller = PageController(viewportFraction: 1, initialPage: 0);
  bool isFirst = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        isFirst = controller.page.toInt() != 0;
        isLastPage = controller.page.toInt() == widget.widgets.length - 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => controller.previousPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeIn),
          child: isFirst
              ? Row(
                  children: [Icon(Icons.arrow_back_ios)],
                )
              : null,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: PageView(
                controller: controller,
                children: widget.widgets,
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: SmoothPageIndicator(
                controller: controller,
                count: widget.widgets.length,
                effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    dotColor: Color(0xffDEE2E6),
                    activeDotColor: Theme.of(context).primaryColor),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 45, right: 24, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: InkWell(
                    onTap: () {
                      widget.onSkip();
                    },
                    child: Text("Skip",
                        style: font1(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            size: 14)),
                  )),
                  Flexible(
                    child: Container(
                      width: 112,
                      height: 48,
                      child: RaisedButton(
                          child: Text("NEXT"),
                          onPressed: () {
                            if (isLastPage) {
                              widget.onNext();
                            } else {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            }
                          }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
