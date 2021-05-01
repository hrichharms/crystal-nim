
# game over function
def game_over(piles)
    return piles.count(0) == piles.size
end

# get array of legal moves from a given position
def get_moves(piles)
    moves = Array(Tuple(Int32, Int32)).new
    piles.size.times do |i|
        piles[i].times do |j|
            moves.push({i, j + 1})
        end
    end
    return moves
end

# return a new piles array with the given move performed
def perform_move(piles, move)
    new_piles = piles.clone
    new_piles[move[0]] -= move[1]
    return new_piles
end

# check if a position is optimal
def is_optimal(piles, optimizer)
    # if the optimizer has won
    if game_over(piles)
        return optimizer
    end

    if optimizer
        optimal = false
        get_moves(piles).each do |move|
            optimal = optimal | is_optimal(perform_move(piles, move), !optimizer)
        end
    else
        optimal = true
        get_moves(piles).each do |move|
            optimal = optimal & is_optimal(perform_move(piles, move), !optimizer)
        end
    end
    return optimal
end

# get optimal move from a given position
def get_optimal(piles)
    get_moves(piles).each do |move|
        if is_optimal(perform_move(piles, move), false)
            return move
        end
    end
    return {0, 0}
end

# get number of piles
print "Number of piles: "
n = gets.not_nil!.to_i

# initialize piles array
piles = Array.new(n, 0)

# get pile sizes
n.times do |i|
    print "Initial size of pile #{i}: "
    piles[i] = gets.not_nil!.to_i
end

# get starting player
print "Starting player (0 for cpu, anything else for user): "
cpu_turn = gets.not_nil!.to_i == 0

# play game
puts piles
while !game_over(piles)
    if cpu_turn
        move = get_optimal(piles)
        puts "CPU taking #{move[1]} from pile #{move[0]}!"
        piles = perform_move(piles, move)
    else
        print "Move (<pile index> <amount>): "
        move_arr = gets.not_nil!.split(" ")
        move = {move_arr[0].to_i, move_arr[1].to_i}
        piles = perform_move(piles, move)
    end
    puts piles
    cpu_turn = !cpu_turn
end

if cpu_turn
    puts "User Wins!"
else
    puts "CPU Wins!"
end
