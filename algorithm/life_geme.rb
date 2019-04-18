m = [0,1,0,0,0,0,1,0,1,1,1,0,0,0,0,0]

def update m
  temp = m
  n =
  m = m.map {|square| square = 0}

  for i in (1..n*n)

    if (i-1)%n == 0
      a = 0
      b = 1
    elsif i%n == 0
      a = -1
      b = 0
    else
      a = -1
      b = 1
    end

    e = 0

    for y in (-1..1)
      for x in (a..b)
        if y != 0 || x != 0
          c = i + y*n + x
          if 1 <= c && c <=  n*n
            if temp[c-1] == 1
              e = e + 1
            end
          end
        end
      end
    end

    if temp[i-1] == 0 && e == 3
      m[i-1] = 1
    elsif temp[i-1] == 1 && ( e == 2 or e == 3 )
      m[i-1] = 1
    end
  end
  p m
end

update m
