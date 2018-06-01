/**
 * DataLoader class
 * created by Alexander Keidel, 22397868 on 10.12.2016
 * last edited 10.12.2016
 */
class DataLoader {
  String[] lines; //holds all lines of the file
  int[] integers = new int[100];
  public DataLoader(String filePath) {
    lines = loadStrings(filePath);
    convertStringsToIntegers();
  }

  public void printAllLines() {
    for (String l : lines) {
      println(l);
    }
    println("total line count: " + lines.length);
  }

  /**convert the strings to integers to be used by the audio generation algorithm
   * see https://processing.org/reference/char.html
   * and https://processing.org/reference/int.html
   * chars are 2 bytes or 16 bits
   * ints are 4 bytes or 32 bits
   */
  private void convertStringsToIntegers() {
    String neededLines = lines[0];
    for(int i = 0; i < integers.length; i++){
      integers[i] = neededLines.charAt(i);
      println("integers[" + i + "] = " + integers[i]);
    }
  }
}