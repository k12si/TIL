V = 11

$maxvalue = Array.new(V)
$choice = Array.new(V)

$goods = [
    {
        name: 'A',
        value: 2,
        size: 1
    },
    {
        name: 'B',
        value: 6,
        size: 2
    },
    {
        name: 'C',
        value: 9,
        size: 3
    }
]

V.times do |k|
  $maxvalue[k] = 0
  $choice[k] = -1
end

$goods.each_with_index do |good|
  V.times do |t|
    if t >= good[:size]    # そもそも容量制限内に各種の容量いずれも収まらない場合を除外（容量制限:0, 価値合計:0, 最終選択商品:-1）
      temp = $maxvalue[t-good[:size]] + good[:value]
      if temp > $maxvalue[t]
        $maxvalue[t] = temp
        $choice[t] = good[:name]
      end
    end
  end
end

p $choice
p $maxvalue

# 出力したい答え

k = V-1 # マックス容量制限

# 選択商品順
while $choice[k].kind_of?(String) do
  p $choice[k]
  $goods.each do |good|
    if $choice[k] == good[:name]
      k = k - good[:size]
    end
  end
end

# 価値合計
p $maxvalue[V-1]