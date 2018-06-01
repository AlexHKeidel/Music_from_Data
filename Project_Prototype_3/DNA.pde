/**
 * Custom DNA class used by the genetic algorithm
 * Created by Alexander Keidel, 22397868 on 19.12.2016
 * last edited 19.12.2016
 **/

public class DNA {
  float fitness; //fitness value from 0.0 to 1.0 (representing percentage)
  public String geneticInformation; //the genetic information it holds
  public DNA(String information) { //constructor
    geneticInformation = information;
  }

  /**
   * Calculate the fitness of the DNA object based on the passed string compared to the genetic information it holds
   **/
  public void fitnessFunction(String targetInfo) {
    int correctness = 0;
    for (int i = 0; i < targetInfo.length(); i++) { //for each character in the targetInfo
      if (targetInfo.charAt(i) == geneticInformation.charAt(i)) { //correct character in the right place
        //println("found correct character");
        correctness++; //increment correctness
      }
    }
    fitness = (float) correctness / targetInfo.length(); //make the fitness the percentage of how correct it is
    //println("fitness = " + fitness);
  }
}