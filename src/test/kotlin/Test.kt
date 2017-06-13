import edu.princeton.cs.algs4.*
import org.junit.Test
import org.junit.Assert.*
import org.hamcrest.MatcherAssert.*
import org.hamcrest.Matchers.*

class KV<K: Comparable<K>, V>(val key: K, val value: V): Comparable<KV<K,V>>{
  override fun compareTo(other: KV<K,V>): Int{
    return key.compareTo(other.key)
  }
}

class Test{
  @Test fun test(){
    val bst = Kt.Node<Int, String>()
    assertEquals(false, bst.containsKey(1))
    bst.put(1, "a")
    assertEquals(true, bst.containsKey(1))
    assertEquals("a", bst.get(1))
    bst.put(1, "b")
    assertEquals(true, bst.containsKey(1))
    assertEquals("b", bst.get(1))
    assertEquals(true, bst.containsKey(1))
    var s:Node<Int> = Leaf()
    s = s.insert(1)
    assertEquals(1, s.search(1))
    assertEquals(null, s.search(2))
    s = s.insert(2)
    assertEquals(2, s.search(2))
    val random = java.util.Random()
    for (i in 0..500000){
      s = s.insert(i)
      assertEquals(i, s.search(i))
    }
    for (i in 0..500000){
      assertEquals(i, s.search(i))
    }
    /* s.each{e -> println(e)} */
    for (i in 0..500000){
      val r = random.nextInt()
      s = s.insert(r)
      assertEquals(r, s.search(r))
    }

    var tree:Node<KV<Int, Int>> = Leaf()
    for (i in 0..500000){
      tree = tree.insert(KV(i, i*2))
      assertEquals(i*2, tree.search(KV(i, 0))!!.value)
    }
  }
}

