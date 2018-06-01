import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/**
 * Prototype 2
 * Cellular Automaton based on the Game of Life
 * This class takes the provided crime data and turns it into the seed for the implemented Game of Life.
 * It then uses the overall state of the game to produce an audible outcome based on a sine wave.
 * The frequency and amplitude of the sine wave are based on how many cells in the game are currently alive.
 * Created by Alexander Keidel, 22397868 on 16.12.2016
 * last edited 18.12.2016
 **/
public final int CELL_SIZE = 5; //define the size of each cell to be drawn on the canvas (rectangle)
DataLoader dataloader; //custom data loader class to load the crime data
Minim minim; //minim sound class
AudioOutput out; //audio output class 
Oscil wave; //oscillator class to generate sound waves
int time = 0; //time counter
Cell[][] cells; //two dimensional array of cells
//setup method is called once at the beginning of the program
void setup() {
  size(500, 500); //500 by 500 window, any size where x = y is supported
  background(51); //grey background
  frameRate(60); //set to 60 frames per second
  minim = new Minim(this); //setup Minim
  out = minim.getLineOut(); //set up the auido output object
  wave = new Oscil(440, 0.5f, Waves.SINE); //setup the wave object
  wave.patch(out); //set up the wave object to the out line

  //dataloader.convertStringsToIntegers(); //convert the read string values into integer values
  cells = new Cell[width / CELL_SIZE][height / CELL_SIZE]; //initialise array
  dataloader = new DataLoader("2016-04-lancashire-street.csv"); //load the file, make sure this is done after assigning the cells array as it is required!

  //generate random state (can be ussed instead of the crime data)
  int[] randomStates = new int[cells.length * cells.length]; 
  for (int i = 0; i < randomStates.length; i++) {
    //println("i = " + i);
    randomStates[i] = (int) random(2);
  }
  //setupStartingGeneration(randomStates); //random values, do not use
  setupStartingGeneration(dataloader.integers); //load the crime data as the seed
}

//draw is called after setup and loops forever (unless noLoop() has been specified)
void draw() {

  if (time % 20 == 0) { //set the speed of the game based on the fps
    background(51); //redraw the background
    drawAllCells(); //draw all the cells
    nextGeneration(); //generate the next generation
    playSounds(); //play the sound based on the state of the current generation
  }
  time++; //increment frame counter
}

//setup the starting generation based on the passed values, also referred to as the seed
void setupStartingGeneration(int[] states) {
  int stateCounter = 0;
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) {
      int state = 0; //initialise as dead state
      if (states[i] > 100) { //if our read value from the dataset is greater than it's average value dataloader.average
        state = 1; //make state alive
      }
      cells[i][j] = new Cell(i, j, 0, state);
      //println("i = " + i + " j = " + j + " stateCounter = " + stateCounter);
      stateCounter++;
    }
  }
}
/**
 Conway's Game of Life Rules
 Any live cell with fewer than two live neighbours dies (referred to as underpopulation or exposure).
 Any live cell with more than three live neighbours dies (referred to as overpopulation or overcrowding).
 Any live cell with two or three live neighbours lives, unchanged, to the next generation.
 Any dead cell with exactly three live neighbours will come to life.
 */
void nextGeneration() {
  //update the state of all cells including the boarder
  for (int i = 0; i < cells.length - 0; i++) {
    for (int j = 0; j < cells.length - 0; j++) {
      //apply the new State to all cells
      cells[i][j].state = cells[i][j].newState;
    }
  }
  int liveCounter = 0;
  //loop through all the cells, ignoring the border of the screen
  for (int i = 1; i < cells.length - 1; i++) {
    for (int j = 1; j < cells.length - 1; j++) {
      liveCounter = 0; //reset liveCounter
      liveCounter += cells[i - 1][j - 1].state + cells[i][j - 1].state + cells[i + 1][j - 1].state; //check top row
      liveCounter += cells[i - 1][j].state                             + cells[i + 1][j].state;//check middle row
      liveCounter += cells[i - 1][j + 1].state + cells[i][j + 1].state + cells[i + 1][j + 1].state;// check bottom row
      if (cells[i][j].state == 0) { //the cell is dead
        if (liveCounter == 3) cells[i][j].newState = 1; //Any dead cell with exactly three live neighbours will come to life.
      } else //the cell is alive
      {
        //Any live cell with fewer than two live neighbours dies (referred to as underpopulation or exposure).
        //Any live cell with more than three live neighbours dies (referred to as overpopulation or overcrowding).
        if (liveCounter < 2 || liveCounter > 3) {
          //println("cell[" + i + "][" + j + "].state = " + cells[i][j].state);
          cells[i][j].newState = 0; // kill the cell
        }
      }
    }
  }
}

/**
 * draw all the cells on to the screen
 */
void drawAllCells() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) {
      cells[i][j].display();
    }
  }
}

/**
 * Play all the sounds based on the current state of the game of life
 * The frequency and amplitude of the sine wave are based on how many cells are currently alive
 */
void playSounds() {
  float amp = 0; //amplitude value
  float freq = 0; //frequency value
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) {
      amp += cells[i][j].state;
      freq += cells[i][j].state;
    }
  }
  amp = map(amp, 0, cells.length * cells.length, 5, 0); //map the value of the amplitude to values from 5.0 to 0.0 (initially from 1 to 0)
  freq = map(freq, 0, cells.length * cells.length, 110, 880 * 3); //map the value of the frequency to values from 110 to 880 * 3(initially from 110 to 880)
  wave.setAmplitude(amp); //set the amplitude of the oscillator
  wave.setFrequency(freq); //set the frequency of the oscillator
}