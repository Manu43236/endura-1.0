// ignore_for_file: must_be_immutable

import 'package:endura_app/app/modules/dropdown_selector/controllers/service_tech_home_company_selector_controller.dart';
import 'package:endura_app/app/modules/dropdown_selector/controllers/service_tech_home_representative_selector_controller.dart';
import 'package:endura_app/app/modules/login/controllers/login_controller.dart';
import 'package:endura_app/core/base/controllers/base_controller.dart';
import 'package:endura_app/core/base/views/search_selection_dialog_view.dart';
import 'package:endura_app/core/base/views/search_view.dart';
import 'package:endura_app/core/constants/color_constants.dart';
import 'package:endura_app/core/util_widgets/selector_container.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ServiceTechRepresentativeSearchSelectView
    extends SearchView<ServiceTechHomeRepresentativeSelectorController> {
  ServiceTechRepresentativeSearchSelectView({Key? key}) : super(key: key);

  @override
  Widget cBuild(BuildContext context,
      ServiceTechHomeRepresentativeSelectorController cController) {
    return Obx(
      () => cController.apiState.value == APIState.LOADING
          ? _getShimmerLoader()
          : InkWell(
              onTap: () async {
                var item = await Get.dialog(SearchSelectionDialogView(
                  items: cController.routes,
                  searchHint: 'Select Representative',
                  title: 'Representatives',
                ));

                if (item != null) {
                  List list = cController.model.value.result!
                      .where(
                        (element) => element.name == item,
                      )
                      .toList();

                  cController.selectedRepresentativeEmail.value =
                      list[0].email!;
                  Get.find<ServiceTechCompanySelectorController>()
                      .getCustomersOrCompaniesByAccRep(
                          email:
                              Get.find<LoginController>().userModel.value.email,
                          accRepEmail: list[0].email);

                  cController.selectedRepresentativeName(item);
                }
              },
              child: Containers().getSelectorContainer(
                name: cController.selectedRepresentativeName.value,
              )),
    );
  }
}

_getShimmerLoader() {
  return Shimmer.fromColors(
    baseColor: ColorConstants.color2.withOpacity(0.05),
    highlightColor: ColorConstants.black1.withOpacity(0.2),
    child: Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      height: 60.0,
      width: double.infinity,
    ),
  );
}
