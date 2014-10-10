{-# LANGUAGE GADTs #-}
module Data.Matrix.Generic.Mutable
   ( thaw
   , unsafeThaw
   , freeze
   , unsafeFreeze
   , write
   , unsafeWrite
   , read
   , unsafeRead
   ) where

import Prelude hiding (read)
import Control.Monad
import Data.Matrix.Generic.Types
import qualified Data.Vector.Generic as G
import qualified Data.Vector.Generic.Mutable as GM
import Control.Monad.Primitive

-- to be removed in GHC-7.10
(<$>) :: Monad m => (a -> b) -> m a -> m b
(<$>) = liftM

thaw :: PrimMonad m => Matrix v a -> m (MMatrix (G.Mutable v) (PrimState m) a)
thaw (Matrix r c tda offset v) = MMatrix r c tda offset <$> G.thaw v
{-# INLINE thaw #-}

unsafeThaw :: PrimMonad m => Matrix v a -> m (MMatrix (G.Mutable v) (PrimState m) a)
unsafeThaw (Matrix r c tda offset v) = MMatrix r c tda offset <$> G.unsafeThaw v
{-# INLINE unsafeThaw #-}

freeze :: (PrimMonad m, G.Vector v a) => MMatrix (G.Mutable v) (PrimState m) a -> m (Matrix v a)
freeze (MMatrix r c tda offset v) = Matrix r c tda offset <$> G.freeze v
{-# INLINE freeze #-}

unsafeFreeze :: (PrimMonad m, G.Vector v a) => MMatrix (G.Mutable v) (PrimState m) a -> m (Matrix v a)
unsafeFreeze (MMatrix r c tda offset v) = Matrix r c tda offset <$> G.unsafeFreeze v
{-# INLINE unsafeFreeze #-}

write :: (PrimMonad m, GM.MVector v a)
      => MMatrix v (PrimState m) a -> Int -> Int -> a -> m ()
write (MMatrix _ _ tda offset v) i j = GM.write v idx
  where idx = offset + i * tda + j
{-# INLINE write #-}

unsafeWrite :: (PrimMonad m, GM.MVector v a)
            => MMatrix v (PrimState m) a -> Int -> Int -> a -> m ()
unsafeWrite (MMatrix _ _ tda offset v) i j = GM.unsafeWrite v idx
  where idx = offset + i * tda + j
{-# INLINE unsafeWrite #-}

read :: (PrimMonad m, GM.MVector v a)
     => MMatrix v (PrimState m) a -> Int -> Int -> m a
read (MMatrix _ _ tda offset v) i j = GM.read v idx
  where idx = offset + i * tda + j
{-# INLINE read #-}

unsafeRead :: (PrimMonad m, GM.MVector v a)
           => MMatrix v (PrimState m) a -> Int -> Int -> m a
unsafeRead (MMatrix _ _ tda offset v) i j = GM.unsafeRead v idx
  where idx = offset + i * tda + j
{-# INLINE unsafeRead #-}
