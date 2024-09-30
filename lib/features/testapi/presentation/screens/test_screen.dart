import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movemate/features/testapi/presentation/screens/test_controller.dart';
import 'package:movemate/features/testapi/data/models/house_model.dart';

class TestScreen extends HookConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the controller
    final controller = ref.read(testControllerProvider.notifier);

    // Use useState to manage the houses list
    final houses = useState<List<HouseModel>?>(null);
    final isLoading = useState<bool>(false);
    final error = useState<Object?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API'),
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : houses.value != null
              ? ListView.builder(
                  itemCount: houses.value!.length,
                  itemBuilder: (context, index) {
                    final house = houses.value![index];
                    return ListTile(
                      title: Text(
                        house.id.toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 30),
                      ),
                      subtitle: Text(house.name ?? 'Unnamed House'),
                      // subtitle: Text(house.address ?? 'No Address'),
                    );
                  },
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Fetch the data and update the state
                      isLoading.value = true;
                      controller.getHouses(context).then((data) {
                        houses.value = data;
                        isLoading.value = false;
                      }).catchError((e) {
                        error.value = e;
                        isLoading.value = false;
                        print("Error fetching houses: $e");
                      });
                    },
                    child: const Text('Fetch Houses'),
                  ),
                ),
    );
  }
}
