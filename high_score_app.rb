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
  
  def high_score_stack(machine)
      flow{para("#{machine.name} Top 5", :font => 'PC Senior', :stroke => red, :size => 20)}
      scores = Score.find_all_by_machine_id(machine.id, :order => "score").reverse
      scores[0..4].each do |score| 
        flow{
          para score.player.name, :font => 'PC Senior', :stroke => turquoise
          para score.score, :font => 'PC Senior', :stroke => turquoise
        }
      end
  end
  
  def index
    background "static/background.png"
    stack{para link("Add a High Score", :click => "/newscore", :font => 'PC Senior', :stroke => white)}
    machines = Machine.find(:all)
    machines.each do |machine|
      high_score_stack(machine)
    end
  end

  def new_score
    background "static/background.png"
    stack(:margin => 4) {
      flow {
        para "Name:", :font => 'PC Senior', :stroke => turquoise 
        @player_name = edit_line
      }
      flow {
        para "Machine:", :font => 'PC Senior', :stroke => turquoise
        @game_name = edit_line
      }
      flow {
        para "Score:", :font => 'PC Senior', :stroke => turquoise   
        @high_score = edit_line
      }
      @submit = button "Submit Score" 
    }
    @submit.click {
      player = Player.find_or_create_by_name(@player_name.text)
      score = Score.new(:score => @high_score.text)
      machine = Machine.find_or_create_by_name(@game_name.text)
      score.save
      player.score << score
      machine.score << score
      player.save
      machine.save
      visit "/"
    }
  end

  end
Shoes.app :width => 521, :height => 665, :title => 'high score'
