module Canvas.Util where

import Control.Monad.Eff (Eff)
import Graphics.Canvas (CANVAS, CanvasElement, Context2D, ImageData)
import Node.Stream (Readable)

foreign import mutateData
  :: forall e
   . Context2D
  -> ImageData
  -> ColorChange
  -> Eff (canvas :: CANVAS | e) ImageData

type ColorChange = Int -> Int ->
  { r :: Int
  , g :: Int
  , b :: Int
  , a :: Int
  }

foreign import createNodeCanvas
  :: forall e
   . Number
  -> Number
  -> Eff (canvas :: CANVAS | e) CanvasElement

foreign import createPngStream
  :: forall e
   . CanvasElement
  -> Eff (canvas :: CANVAS | e) (Readable () (canvas :: CANVAS | e))