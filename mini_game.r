## Just quick mini games I've created. Enjoy it.

# Mini Game 1: Star Wars Chatbot
## If you ask me Harry Potter or Star Wars, what do I prefer, then I'd totally go for Star Wars!

starwars_bot <- function() {
  you_are = readline("Who are you? ")
  print(paste("I am", you_are , ", a Jedi master."))
  ask_1 = readline("How did you survive the order 66? ")
  print(paste(ask_1))
}

## How to play?
  ## 1. First, you typed this to start the bot.
      starwars_bot()
  ## 2. There'll be a question asked "Who you are?" and you can simply type your name in a console.
      Goku
  ## 3. Then, the next reply from bot will ask how did you survive the order 66? And you can simply write anything in your mind.
      I transformed into Super Saiyan 3 and killed all storm troopers.
  ## That's the end.


# Mini Game 2: Pokemon Power!
## Just a simple mini game where you and bot choose a power of the 3 components: fire, water, and leaf.

pokemon_power <- function() {
  
  choices <- c("Fireball!", "Water Gun!", "Razor Leaf!")
  print(choices)
  
  choose_power = readline("Choose your power! = ")
  
  if (!(choose_power %in% choices)) {
    cat(paste("Error: object '", choose_power, "' not found\n", sep = ""))
    cat("Please type your attack correctly from these 3 choices\n")
    cat("  1. Fireball!\n  2. Water Gun!\n  3. Razor Leaf!\n\n")
    return(pokemon_power())
  }
  
  bot_selection <- sample(choices, 1)
  print( paste("Bot selects", bot_selection))
  
  ifelse (choose_power == bot_selection, "Try Again!", 
  ifelse (choose_power == "Fireball!" & bot_selection == "Razor Leaf!", "Congratulations, you win!", 
  ifelse (choose_power == "Fireball!" & bot_selection == "Water Gun!", "You lose...", 
  ifelse (choose_power == "Water Gun!" & bot_selection == "Fireball!", "Congratulations, you win!",
  ifelse (choose_power == "Water Gun!" & bot_selection == "Razor Leaf!", "You lose...",
  ifelse (choose_power == "Razor Leaf!" & bot_selection == "Water Gun!", "Congratulations, you win!",
  ifelse (choose_power == "Razor Leaf!" & bot_selection == "Fireball!", "You lose...",)))))))
}

pokemon_power()

## How to play?
    ## 1. After running the codes, you can simply use... the below code to start the game.
        pokemon_power()
    ## 2. In the console tab, there'll be a message show up
        ## [1] "Fireball!"   "Water Gun!"  "Razor Leaf!"
        ## Choose your power! = 
    ## 3. Then, you must type exactly what is in the double quotation marks to continue the game.
        watergun
        ## If you type incorrectly, it will show error like this "Error: object 'watergun' not found" and the warning will show you to type.
        ## And the choices will appear again for you to choose.
    ## 4. If you type correctly, the game officially starts!
        ## 4.1 If both players choose the same attack, it’s a tie, and you need to rechoose the attack again.
        ## 4.2 If your attack beats the bot's, you win! Otherwise, you lose.
