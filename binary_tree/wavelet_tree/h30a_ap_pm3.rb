DNA = { 'A' => 0, 'C' =>  1, 'G' => 2, 'T' => 3, 'W' => 4, 'Z' => 5, 'Q' => 6, 'S' => 7, 'B' => 8}
DEPTH = Math.log2(DNA.size).ceil

Node = Struct.new(:key, :left, :right)

# ウェーブレット木の構築
def make_tree str, depth, child = 0
  return if depth >= DEPTH
  key = 0
  str.chars.each {|c|
    if depth == 0               # 根のとき
      key |= (DNA[c] >> (DEPTH - 1)) & 0x01
      key <<= 1
    else                        # 根以外のとき
      # マスク対象のbit位置は,位置bit前のbit全て
      if (DNA[c] >> (DEPTH - depth)) == child
        position_bit = DNA[c] >> (DEPTH - depth - 1)
        key |= position_bit & 0x01
        key <<= 1
      end
    end
  }
  key >>= 1
  # childの0,1をどんどん格納していく(過去のbit並びも全て記憶させる)
  child <<= 1
  left  = make_tree str, depth+1, child |= 0
  right = make_tree str, depth+1, child |= 1
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

str_p = "CTQWCZGAWSGAGZWTABZZ"            # DNA配列

root = make_tree str_p, 0       # ウェーブレット木を構築
pp root

# 文字の数を数える
DNA.keys.each {|k|
  puts "#{k} : #{rank root, str_p.size, k}"
}