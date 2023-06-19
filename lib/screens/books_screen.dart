import 'package:flutter/material.dart';
import 'package:seventy_five_hard/models/book_model.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  bool booksLoading = true;
  List<BookModel> books = [];

  @override
  void initState() {
    super.initState();
    _getBooks();
  }

  _getBooks() async {
    APIServices apiServices = APIServices.instance;
    books = await apiServices.fetchBooks();
    setState(() {
      booksLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Books",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: booksLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xB6626262),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          leading: Image.network(
                              books[index].imageLinks!.smallThumbnail!),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(books[index].title!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                          ),
                          subtitle: books[index].authors!.isNotEmpty
                              ? Text(
                                  books[index].authors!.join(", "),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                )
                              : const SizedBox()),
                      books[index].description != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(books[index].description!.toString()),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              }),
    );
  }
}
