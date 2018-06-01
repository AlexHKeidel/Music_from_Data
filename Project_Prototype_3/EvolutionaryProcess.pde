/**
 * Custom EvolutionaryProcess class
 * It takes values for the defined target value (String), the population and mutation rate (float representing %)
 * Created by Alexander Keidel, 22397868 on 19.12.2016
 * last edited 19.12.2016
 **/

public class EvolutionaryProcess {
  //DataLoader dataloader; //custom data loader class to load the dataset into the program
  ArrayList<DNA> elements; //array list of dna elements (parents)
  String targetValue; //the target value for all DNA elements
  int population; //size of the population to calculate
  float mutationRate; //the % rate of mutation
  public int generation = 0; //number of generations iterated through
  public float bestFitnessScore = 0; //best fitness score within all elements
  public DNA bestElement = new DNA(""); //the DNA of the best element
  public EvolutionaryProcess(String targetValue, int population, float mutationRate) {
    //dataloader = new DataLoader("2016-04-lancashire-street.csv");
    elements = new ArrayList<DNA>(); //init elements
    this.targetValue = targetValue;
    this.population = population;
    this.mutationRate = mutationRate;
    createPopulation();
  }

  /**
   * create the initial population for the evolutionary process
   **/
  private void createPopulation() {
    //println("Starting to create initial population");
    for (int i = 0; i < population; i++) {
      String randomString = "";
      for (int s = 0; s < targetValue.length(); s++) { //for each character in the target value generate a random character for the DNA object
        randomString += (char) random(33, 127);
      }
      //println("adding element with " + randomString);
      elements.add(new DNA(randomString)); //add the new element to the array list
    }

    for (DNA element : elements) { //for each DNA object in the elements list
      element.fitnessFunction(targetValue); //calculate the fitness
    }
  }

  /**
   * Generate a new population based on each of the elements fitness score and mutation
   * Thus implementing heredity, variation, and selection.
   **/
  public void generateNewPopulation() {
    if (bestElement.geneticInformation.equals(target)) { //result has been found
      return; //return
    }
    generation++; //increment generation counter
    //println("Generating new population #" + generation);
    ArrayList<DNA> newPopulation = new ArrayList<DNA>();
    ArrayList<DNA> fitnessPopulationDistributor = new ArrayList<DNA>();
    for (int i = 0; i < population; i++) { //for each member of the population
      //println("elements.get(i).fitness = " + elements.get(i).fitness);
      for (int j = 0; j < 1 + (int) (elements.get(i).fitness * 100); j++) { //for the element's fitness times 100 plus one (in case fitness = 0)
        fitnessPopulationDistributor.add(elements.get(i)); //add the element that many times to the list
      }
    }
    //println("population = " + population);
    //println("fitnessPopulationDistributor.size() = " + fitnessPopulationDistributor.size());
    for (int i = 0; i < population; i++) { //for each member of the population
      //pick two parents, mix the DNA up and apply mutation
      DNA parent1 = fitnessPopulationDistributor.get((int) random(fitnessPopulationDistributor.size() - 1)); //pick a random first parent
      DNA parent2 = fitnessPopulationDistributor.get((int) random(fitnessPopulationDistributor.size() - 1)); //pick a random second parent

      String childDNA = "";
      for (int j = 0; j < parent1.geneticInformation.length(); j++) {
        if (random(0, 2) <= mutationRate) { //mutation!
          //println("mutating element");
          childDNA += (char) random(32, 127); //random character!
          continue; //continue the loop and go to the next character
        }
        if (parent1.geneticInformation.charAt(j) == target.charAt(j)) { //correct value from the paret found
          childDNA += parent1.geneticInformation.charAt(j);
          continue;
        } else if (parent2.geneticInformation.charAt(j) == target.charAt(j)) { //correct value is in parent 2
          childDNA += parent2.geneticInformation.charAt(j);
          continue;
        }
        if (random(0, 1) > 0.5) { //50% chance since neither has got the right character
          childDNA += parent1.geneticInformation.charAt(j); //get the information from parent one
        } else {
          childDNA += parent2.geneticInformation.charAt(j); //get the information from parent two
        }
      }
      //println("childDNA = " + childDNA);
      newPopulation.add(new DNA(childDNA));
    }
    //println("replacing elements with the new generation");
    elements = newPopulation; //replace the list of elements with the newly generated population
    calculateFitnessScores(); //calculate the fitness score for all elements
  }

  /**
   * calculate all fitness scores of all elements
   **/
  private void calculateFitnessScores() {
    //println("calculating fitness scores of all elements of generation " + generation);
    for (int i = 0; i < elements.size(); i++) { //for each element
      elements.get(i).fitnessFunction(targetValue); //calculate the fitness
      //println(elements.get(i).geneticInformation);
      if (elements.get(i).fitness >= bestFitnessScore) { //if it is greater than the current best fitness 
        bestFitnessScore = elements.get(i).fitness; //set new best fitness score
        bestElement = elements.get(i);
      }
    }
  }
}