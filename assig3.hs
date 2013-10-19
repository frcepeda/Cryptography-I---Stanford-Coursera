import Data.List
import Crypto.Hash.SHA256
import Data.ByteString as B
import Data.ByteString.Base16 as Hex

splitEvery n xs
    | B.null xs = []
    | otherwise = left : splitEvery n right 
        where (left, right) = B.splitAt n xs

main = do
    file <- B.readFile "toHash"
    let chunks = splitEvery 1024 file
    print . Hex.encode $ Prelude.foldr go B.empty chunks
        where go x h = hash (append x h)
