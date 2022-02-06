module Forth

import public Control.Monad.State
import Data.List
import Data.String

public export
data Expr : Type where
  Val : Int -> Expr
  BinOp : String -> (Int -> Int -> Int) -> Expr

export
Show Expr where
  show (Val x) = show x
  show (BinOp s _) = "BinOp " <+> s


public export
Stack : Type
Stack = List Int

public export
Eval : Type -> Type
Eval = StateT Stack Maybe

peek : Eval Int
peek = gets List.head' >>= maybe empty pure

pop : Eval Int
pop = do
  get >>= \case
    [] => empty
    (x :: xs) => do
      put xs
      pure x

export
push : Expr -> Eval ()
push (Val x) = modify (x ::)
push (BinOp _ f) = flip f <$> pop <*> pop >>= push . Val

export
eval : Eval a -> Maybe Int
eval e = evalStateT [] $ e *> peek

export
parse : String -> Either String (List Expr)
parse str =
  traverse toExpr $ String.words str
  where
    toExpr : String -> Either String Expr
    toExpr s@"+" = pure $ BinOp s (+)
    toExpr s@"-" = pure $ BinOp s (-)
    toExpr s@"*" = pure $ BinOp s (*)
    toExpr s@"/" = pure $ BinOp s div
    toExpr s = case String.parseInteger s of
      Nothing => Left $ "Bad token: " <+> s
      Just i => pure $ Val i

export
run : String -> Either String Int
run str = do
  exprs <- parse str
  case eval $ traverse_ push exprs of
    Nothing => Left "Bad expression"
    Just i => pure i

