#!/usr/bin/env open -a Shoes.app
Shoes.setup do
  gem 'activesupport'
  gem 'activerecord'
end
require 'database'
require 'player'
require 'score'
require 'machine'

class HighScore < Shoes
  Database.test_connect
  url "/", :index
  url "/newscore", :new_score
  url "/dashboard", :dashboard

  def high_score_stack(machine, target_stack)
    target_stack.append{para("#{machine.name} Top 5", :font => 'PC Senior', :stroke => red, :size => 20)}
    Score.top_five_scores_by_machine_id(machine.id).each do |score| 
      target_stack.append do
        flow do
          para score.player.name, :font => 'PC Senior', :stroke => turquoise
          para score.score, :font => 'PC Senior', :stroke => turquoise
        end
      end
    end
  end

  def navigation
    para link("Add a High Score", :click => "/newscore", :font => 'PC Senior', :stroke => white)
    para link("View Dashboard", :click => "/dashboard", :font => 'PC Senior', :stroke => white)
  end

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
    stack(:margin => 4) do
      flow do
        para "Name:", :font => 'PC Senior', :stroke => turquoise 
        @player_name = edit_line
      end
      flow do
        para "Machine:", :font => 'PC Senior', :stroke => turquoise
        @game_name = edit_line
      end
      flow do
        para "Score:", :font => 'PC Senior', :stroke => turquoise   
        @high_score = edit_line
      end
      @submit = button "Submit Score" 
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
    animate(1) do |frame|
      mystack.clear
      index = frame % machines.size
      high_score_stack(machines[index], mystack)
      sleep 3 unless frame == 0
    end
  end

end
Shoes.app :width => 521, :height => 665, :title => 'high score'
