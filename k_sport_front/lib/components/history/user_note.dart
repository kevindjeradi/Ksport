import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/helpers/logger.dart';

class UserNote extends StatefulWidget {
  final String initialNote;
  final Function(String) onSave;
  final int maxNoteLength;
  final TextInputType keyboardType;

  const UserNote({
    Key? key,
    required this.initialNote,
    required this.onSave,
    this.maxNoteLength = 300,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  @override
  State<UserNote> createState() => _UserNoteState();
}

class _UserNoteState extends State<UserNote> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Log.logger.i("initialNote: ${widget.initialNote}");
    _controller.text = widget.initialNote;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color noteBackgroundColor = theme.colorScheme.background;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: noteBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Text(
              'Ajouter une note',
              style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground),
            ),
          ),
          TextField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            maxLines: null,
            maxLength: widget.maxNoteLength,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              fillColor: noteBackgroundColor,
              filled: true,
              border: InputBorder.none,
              counterText: '${_controller.text.length}/${widget.maxNoteLength}',
            ),
            style: TextStyle(
              color: theme.colorScheme.onBackground,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _controller.text.isEmpty
                    ? null
                    : () {
                        widget.onSave(_controller.text);
                        showCustomSnackBar(
                            context, "Note mise à jour", SnackBarType.success);
                      },
                mini: true,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.check),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
