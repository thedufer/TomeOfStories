module Main where
import Web.Scotty
import Data.Text.IO (readFile, writeFile)
import Prelude hiding (readFile, writeFile)
import Network.Wai.Middleware.RequestLogger

main:: IO ()
main = do
  token <- readFile "token"
  scotty 8000 $ do
    middleware logStdoutDev
