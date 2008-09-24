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
  Database.test_connect
  
  def index
    starfield_background
    navigation
    content = stack(:margin => 4)
    overall_score_stack(content)
  end

  def new_score
    starfield_background
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
    {:font => FONT, :stroke => red, :align => "center"}
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
      #para "HI SCORE", red_centered
      #top = Player.sorted_overall_scores[0]
      #if (!top.nil) then 
      #  para "#{top.overall_score}", red_centered 
      #end
      banner "MonkeyFarm Arcade Classic", turq_centered
      image("static/kong.png", :margin_left => "45%")
      para link("Add a High Score", white_centered.with(:click, "/newscore"))
      para link("Add a Grudge Match Score", white_centered.with(:click, "/newgrudge"))
      para link("View Dashboard", white_centered.with(:click, "/dashboard"))
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
      fill rgb rand(255), rand(255), rand(255)
      @starfield[index] = oval :top=> rand(768), :left => rand(1024), :radius => 2
    end  
  end
  
  def animate_starfield
    animate(12) do
      @starfield.each do |star|
        #at the bottom of the screen, pick a new spot on top
        if(star.top > 768) 
          star.left = rand(1024) 
        end
        #fall
        star.top = star.top%768+5
      end
    end
  end
  
end
Shoes.app :width => 1024, :height => 768, :title => 'high score'
