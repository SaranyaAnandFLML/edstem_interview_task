import 'package:edstem_interview/core/common/error_text.dart';
import 'package:edstem_interview/core/common/loader.dart';
import 'package:edstem_interview/pallette/pallette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/global_variables.dart';
import '../controller/movies_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController=TextEditingController();
  final searchInputProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    h=MediaQuery.of(context).size.height;
    w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // taller AppBar
        child: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Movies',
                    style: TextStyle(
                      fontSize: w*0.05,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child:  Row(
                      children: [
                        Icon(Icons.search, color: Pallete.greyColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              return  TextField(
                                controller: searchController,
                                onChanged: (value) => ref.read(searchInputProvider.notifier).state = value,
                                decoration: InputDecoration(
                                  hintText: 'Search your collection',
                                  border: InputBorder.none,
                                ),
                              );
                            },

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final search = ref.watch(searchInputProvider);
          final data = ref.watch(getMoviesProvider(search));

          return data.when(
            data: (objects) {
              return objects.isEmpty
                  ? const Center(child: Text('NO DATA FOUND'))
                  : ListView.builder(
                itemCount: objects.length,
                itemBuilder: (context, index) {
                  final movie = objects[index];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Pallete.greyColor.shade300),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Poster
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                            width: 70,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(width: 70, height: 100, color: Pallete.greyColor[300]),
                          ),
                        ),
                        SizedBox(width: 12),

                        // Movie Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                movie.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4),

                              // Release Date
                              Text(
                                'Release: ${movie.releaseDate}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Pallete.greyColor[600],
                                ),
                              ),

                              SizedBox(height: 4),

                              // Language + Votes
                              Text(
                                'Language: ${movie.originalLanguage.toUpperCase()} • Votes: ${movie.voteCount.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 13, color: Pallete.greyColor[700]),
                              ),

                              SizedBox(height: 6),

                              // Star Rating
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < (movie.voteAverage / 2).round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Pallete.orangeColor,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

            },
            error: (error, stack) {
              print(error);
              return ErrorText(error: error.toString());
            },
            loading: () {
              return Loader();
            },
          );
        },
      ),


    );
  }
}
