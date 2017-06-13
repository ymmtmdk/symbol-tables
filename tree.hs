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
