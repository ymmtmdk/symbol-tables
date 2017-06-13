module Main where

import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.QuickCheck2

----------------------------------------------------------------

data Hash k v = Leaf -- color is Black
              | Node Color (Hash k v) (k,v) (Hash k v)
              deriving Show

data Color = R | B deriving Show

----------------------------------------------------------------

empty :: Hash k v
empty = Leaf

turnB :: Hash k v -> Hash k v
turnB (Node c l (k,v) r) = Node B l (k,v) r

insert :: Ord k => (k,v) -> Hash k v -> Hash k v
insert (k,v) t = turnB (insert' k v t)

insert' :: Ord k => k -> v -> Hash k v -> Hash k v
insert' kx vx Leaf = Node R Leaf (kx,vx) Leaf
insert' kx vx (Node c l (k,v) r) = case compare kx k of
    -- 左部分木に挿入してバランスを回復
    LT -> balance c (insert' kx vx l) (k,v) r
    -- 右部分木に挿入してバランスを回復
    GT -> balance c l (k,v) (insert' kx vx r)
    -- 元の木をそのまま返す
    EQ -> Node c l (k,v) r

balance :: Color -> Hash k v -> (k,v) -> Hash k v -> Hash k v
balance B (Node R (Node R a x b) y c) z d = 
    Node R (Node B a x b) y (Node B c z d)
balance B (Node R a x (Node R b y c)) z d = 
    Node R (Node B a x b) y (Node B c z d)
balance B a x (Node R b y (Node R c z d)) = 
    Node R (Node B a x b) y (Node B c z d)
balance B a x (Node R (Node R b y c) z d) =
    Node R (Node B a x b) y (Node B c z d)
balance c a x b = Node c a x b

----------------------------------------------------------------

insert'' :: Ord k => Hash k v -> (k, v) -> Hash k v
insert'' t kv = insert kv t

fromList :: Ord k => [(k,v)] -> Hash k v
fromList = foldl insert'' empty

----------------------------------------------------------------

search :: Ord k => k -> Hash k v -> Maybe v
search kx Leaf = Nothing
search kx (Node c l (k,v) r) = case compare kx k of
    LT -> search kx l
    GT -> search kx r
    EQ -> Just v


----------------------------------------------------------------

showTree :: (Show k, Show v) => Hash k v -> String
showTree = showTree' ""

showTree' :: (Show k, Show v) => String -> Hash k v -> String
showTree' _ Leaf = "\n"
showTree' pref (Node c l (k,v) r) = show c ++ ": " ++ show k ++ " -> " ++ show v ++ "\n"
                                 ++ pref ++ "+ " ++ showTree' pref' l
                                 ++ pref ++ "+ " ++ showTree' pref' r
  where
    pref' = "  " ++ pref

printTree :: (Show k, Show v) => Hash k v -> IO ()
printTree = putStr . showTree

----------------------------------------------------------------

isBalanced :: Hash k v -> Bool
isBalanced t = isBlackSame t && isRedSeparate t

isBlackSame :: Hash k v -> Bool
isBlackSame t = all (n==) ns
  where
    n:ns = blacks t

blacks :: Hash k v -> [Int]
blacks = blacks' 0
  where
    blacks' n Leaf = [n+1]
    blacks' n (Node R l _ r) = blacks' n  l ++ blacks' n  r
    blacks' n (Node B l _ r) = blacks' n' l ++ blacks' n' r
      where
        n' = n + 1

isRedSeparate :: Hash k v -> Bool
isRedSeparate t = reds B t

reds :: Color -> Hash k v -> Bool
reds _ Leaf = True
reds R (Node R _ _ _) = False
reds _ (Node c l _ r) = reds c l && reds c r

toList :: Hash k v -> [(k,v)]
toList t = inorder t []
  where
    inorder Leaf xs = xs
    inorder (Node _ l x r) xs = inorder l (x : inorder r xs)

isOrdered :: Ord k => Hash k v -> Bool
isOrdered t = ordered $ toList t
  where
    ordered [] = True
    ordered [_] = True
    ordered ((x,_):yv@(y,_):xys) = x < y && ordered (yv:xys)

valid :: Ord k => Hash k v -> Bool
valid t = isBalanced t && isOrdered t

----------------------------------------------------------------


tests :: [Test]
tests = [ testGroup "Property Test" [
               testProperty "fromList"           prop_fromList
             , testProperty "toList"             prop_toList
             , testProperty "search"             prop_search
             ]
        ]

prop_fromList :: [(Int,Int)] -> Bool
prop_fromList xs = valid $ fromList xs

prop_toList :: [(Int,Int)] -> Bool
prop_toList xs = ordered ys
  where
    ys = toList . fromList $ xs
    ordered (x:y:xys) = x <= y && ordered (y:xys)
    ordered _         = True

prop_search :: [(Int,Int)] -> Bool
prop_search [] = True
prop_search xss@((k,v):_) = search k t == Just v
  where
    t = fromList xss

main :: IO ()
main = defaultMain tests
