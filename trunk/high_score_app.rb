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
require 'high_score_app_helper'

class HighScore < Shoes
  FONT = 'PC Senior'
  url "/", :index
  url "/newscore", :new_score
  url "/dashboard", :dashboard
  url "/newgrudge", :new_grudge
  url "/newmachine", :new_machine
  url "/newplayer", :new_player
  url "/machines", :machines
  Database.connect
  
  def index
    starfield_background
    navigation
    content = stack(:margin => 4)
    overall_score_stack(content)
  end

  def new_score
    window :height => 200, :width => 500 do
      background black
      helper = HighScoreAppHelper.new
      stack :width => "30%", :margin_left => 5, :margin_top => 5 do
        para "Name:", {:stroke => turquoise, :font => FONT, :align => "center"}
        para "Machine:", {:stroke => turquoise, :font => FONT, :align => "center"}
        para "Score:", {:stroke => turquoise, :font => FONT, :align => "center"}
      end
      stack :width => "70%", :margin_left => 5, :margin_top => 5 do
        @player_name = list_box :items => helper.get_player_names
        @game_name = list_box :items => helper.get_machine_names
        @high_score = edit_line
        @submit = button "Submit Your Score" 
      end
      @submit.click do
        Score.add_high_score(@player_name.text, @game_name.text, @high_score.text)
        close    
      end
    end
    visit "/"
  end

  def new_machine
    starfield_background
    navigation
    stack :width => "80%", :top => 200 do
      stack :width => "20%", :margin_top => 10, :top => 20 do
        para "Machine:", turq_centered
      end
      stack :width => "80%", :margin_top => 10, :top => 20 do
        @game_name = edit_line
        @submit = button "Save" 
      end
    end
    @submit.click do
      machine = Machine.create(:name => @game_name.text)
      machine.save
      visit "/" 
    end
  end
  
  def new_player
    starfield_background
    navigation
    stack :width => "80%", :top => 200 do
      stack :width => "20%", :margin_top => 10, :top => 20 do
        para "Player Name:", turq_centered
      end
      stack :width => "80%", :margin_top => 10, :top => 20 do
        @player_name = edit_line
        @submit = button "Save" 
      end
    end
    @submit.click do
      player = Player.create(:name => @player_name.text)
      player.save
      visit "/" 
    end
  end

  def new_grudge
    starfield_background
    navigation
    stack :width => "50%", :margin_left => 10, :margin_top => 10 do
        para "Winner:", turq_centered
        para "Loser:", turq_centered
        para "Machine:", turq_centered
    end
    stack :width => "-50%", :margin => 10 do
        @winner_name = edit_line
        @loser_name = edit_line
        @grudge_machine = edit_line
        @submit = button "Submit Your Match" 
    end
    @submit.click do
      GrudgeMatch.add_score(@winner_name.text, @loser_name.text, @grudge_machine.text)
      visit "/" 
    end
  end

  def new_vs_score
    starfield_background
    navigation
    stack :width => "50%", :margin_left => 10, :margin_top => 10 do
        para "Winner:", turq_centered
        para "LOSER!:", turq_centered
        para "Machine:", turq_centered
    end
    stack :width => "-50%", :margin => 10 do
        @winner = edit_line
        @loser = edit_line
        @vs_game_name = edit_line
        @vs_submit = button "Submit Your Score" 
    end
    @vs_submit.click do
      VsScore.add_score(@winner.text, @loser.text, @vs_game_name.text)
      visit "/" 
    end
  end
  
  def machines
    starfield_background
    navigation
    stack :margin_left => 10, :margin_top => 10 do
      para "Machines:", turq_centered
      machines = Machine.all().each do |machine|
        para machine.name, red_centered
        machine.score.each do |score|
          para "#{score.player.name} - #{score.score}", turq_centered
        end
      end
    end
  end

  def dashboard
    starfield_background
    navigation
    machines = Machine.find(:all)
    mystack = stack
    helper = HighScoreAppHelper.new
    every(1) do |frame|
      mystack.clear
      helper.increment_machine_index_based_on_frame(frame, machines)
      if helper.display_overall?(frame)
        overall_score_stack(mystack) 
      else
        high_score_stack(machines[helper.index], mystack)
      end
    end
  end
  
  private
  def high_score_stack(machine, target_stack)
    return if machine.nil?
    if machine.is_grudge_match_machine?
      target_stack.append{para("#{machine.name} Grudge Matches", red_centered.with(:size,20))}
      machine.grudge_match.each do |match| 
        target_stack.append do
          para "W: #{match.winner.name} - L: #{match.loser.name}", turq_centered
        end
      end
    else 
      target_stack.append{para("#{machine.name} Top 5", red_centered.with(:size,20))}
      Score.top_five_scores_by_machine_id(machine.id).each do |score| 
        target_stack.append do
          para "#{score.player.name} - #{score.score}", turq_centered
        end
      end
    end
  end

  def overall_score_stack(target_stack)
    target_stack.append do
      para("Overall High Scores", red_centered.with(:size, 20))
      Player.sorted_overall_scores.each do |player|
        para("#{player.name} - #{player.overall_score} - #{player.ppg} ppg", turq_centered)
      end
    end
  end

  def red_centered
    {:stroke => red, :font => FONT, :align => "center"}
  end

  def turq_centered
    {:stroke => turquoise, :font => FONT, :align => "center"}
  end

  def white_centered
    {:stroke => white, :font => FONT, :align => "center"}
  end

  def navigation
    stack do
      banner "MonkeyFarm Arcade Classic", turq_centered
      image("static/kong.png", :margin_left => "45%")
      para link("Add a High Score", :click => "/newscore"), white_centered
      para link("Add a Grudge Match Score", :click => "/newgrudge"), white_centered
      para link("View Dashboard", :click => "/dashboard"), white_centered
      para link("Add Machine", :click => "/newmachine"), white_centered
      para link("Add Player", :click => "/newplayer"), white_centered
      para link("View Machines", :click => "/machines"), white_centered
    end
  end
  
  def starfield_background
    background black
    init_starfield
    animate_starfield
  end
  
  
  def init_starfield
    @starfield = Array.new
    50.times do |index|
      distance = (rand(3)+rand(3)+rand(3)+2)
      #brighter stars are closer, faster
      fill rgb bright(distance), bright(distance), bright(distance)
      @starfield[index] = oval :top=> rand(parent.height), :left => rand(parent.width), :radius => 2, :velocity=>distance
    end  
  end
  
  def animate_starfield
    animate(12) do
      @starfield.each do |star|
        #at the bottom of the screen, pick a new spot on top
        if(star.top > parent.height) 
          star.left = rand(parent.width) 
        end
        #fall
        star.top = star.top%parent.height+star.style[:velocity]
        #twinkle
      end
    end
  end
  
  def bright(distance)
    (rand(222)+32)*distance/10
  end
  
end
Shoes.app :width => 1024, :height => 768, :title => 'high score'
