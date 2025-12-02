import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/helper/notification_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialogWidget extends StatefulWidget {
  final int orderId;

  const NewRequestDialogWidget({super.key, required this.orderId});

  @override
  State<NewRequestDialogWidget> createState() => _NewRequestDialogWidgetState();
}

class _NewRequestDialogWidgetState extends State<NewRequestDialogWidget> {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    _stopAlarm();
    NotificationHelper.stopRingingForOrder(widget.orderId);
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAlarm() {
    _playNotification();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _playNotification();
    });
  }

  void _playNotification() {
    _audioPlayer.play(AssetSource('notification.mp3'));
  }

  void _stopAlarm() {
    _timer?.cancel();
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {

    bool isRental = Get.find<AuthController>().getModuleType() == 'rental';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.notificationIn, height: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              isRental ? 'new_trip_booked'.tr : 'new_order_placed'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          CustomButtonWidget(
            height: 40,
            buttonText: 'ok'.tr,
            onPressed: () {
              _stopAlarm();
              NotificationHelper.stopRingingForOrder(widget.orderId);
              if(Get.isDialogOpen!) {
                Get.back();
              }
              if(isRental) {
                Get.offAll(() => TripDetailsScreen(tripId: widget.orderId, fromNotification: true));
              } else{
                Get.offAllNamed(RouteHelper.getOrderDetailsRoute(widget.orderId, fromNotification: true));
              }
            },
          ),

        ]),
      ),
    );
  }
}
