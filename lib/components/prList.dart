import 'package:flutter/material.dart';
import 'package:github/components/pr.dart';
import 'package:github/model/prModel.dart';

class PRList extends StatelessWidget {
  final List<PRModel> prList;
  final Function onLoadMore;
  final bool isLoading;

  const PRList(
      {required this.prList,
      required this.onLoadMore,
      required this.isLoading,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemBuilder: (context, index) => Column(children: [
          PR(pr: prList[index]),
          if (index == prList.length - 1)
            isLoading
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: const CircularProgressIndicator())
                : SizedBox(
                    height: 50,
                    child: TextButton(
                        onPressed: () => onLoadMore(), child: const Text('Load More')))
        ]),
        itemCount: prList.length,
      ),
    );
  }
}
