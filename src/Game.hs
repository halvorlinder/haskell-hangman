{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Used otherwise as a pattern" #-}
module Game (game, Gamestate (..)) where

import Data.List (nub, sort)

game :: Gamestate -> IO ()
game state = do
  print state
  let res = getResult state
  case res of
    Ongoing -> do
      g <- getGuess
      game $ guess g state
    _ -> do
      print res

getGuess :: IO Char
getGuess = do
  putStrLn "Guess a single letter: "
  l <- getLine
  if length l <= 2 && length l > 0
    then return (head l)
    else do
      putStrLn "Invalid guess!"
      getGuess

data Gamestate = Gamestate {solution :: String, guesses :: Int, allowed :: Int, guessed :: [Char]}

instance Show Gamestate where
  show Gamestate {..} = "\nMystery word: " ++ map (\c -> if c `elem` guessed then c else '*') solution ++ "\n" ++ show guesses ++ "/" ++ show allowed ++ " guesses used."

data Result = Ongoing | Win | Loss

instance Show Result where 
    show Win = "Congratulations, you won the game!"
    show Loss = "You lost the game."
    show Ongoing = "The game is ongoing"

guess :: Char -> Gamestate -> Gamestate
guess g Gamestate {..} = Gamestate solution (guesses + 1) allowed (nub (g : guessed))

getResult :: Gamestate -> Result
getResult Gamestate {..}
  | filter ( `elem` guessed ) solution == solution = Win
  | guesses < allowed = Ongoing
  | otherwise = Loss