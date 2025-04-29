import 'package:flutter/material.dart';
import '../models/materi.dart';

class MateriList extends StatelessWidget {
  final List<Materi> materiList;
  final Function(int) onDelete;
  final Function(int, String) onEdit;
  final Function(int, bool) onToggleCheck;

  const MateriList({
    super.key,
    required this.materiList,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(materiList.length, (i) {
        final materi = materiList[i];
        return CheckboxListTile(
          title: Text(materi.text),
          value: materi.isChecked,
          onChanged: (bool? value) {
            onToggleCheck(i, value ?? false);
          },
          secondary: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final controller = TextEditingController(text: materi.text);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Edit Materi"),
                      content: TextField(controller: controller),
                      actions: [
                        TextButton(
                          onPressed: () {
                            onEdit(i, controller.text);
                            Navigator.pop(context);
                          },
                          child: const Text("Simpan"),
                        )
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(i),
              ),
            ],
          ),
        );
      }),
    );
  }
}