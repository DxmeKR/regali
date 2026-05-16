import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/prodotto.dart';

class CaroselloFoto extends StatefulWidget {
  final Prodotto prodotto;
  const CaroselloFoto({super.key, required this.prodotto});

  @override
  State<CaroselloFoto> createState() => _CaroselloFotoState();
}

class _CaroselloFotoState extends State<CaroselloFoto> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: (widget.prodotto.immagineUrl ?? []).map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),

        // 🔵 Indicatori (pallini)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (widget.prodotto.immagineUrl ?? []).asMap().entries.map((
              entry,
            ) {
              return Container(
                width: _currentIndex == entry.key ? 10 : 6,
                height: _currentIndex == entry.key ? 10 : 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.black
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
