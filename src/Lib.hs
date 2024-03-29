-- Lib.hs
{-# LANGUAGE NoMonomorphismRestriction, FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module Lib 
  ( mkButton
  , Justify(..)
  , Flavor(..)
  ) where

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
--import Diagrams.TwoD.Text
import qualified Graphics.SVGFonts as F
import Graphics.SVGFonts.ReadFont

data Flavor = Greenish | Greyish | Redish deriving(Eq,Ord,Show)

data Justify = LeftJustify | Centered | RightJustify deriving(Eq,Ord,Show)

bht :: Double
bht = 20  -- button height

bwd :: Double
bwd = 300 -- button width

vmg :: Double
vmg = 8 -- vertical button margin 

hmg :: Double
hmg = 16 -- horizontal button margin 

bcr :: Double
bcr = 8  -- button corner radius


mkButton :: PreparedFont Double -> Justify -> Flavor -> String -> Diagram B
mkButton f Centered flavor msg = 
   F.drop_rect 
    (F.fit_height (bht - vmg) $ F.fit_width (bwd - hmg) $ F.svgText def {F.textFont = f} msg)
    # stroke
    # fontSizeL 12 
    # fc white
    # lc white
    # centerXY
    <> roundedRect bwd bht bcr 
    # fillTexture (if flavor == Greenish then gradientGreen 
                   else if flavor == Greyish then gradientGrey
                   else gradientRed)

-- mkButtonL :: PreparedFont Double -> Flavor -> String -> Diagram B
mkButton f LeftJustify flavor msg = 
   F.drop_rect 
    (F.fit_height (bht - vmg) $ F.fit_width (bwd - hmg) $ F.svgText def {F.textFont = f} msg)
    # stroke
    # fontSizeL 12 
    # fc white
    # lc white
    # alignL  -- Left-align the text
    # translateX (-0.5 * bwd + hmg)  -- Shift the diagram to the left
    <> roundedRect bwd bht bcr 
    # fillTexture (if flavor == Greenish then gradientGreen 
                   else if flavor == Greyish then gradientGrey
                   else gradientRed)

mkButton f RightJustify flavor msg = 
   F.drop_rect 
    (F.fit_height (bht - vmg) $ F.fit_width (bwd - hmg) $ F.svgText def {F.textFont = f} msg)
    # stroke
    # fontSizeL 12 
    # fc white
    # lc white
    # alignR
    <> roundedRect bwd bht bcr 
    # fillTexture (if flavor == Greenish then gradientGreen 
                   else if flavor == Greyish then gradientGrey
                   else gradientRed)


 {- gradient experiments -}

lighterGreen = sRGB24 142 167 115
darkerGreen  = sRGB24  51  75  27
lighterGrey  = sRGB24 126 121 119
darkerGrey   = sRGB24  34  30  29
lighterRed    = sRGB24 181 105 130
darkerRed    = sRGB24  87  18  40


stopsGreen :: Num d => [GradientStop d]
stopsGreen = mkStops [(darkerGreen,0,1), (lighterGreen,1,1)]

stopsGrey :: Num d => [GradientStop d]
stopsGrey = mkStops [(darkerGrey,0,1), (lighterGrey,1,1)]

stopsRed :: Num d => [GradientStop d]
stopsRed = mkStops [(darkerRed,0,1), (lighterRed,1,1)]


gradientGreen :: Fractional n => Texture n
gradientGreen = mkLinearGradient stopsGreen (0 ^& (-8.0)) (0 ^& 8.0) GradPad 

gradientGrey :: Fractional n => Texture n
gradientGrey = mkLinearGradient stopsGrey (0 ^& (-8.0)) (0 ^& 8.0) GradPad 

gradientRed :: Fractional n => Texture n
gradientRed = mkLinearGradient stopsRed (0 ^& (-8.0)) (0 ^& 8.0) GradPad 
