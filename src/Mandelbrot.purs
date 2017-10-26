module Mandelbrot where

import Prelude

import Data.Complex (Complex, length, (^))
import Data.Maybe (Maybe(..))

maxCount :: Int
maxCount = 200

mandelbrot :: Complex -> Complex -> Complex
mandelbrot c x = x^2 + c

nth :: forall a. (a -> a) -> Int -> (a -> a)
nth f 0 = id
nth f n = f <<< nth f (n - 1)

infixr 9 nth as ^^

nthList :: forall a. (a -> a) -> Int -> a -> Array a
nthList f 0 = \ a -> [a]
nthList f n = \ a -> nthList f (n - 1) a <> [f ^^ n $ a]

diverges :: Complex -> Maybe Int
diverges = div' 0 zero where
  div' count curr z
    | count >= maxCount = Nothing
    | length z <= 2.0 && length (mandelbrot z curr) >= 2.0 = Just (count + 1)
    | otherwise = div' (count + 1) (mandelbrot z curr) z