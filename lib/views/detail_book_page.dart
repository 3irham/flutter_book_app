import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_book_app/models/book_detail_response.dart';
import 'package:flutter_book_app/views/image_view_screen.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;

  fetchDetailBookApi() async {
    print('response: ${widget.isbn}');
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // print(await http.read(Uri.parse('https://example.com/foobar.txt')));

    if (response.statusCode == 200) {
      setState(() {
        final jsonDetail = jsonDecode(response.body);
        detailBook = BookDetailResponse.fromJson(jsonDetail);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: detailBook == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewScreen(
                              imageUrl: detailBook!.image!,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        detailBook!.image!,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(detailBook!.title!),
                    ),
                  ],
                ),
                Text(detailBook!.subtitle!),
                Text(detailBook!.price!),
                // isbn10
                Text(detailBook!.isbn10!),
                // isbn13
                Text(detailBook!.isbn13!),
                // pages
                Text(detailBook!.pages!.toString()),
                // authors
                Text(detailBook!.authors!),
                // publisher
                Text(detailBook!.publisher!),
                // desc
                Text(detailBook!.desc!),
                // rating
                Text(detailBook!.rating!.toString()),
              ],
            ),
    );
  }
}
