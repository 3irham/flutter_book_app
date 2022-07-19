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
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          height: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detailBook!.title!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              detailBook!.authors!,
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              detailBook!.subtitle!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              detailBook!.price!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Buy'),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(detailBook!.desc!),
                      // Text(detailBook!.isbn10!),
                      // Text(detailBook!.isbn13!),
                      Text(detailBook!.publisher!),
                      Text(detailBook!.pages!.toString()),
                      // Text(detailBook!.rating!.toString()),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
