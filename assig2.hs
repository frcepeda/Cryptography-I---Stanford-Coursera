import qualified Data.ByteString as B
import Data.ByteString.Base16 as Hex
import Crypto.Cipher.AES

main = do
    mode <- Prelude.getLine
    keyStr <- B.getLine
    cyphStr <- B.getLine

    let f = if mode == "CBC" then decryptCBC else decryptCTR
    let k = fst . Hex.decode $ keyStr
    let iv = fst . Hex.decode . B.take 32 $ cyphStr
    let c = fst . Hex.decode . B.drop 32 $ cyphStr

    B.putStrLn $ f (initAES k) iv c 
