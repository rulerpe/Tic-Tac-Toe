class GameTable
    attr_accessor :table
    @@turn = "x"
    def initialize
       @table = { 'a' => {'col' => 'a', '1' => 1, '2' => 2, '3' => 3}, 'b' =>{'col' => 'b', '1' => 1, '2' => 2, '3' => 3}, 'c' => {'col' => 'c', '1' => 1, '2' => 2, '3' => 3}} 
    end
    
    def get(x)
        arr = x.split
        puts @table[arr[0].to_sym][arr[1].to_sym]
    end
    
    def move(step)
        arr = step.split
        @table[arr[0]][arr[1]] = @@turn
        @@turn = @@turn == "x"? "o":"x"        
    end
    
    def win
        res = false
        @table.each_key do|k|
            @table[k].each_value do|v|
                res =  v==@@turn ? true:false
            end
            if res == true
                return res
            end
        end

        return res
    end
end

class Draw
    def initialize(table)
        @table = table        
    end
    def print_table
        row = ['  ','1 ','2 ','3 ']
        row.each{|x|
            print x
        }
        @table.each_key{|y|
            puts ' '
            @table[y].each_value{|x|
                print "#{x} "
            }
        }
        
    end
end

text = GameTable.new
draw = Draw.new(text.table)
draw.print_table
begin
    p1 = gets.chomp
    text.move(p1)
    draw.print_table
end until text.win
