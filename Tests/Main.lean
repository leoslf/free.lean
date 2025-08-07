import Free

open Free

inductive Expr (a : Type) : Type where
| increment : Nat -> (Nat -> a) -> Expr a

instance : Functor Expr where
  map f
  | Expr.increment n k => Expr.increment n (f ∘ k)

def Expr.run : Expr Nat -> Nat
| Expr.increment n k => k (n + 1)

def Expr.runM : Expr (IO Nat) -> IO Nat
| Expr.increment n k => do
  k =<< pure (n + 1)

def liftIncrement (n : Nat) : Free Expr Nat :=
  Free.mk λpure free => free $ Expr.increment n pure

def testIter : IO Unit := do
  let program : Free Expr Nat := do
    let x <- liftIncrement 1
    let y <- liftIncrement x
    pure y
  assert! program.iter Expr.run = 3 -- (1 + 1) + 1 = 3

def main : IO Unit := do
  testIter
