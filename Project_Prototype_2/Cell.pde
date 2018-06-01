/**Cell class
* Each cell has values to represent it's x and y location, as well as it's current state and new state for the next generation
**/
public class Cell{
  int x, y; //x and y location of the cell
  int state; //state of the cell
  int newState;
  final int cellSize = CELL_SIZE; //size of the cell, this value never changes
  
  public Cell (int x, int y, int state, int newState){ //constructor
    this.x = x;
    this.y = y;
    this.state = state;
    this.newState = newState;
  }
  
  public void display(){
    fill(255 * state); //fill based on the state
    rect(x * cellSize, y * cellSize, cellSize, cellSize); //draw the cell
  }
}