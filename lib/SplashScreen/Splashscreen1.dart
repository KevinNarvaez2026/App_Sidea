import 'package:app_actasalinstante/constants.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animations/animations.dart';
import '../LoginView/api/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.7) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: copAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(copAnimated ? 40.0 : 0.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !copAnimated,
                  child: Lottie.asset(
                    'assets/ACTAS.json',
                    controller: _coffeeController,
                    onLoaded: (composition) {
                      _coffeeController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
                Visibility(
                  visible: copAnimated,
                  child: Image.asset(
                    'assets/splash.png',
                    height: 190.0,
                    width: 190.0,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCafeText ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: Text('Actas al instante',
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          ),

          // Text bottom part
          Visibility(visible: copAnimated, child: const _BottomPart()),
        ],
      ),
    );
  }
}
//

class _BottomPart extends StatelessWidget {
  const _BottomPart({key}) : super(key: key);

  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Descarga tus actas de Nacimiento, Matrimonio, Defunción y Divorcio',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                )),
            const SizedBox(height: 20.0),
            Text(
              '',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40.0),
            // Align(

            //   alignment: Alignment.centerRight,

            //   child: Container(
            //     height: 85.0,
            //     width: 85.0,

            //     decoration: BoxDecoration(

            //       shape: BoxShape.circle,
            //       border: Border.all(color: Colors.white, width: 2.0),

            //     ),

            //   ),
            // ),
            const SizedBox(height: 40.0),

            SizedBox(height: 20),
            MaterialButton(
              minWidth: double.infinity,
              height: 70,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Icon(
                Icons.chevron_right,
                size: 70.0,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
