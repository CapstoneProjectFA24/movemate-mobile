import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movemate/features/booking/domain/entities/services_fee_system_entity.dart';
import 'package:movemate/features/booking/presentation/widgets/booking_screen_2th/fee_system/services_fee_system_controller.dart';
import 'package:movemate/models/request/paging_model.dart';
@RoutePage()
class SystemFeeScreen extends ConsumerStatefulWidget {
  const SystemFeeScreen({super.key});

  @override
  ConsumerState<SystemFeeScreen> createState() => _SystemFeeScreenState();
}

class _SystemFeeScreenState extends ConsumerState<SystemFeeScreen> {
  late Future<List<ServicesFeeSystemEntity>> _feeSystemsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState
    _feeSystemsFuture = _fetchFeeSystems();
  }

  Future<List<ServicesFeeSystemEntity>> _fetchFeeSystems() async {
    // Initialize PagingModel with default values or as required
    final pagingModel = PagingModel(
 
      pageSize: 20,
      // Add other fields if necessary
    );

    // Access the controller's notifier
    final controller = ref.read(servicesFeeSystemControllerProvider.notifier);

    // Call getFeeSystems and pass the BuildContext
    return controller.getFeeSystems(pagingModel, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Fee System'),
      ),
      body: FutureBuilder<List<ServicesFeeSystemEntity>>(
        future: _feeSystemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No services fee available.'),
            );
          } else {
            final feeSystems = snapshot.data!;
            return ListView.separated(
              itemCount: feeSystems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final fee = feeSystems[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(fee.id.toString()),
                  ),
                  title: Text(fee.name),
                  subtitle: fee.description != null ? Text(fee.description!) : null,
                  trailing: Text('\$${fee.amount}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
