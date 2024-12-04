import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movemate/configs/routes/app_router.dart';
import 'package:movemate/features/profile/domain/entities/transaction_entity.dart';
import 'package:movemate/features/profile/presentation/controllers/profile_controller/profile_controller.dart';
import 'package:movemate/features/profile/presentation/controllers/transaction_controller/transaction_controller.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/credit_card_widget.dart';
import 'package:movemate/features/profile/presentation/widgets/transaction/transaction_item.dart';
import 'package:movemate/hooks/use_fetch.dart';
import 'package:movemate/models/request/paging_model.dart';
import 'package:movemate/utils/commons/widgets/app_bar.dart';
import 'package:movemate/utils/commons/widgets/custom_circular.dart';
import 'package:movemate/utils/commons/widgets/empty_box.dart';
import 'package:movemate/utils/commons/widgets/home_shimmer.dart';
import 'package:movemate/utils/commons/widgets/widgets_common_export.dart';
import 'package:movemate/utils/constants/asset_constant.dart';
import 'package:movemate/utils/enums/payment_method_type.dart';
import 'package:movemate/utils/enums/transaction_status_enum.dart';

@RoutePage()
class ListTransactionScreen extends HookConsumerWidget {
  const ListTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);

    final controller = ref.read(transactionControllerProvider.notifier);

    // Sử dụng useFetch để lấy danh sách ServicesPackageTruckEntity
    final fetchResult = useFetch<TransactionEntity>(
      function: (model, context) async {
        // Gọi API và lấy dữ liệu ban đầu
        final servicesList = await controller.getTransactionByUserId(context);

        // Trả về danh sách ServicesPackageTruckEntity
        return servicesList;
      },
      initialPagingModel: PagingModel(),
      context: context,
    );

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AssetsConstants.primaryMain,
          title: "Lịch sử giao dịch",
          iconSecond: Icons.home_outlined,
          backButtonColor: Colors.white,
          centerTitle: true,
          onCallBackSecond: () {
            final tabsRouter = context.router.root
                .innerRouterOf<TabsRouter>(TabViewScreenRoute.name);
            if (tabsRouter != null) {
              tabsRouter.setActiveIndex(0);
              context.router.popUntilRouteWithName(TabViewScreenRoute.name);
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thẻ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Horizontal Scroll for Cards
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 35), // Optional space between cards
                    CreditCardWidget(
                        // cardNumber: '1234 5678 9876 5432',
                        // cardHolder: 'John Doe',
                        // expiryDate: '11/24',
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Giao dịch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // ListView for Transaction Items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (state.isLoading && fetchResult.items.isEmpty)
                        const Center(
                          child: HomeShimmer(amount: 4),
                        )
                      else if (fetchResult.items.isEmpty)
                        const Align(
                          alignment: Alignment.topCenter,
                          child: EmptyBox(title: 'Không có giao dịch'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fetchResult.items.length + 1,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AssetsConstants.defaultPadding - 15.0,
                          ),
                          itemBuilder: (_, index) {
                            if (index == fetchResult.items.length) {
                              if (fetchResult.isFetchingData) {
                                return const CustomCircular();
                              }
                              return fetchResult.isLastPage
                                  ? const SizedBox.shrink()
                                  : Container();
                            }
                            final transaction = fetchResult.items[index];
                            final transactionIcon = getIconForTransactionType(
                                transaction.transactionType);
                            final cardColor =
                                getCardColor(transaction.transactionType);
                            final amountColor =
                                getAmountColor(transaction.transactionType);
                            final titleStyle = getTextStyleForTitle(
                                transaction.transactionType);
                            final descriptionStyle = getTextStyleForDescription(
                                transaction.transactionType);

                            return TransactionItem(
                              transaction: transaction,
                              icon: transactionIcon,
                              name: transaction.transactionType,
                              description: transaction.transactionCode,
                              amount: transaction.amount,
                              date: transaction.createdAt.toString(),
                              paymentMethod: transaction.paymentMethod ??
                                  'Unknown', // Payment method
                              imageUrl: transaction.paymentMethod ??
                                  '', // Transaction image (if any)
                              cardColor: cardColor,
                              amountColor: amountColor,
                              titleStyle: titleStyle,
                              descriptionStyle: descriptionStyle,
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
