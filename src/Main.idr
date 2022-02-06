module Main

import Forth

main : IO ()
main = do
  printLn $ Val 3
  printLn $ eval $ do
    push $ Val 3
    push $ Val 5
    push $ BinOp "+" (+)

  printLn $ eval $ do
    push (Val 3)
    push (BinOp "+" (+))

  printLn $ run "3 4 + 10 + 2 /"
  printLn $ parse "3 4 + 10 + 2 /"
  printLn $ run "3 4ho + +"

  putStrLn "OK"
