module Canvas.Util where

import Control.Monad.Eff (Eff)
import Graphics.Canvas (CANVAS, Context2D, ImageData)

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