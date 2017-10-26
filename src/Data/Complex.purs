module Data.Complex where

import Prelude

import Math as Math

infixr 8 Math.pow as **

data Complex = Complex Number Number

infixl 6 Complex as :+:

derive instance eqComplex :: Eq Complex

instance showComplex :: Show Complex where
  show (Complex x y) = "(Complex " <> show x <> " " <> show y <> ")"

real :: Complex -> Number
real (Complex x _) = x

imaginary :: Complex -> Number
imaginary (Complex _ y) = y

injReal :: Number -> Complex
injReal x = Complex x 0.0

injImaginary :: Number -> Complex
injImaginary y = Complex 0.0 y

addComplex :: Complex -> Complex -> Complex
addComplex (Complex x1 y1) (Complex x2 y2) = Complex (x1 + x2) (y1 + y2)

mulComplex :: Complex -> Complex -> Complex
mulComplex (Complex x1 y1) (Complex x2 y2) = Complex x' y' where
  x' = x1*x2 - y1*y2
  y' = x1*y2 + y1*x2

i :: Complex
i = Complex 0.0 1.0

length :: Complex -> Number
length (Complex x y) = Math.sqrt (x ** 2.0 + y ** 2.0)

pow :: Complex -> Int -> Complex
pow z p = case p of
  0 -> one
  n -> z * z^(p - 1)

infixr 8 pow as ^

toPoint :: Complex -> {x :: Number, y :: Number}
toPoint (Complex x y) = {x, y}

fromPoint :: {x :: Number, y :: Number} -> Complex
fromPoint {x, y} = Complex x y

instance semiringComplex :: Semiring Complex where
  zero = injReal 0.0
  one = injReal 1.0
  mul = mulComplex
  add = addComplex

instance ringComplex :: Ring Complex where
  sub z (Complex x2 y2) = z + Complex (negate x2) (negate y2)