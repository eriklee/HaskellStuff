{-# LANGUAGE NoMonomorphismRestriction #-}
import Data.Char
import System.Environment

wordLadder :: [String]  -- dictionary
            -> String   -- Starting word 
            -> String   -- Ending word
            -> [[String]]
wordLadder d s f = filter ((s==) . head) . concat . iterate iterF $ [[f]] where
                        iterF = extend d

wlMain = do
    [s, f] <- getArgs
    d <- dict >>= return . preprocess (length s)
    let answers = wordLadder d s f
    print $ head answers

main = wlMain
    
-- not really edit distance, only allows modifications, not insert/deletes
editDistance = (length . filter (uncurry (/=))) .: zip

adjacencyList :: String -> [String] -> [String]
adjacencyList w = filter ((1==) . editDistance w)

extend :: [String] -> [[String]] -> [[String]]
extend d = filter (not . dups) . concat . map (flip next d)

next :: [String] -> [String] -> [[String]]
next ws = map (:ws) . adjacencyList (head ws)

dict = readFile "/usr/share/dict/words" >>= (return . lines)
-- Filter words of length n (and remove words with apostrophes and proper names)
preprocess n = filter ((n==).length) . filter (notElem '\'' . id) . filter (and . map isLower)

dups :: Eq a => [a] -> Bool
dups [] = False
dups (s:ss) = (s `elem` ss) || (dups ss)

(.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
(.:) = (.) . (.)
infixr 9 .:
