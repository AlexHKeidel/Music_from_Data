# Music_from_Data
This project uses a publically available anonymised data set. You can replace the data with any other csv file for different results.

The three examples use three different concepts to generate "Music" from the input data file:
* Random vs Perlin noise vs DataSet
* Conway's Game of Life [Wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
* Genetic / Evolutionary Algorithm


In the game of life example we measure the amount of alive vs dead cells and change the pitch of the sound. The initial state of the game is determined by the input read from the CSV file. In the given example the game reaches an equilibrium (an infintely repeating pattern).

The evolutionary algorithm changes the pitch based on the currently best representing match for the given data string read from the CSV file.
You can play around with the different values such as size of the population and mutation rate to get different results. The default parameters are chosen to show the audio change over a time-frame that shows the change (not too fast, but not too slow either)

## Installation
Install [Processing](https://processing.org/)

## Running the Program
Just execute the scripts in your Processing IDE. In some cases you can change some variables at the top of the code for different results.

You can change the input data by providing your own CSV file and changing the variable for the data loader class.
