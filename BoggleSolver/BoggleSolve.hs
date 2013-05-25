--BFS Boggle solver with pruning
--10/8/12
{-# LANGUAGE TupleSections #-}

module Main where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as B
import qualified Data.Map as M
import qualified Data.Trie as T (Trie,fromList,null,submap,member)

type Dict = T.Trie Bool
type Coord = (Int,Int)
type BoggleBoard = M.Map Coord Char

main :: IO ()
main = do
        putStrLn "Initializing dict + board"
        ws <- B.readFile "/usr/share/dict/words"
        let dict = makeDict (filter ((>2) . B.length) (B.lines ws))
        boardS <- getLine 
        let coords = [(x,y) | x <- [1..sizeM], y <- [1..sizeN]]
        let board = M.fromList $ zip coords boardS
        let initials = makeList board (map (:[]) coords)
        putStrLn "Initialization Finished: Now Solving"
        --Sub bfsPrune below to solve with pruning
        let results = bfsNoPrune initials board dict []
        B.putStrLn $ B.unlines results

sizeM, sizeN :: Int
sizeM = 5
sizeN = 5

--Does a BFS of the board, using the dictionarry to prune unproductive paths
bfsPrune :: [([Coord],String)] -> BoggleBoard -> Dict -> [ByteString] -> [ByteString]
bfsPrune [] _ _ acc = acc
bfsPrune ((cs,w):tl) b d acc = bfsPrune tl' b d acc' where
                                acc' = if isWord w d then (B.pack w):acc 
                                        else acc
                                tl' = if not $ isPrefix w d then tl 
                                        else
                                         tl++(makeList b (getNexts cs)) 
 
--Does a BFS of the board but does not prune using the dictionary
bfsNoPrune :: [([Coord],String)] -> BoggleBoard -> Dict -> [ByteString] -> [ByteString]
bfsNoPrune [] _ _ acc = acc
bfsNoPrune ((cs,w):tl) b d acc = bfsNoPrune tl' b d acc' where
                                acc' = if isWord w d then (B.pack w):acc 
                                        else acc
                                tl' =  tl++(makeList b (getNexts cs)) 
  
-- Get path extensions (of length 1) from given path
-- Assumption that they must be N,S,E,W instead of diagonal
getNexts :: [Coord] -> [[Coord]]
getNexts cs = concat [lN,lE,lS,lW] where
                (x,y) = last cs
                lN = if x-1 == 0    || elem (x-1,y) cs
                        then [] else [cs++[(x-1,y)]]
                lE = if y+1 > sizeN || elem (x,y+1) cs 
                        then [] else [cs++[(x,y+1)]]
                lS = if x+1 > sizeM || elem (x+1,y) cs 
                        then [] else [cs++[(x+1,y)]]
                lW = if y-1 == 0    || elem (x,y-1) cs 
                        then [] else [cs++[(x,y-1)]]
                

--Setup functions
makeStrFromCoordList :: BoggleBoard -> [Coord] -> String
makeStrFromCoordList b = map (\c -> M.findWithDefault '0' c b)

makeList :: BoggleBoard -> [[Coord]] -> [([Coord],String)]
makeList b cs = zip cs ws where ws = map (makeStrFromCoordList b) cs

--Dictionary Functions (mostly String/BS glue)
isWord :: String -> Dict -> Bool
isWord = T.member . B.pack

isPrefix :: String -> Dict -> Bool
isPrefix s = not . T.null . T.submap (B.pack s)

makeDict :: [ByteString] -> Dict
makeDict = T.fromList . map (,True)

