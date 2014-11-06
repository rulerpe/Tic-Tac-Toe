
class Array
    def all_empty?
        self.all? { |element| element.to_s.empty? }
    end
    
    def all_same?
        self.all? { |element| element == self[0] }
    end
    
    def any_empty?
        self.any? { |element| element.to_s.empty? }
    end
    
    def none_empty?
        !any_empty?
    end
end

class Cell
    attr_accessor :value
    def initialize(value = "")
      @value = value
    end
end

class Player
    attr_reader :color, :name
    def initialize(input)
      @color = input.fetch(:color)
      @name = input.fetch(:name)
    end
end

class Board
    attr_reader :grid
    def initialize(input = {})
      @grid = input.fetch(:grid, default_grid)
    end
 
    private
 
    def default_grid
      Array.new(3) { Array.new(3) { Cell.new } }
    end
    
    public
    def get_cell(x, y)
        @grid[y][x]
    end
    
    def set_cell(x, y, value)
        get_cell(x, y).value = value
    end
    
    def game_over
        return :winner if winner?
        return :draw if draw?
        false
    end
    
    def draw?
        @grid.flatten.map { |cell| cell.value }.none_empty?
    end
    
    def winning_positions
        @grid + # rows
        @grid.transpose + # columns
        diagonals # two diagonals
    end
 
    def diagonals
      [
        [get_cell(0, 0), get_cell(1, 1), get_cell(2, 2)],
        [get_cell(0, 2), get_cell(1, 1), get_cell(2, 0)]
      ]
    end
    
    def winner?
         winning_positions.each do |winning_position|
            next if winning_position_values(winning_position).all_empty?
            return true if winning_position_values(winning_position).all_same?
        end
        false
    end
 
    def winning_position_values(winning_position)
        winning_position.map { |cell| cell.value }
    end
    
    def formatted_grid
        @grid.each_index do |index|
            @grid[index].each_index do |key|
                print @grid[index][key].value == ""? '-' : @grid[index][key].value
                print " "
            end
            puts ""
        end
    end
end

class Game
    attr_reader :players, :board, :current_player, :other_player
    def initialize(players, board = Board.new)
      @players = players
      @board = board
      @current_player, @other_player = players.shuffle
    end
    
    def switch_players
        @current_player, @other_player = @other_player, @current_player
    end
    
    def solicit_move
        "#{current_player.name}: Enter a number between 1 and 9 to make your move"
    end
    
    def get_move(human_move = gets.chomp)
        human_move_to_coordinate(human_move)
    end
     
    private
     
    def human_move_to_coordinate(human_move)
          mapping = {
            "1" => [0, 0],
            "2" => [1, 0],
            "3" => [2, 0],
            "4" => [0, 1],
            "5" => [1, 1],
            "6" => [2, 1],
            "7" => [0, 2],
            "8" => [1, 2],
            "9" => [2, 2]
          }
          mapping[human_move]
    end
    
    public
    
    def computer
        while true
            x = rand(3)
            y = rand(20)%3
            if board.get_cell(x,y).value == ""
                return x,y
            end
        end
    end
    
    def game_over_message
        return "#{current_player.name} won!" if board.game_over == :winner
        return "The game ended in a tie" if board.game_over == :draw
    end
    
    def play
      puts "#{current_player.name} has randomly been selected as the first player"
      
      while true
        board.formatted_grid
        puts ""
        if current_player.name == "Computer"
            puts "Computer move"
            x,y = computer
            board.set_cell(x, y, current_player.color)
        else
            puts solicit_move  
            x, y = get_move
            board.set_cell(x, y, current_player.color)
        end
        if board.game_over
          puts game_over_message
          board.formatted_grid
          return
        else
          switch_players
        end
      end
    end
    

end




puts "Welcome to tic tac toe"
puts "How many player? 1 or 2"
num_player = gets.chomp
print "Player 1 enter your name"
player1 = gets.chomp
player2 = ""
if num_player == '1'
    player2 = "Computer"
else
    print "Player2 enter your name"
    player2 = gets.chomp
end
p1 = Player.new({:color => "X", :name => player1})
p2 = Player.new({:color => "O", :name => player2})
players = [p1,p2 ]
new_game = Game.new(players)
new_game.play
