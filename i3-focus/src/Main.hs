{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Data.Aeson
import Data.Text hiding (map)
import System.Environment
import System.Process
import qualified Data.ByteString.Lazy.Char8 as BS

data I3Node = I3Node
  { focused :: Bool
  , layout  :: Text
  , nodes   :: [I3Node]
  } deriving (Show)

instance FromJSON I3Node where
  parseJSON (Object v) =
    I3Node <$> v .: "focused"
           <*> v .: "layout"
           <*> v .: "nodes"

firstJust :: [Maybe a] -> Maybe a
firstJust [] = Nothing
firstJust (x:xs) = case x of
  Just w -> Just w
  Nothing -> firstJust xs

tabAndStackDepth :: I3Node -> Maybe (Int, Int)
tabAndStackDepth node =
  if focused node
  then Just (0, 0)
  else let depths = map tabAndStackDepth (nodes node)
           t' = if layout node == "tabbed" then 1 else 0
           s' = if layout node == "stacked" then 1 else 0
       in case firstJust depths of
            Just (t, s) -> Just (t + t', s + s')
            Nothing -> Nothing

main :: IO ()
main = do
  [arg] <- getArgs
  out <- readProcess "i3-msg" ["-t", "get_tree"] []
  let Just foo = decode (BS.pack out) :: Maybe I3Node
      Just (t, s) = tabAndStackDepth foo
  let n | arg == "up"   || arg == "down"  = s
        | arg == "left" || arg == "right" = t
  replicateM_ n $ readProcess "i3-msg" ["focus", "parent"] []
  readProcess "i3-msg" ["focus", arg] []
  pure ()
