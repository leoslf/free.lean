/-- Church-encoded Free monad for a functor `f` -/
structure Free (f : Type u -> Type v) (a : Type u) where
  mk ::
  /--
  `run` takes two continuations:
  * one to handle a pure value (`a -> r`)
  * one to handle an effectful layer (`f r -> r`)
  -/
  run : (a -> r) -> (f r -> r) -> r

-- Allow `f` and `a` to be implicit for subsequent definitions
variable {f : Type u -> Type v}
variable {a : Type u}

/-- Interpret the free monad using a *pure* algebra `ϕ : f a -> a` -/
def Free.iter (ϕ : f a -> a) (self : Free f a) : a :=
  self.run id ϕ

/-- Interpret the free monad into a monad `m`, using an *effectful* algebra `ϕ : f (m a) → m a` -/
def Free.iterM [Monad m] (ϕ : f (m a) -> m a) (self : Free f a) : m a :=
  self.run pure ϕ

instance : Functor (Free f) where
  map
  | f, ⟨g⟩ =>
    Free.mk λpure => g $ pure ∘ f

instance : Applicative (Free f) where
  pure a := Free.mk λpure _ => pure a
  seq f g :=
    match f, g () with
    | ⟨f⟩, ⟨g⟩ => Free.mk λpure free =>
      f (λa => g (pure ∘ a) free) free

instance : Monad (Free f) where
  bind
  | ⟨m⟩, f => Free.mk λpure free =>
    m (λa => f a |>.run pure free) free

