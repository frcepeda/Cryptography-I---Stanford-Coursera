{-# LANGUAGE BangPatterns #-}

-- 550 seconds to compute the answer. D:

import Data.Map.Strict as M
import Control.Applicative
import Data.List

b = 2^20
p = 13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171 :: Integer
g = 11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568 :: Integer
h = 3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333 :: Integer

modexp x e m = mexp' x e 1
    where mod' = flip mod m
          mexp' _ 0 !z = mod' z
          mexp' !x !e !z = mexp' (mod' (x^2)) q (if r == 1 then mod' (x*z) else z)
                where (q,r) = quotRem e 2

modInv !x !p = modexp x (p-2) p

solve p g h = r*b + l
    where r = case Data.List.findIndex (flip M.member left) right of Just a -> fromIntegral a
          l = case M.lookup (right !! r) left of Just a -> a
          left = M.fromList $ zipWith (,) xs [0..]
              where xs = (\d -> modMult h (modInv d p)) <$> (scanl modMult 1 (replicate (fromIntegral b) g))
          right = scanl modMult 1 (replicate (fromIntegral b) gB)
          gB = modexp g b p
          modMult a b = mod (a*b) p

main = print $ solve p g h
