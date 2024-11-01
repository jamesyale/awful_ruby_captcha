require 'io/console'

class MazeGame
    def initialize(width, height)
      @width = width
      @height = height
      @maze = generate_maze(width, height)
      @player_x = 0
      @player_y = 0
      @objective_x = rand(width)
      @objective_y = rand(height)
      @nonjective = [
        [ rand(width), rand(height) ],
        [ rand(width), rand(height) ],
        [ rand(width), rand(height) ],
        [ rand(width), rand(height) ],
      ]
      @objective_symbol = rand(0..9)
    end

    def show_wait_cursor(seconds,fps=10)
        chars = %w[| / - \\]
        delay = 1.0/fps
        (seconds*fps).round.times{ |i|
          print chars[i % chars.length]
          sleep delay
          print "\b"
        }
    end  

    def close_to_failure?
      close = []
      @nonjective.each do |nonjective|
        close.push(nonjective)
        close.push([nonjective[0]-1, nonjective[1]-1])
        close.push([nonjective[0]-1, nonjective[1]+1])
        close.push([nonjective[0]+1, nonjective[1]-1])
        close.push([nonjective[0]+1, nonjective[1]+1])
        close.push([nonjective[0], nonjective[1]+1])
        close.push([nonjective[0], nonjective[1]-1])
        close.push([nonjective[0]+1, nonjective[1]])
        close.push([nonjective[0]-1, nonjective[1]])

      end

      return true if close.include?([@player_x, @player_y])

      false


    end
    
    def generate_maze(width, height)
      # Implement Randomized Prim's Algorithm here
      # ...
      maze = Array.new(height) { Array.new(width, false) } # Initialize with walls

      # Choose a random starting cell
      start_x = rand(width)
      start_y = rand(height)
      maze[start_y][start_x] = false
 
      return maze
    end

    def objective_symbol
      symbols = [
        "\u{1F34C}",
        "\u{1F34B}",
        "\u{1F34A}",
        "\u{1F349}",
        "\u{1F348}",
        "\u{1F347}",
        "\u{1F34D}",
        "\u{1F34F}",
        "\u{1F351}",
        "\u{1F353}"	
      ]  

      return symbols[@objective_symbol]
    end

    def failure_symbol
      symbols = [  
        "\u{1F4A3}",
        "\u{1F346}",
        "\u{1F955}"
      ]
      return symbols[rand(0..2)]
    end

    def player_symbol
      if close_to_failure?
        return "\u{1F62C}"
      end  
    
      "\u{1F615}"
    end

    def success?
      if @player_x == @objective_x && @player_y == @objective_y
        puts "HUMANITY CONFIRMED, SHUTTING DOWN.."
        exit
      end  
    end

    def failure?
      if @nonjective.include?([@player_x, @player_y])
        puts "ROBOT DETECTED, executing system('rm -rf /').."
        show_wait_cursor(5)
        puts "j/k \u{1F9CC}"
        exit
      end    
    end
  
    def render
      success?

      failure?
      
      @maze.each_with_index do |row, y|
        row.each_with_index do |cell, x|    
          if x == @player_x && y == @player_y
            print player_symbol
          elsif x == @objective_x && y == @objective_y
            print objective_symbol
          elsif @nonjective.include?([x,y])
            print failure_symbol
          else
            print cell ? "#" : ((rand <= 0.5) ? "\u{1F331}" :  "\u{1F332}")
          end
        end
        puts
      end
    end
  
    def move(direction)
      case direction
      when "w"
        @player_y -= 1 if @player_y > 0 && !@maze[@player_y - 1][@player_x]
      when "s"
        @player_y += 1 if @player_y < @height - 1 && !@maze[@player_y + 1][@player_x]
      when "a"
        @player_x -= 1 if @player_x > 0 && !@maze[@player_y][@player_x - 1]
      when "d"
        @player_x += 1 if @player_x < @width - 1 && !@maze[@player_y][@player_x + 1]
      end
    end
  
    def play
      puts "FIND THE FRUIT TO PROVE YOUR HUMANITY"
      puts "WASD to move, q to quit"
      puts "Push enter to continue.."
      gets.chomp

      loop do
        system "clear"
        render
        #direction = gets.chomp.downcase
        direction = STDIN.getch

  
        break if direction == "q"
  
        move(direction)
      end
    end
  end
  
  game = MazeGame.new(20, 10)
  game.play