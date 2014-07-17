module Main where
import Web.Scotty
import Data.Text (Text)
import Data.Text.IO (readFile, writeFile)
import Database.HDBC.Sqlite3 (connectSqlite3, Connection)
import Database.HDBC (prepare, execute, commit, fetchAllRows)
import Database.HDBC.SqlValue (SqlValue, fromSql, toSql)
import Data.Time (UTCTime, getCurrentTime)
import Data.Time.Format (formatTime)
import Prelude hiding (readFile, writeFile)
import Network.Wai.Middleware.RequestLogger

type User = Text
type Token = Text
data Story = Story User Text UTCTime deriving (Show)
data TomeOfStories = TomeOfStories User [Story] deriving (Show)

token :: FilePath
token = "token"

databasePath :: FilePath
databasePath = "tome.db"

holder :: TomeOfStories -> User
holder (TomeOfStories h _) = h

makeSqlStory :: Story -> [SqlValue]
makeSqlStory (Story user story timestamp) =
  [toSql user, toSql story, toSql timestamp]

main :: IO ()
main = do
  token <- readFile "token"
  scotty 8000 $ do
    middleware logStdoutDev
