/**
 * DataLoader class
 * created by Alexander Keidel, 22397868 on 10.12.2016
 * last edited 16.12.2016
 */
class DataLoader {
  String[] lines; //holds all lines of the file
  int[] integers; //generate a value for each cell
  float average = 0.0f; //average of the read values
  public DataLoader(String filePath) {
    println("DataLoder constructor filePath = " + filePath);
    lines = loadStrings(filePath);
    println("lines.length = " + lines.length);
    println("cells.length = " + cells.length);
    integers = new int[cells.length * cells.length];
    println("integers.length = " + integers.length);
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
    String neededLines = "";
    for (int i = 0; i < lines.length; i++) { //for each line in lines
      neededLines += lines[0];
      if (neededLines.length() >= integers.length) { //if we have enough lines break the loop
        break;
      }
    }
    try { //if there are not enough lines the the exception will be caught
      for (int i = 0; i < integers.length; i++) {
        integers[i] = neededLines.charAt(i);
        println("integers[" + i + "] = " + integers[i]);
        average += integers[i]; //add all values to the average
      }
    } 
    catch (Exception ex) {
    }
    average = average / integers.length; //calculate the average
    println("average = " + average);
  }
}