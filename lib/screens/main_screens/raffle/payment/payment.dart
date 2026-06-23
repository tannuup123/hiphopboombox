import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/screens/main_screens/raffle/payment/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../backend/api.dart';

class Payment extends StatelessWidget {
  final ShoeModal shoeModal;
  final String humanType;
  final String size;
  const Payment({super.key, required this.shoeModal, required this.humanType, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selection Made',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 30.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shoeModal.title,style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(fontSize: 18.sp)
                        ,),
                      SizedBox(height: 10.h,),
                      Text(shoeModal.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.h,),
                      Text('$humanType - $size',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24
                    )
                  ),
                  child: Image.network(shoeModal.image1,
                  height: 100.h,width: 130.w,),
                )
              ],
            ),

            SizedBox(height: 30.h,),
            InkWell(
              onTap: (){
                MyApi.getInstance.sendVerifyEmail(gender: humanType, size: size, raffleId: shoeModal.id);
                Navigator.push(context, MaterialPageRoute(builder: (builder)=> VerifyEmail(gender: humanType, size: size, raffleId: shoeModal.id)));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 50.w),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.r)
                ),
                child: Center(
                  child: Text('Continue',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18.sp,
                      color: Colors.white
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
