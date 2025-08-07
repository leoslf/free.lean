# Free Monad

A Lean 4 implementation of the Church‑encoded Free Monad for effectful computations over any functor f.

## Overview

This library provides a compact, Church‑encoded representation of the Free monad using continuations.

It supports:

- Functor, Applicative, and Monad instances

- Two iteration modes:

  - iter for pure interpretation (f a -> a)

  - iterM for effectful interpretation into any Monad m

This implementation works around Lean’s strict‑positivity restrictions via Church-encoding / CPS of free monad instead of using an inductive free type.

