import 'package:flutter/material.dart';
import 'package:staffapp/constants/styles.dart';

class TagRow extends StatelessWidget {
  final List<String> tags;
  const TagRow({Key key, this.tags = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tags.length > 1
        ? Row(
            children: [
              _tag(tags[0]),
              Icon(
                Icons.arrow_right_alt_sharp,
                size: 16,
                color: Color(0XFF6A7178),
              ),
              ...tags.skip(1).map((e) => _tag(e)),
            ],
          )
        : tags.length == 1 && tags.first.isNotEmpty
            ? _tag(tags[0])
            : Container();
  }

  Widget _tag(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
        child: Text(text,
            style: roboto(
                size: 12,
                fontWeight: FontWeight.w300,
                color: Color(0XFF6A7178))),
      ),
    );
  }
}
