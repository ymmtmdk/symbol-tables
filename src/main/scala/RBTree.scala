/**
  * Created by chenl on 2016/11/17.
  */

import scala.math.Ordering.Implicits._

object RBTree {

  abstract class Color
  case class R() extends Color
  case class B() extends Color

  abstract class Tree[T: Ordering]()
  case class Node[T: Ordering](color: Color, left: Tree[T], key: T, right: Tree[T]) extends Tree[T]
  case class Empty[T: Ordering]() extends Tree[T]

  def insert[T: Ordering](e: T, tree: Tree[T]): Tree[T] = {
    def makeBlack(tree: Tree[T]): Tree[T] = tree match {
      case Node(_, l, k, r) => Node(B(), l, k, r)
    }

    def balance(color: Color, left: Tree[T], key: T, right: Tree[T]): Tree[T] = {
      (color, left, key, right) match {
        case (B(), Node(R(), Node(R(), a, x, b), y, c), z, d) => Node(R(), Node(B(), a, x, b), y, Node(B(), c, z, d))
        case (B(), Node(R(), a, x, Node(R(), b, y, c)), z, d) => Node(R(), Node(B(), a, x, b), y, Node(B(), c, z, d))
        case (B(), a, x, Node(R(), Node(R(), b, y, c), z, d)) => Node(R(), Node(B(), a, x, b), y, Node(B(), c, z, d))
        case (B(), a, x, Node(R(), b, y, Node(R(), c, z, d))) => Node(R(), Node(B(), a, x, b), y, Node(B(), c, z, d))
        case (c, l, x, r) => Node(c, l, x, r)
      }
    }

    def ins(tree: Tree[T]): Tree[T] = tree match {
        case Node(c, l, k, r) =>
          if (e < k)
            balance(c, ins(l), k, r)
          else if (e > k)
            balance(c, l, k, ins(r))
          else
            tree
        case Empty() => Node(R(), Empty(), e, Empty())
    }
    makeBlack(ins(tree))
  }
}
