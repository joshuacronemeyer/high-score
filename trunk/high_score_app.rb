#!/usr/bin/env open -a Shoes.app
Shoes.setup do
  gem 'activesupport'
  gem 'activerecord'
end
require 'database'
require 'player'
require 'score'
require 'machine'
require 'new_hash'

class HighScore < Shoes
  FONT = 'PC Senior'
  url "/", :index
  url "/newscore", :new_score
  url "/dashboard", :dashboard
  Database.test_connect
  
  def index
    background "static/background.png"
    navigation
    content = stack(:margin => 4)
    Machine.find(:all).each do |machine|
      high_score_stack(machine, content)
    end
  end

  def new_score
    background "static/background.png"
    navigation
    stack :width => "50%", :margin_left => 10, :margin_top => 10 do
        para "Name:", turq_centered
        para "Machine:", turq_centered
        para "Score:", turq_centered
    end
    stack :width => "-50%", :margin => 10 do
        @player_name = edit_line
        @game_name = edit_line
        @high_score = edit_line
        @submit = button "Submit Your Score" 
    end
    @submit.click do
      Score.add_high_score(@player_name.text, @game_name.text, @high_score.text)
      visit "/" 
    end
  end

  def dashboard
    background "static/background.png"
    navigation
    machines = Machine.find(:all)
    mystack = stack
    index = -1
    animate(1) do |frame|
      mystack.clear
      index += 1 if (frame % 3 == 0)
      index %= machines.size
      high_score_stack(machines[index], mystack)
    end
  end
  
  private
  def high_score_stack(machine, target_stack)
    target_stack.append{para("#{machine.name} Top 5", :font => FONT, :stroke => red, :size => 20, :align => "center")}
    Score.top_five_scores_by_machine_id(machine.id).each do |score| 
      target_stack.append do
          para "#{score.player.name} - #{score.score}", turq_centered
      end
    end
  end

  def turq_centered
    #TODO Could do some cool DSL type stuff so i could type turq.centered
    {:stroke => turquoise, :font => FONT, :align => "center"}
  end

  def white_centered
    {:font => FONT, :stroke => white, :align => "center"}
  end

  def navigation
    stack do
      banner "MonkeyFarm Arcade Classic", turq_centered
      image("static/kong.png", :margin_left => "45%")
      para link("Add a High Score", white_centered.with(:click, "/newscore"))
      para link("View Dashboard", white_centered.with(:click, "/dashboard"))
      para link("Index", white_centered.with(:click, "/"))
    end
  end

end
Shoes.app :width => 1024, :height => 768, :title => 'high score'
