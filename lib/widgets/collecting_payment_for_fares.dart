import 'package:flutter/material.dart';
import 'package:uber_clone_2_driver/brand_colors.dart';
import 'package:uber_clone_2_driver/helpers/helpersmethod.dart';
import 'package:uber_clone_2_driver/widgets/brand_divider.dart';
import 'package:uber_clone_2_driver/widgets/taxi_button.dart';

//todo 2 (finish)
class CollectPayment extends StatelessWidget {

  final String paymentMethod;
  final int fares;

  CollectPayment({this.paymentMethod,this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(mainAxisSize: MainAxisSize.min,children: [
          SizedBox(height: 20),
          Text('${paymentMethod.toUpperCase()} PAYMENT'),
          SizedBox(height: 20),
          BrandDivider(),
          SizedBox(height: 10),
          Text('\$$fares',style: TextStyle(fontFamily: 'Brand-Bold',fontSize: 50)),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Amount above is total fares to be charged to the rider',textAlign: TextAlign.center),
          ),

          SizedBox(height: 30),
          Container(
            width: 230,
            child: TaxiButton(
              title: (paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM',
              color: BrandColors.colorGreen,
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);

                HelperMethods.enableHomeTabLocationUpdates();
              },
            ),
          )
        ],),
      ),
    );
  }
}
