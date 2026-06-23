import 'package:boombox/modal/shoe_modal.dart';
import 'package:boombox/screens/main_screens/raffle/product_details/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatelessWidget {
  final ShoeModal shoeModal;
  const ProductDetails({super.key, required this.shoeModal});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>ProductSelectCubit())
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shoeModal.title,style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: 10.h,),
                      Text(_formatDate(shoeModal.date),style: Theme.of(context).textTheme.bodyMedium,),
                    ],
                  ),
                ),
                BlocBuilder<ProductSelectCubit,int>(
                  builder: (BuildContext context, int imageIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Image.network(_getImage(imageIndex),height: MediaQuery.sizeOf(context).height * .3,)
                        ),
                        SizedBox(height: 30.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * .1,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: (){
                                      context.read<ProductSelectCubit>().selectIndex(index);
                                    },
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.r),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: index == imageIndex? Colors.blue :
                                              Theme.of(context).brightness==Brightness.light ? Colors.black26 : Colors.white24,
                                            width: index == imageIndex? 4 : 1
                                          ),
                                          image: DecorationImage(
                                            image: Image.network(_getImage(index)).image,
                                          )
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context,index){
                                  return SizedBox(width: 30.w,);
                                },
                                itemCount: 4
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h,),
      
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  RichText(
                                      text: TextSpan(
                                        text: 'Retail  ',
                                        style: Theme.of(context).textTheme.bodyMedium!.
                                        copyWith(fontSize: 16.sp),
                                        children: [
                                          TextSpan(
                                              text: '\$${shoeModal.retailPrice}',
                                              style: Theme.of(context).textTheme.titleSmall!.
                                              copyWith(fontSize: 30.sp)
                                          )
                                        ],
                                      )
                                  ),
                                  SizedBox(width: 20.w,),
                                  RichText(
                                      text: TextSpan(
                                        text: 'Resell  ',
                                        style: Theme.of(context).textTheme.bodyMedium!.
                                        copyWith(fontSize: 16.sp),
                                        children: [
                                          TextSpan(
                                              text: '\$${shoeModal.resellPrice}',
                                              style: Theme.of(context).textTheme.titleSmall!.
                                              copyWith(fontSize: 30.sp)
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h,),
                              Text(shoeModal.description,style: Theme.of(context).textTheme.bodyMedium,),
                            ],
                          ),
                        )
                      ],
                    );
                  },
      
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date){
    DateTime dateTime = DateTime.parse(date);
    // Create a DateFormat instance with the desired format
    return DateFormat("MMM dd, yyyy").format(dateTime);
  }

  String _getImage(int index){
    if (index==0) return shoeModal.image1;
    else if (index==1) return shoeModal.image2;
    else if (index==2) return shoeModal.image3;
    else if (index==3) return shoeModal.image4;
    else return shoeModal.image5;
  }

}
