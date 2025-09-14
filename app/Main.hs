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
  genButton f Centered Redish "Switch" "Return to Main Menu"

{-}
  genButton f Centered Greenish "Mission" "0  Basic Movement"
  genButton f Centered Greenish "Mission" "1  Guide Builder Home"
  genButton f Centered Greenish "Mission" "2  Mine Copper"
  genButton f Centered Greenish "Mission" "3  Build Farms"
  genButton f Centered Greenish "Mission" "4  Train Soldiers"
-}
  genButton f Centered Greenish "Chapter" "0  Dawn"
  genButton f Centered Greenish "Chapter" "1  Forge"
  genButton f Centered Greenish "Chapter" "2  Crossroads"
  genButton f Centered Greenish "Chapter" "3  Sanctuary"
  genButton f Centered Greenish "Chapter" "4  Storm"

  genButton f LeftJustify Greenish "Button" "1"
  genButton f LeftJustify Greenish "Button" "2"
  genButton f LeftJustify Greenish "Button" "3"
  genButton f LeftJustify Greenish "Button" "4"
  genButton f LeftJustify Greenish "Button" "5"
  genButton f LeftJustify Greenish "Button" "6"
  genButton f LeftJustify Greenish "Button" "7"
  genButton f LeftJustify Greenish "Button" "8"
  genButton f Centered    Redish   "Button" "Back to Main Menu"

  genButton f Centered Greenish "Home" "Tutorials"
  genButton f Centered Greenish "Home" "Campaign"
  genButton f Centered Greenish "Home" "Saved Games"
  genButton f Centered Greenish "Home" "Map Editor"
  genButton f Centered Greenish "Home" "Standard Play"
  genButton f Centered Greenish "Home" "Options"
  genButton f Centered Greenish "Home" "Credits"
  genButton f Centered Redish   "Home" "Leave Game"

  genButton f Centered Redish   "Splash" "Enter"

  genButton f Centered Greenish "Lobby" "Invite Friend"
  genButton f Centered Greenish "Lobby" "Ready"

  genWriting f Centered "Lobby" "Invite a Friend to Play Brave Splat"
  genWriting f Centered "Lobby" "Waiting for Player 2"
  genWriting f Centered "Lobby" "Player 2 has Accepted your Invite"
  genWriting f Centered "Lobby" "Player 2 has Declined your Invite"
  genWriting f Centered "Lobby" "Countdown will being when both players are ready"

genOnOff :: Font -> String -> String -> IO()
genOnOff f prefix msg = do
  genButton f Centered Greenish prefix $ msg ++ " On"
  genButton f Centered Greyish  prefix $ msg ++ " Off"

genButton :: Font -> Justify -> Flavor -> String -> String -> IO()
genButton f j flav prefix msg = do
  let diagram = mkButton f j flav msg
  let basename = prefix ++ "-" ++ dashify msg
  let pngfile = "out/" ++ basename ++ ".png"
  let svgfile = "out/" ++ basename ++ ".svg"
  renderPretty svgfile (mkWidth 600) diagram
  convert pngfile svgfile 

genWriting :: Font -> Justify -> String -> String -> IO()
genWriting f j prefix msg = do 
  let diagram = mkWriting f j msg
  let basename = prefix ++ "-" ++ dashify msg
  let pngfile = "out/" ++ basename ++ ".png"
  let svgfile = "out/" ++ basename ++ ".svg"
  renderPretty svgfile (mkWidth 600) diagram
  convert pngfile svgfile

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