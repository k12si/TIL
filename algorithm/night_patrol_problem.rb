M = 4 #行
N = 3 #列

Board = Array.new(M).map{Array.new(N, 0)}   #盤面

# ナイトの動き
$dv = [-2, -1, 1, 2, 2, 1, -1, -2]
$dh = [1, 2, 2, 1, -1, -2, -2, -1]

# 解答が存在するか判定/解答の個数カウント
$printFlag = 0

def search i, v, h
  if 1 <= v && v <= M
    if 1 <= h && h <= N
      if Board[v-1][h-1] == 0
        Board[v-1][h-1] = i
        if i == M*N
          $printFlag += 1
          printBoard($printFlag)
        else
          (0..7).each do |num|
            search(i+1, v+$dv[num], h+$dh[num])
          end
        end
        # ナイトが巡回できなかった場合,それまでの移動手順の足跡を消す
        # ナイトが巡回できた場合はここに至る前に,先にprintBoardメソッドで解答が吐き出されるため,上書きされても問題ない
        Board[v-1][h-1] = 0
      end
    end
  end
end

def printBoard(n)
  puts "#{n}個目の解答"
  M.times do |v|
    N.times do |h|
      print "#{Board[v][h]}\t"
    end
    puts ''
  end
  puts ''
end

def main()
  search(1, 1, 1)
  if $printFlag == 0
    puts '解答は存在しません。'
  end
end

main