
class Controller
    def initialize()
	end
    def selectHumanPlayerTile()
	#Asks the user which tile he/she wants to use
	#returns the tile selected by the user
		puts "Please select your tile : X/O"
		tiles = [ "x","o"]
		humanPlayerTile=gets.chomp.downcase
		until (tiles.include? humanPlayerTile) 
			puts 'Invalid input: please select X or O'
			humanPlayerTile=gets.chomp.downcase
		end	
		return humanPlayerTile
    end
	def selectFirstPlayer()	
	#Asks the user if he/she wants to be the first player
	#returns the player who is going to move first (User or Cpu)
		puts "Would you like to be the first player: Y/N"
		options = [ "y","n"]
		answer=gets.chomp.downcase
		until (options.include? answer) 
			puts 'Invalid input: please select Y or N'
			answer=gets.chomp.downcase
		end	
		if answer== "y"
			firstPlayer="User"
		else
			firstPlayer="Cpu"
		end
		return firstPlayer
	end
	def createNewGame(firstPlayer,humanPlayerTile)
	#Creates and returns an instance of a game 
	#assigns the tiles to the game players
	#assign the player in turn to the game 
		puts "Please select the board size"
		size=gets.chomp		
		notNumber=false
		while notNumber
			user_not_num=Integer(gets) rescue true 
			if user_not_num 
				puts "INVALID: Please select an integer value"	
			end
		end
		game = TicTacToe.new(size,firstPlayer)
		game.printBoard()
		#assigns tiles to the players and indicates to the game who is the tile of the first player moving
		if humanPlayerTile=='x'
			game.set_humanPlayer_tile('x')
			game.set_computerPlayer_tile('o')
			if firstPlayer=='User'
				game.set_playerLookAhead('x')
			else
				game.set_playerLookAhead('o')
			end
		else
			game.set_humanPlayer_tile('o')
			game.set_computerPlayer_tile('x')
			if firstPlayer== 'User'
				game.set_playerLookAhead('o')
			else
				game.set_playerLookAhead('x')
			end
		end
		return game
	end
	def play(game)
	#Assigns the correspondent tile to each player
	#Updates the playerLookAhead for the game, which is the variable to control who is playing ('x'  or 'o')
	#creates a loop to play until the game is over, alternating the players (cpu and human player)		
		
		#game.give_turn_computer()
		
		#Kernel.exit(false)
		
		until (game.gameOver() == true) 
			puts "\r"
			puts "Turn : #{game.playerInTurn}"
			if game.playerInTurn=='User'
				game.give_turn_human()
			else
				game.give_turn_computer()
			end
			game.assignNextPlayer()
			game.printBoard()
			game.changePlayer()
		end	
		puts 'Winner: '+game.getWinnerPlayer()
		
	end
end

class Game
  attr_accessor :board  
  attr_accessor :playerInTurn
  #attr_accessor :playerLookAhead
  attr_accessor :humanPlayer
  attr_accessor :computerPlayer
  attr_accessor :boardSize
 
  
  
	def initialize(size, playerInTurn)
		@boardSize=size  
		@board = Array.new(Integer(size)) { Array.new(Integer(size)) { '_' } }
		@playerLookAhead=''
		@playerInTurn=playerInTurn
		@winnerPlayer=''
		@humanPlayer = HumanPlayer.new()
		@computerPlayer = ComputerPlayer.new()
    end
	def gameOver()
	#checks if the game is over
	#returns true or false 
	end
	def changePlayer()
	#switch playerInTurn between USER and CPU
	#playerInTurn is used to control who's turn is	
		if @playerInTurn=='User'
			@playerInTurn='Cpu'
		else
			@playerInTurn='User'
		end
	end
	def assignNextPlayer
	#modfies the playerlookAhead value 
	end
	def printBoard()
	#prints the 2 dimensional array that represents the game board
		 @board.each do |r|
			 puts r.each { |p| p }.join(" ")
		 end
	 end
	def give_turn_human()
		row,column =@humanPlayer.getMove(self, @board,@boardSize)
		humanPlayer.makeMove(self,[row, column])
		
	end
	def give_turn_computer()
	
		row,column,bestV =@computerPlayer.getMove(self)
		computerPlayer.makeMove(self,[row, column])
		
	end
	def set_board(board)
		@board=board
	end
	def set_playerInTurn(playerInTurn)
		@playerInTurn=playerInTurn
	end
	def set_playerLookAhead(playerLookAhead)
		@playerLookAhead=playerLookAhead
	end
	def get_LookAheadPlayer()
	# puts "winner generic"	
		return @playerLookAhead
	end
	def getWinnerPlayer()
		return @winnerPlayer
	end
	end

