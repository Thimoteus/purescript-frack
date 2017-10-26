module Main where

import Prelude

import Canvas.Util (ColorChange, mutateData)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION, error, throwException)
import Data.Complex (fromPoint)
import Data.Int (round, toNumber)
import Data.Maybe (Maybe(..), fromMaybe)
import Graphics.Canvas (CANVAS, getCanvasElementById, getContext2D, getImageData, putImageData, setCanvasDimensions)
import Mandelbrot (diverges, maxCount)

minX :: Number
minX = -2.5

maxX :: Number
maxX = 1.0

minY :: Number
minY = -1.0

maxY :: Number
maxY = 1.0

dx :: Number
dx = 0.01

dy :: Number
dy = 0.01

width :: Int
width = round (maxX - minX) * 200

height :: Int
height = round (maxY - minY) * 200

scaleFactor :: Number
scaleFactor = 2550.0 / toNumber maxCount

getPosition :: Int -> Maybe {x :: Int, y :: Int}
getPosition n
  | n `mod` 4 == 0 =
    let y = n/(4*width)
        x = (n - 4*width*y)/4
     in Just {x, y}
  | otherwise = Nothing

unscalePosition :: {x :: Int, y :: Int} -> {x :: Number, y :: Number}
unscalePosition unscaled =
  let mx = (maxX - minX)/(toNumber width)
      fx x = mx*x + minX
      my = (maxY - minY)/(toNumber height)
      fy y = my*y + minY
   in {x: fx (toNumber unscaled.x), y: fy (toNumber unscaled.y)}

changeColors :: ColorChange
changeColors i _ = fromMaybe {r: 0, g: 0, b: 0, a: 255} do
  z <- fromPoint <<< unscalePosition <$> getPosition i
  n <- diverges z
  let r = 0
      g = 0
      b = round (scaleFactor * toNumber n)
      a = 255
  pure {r, g, b, a}

main :: forall e.
  Eff
  (canvas :: CANVAS, exception :: EXCEPTION, console :: CONSOLE | e)
  Unit
main = do
  maybecanvas <- getCanvasElementById "canvas"
  canvas <- case maybecanvas of
    Just c -> pure c
    _ -> throwException $ error "No canvas element detected"
  canvas' <- setCanvasDimensions {width: toNumber width, height: toNumber height} canvas
  ctx2d <- getContext2D canvas'
  imageData <- getImageData ctx2d 0.0 0.0 (toNumber width) (toNumber height)
  imageData' <- mutateData ctx2d imageData changeColors
  void $ putImageData ctx2d imageData' 0.0 0.0