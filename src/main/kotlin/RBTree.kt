enum class Color {
  Red, Black
}

interface Node<K: Comparable<K>>{
  fun isRed(): Boolean
  fun insert(k: K): Branch<K>{
    val br = insert_(k)
    return Branch(Color.Black, br.left, br.key, br.right)
  }
  fun insert_(k: K): Branch<K>
  fun search(k: K): K?
  fun traverse(f: (Node<K>) -> Unit): Unit
}

class Leaf<K: Comparable<K>>: Node<K>{
  override fun isRed(): Boolean = false
  override fun insert_(k: K): Branch<K>{
    return Branch(Color.Red, Leaf(), k, Leaf())
  }
  override fun search(k: K): K? = null
  override fun traverse(f: (Node<K>) -> Unit) = f(this)
}

class Branch<K: Comparable<K>>(val color: Color, val left: Node<K>, val key: K, val right: Node<K>): Node<K>{
  override fun isRed(): Boolean = color == Color.Red

  override fun insert_(k: K): Branch<K>{
    return if (k < key){
      balance(color, left.insert_(k), key, right)
    }else if (k > key){
      balance(color, left, key, right.insert_(k))
    }else{
      this
    }
  }

  override fun search(k: K): K? {
    return if (k < key){
      left.search(k)
    }else if (k > key){
      right.search(k)
    }else{
      key
    }
  }

  override fun traverse(f: (Node<K>) -> Unit){
    left.traverse(f)
    f(this)
    right.traverse(f)
  }

  private fun balance(c: Color, l: Node<K>, k: K, r: Node<K>): Branch<K>{
    if (c == Color.Red){
      return Branch(c, l, k, r)
    }

    if (l is Branch && l.isRed()){
      val ll = l.left
      val lr = l.right
      if (ll is Branch && ll.isRed()){
        return Branch(Color.Red,
        Branch(Color.Black, ll.left, ll.key, ll.right),
        l.key,
        Branch(Color.Black, lr, k, r))
      }
      else if (lr is Branch && lr.isRed()){
        return Branch(Color.Red,
        Branch(Color.Black, ll, l.key, lr.left),
        lr.key,
        Branch(Color.Black, lr.right, k, r))
      }
    }

    if (r is Branch && r.isRed()){
      val rl = r.left
      val rr = r.right
      if (rr is Branch && rr.isRed()){
        return Branch(Color.Red,
        Branch(Color.Black, l, k, rl),
        r.key,
        Branch(Color.Black, rr.left, rr.key, rr.right))
      }
      else if (rl is Branch && rl.isRed()){
        return Branch(Color.Red,
        Branch(Color.Black, l, k, rl.left),
        rl.key,
        Branch(Color.Black, rl.right, r.key, rr))
      }
    }

    return Branch(c, l, k, r)
  }
}