class TicTacToe < Game
	def gameOver()
	#Game will be over if:
	#1-the last player who moved completed a line (horizontal, vertical or diagonal)
	#2-board is full
		@winnerPlayer='none'
		tilesInLine=0
		gameOver=false
		actions=["fullBoard","horizontal", "vertical", "rightDiagonal", "leftDiagonal"]
		for i in 0...5
			if gameOver == true
				break
			end
			case actions[i]
			when "fullBoard"
				full=true
				@board.each do |element|
					element.each do |innerElement|
						if innerElement=='_'
							full=false
						end
					end
				end
				if full
					#puts 'full board'
					#printBoard()
					gameOver=true
					lastPlayer='none'					
				end
			when "horizontal"

				@board.each do |element|				
					if checkArray(element) ==true && element[0]!= '_'
						#puts '1'
						gameOver = true
						lastPlayer=element[0]
					end 
				 end
			when "vertical"
				transposeBoard=@board.transpose
				transposeBoard.each do |element|
					if checkArray(element) ==true && element[0]!= '_'
						#puts 'win'
						#puts '2'
						gameOver = true
						lastPlayer=element[0]
					end 
				 end
			when "rightDiagonal"
				rightDiag= (0..Integer(@boardSize)-1).collect { |i| @board[i][i] }
				if checkArray(rightDiag) ==true && rightDiag[0]!= '_'
					#puts '3'
					gameOver = true
					lastPlayer=rightDiag[0]
				end 
			when "leftDiagonal"
				reversedBoard=@board.reverse
				leftDiag= (0..Integer(@boardSize)-1).collect { |i| reversedBoard[i][i] }
				if checkArray(leftDiag) ==true && leftDiag[0]!= '_'
					#puts '4'
					gameOver = true
					lastPlayer=leftDiag[0]
				end 
			end
		end
		if gameOver==true
			#printBoard()
			#puts @playerLookAhead
			#Kernel.exit(false)
			@winnerPlayer=lastPlayer
			
		end
		return gameOver
			
	end
	def assignNextPlayer
	#modfies the playerlookAhead value 
	#puts 'changng player'
		if @playerLookAhead == 'x' 
			@playerLookAhead='o'
		else 
			@playerLookAhead='x'
		end
	end	
	def checkArray(array)
	#checks if all the elements in the array have the same value to determine if its a win line
		if array.all? {|x| x == array[0]} == true
			return true
		else
			return false
		end 
	end		
	def set_humanPlayer_tile(tile)
		@humanPlayer.set_tile(tile)
	end
	def set_computerPlayer_tile(tile)
		@computerPlayer.set_tile(tile)
	end
end

class Player
	def initialize()
		@tile=''
    end
	
	def getMove(game,board,boardSize)
	#returns the move to be done
	puts 'calling general getMove() method'
	end
	
	def makeMove(game, move)
	#alters the board with a move
	#modifies the board with the move
	#the move consists of an array with the row and column 
		game.board[move[0]][move[1]]=game.get_LookAheadPlayer
		
	end
	def unMakeMove(game,move)
	#restores  the board with to the state it was before the move
	#the move consists of an array with the row and column 
		game.board[move[0]][move[1]]='_'
	end
	
	def set_tile(tile)
		@tile=tile
	end
	
	def get_tile
		return @tile
	end
