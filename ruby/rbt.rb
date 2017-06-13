R = true
B = false

class KV
  include Comparable
  attr_reader :k, :v

  def initialize(k, v)
    @k = k
    @v = v
  end

  def <=> (other)
    @k <=> other.k
  end

  def to_s
    inspect
  end

  def inspect
    "k: #{@k}, v: #{@v}"
  end
end

class Hsh
  attr_reader :color, :left, :key, :right
  def insert(k)
    n = insert_(k, 0)
    Node.new(B, n.left, n.key, n.right)
  end
end

class Leaf < Hsh
  def color
    B
  end

  def red?
    false
  end

  def search(k)
    nil
  end

  def insert_(key, depth)
    Node.new(R, Leaf.new, key, Leaf.new)
  end

  def each
    yield self
  end

  def inspect
    "LF"
  end
end

class Node < Hsh
  def initialize(color, left, key, right)
    @color = color
    @left = left
    @key = key
    @right = right
  end

  def inspect
    "ND: #{red? ? "R" : "B"}, #{@key}"
  end

  def red?
    @color
  end

  def each(&b)
    @left.each(&b)
    yield self
    @right.each(&b)
  end

  def balance(color, left, key, right)
    if color == R
      return Node.new(color, left, key, right)
    end

    ll = left.left
    lr = left.right
    rl = right.left
    rr = right.right

    if left.red? && ll.red?
      p "balance 1"
      a = ll.left
      x = ll.key
      b = ll.right
      y = left.key
      c = lr
      z = key
      d = right
      Node.new(R, Node.new(B, a, x, b), y, Node.new(B, c, z, d))
    elsif left.red? && lr.red?
      p "balance 2"
      a = left.left
      x = left.key
      b = lr.left
      y = lr.key
      c = lr.right
      z = key
      d = right
      Node.new(R, Node.new(B, a, x, b), y, Node.new(B, c, z, d))
    elsif right.red? && rr.red?
      p "balance 3"
      a = left
      x = key
      b = rl
      y = right.key
      c = rr.left
      z = rr.key
      d = rr.right
      Node.new(R, Node.new(B, a, x, b), y, Node.new(B, c, z, d))
    elsif right.red? && rl.red?
      p "balance 4"
      a = left
      x = key
      b = rl.left
      y = rl.key
      c = rl.right
      z = right.key
      d = rr
      Node.new(R, Node.new(B, a, x, b), y, Node.new(B, c, z, d))
    else
      return Node.new(color, left, key, right)
    end
  end

  def insert_(k, depth)
    p depth
    if k < @key
      balance(@color, @left.insert_(k, depth+1), @key, @right)
    elsif k > @key
      balance(@color, @left, @key, @right.insert_(k, depth+1))
    else
      self
    end
  end

  def search(k)
    if k < @key
      @left.search(k)
    elsif k > @key
      @right.search(k)
    else
      @key
    end
  end
end

class Set
  def initialize
    @tree = Leaf.new
  end

  def insert(k, v)
    @tree = @tree.insert(KV.new(k, v))
  end

  def search(k)
    r = @tree.search(KV.new(k, nil))
    r ? r.v : nil
  end

  def each
    @tree.each do |e|
      yield e
    end
  end
end

t = Set.new
8.times{|i| t.insert(i,i)}

t.each do |e|
  p e
end

srand(0)
t = Set.new
h = {}
3.times do |i|
  n = i
  t.insert(n, n)
  h[n] = n
end

10000.times do
  n = rand(100)
  raise unless t.search(n) == h[n]
end

