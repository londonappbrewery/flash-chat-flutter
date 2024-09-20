import 'dart:math';

int randomNumberGenerator() {
  return Random().nextInt(1000);
}

String randomImageUrl() {
  final int randomNumber = randomNumberGenerator();
  return 'https://picsum.photos/seed/$randomNumber/200/300';
}
