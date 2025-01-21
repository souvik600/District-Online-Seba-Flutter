import 'package:flutter/material.dart';
import '../../../../../AppColors/AppColors.dart';
import '../../../../../Styles/TextContainerStyle.dart';
import '../../../../../Widgets/information_category_list_widget.dart';
import 'admin_comment_screen.dart';

class AdminCommentAndUserListCategory extends StatelessWidget {
  const AdminCommentAndUserListCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
        Border.all(color: AppColors.pColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            TextContainerStyle("Admin Comment and User List",AppColors.pColor),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                AllInfromationCategoryList(
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminCommentScreen(),
                        ));
                  },
                  'assets/icons/comment.png',
                  'Comment',
                ),
                AllInfromationCategoryList(
                      () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           AdminHighSchoolScreen(),
                    //     ));
                  },
                  'assets/icons/teamwork.png',
                  "UserList",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