end

class HumanPlayer < Player

	def getMove(game, board, boardSize)
	#returns the move frrom users input  (row and column)
		row=-1
		column=-1
		puts "Please select a row"
		row=Integer(gets.chomp)
		puts "Please select a column"
		column=Integer(gets.chomp)
		
		#validates that row and column are withing the boudaries 
		while row >= Integer(boardSize) || column >= Integer(boardSize)
			puts "INVALID MOVE: please consider the board dimension: #{boardSize} * #{boardSize}"
			puts "Please select a row"
			row=Integer(gets.chomp)
			puts "Please select a column"
			column=Integer(gets.chomp)
		end
		#validates that the position selected is empty
		while board[Integer(row)][Integer(column)]!='_' 
			puts "INVALID MOVE: please select an empty space"
			puts "Please select a row"
			row=Integer(gets.chomp)
			puts "Please select a column"
			column=Integer(gets.chomp)
		end	
		return row, column
	end
	
end

class ComputerPlayer < Player
	def getMove(game)
	#returns the move to be done by AI algorithm (row column)
		row=-1
		column=-1
		puts 'CPU thinking...'
		bestV, bestM= negamax(game, 7)
		row,column=bestM		
		return row, column,bestV
	end

	def negamax(game, depthLeft)
		#If at terminal state or depth limit, return utility value and move None
		if game.gameOver() || depthLeft == 0
			return getUtility(game), nil # call to negamax knows the move
		end
		bestValue, bestMove = nil, nil
		
		for move in getValidMoves(game)
			makeMove(game,move)
			game.assignNextPlayer
			value, _ = negamax(game,depthLeft-1)
			unMakeMove(game,move)
			game.assignNextPlayer
			if value == nil
				next 
			end
			value =- value
			if bestValue == nil || value > bestValue
				#Value for this move is better than moves tried so far from this state.
				bestValue, bestMove = value, move
			end
		end
		
		return bestValue, bestMove
	end
	
	def getValidMoves(game)
	#return the valid moves for a given state of the game
	moves = []
	for i in 0...Integer(game.boardSize)
		for j in 0...Integer(game.boardSize)
			 if game.board[i][j]== '_'
				sub= [i,j]
				moves.push sub
			 end
		 end
	 end
	return moves
	end
	
	
	def getUtility(game)
	#puts 'tile'
	#puts @tile
	utility=''
		case game.getWinnerPlayer
			when 'x'
			#puts 'winner x'
			#game.printBoard()
			
				case @tile
					when 'x'
						if game.get_LookAheadPlayer()=='x'
							utility=1
						else
							utility=-1
						end
					when 'o'
						if game.get_LookAheadPlayer()=='o'
							utility=1
						else
							utility=-1
						end
				end
				#puts utility
				#Kernel.exit(false)
			
			when 'o'
			#puts 'winner o'
			#game.printBoard()
			#Kernel.exit(false)
				case @tile
					when 'x'
						if game.get_LookAheadPlayer()=='x'
							utility=1
						else
							utility=-1
						end
					when 'o'
						if game.get_LookAheadPlayer()=='o'
							utility=1
						else
							utility=-1
						end
				end
				#puts utility
				#Kernel.exit(false)
			
			when 'none'
				#puts 'returning nil '
				#game.printBoard()
				#Kernel.exit(false)
				utility=nil
			else
				puts 'utility 0'
				game.printBoard()
				Kernel.exit(false)
				utility=0
			end
		return utility	
		end
	
	end
	
	
	
	


controller = Controller.new()
humanPlayerTile=controller.selectHumanPlayerTile()
firstPlayer=controller.selectFirstPlayer()
game=controller.createNewGame(firstPlayer,humanPlayerTile) 
controller.play(game)


