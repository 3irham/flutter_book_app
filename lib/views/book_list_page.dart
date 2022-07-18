import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_book_app/models/book_list_response.dart';
import 'package:http/http.dart' as http;

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListResponse? bookList;

  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        final jsonBookList = jsonDecode(response.body);
        bookList = BookListResponse.fromJson(jsonBookList);
      });
    }

    // print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Catalogue'),
        centerTitle: true,
      ),
      body: Container(
        child: bookList == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookList!.books!.length,
                itemBuilder: ((context, index) {
                  final currentBook = bookList!.books![index];
                  return Row(
                    children: [
                      Image.network(
                        currentBook.image!,
                        height: 100,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentBook.title!,
                                textAlign: TextAlign.left,
                              ),
                              Text(currentBook.subtitle!),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(currentBook.price!)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
      ),
    );
  }
}
