module Main where

import Prelude

import Canvas.Util (ColorChange, createNodeCanvas, createPngStream, mutateData)
import Control.Monad.Eff (Eff)
import Data.Complex (fromPoint)
import Data.Int (round, toNumber)
import Data.Maybe (Maybe(..), fromMaybe)
import Graphics.Canvas (CANVAS, getContext2D, getImageData, putImageData)
import Mandelbrot (diverges, maxCount)
import Node.FS (FS)
import Node.FS.Stream (createWriteStream)
import Node.Stream (pipe)

minX :: Number
minX = -2.5

maxX :: Number
maxX = 1.0

dx :: Number
dx = maxX - minX

minY :: Number
minY = -maxY

maxY :: Number
maxY = 9.0*dx/32.0

dy :: Number
dy = maxY - minY

width :: Int
width = round (dx * sizeScaleFactor)

height :: Int
height = round (dy * sizeScaleFactor)

sizeScaleFactor :: Number
sizeScaleFactor = 400.0 -- 548.57

colorScaleFactor :: Number
colorScaleFactor = 1000.0 / toNumber maxCount

getPosition :: Int -> Maybe {x :: Int, y :: Int}
getPosition n
  | n `mod` 4 == 0 =
    let y = n/(4*width)
        x = (n - 4*width*y)/4
     in Just {x, y}
  | otherwise = Nothing

unscalePosition :: {x :: Int, y :: Int} -> {x :: Number, y :: Number}
unscalePosition unscaled =
  let mx = dx / toNumber width
      fx x = mx*x + minX
      my = dy / toNumber height
      fy y = my*y + minY
   in {x: fx (toNumber unscaled.x), y: fy (toNumber unscaled.y)}

changeColors :: ColorChange
changeColors i _ = fromMaybe {r: 0, g: 0, b: 0, a: 255} do
  z <- fromPoint <<< unscalePosition <$> getPosition i
  n <- diverges z
  let r = 0
      g = round (colorScaleFactor * toNumber n) `mod` 255
      b = round (colorScaleFactor * toNumber n) `mod` 255
      a = 255
  pure {r, g, b, a}

main :: Eff (canvas :: CANVAS, fs :: FS) Unit
main = do
  writestream <- createWriteStream "/home/evante/mandelbrot.png"
  canvas <- createNodeCanvas (toNumber width) (toNumber height)
  ctx2d <- getContext2D canvas
  imageData <- getImageData ctx2d 0.0 0.0 (toNumber width) (toNumber height)
  imageData' <- mutateData ctx2d imageData changeColors
  ctx2d' <- putImageData ctx2d imageData' 0.0 0.0
  readstream <- createPngStream canvas
  void $ pipe readstream writestream

-- main = do
--   maybecanvas <- getCanvasElementById "canvas"
--   canvas <- case maybecanvas of
--     Just c -> pure c
--     _ -> throwException $ error "No canvas element detected"
--   canvas' <- setCanvasDimensions {width: toNumber width, height: toNumber height} canvas
--   ctx2d <- getContext2D canvas'
--   imageData <- getImageData ctx2d 0.0 0.0 (toNumber width) (toNumber height)
--   imageData' <- mutateData ctx2d imageData changeColors
--   void $ putImageData ctx2d imageData' 0.0 0.0