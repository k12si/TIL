DNA = { 'A' => 0, 'C' =>  1, 'G' => 2, 'T' => 3 }
DEPTH = Math.log2(DNA.size).to_i

Node = Struct.new(:key, :left, :right)

# ウェーブレット木の構築
def make_tree str, depth, child = nil
  return if depth >= DEPTH
  key = 0
  str.chars.each {|c|
    if depth == 0               # 根のとき
      key |= (DNA[c] >> (DEPTH - 1)) & 0x01
      key <<= 1
    else                        # 根以外のとき
      if ((DNA[c] >> depth) & 0x01) == child
        key |= (DNA[c] >> (depth - 1)) & 0x01
        key <<= 1
      end
    end
  }
  key >>= 1
  left  = make_tree str, depth+1, 0
  right = make_tree str, depth+1, 1
  node = Node.new(key, left, right)
end

# 対象文字の出現回数を数える
def rank root, m, r
  nodep = root
  d = 1                         # 符号中の左からのビット位置の初期化
  n = m                         # 検索対象の文字列の長さの初期化
  while nodep != nil
    count = 0
    # rに対応するビット列の左からd番目のビット位置のビットの値をbに格納
    x = 1 << (DEPTH - d)
    x = x & DNA[r]
    b = x >> (DEPTH - d)        # bは 0 か 1 の値
    1.upto(n) {|i|
      if b == ((nodep.key >> (n - i)) & 0x01)
        count += 1
      end
    }
    if b == 0
      nodep = nodep.left
    else
      nodep = nodep.right
    end
    n = count
    d += 1
  end
  n
end

str_p = "CTCGAGAGTA"            # DNA配列

root = make_tree str_p, 0       # ウェーブレット木を構築
pp root

# 文字の数を数える
DNA.keys.each {|k|
  puts "#{k} : #{rank root, str_p.size, k}"
}