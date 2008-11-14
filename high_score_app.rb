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
    background black
    navigation
  end

  def new_score
    background black
    navigation
    helper = HighScoreAppHelper.new
    stack :width => "30%", :margin_left => 5, :margin_top => 5 do
      para "Name:", turq_centered
      para "Machine:", turq_centered
      para "Score:", turq_centered
    end
    stack :width => "70%", :margin_left => 5, :margin_top => 5 do
      @player_name = list_box :items => helper.get_player_names
      @game_name = list_box :items => helper.get_machine_names
      @high_score = edit_line
      @submit = button "Submit Your Score" 
    end
    @submit.click do
      Score.add_high_score(@player_name.text, @game_name.text, @high_score.text)
      visit "/"
    end
  end

  def new_machine
    background black
    navigation
    stack :width => "30%", :margin_left => 5 do
      para "Machine:", turq_centered
    end
    stack :width => "70%" do
      @game_name = edit_line
      @submit = button "Save" 
    end
    @submit.click do
      machine = Machine.create(:name => @game_name.text)
      machine.save
      visit "/"
    end
  end

  def new_player
    background black
    navigation
    stack :width => "30%", :margin_left => 5 do
      para "Player Name:", turq_centered
    end
    stack :width => "70%" do
      @player_name = edit_line
      @submit = button "Save" 
    end
    @submit.click do
      player = Player.create(:name => @player_name.text)
      player.save
      visit "/" 
    end
  end

  def new_grudge
    background black
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

  def machines
    window :width => 1024, :height => 768, :title => 'high score' do
      @dash ||= DashboardWindow.new(self)
      background black
      banner "MonkeyFarm Arcade Classic", @dash.turq_centered
      image("static/kong.png", :margin_left => "45%")
      stack :margin_left => 10, :margin_top => 10 do
        para "Machines:", @dash.turq_centered
        machines = Machine.all().each do |machine|
          para machine.name, @dash.red_centered
          machine.score.sort.each do |score|
            para "#{score.player.name} - #{score.formatWithComma}", @dash.turq_centered
          end
        end
      end
    end
    visit "/"
  end

  def dashboard
    window :width => 1024, :height => 768, :title => 'high score' do
      @dash ||= DashboardWindow.new(self)
      @dash.starfield_background
      banner "MonkeyFarm Arcade Classic", @dash.turq_centered
      image("static/kong.png", :margin_left => "45%")
      machines = Machine.find(:all)
      mystack = stack
      helper = HighScoreAppHelper.new
      every(5) do |frame|
        mystack.clear
        helper.increment_machine_index(machines)
        if helper.display_overall?(frame)
          @dash.overall_score_stack(mystack) 
        else
          @dash.high_score_stack(machines[helper.index], mystack)
        end
      end
    end
    visit "/"
  end

  private
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
      para link("Add a High Score", :click => "/newscore"), white_centered
      para link("Add a Grudge Match Score", :click => "/newgrudge"), white_centered
      para link("View Dashboard", :click => "/dashboard"), white_centered
      para link("Add Machine", :click => "/newmachine"), white_centered
      para link("Add Player", :click => "/newplayer"), white_centered
      para link("View Machines", :click => "/machines"), white_centered
    end
  end

end

class DashboardWindow
  FONT = 'PC Senior'
  def initialize(shoes)
    @shoes=shoes 
  end

  def turq_centered
    {:stroke => turquoise, :font => FONT, :align => "center"}
  end
  def red_centered
    {:stroke => red, :font => FONT, :align => "center"}
  end
  def white_centered
    {:stroke => white, :font => FONT, :align => "center"}
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
      @starfield[index] = oval :top=> rand(@shoes.height), :left => rand(@shoes.width), :radius => 2, :velocity=>distance
    end  
  end

  def animate_starfield
    animate(12) do
      @starfield.each do |star|
        #at the bottom of the screen, pick a new spot on top
        if(star.top > @shoes.height) 
          star.left = rand(@shoes.width) 
        end
        #fall
        star.top = star.top % @shoes.height+star.style[:velocity]
        #twinkle
      end
    end
  end

  def bright(distance)
    (rand(222)+32)*distance/10
  end

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
          para "#{score.player.name} - #{score.formatWithComma}", turq_centered
        end
      end
    end
  end

  def overall_score_stack(target_stack)
    time = Time.now
    target_stack.append do
      para("Overall High Scores", red_centered.with(:size, 20))
      Player.sorted_overall_scores.each do |player|
        para("#{player.name} - #{player.overall_score} - #{player.ppg} ppg", turq_centered)
      end
    end
    #debug("TODO: speed this up.  old average is 3.14 seconds for prod data.  New time is: " + (Time.now - time))
  end

  def method_missing(meth, *args, &block)
    @shoes.send(meth, *args, &block)
  end
end

Shoes.app :width => 400, :height => 400, :title => 'high score'
