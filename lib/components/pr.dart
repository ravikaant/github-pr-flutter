import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:github/model/prModel.dart';
import 'package:url_launcher/url_launcher.dart';

class PR extends StatelessWidget {
  final PRModel pr;
  const PR({required this.pr, Key? key}) : super(key: key);

  void _openUrl(String prUrl) async {
    try {
      await launch(prUrl);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(pr.user.avatarUrl)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text(
                        '#${pr.prNumber} ${pr.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onTap: () => _openUrl(pr.htmlUrl),
                    ),
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                          const TextSpan(text: 'by: '),
                          TextSpan(
                              text: pr.user.login,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _openUrl(pr.user.htmlUrl)),
                        ])),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
