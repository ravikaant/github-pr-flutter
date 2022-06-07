import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github/components/chat.dart';
import 'package:github/components/prList.dart';
import 'package:github/model/prModel.dart';
import 'package:http/http.dart' as http;

void topFetchPRs({required int page, required Function onDataLoad}) async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/torvalds/linux/pulls?per_page=10&page=$page'));
  final List<PRModel> newPrs = await compute(topParsePRs, response.body);
  onDataLoad(newPrs);
}

List<PRModel> topParsePRs(String responseBody) {
  final parsedRes = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsedRes.map<PRModel>((json) => PRModel.fromJSON(json)).toList();
}

class PullRequests extends StatefulWidget {
  const PullRequests({Key? key}) : super(key: key);

  @override
  _PullRequestsState createState() => _PullRequestsState();
}

class _PullRequestsState extends State<PullRequests> {
  late final pullRequests = <PRModel>[];
  int _page = 0;
  bool _isLoading = false;
  bool _darkTheme = false;
  late BuildContext scaffoldContext;

  void toggleTheme() => setState(() {
        _darkTheme = !_darkTheme;
      });

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void onDataLoad(List<PRModel> newPrs) {
    setState(() {
      _isLoading = false;
      _page++;
      pullRequests.addAll(newPrs);
    });
  }

  void fetchData() {
    setState(() {
      _isLoading = true;
    });
    topFetchPRs(page: _page, onDataLoad: onDataLoad);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github PRs',
      debugShowCheckedModeBanner: false,
      theme: _darkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Github PRs'),
            actions: [
              IconButton(
                  onPressed: toggleTheme,
                  icon: const Icon(Icons.nightlight_round)),
              IconButton(
                onPressed: () {
                  print('button clicked: $context');
                  Navigator.of(scaffoldContext).push(
                      MaterialPageRoute(builder: (context) => const ChatApp()));
                },
                icon: const Icon(Icons.message_rounded),
                tooltip: 'Chat For Free',
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              scaffoldContext = context;
              return Column(children: [
                PRList(
                  prList: pullRequests,
                  onLoadMore: fetchData,
                  isLoading: _isLoading,
                )
              ]);
            },
          )),
    );
  }
}

/*
FutureBuilder<List<PRModel>>(
            future: topFetchPRs(page: _page, onDataLoad: onDataLoad),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                //onDataLoad(snapshot.data!);
                return Column(children: [
                  PRList(
                    prList: snapshot.data!,
                    onLoadMore: fetchPRs,
                    isLoading: _isLoading,
                  )
                ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
Column(children: [
          PRList(
            prList: pullRequests,
            onLoadMore: fetchPRs,
            isLoading: _isLoading,
          )
        ]));

*/
