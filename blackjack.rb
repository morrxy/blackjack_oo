class Deck
  SUIT = %w(S H C D)
  CARD = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  attr_accessor :cards

  def initialize
    @cards = SUIT.product(CARD)
    @cards.shuffle!
  end

end

class Player
  attr_accessor :hands, :name

  def initialize(name)
    @name = name
    @hands = []
  end

end

class Dealer
  attr_accessor :hands, :name
  def initialize(name)
    @name = 'dealer'
    @hands = []
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @deck = Deck.new
  end

  def deal
    player.hands << deck.cards.pop
    dealer.hands << deck.cards.pop
    player.hands << deck.cards.pop
    dealer.hands << deck.cards.pop

    if player_win?
      show_game
      puts 'player win'
      play_again
    end
  end

  def calculate_total(cards)
    arr = cards.map do |card|
      card[1]
    end

    total = 0
    arr.each do |x| # 2-10 J-A
      if x.to_i != 0 # 2-10
        total += x.to_i
      elsif x == 'A' # A
        total += 11
      else # J-K
        total += 10
      end
    end

    arr.count('A').times do
      total -= 10 if total > 21
    end

    total
  end

  def player_win?
    calculate_total(player.hands) == 21
  end

  def player_burst?
    calculate_total(player.hands) > 21
  end

  def dealer_win?
    calculate_total(dealer.hands) == 21
  end

  def dealer_burst?
    calculate_total(dealer.hands) > 21
  end

  def player_turn
    while true
      show_game
      puts 'What would you like to do? 1) hit 2) stay'
      hit_or_stay = gets.chomp
      unless %w(1 2).include?(hit_or_stay)
        puts 'What would you like to do? 1) hit 2) stay'
        next
      end

      if hit_or_stay == '2'
        puts "#{ player.name } stay"
        break
      end

      puts "#{ player.name } hit"
      c = deck.cards.pop
      puts "#{ player.name } got card #{ c.inspect }"

      player.hands << c

      if player_win?
        show_game
        puts 'palyer win'
        play_again
      end

      if player_burst?
        show_game
        puts 'player burst'
        play_again
      end

    end

  end

  def dealer_turn
    while true
      dealer_score = calculate_total(dealer.hands)
      if dealer_score >= 17 && dealer_score > calculate_total(player.hands)
        puts "#{ dealer.name } stay"
        break
      end

      puts "#{ dealer.name } hit"
      c = deck.cards.pop
      puts "#{ dealer.name } got card #{ c.inspect }"

      dealer.hands << c

      if dealer_win?
        show_game
        puts 'dealer win'
        play_again
      end

      if dealer_burst?
        show_game
        puts 'dealer burst'
        play_again
      end

    end
  end

  def compare_score
    p = calculate_total(player.hands)
    d = calculate_total(dealer.hands)

    show_game

    if p > d
      puts 'player win'
      return
    elsif p < d
      puts 'dealer win'
      return
    else
      puts 'draw game'
    end

  end

  def play_again
    while true
      puts 'play again? 1) yes 2) no'
      again = gets.chomp
      unless %w(1 2).include?(again)
        puts 'play again? 1) yes 2) no'
        next
      end

      exit if again == '2'

      self.deck = Deck.new
      self.player.hands = []
      self.dealer.hands = []
      self.run
    end
  end

  def show_game
    puts "#{ player.name }'s cards: #{ player.hands.inspect }"
    puts "#{ player.name }'s point: #{ calculate_total(player.hands) }"
    puts "#{ dealer.name }'s cards: #{ dealer.hands.inspect }"
    puts "#{ dealer.name }'s point: #{ calculate_total(dealer.hands) }"
  end

  def run
    puts "welcome to Blackjack! #{ player.name }"

    deal

    player_turn

    dealer_turn

    compare_score

    play_again
  end

end

player = Player.new('Hujun')
dealer = Dealer.new('dealer')
new_game = Game.new(player, dealer)
new_game.run

