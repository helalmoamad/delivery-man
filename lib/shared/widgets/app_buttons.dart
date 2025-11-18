import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class AppButton {
  static normalButton({
    required String title,
    VoidCallback? onPress,
    Color backgroundColor = AppColors.darkGrey,
    Color titleColor = Colors.white,
    double titleSize = 14,
    bool shadow = true,
    double height = 50,
    double width = double.infinity,
    Key? key1,
  }) {
    return  InkWell(
        onTap: onPress,
        key: key1,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor.withOpacity(0.9), backgroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    )
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextWidget(
              text: title,
              color: titleColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxline: 2,
            ),
          ),
        ),
      
    );
  }
}


// import 'package:delivery_man_app/shared/widgets/text_widget.dart';
// import 'package:flutter/material.dart';

// import '../constants/color_constants.dart';

// class AppButton {
//   static normalButton({
//     required String title,
//     VoidCallback? onPress,
//     Color backgroundColor = AppColors.darkGrey,
//     Color titleColor = Colors.white,
//     double titleSize = 14,
//     bool shadow = true,
//     double height = 50,
//     double width = double.infinity,
//     Key? key1,
//   }) {
//     return InkWell(
//       onTap: onPress,
//       key: key1,
//       borderRadius: BorderRadius.circular(height / 2),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               height: height,
//               width: height * 2,
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(height / 2),
//                 boxShadow: shadow
//                     ? [
//                         BoxShadow(
//                           color: backgroundColor.withOpacity(0.3),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         )
//                       ]
//                     : null,
//               ),
//               child: Align(
//                 alignment: backgroundColor == const Color.fromARGB(255, 22, 219, 65)
//                     ? Alignment.centerRight
//                     : Alignment.centerLeft,
//                 child: Container(
//                   height: height - 8,
//                   width: height - 8,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 1),
//             TextWidget(
//               text: title,
//               color: Colors.black,
//               fontSize: titleSize - 1,
//               fontWeight: FontWeight.bold,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               maxline: 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
