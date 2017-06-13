package Kt

class Node<K: Comparable<K>, V>{
  var key: K? = null
  var value: V? = null
  var left: Node<K, V>? = null
  var right: Node<K, V>? = null

  fun put(k: K, v: V){
    if (key == null){
      key = k
      value = v
    }
    else if (key == k){
      value = v
    }
    else if (key!! > k){
      if (left == null){
        left = Node()
      }
      left!!.put(k, v)
    }
    else{
      if (right == null){
        right = Node()
      }
      right!!.put(k, v)
    }
  }

  fun get(k: K): V?{
    if (key == null){
      return null
    }
    else if (key == k){
      return value
    }
    else if (key!! > k){
      if (left == null){
        return null
      }
      return left!!.get(k)
    }
    else{
      if (right == null){
        return null
      }
      return right!!.get(k)
    }
  }

  fun containsKey(k: K): Boolean{
    return get(k) != null
  }
}

