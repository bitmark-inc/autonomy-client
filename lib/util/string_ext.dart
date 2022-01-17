extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String mask(int number) {
  return "[${this.substring(0, number)}...${this.substring(this.length - number, this.length)}]";
  }
}