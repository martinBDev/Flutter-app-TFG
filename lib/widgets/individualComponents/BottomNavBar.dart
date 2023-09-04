

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/MyNavigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';

///Bottom navigation bar
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});




    @override
    State<StatefulWidget> createState() => BottomNavBarState();
  }



class BottomNavBarState extends State<BottomNavBar>{




  static int currentIndex = 0;

  ///Change the screen depending on the index
  @override
  BottomNavigationBar build(BuildContext context){
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.lightBlue[300],
      unselectedItemColor: Colors.white,
      items:  [
        BottomNavigationBarItem( //index 0 --> status
          icon: const Icon(Icons.monitor_heart),
          label: Text(
              semanticsLabel: AppLocalizations.of(context)!.status,
              AppLocalizations.of(context)!.status).data,
        ),
        BottomNavigationBarItem( //index 1 --> account / login
          icon: const Icon(Icons.account_circle),
          label: Text(
              semanticsLabel:  AppLocalizations.of(context)!.account,
              AppLocalizations.of(context)!.account).data,

        ),

        BottomNavigationBarItem( //index 2 --> BLE device
          icon: const Icon(Icons.bluetooth),
          label: Text(
              semanticsLabel: AppLocalizations.of(context)!.device,
              AppLocalizations.of(context)!.device).data,

        ),
      ],
      currentIndex: currentIndex, //Since the widget has state,
      // we set the selected index to the value saved, then change screen depending on value
      onTap: (index) {

        switch(index){

          case 0:{

            if(currentIndex != index){
              currentIndex = index;
              MyNavigator().navigateTo( "/status", context);
            }


              break;
            }

          case 1:{
            if(currentIndex != index){
              currentIndex = index;
              if(MyAuthController().isUserLoggedIn()){

                MyNavigator().navigateTo("/profile", context);
              }else{
                MyNavigator().navigateTo("/login", context);
              }
            }



            break;
          }
          case 2:{
            if(currentIndex != index){
              currentIndex = index;
              MyNavigator().navigateTo( "/ble",context);
            }

            break;
          }

        }




      }, //Every time
      //the menu nav bar is clicked, we update an save the index
    );
  }

}