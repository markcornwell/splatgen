-- Main.hs

{----------------------------------------------------------------
Generates button art for BraveSplat game.  Main mostly orchestrates
what button buttons to build, the text they contain, and at a high
level their appearance.

The low leve details of shaping, coloring, managing fontsize dealing
with gradients is delegated to Lib.  Lib exports a simplified
interface of button colors and styles.
------------------------------------------------------------------}

{-
stack exec splatgen-exe -- -o output.svg -w 400 
stack exec splatgen-exe -- -o output.png -w 400 
then open with browser
-}

module Main (main) where

import System.Process
import Diagrams.Prelude -- hiding(text, width, height)
import Graphics.SVGFonts.ReadFont
import Diagrams.Backend.SVG
import qualified Graphics.SVGFonts as F
import Lib

type Font = PreparedFont Double 
type File = String

main :: IO()
main = do
  f <- F.loadFont "font/Lucida-Calligraphy-Italic.svg"
  genOnOff  f "Switch" "Show Debug Annotations"
  genOnOff  f "Switch" "Enable Adversary Raids"
  genOnOff  f "Switch" "Enable Music"
  genOnOff  f "Switch" "Enable Sound Effects"
  genOnOff  f "Switch" "Enable Fog of War"
  genOnOff  f "Switch" "Enable Minimap"
  genButton f Redish "Switch" "Return to Main Menu"
  genButton f Greenish "Mission" "0  Basic Movement"
  genButton f Greenish "Mission" "1  Guide Builder Home"
  genButton f Greenish "Mission" "2  Mine Copper"
  genButton f Greenish "Mission" "3  Build Farms"
  genButton f Greenish "Mission" "4  Train Soldiers"

genOnOff :: Font -> String -> String -> IO()
genOnOff f prefix msg = do
  genButton f Greenish prefix $ msg ++ " On"
  genButton f Greyish  prefix $ msg ++ " Off"

genButton :: Font -> Flavor -> String -> String -> IO()
genButton f flav prefix msg = do
  let diagram = mkButton f flav msg
  let basename = prefix ++ "-" ++ dashify msg
  let pngfile = "out/" ++ basename ++ ".png"
  let svgfile = "out/" ++ basename ++ ".svg"
  renderPretty svgfile (mkWidth 600) diagram
  convert pngfile svgfile 

  --callCommand $ "rsvg-convert -d 72 -p 72 -f png -o " ++ pngfile ++ " " ++ svgfile

convert :: File -> File -> IO()
convert pngfile svgfile = do
    callCommand $ "rsvg-convert -d 72 -p 72 -f png -o " ++ pngfile ++ " " ++ svgfile

dashify :: String -> String
dashify = map (\a -> if a == ' ' then '-' else a)

{-
  -- Uncomment one of the following based on the backend you want
  -- mainWith diagram -- for SVG backend
  --mainWith $ diagram # frame 1 -- for SVG backend with a frame
  --renderRasterific "output.png" (mkWidth 400) diagram  -- for Rasterific
  --renderSVG "button.svg" (mkWidth 800) diagram
-}