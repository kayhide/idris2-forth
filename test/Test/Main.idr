module Test.Main

import Forth
import Data.List
import System


assertEq : Eq a => Show a => a -> a -> Either String ()
assertEq x y = when (x /= y) $ do
  Left $ "Failed: " <+> show x <+> " == " <+> show y

tests_eval : List (Either String ())
tests_eval =
  [ assertEq "3" (show $ Val 3)
  , assertEq (Just 8) $ eval $ do
      push $ Val 3
      push $ Val 5
      push $ BinOp "+" (+)
  , assertEq Nothing $ eval $ do
      push (Val 3)
      push (BinOp "+" (+))
  ]

tests_parse : List (Either String ())
tests_parse =
  [ assertEq (Right [Val 3, Val 4, BinOp "+" (+)]) $ parse "3 4 +"
  , assertEq (Left "Bad token: hoge") $ parse "hoge"
  ]

tests_run : List (Either String ())
tests_run =
  [ assertEq (Right 7) $ run "3 4 +"
  , assertEq (Right 17) $ run "3 4 + 10 +"
  , assertEq (Right 8) $ run "3 4 + 10 + 2 /"
  , assertEq (Left "Bad expression") $ run "3 4 + 10 + 2 / +"
  ]

tests : List (Either String ())
tests = concat
  [ tests_eval
  , tests_parse
  , tests_run
  ]

main : IO ()
main = do
  let fails = List.catMaybes $ either Just (const Nothing) <$> tests

  when (null fails) $ do
    putStrLn "OK"
    System.exitSuccess

  putStrLn "Failed..."
  traverse_ putStrLn fails
  System.exitFailure
