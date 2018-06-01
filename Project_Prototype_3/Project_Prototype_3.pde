import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/**
 * Prototype 3
 * Created by Alexander Keidel, 22397868 on 19.12.2016
 * last edited 19.12.2016
 * A genetic algorithm approach to generating music from the provided crime data
 **/
Minim minim;
AudioOutput out;
Oscil wave;
EvolutionaryProcess geneticAlgorithm;
DataLoader dl;
String target = "This is a genetic algorithm.";
final int population = 10;
final float mutationRate = 0.01;
final int howMuchData = 40;

void setup() {
  size(600, 400);
  dl = new DataLoader("2016-04-lancashire-street.csv");
  target = dl.getLines(howMuchData); //override the target from the crime data
  geneticAlgorithm = new EvolutionaryProcess(target, population, mutationRate);
  minim = new Minim(this); //setup Minim
  out = minim.getLineOut(); //set up the audio output object
  wave = new Oscil(440, 0.5f, Waves.SINE); //setup the oscillator
  wave.patch(out); //set up the wave object to the audio output object
}

void draw() {
  geneticAlgorithm.generateNewPopulation(); //generate a new population
  displayInformation();
  playSounds();
}

/**
 * Display all the importan information about the genetic algorithm on the screen
 **/
void displayInformation() {
  background(51); //set background
  fill(190); //set fill value
  textSize(20); //set font size
  text("target = " + target, 20, 20);
  text("population = " + population, 20, 40);
  text("mutation rate = " + mutationRate + "%", 20, 60);
  text("generation = " + geneticAlgorithm.generation, 20, 80);
  text("best element = " + geneticAlgorithm.bestElement.geneticInformation, 20, 100);
  text("best fitness score = " + geneticAlgorithm.bestElement.fitness, 20, 120);
}

void playSounds() {
  float amp = geneticAlgorithm.bestElement.fitness; //set up amplitude based on the fitness score of the best element
  float freq = amp; //the same for the frequency
  amp = map(amp, 0.0, 1.0, 5, 0); //map the value of the amplitude to values from 5.0 to 0.0 (initially from 1 to 0)
  freq = map(freq, 0.0, 1.0, 110, 880); //map the value of the frequency to values from 110 to 880 * 3(initially from 110 to 880)
  wave.setAmplitude(amp); //set the amplitude of the oscillator
  wave.setFrequency(freq); //set the frequency of the oscillator
}