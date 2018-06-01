/**
 * Prototype 1 by Alexander Keidel, 22397868
 * created on 10.12.2016
 * last edited on 10.12.2016
 * This sketch uses the Minim libraries for producing sound, see http://code.compartmental.net/minim/
 * Using either random numbers or perlin noise this sketch produces
 * pseudo-randomly generated sounds based off of all the possible combinations
 * of valid notes from A1 to G8, including sharps and minors
 * This version includes datasets instead of randomisation
 *
 */

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim; //Minim minim class
AudioOutput out; //Minim AudioOutput class
DataLoader dataloader; //custom data loader class
ArrayList<Integer> datasetNumbers = new ArrayList<Integer>(); //holds the numbers generated from the dataset
int tempo = 240;
ArrayList<CustomNote> notes;
ArrayList<String> validNotes; // = {"A3", "A4", "B3", "B4", "C3", "C4", "D3", "D4", "E3", "E4", "F3", "F4", "G3", "G4", "A3", "A4"};
char[] validBases = {'A', 'B', 'C', 'D', 'E', 'F', 'G'}; //valid bases for notes
int[] validOctaves = { 1, 2, 3, 4, 5, 6, 7, 8}; //valid octaves for notes
char[] validAdditions = {'#', 'b'}; //valid addition for notes
static final String RANDOM_MODE = "random";
static final String PERLIN_MODE = "perlin";
static final String DATASET_MODE = "dataset";
String currentMode = DATASET_MODE;
static final int NUMBER_OF_NOTES = 100; //this has to be one to update within draw!
static final int NUMBER_OF_SIMULTANIOUS_NOTES = 1;

void setup()
{
  size(500, 300, P3D);
  dataloader = new DataLoader("2016-04-lancashire-street.csv");
  //dataloader.printAllLines();
  generateAllPossibleNotes();
  //currentMode = PERLIN_MODE;
  currentMode = DATASET_MODE;
  generateNotes(currentMode, NUMBER_OF_NOTES, NUMBER_OF_SIMULTANIOUS_NOTES);
  minim = new Minim(this);

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();


  out.setTempo(tempo); //set tempo

  out.pauseNotes(); //pause all notes

  for (int i = 0; i < notes.size(); i++) { //add all notes to the out object to be played
    float start = notes.get(i).startTime; //get the start time
    float dur = notes.get(i).duration; //get the duration
    String note = notes.get(i).pitchName; //get the name of the note
    out.playNote(start, dur, note); //add the note to the out object
  }

  out.resumeNotes(); //play all notes
}

//endless draw loop
void draw()
{
  background(0); //set background to black
  stroke(255); //set stroke to white
  displayTempo(); //display the tempo in beats per minute (BPM)
  displayMode(); //diplay the mode of the program

  // draw the waveforms based on the buffersize of the out object
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
}

/**generate all possible notes ranging from A1 to G8 including all sharps and minors
 and putting them into the ArrayList of valid notes in order.
 There is an underlying problem with this: there are duplicates in this, 
 leading to higher occurences of notes that are the same, such as Fb being an E flat, 
 and E# being an F flat etc.
 */
void generateAllPossibleNotes() {
  validNotes = new ArrayList<String>();
  for (char base : validBases) {
    for (int octave : validOctaves) {
      validNotes.add("" + base + octave); //adding each base note, e.g. "A1"
      for (char addition : validAdditions) {
        validNotes.add("" + base + addition + octave); //add sharp and minor versions "A#1" and "Ab1"
      }
    }
  }
}

//generate the notes to be played by the AudioOutput "out"
//input value defines the mode, i.e. random or perlin noise
void generateNotes(String mode, int amount, int simultanious) {
  final float startingMax = 3.0;
  final float lengthMax = 3.0;
  notes = new ArrayList<CustomNote>();
  switch(mode) {
  case RANDOM_MODE: //use pseudo random number generation
    for (int i = 0; i < amount; i++) { //pick 100 random notes
      for (int j = 0; j < simultanious; j++) {
        String pickedNote = validNotes.get((int) random(validNotes.size())); //pick a random note out of the pool
        /*generate a new customNote with a random startTime plus i (so not all notes are played at the same time
         * with a random length of up to 9.
         */
        notes.add(new CustomNote(random(startingMax) + i, random(lengthMax), pickedNote));
      }
    }
    break;

  case PERLIN_MODE: //use perlin noise
    final float inc = 0.02;
    float offset = 0.0;
    for (int i = 0; i < amount; i++) { //pick based on perlin noise
      for (int j = 0; j < simultanious; j++) {
        float currentNoise = noise(offset + i + j);
        String pickedNote = validNotes.get((int) (currentNoise  * validNotes.size())); //pick note based on noise
        notes.add(new CustomNote(currentNoise * startingMax + i, currentNoise * lengthMax, pickedNote));
        offset += inc;
        //println("pickedNote = " + pickedNote + " currentNoise = " + currentNoise);
      }
    }
    break;
    
    case DATASET_MODE: //use the dataset
    int counter = 0;
      for(int i : dataloader.integers){ //for each generated integer
        String pickedNote = validNotes.get((int) map(i, 0, 126, 0, validNotes.size())); //map the generated values to the number of possible notes
        float pickedStart = map(i, 0, 126, 0.0, startingMax); //map to startingMax
        float pickedLength = map(i, 0, 126, 0.0, lengthMax); //map to lengthMax
        notes.add(new CustomNote(pickedStart + counter, pickedLength, pickedNote));
        counter++;
      }
    break;
  }
}

//display the BPM of the program on the screen
void displayTempo() {
  text("BPM: " + tempo, width - 100, height - 20);
}

//display the mode on the screen
void displayMode() {
  text("Mode: " + currentMode, width -100, height - 10);
}

//void keyPressed() {
//  println("key = " + key);
//  if (key == 'i' || key == 'I') {
//    tempo++;
//  } else if (key == 'k' || key == 'K') {
//    tempo--;
//  } else return; //no valid key pressed
//  out.setTempo(tempo);
//}