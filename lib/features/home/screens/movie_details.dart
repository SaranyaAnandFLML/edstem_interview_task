import 'package:cached_network_image/cached_network_image.dart';
import 'package:edstem_interview/models/movies_model.dart';
import 'package:edstem_interview/pallette/pallette.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/common/global_variables.dart';

class MovieDetails extends StatelessWidget {
  final MoviesModel movie;
  const MovieDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: double.infinity,
                        height: h * 0.6,
                        color: Colors.grey[200],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: h * 0.6,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: w*0.025),


            // Extra Details: Rating, Language, Adult
            // Extra Details: Star Rating, Language, Adult
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style:  TextStyle(
                      color: Pallete.blackColor,
                      fontSize: w*0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    movie.releaseDate,
                    style:  TextStyle(
                      color: Pallete.greyColor[700],
                      fontSize: w*0.04
                    ),
                  ),
                  SizedBox(height: w*0.02),
                  Row(
                    children: [
                      // 5-Star Display
                      ...List.generate(5, (index) {
                        double rating = movie.voteAverage / 2;
                        if (rating >= index + 1) {
                          return  Icon(Icons.star, color: Colors.amber, size: w*0.05);
                        } else if (rating >= index + 0.5) {
                          return  Icon(Icons.star_half, color: Colors.amber, size: w*0.05);
                        } else {
                          return  Icon(Icons.star_border, color: Colors.amber, size: w*0.05);
                        }
                      }),
                      SizedBox(height: w*0.01),
                      Text(
                        "${movie.voteAverage.toStringAsFixed(1)} / 10",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: w*0.02),
                  Row(
                    children: [
                      const Icon(Icons.language, size: 20, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        movie.originalLanguage.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.warning, size: 20, color: Pallete.blackColor),
                      const SizedBox(width: 4),
                      Text(
                        movie.adult ? "18+" : "PG",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: movie.adult ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            SizedBox(height: w*0.02),

            // Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview,
                style:  TextStyle(fontSize: w*0.035, color: Colors.black87),
              ),
            ),

             SizedBox(height: w*0.03),
          ],
        ),
      ),
    );
  }
}
