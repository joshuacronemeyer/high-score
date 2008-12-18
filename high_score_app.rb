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
  url "/players", :players
  url "/unplayed", :games_i_need_to_play
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
      para "Name:", turquoise_style
      para "Machine:", turquoise_style
      para "Score:", turquoise_style
    end
    stack :width => "70%", :margin_left => 5, :margin_top => 5 do
      @player_name = list_box :items => helper.get_player_names
      @player_name.choose("<Select>");
      @game_name = list_box :items => helper.get_machine_names
      @game_name.choose("<Select>");
      @high_score = edit_line
      @submit = button "Submit Your Score" 
      @submitAnother = button "Submit + Add Another"
    end
    @submit.click do
      Score.add_high_score(@player_name.text, @game_name.text, @high_score.text)
      visit "/"
    end
    @submitAnother.click do
      Score.add_high_score(@player_name.text, @game_name.text, @high_score.text)
      @player_name.choose("<Select>");
      @game_name.choose("<Select>");
      @high_score.text = ''
      submitAnother
    end
  end

  def games_i_need_to_play
    background black
    navigation
    helper = HighScoreAppHelper.new
    stack :width => "30%", :margin_left => 5, :margin_top => 5 do
      para "Name:", turquoise_style
    end
    stack :width => "70%", :margin_left => 5, :margin_top => 5 do
      @player_name = list_box :items => helper.get_player_names
    end
    @submit = button "Search"
    mystack = stack
    @submit.click do
      mystack.clear
      me = Player.find_by_name(@player_name.text)
      mystack.append do
        me.unplayed_games.each{|machine| para machine.name, turquoise_style}
      end
    end
  end

  def new_machine
    background black
    navigation
    stack :width => "30%", :margin_left => 5 do
      para "Machine:", turquoise_style
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
      para "Player Name:", turquoise_style
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
    helper = HighScoreAppHelper.new
    stack :width => "50%", :margin_left => 10, :margin_top => 10 do
      para "Winner:", turquoise_style
      para "Loser:", turquoise_style
      para "Machine:", turquoise_style
    end
    stack :width => "-50%", :margin => 10 do
      @winner_name = list_box :items => helper.get_player_names
      @winner_name.choose("<Select>");
      @loser_name = list_box :items => helper.get_player_names
      @loser_name.choose("<Select>");
      @grudge_machine = list_box :items => helper.get_machine_names
      @grudge_machine.choose("<Select>");
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
      banner "MonkeyFarm Arcade Classic", @dash.turquoise_style
      image("static/kong.png", :margin_left => "45%")
      stack :margin_left => 10, :margin_top => 10 do
        para "Machines:", @dash.turquoise_style
        flow do
          machines = Machine.all().sort.each do |machine|
            stack :width => "50%" do
              para machine.name, @dash.red_style
              machine.score.sort.each do |score|
                para "%10s" % "#{score.player.name} - " + "%12s" % "#{score.formatWithComma.to_s}", @dash.turquoise_style
              end
            end
          end
        end
      end
    end
    visit "/"
  end
  
  def players
    window :width => 1024, :height => 768, :title => 'high score' do
      @dash ||= DashboardWindow.new(self)
      background black
      banner "MonkeyFarm Arcade Classic", @dash.turquoise_style
      image("static/kong.png", :margin_left => "45%")
      stack :margin_left => 10, :margin_top => 10 do
        para "Players:", @dash.turquoise_style
        players = Player.all().each do |player|
          para player.name, @dash.red_style
          player.score.sort{|a,b| a.machine.name <=> b.machine.name}.each do |score|
            para "#{score.machine.name} - #{score.formatWithComma}", @dash.turquoise_style
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
      banner "MonkeyFarm Arcade Classic", @dash.turquoise_style
      image("static/kong.png", :margin_left => "45%")
      machines = Machine.find(:all)
      mystack = stack
      helper = HighScoreAppHelper.new
      every(10) do |frame|
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
  def red_style
    {:stroke => red, :font => FONT, :align => "center"}
  end

  def turquoise_style
    {:stroke => turquoise, :font => FONT, :align => "center"}
  end

  def white_style
    {:stroke => white, :font => FONT, :align => "center"}
  end

  def navigation
    stack do
      para link("Add a High Score", :click => "/newscore"), white_style
      para link("Add a Grudge Match Score", :click => "/newgrudge"), white_style
      para link("Add Machine", :click => "/newmachine"), white_style
      para link("Add Player", :click => "/newplayer"), white_style
      para link("What to Play?", :click => "/unplayed"), white_style
      para link("View Machines", :click => "/machines"), white_style
      para link("View Dashboard", :click => "/dashboard"), white_style
      para link("View Players", :click => "/players"), white_style
    end
  end

end

class DashboardWindow
  FONT = 'PC Senior'
  def initialize(shoes)
    @shoes=shoes 
  end

  def turquoise_style
    {:stroke => turquoise, :font => FONT, :align => "center"}
  end
  def red_style
    {:stroke => red, :font => FONT, :align => "center"}
  end
  def white_style
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
      target_stack.append{para("#{machine.name} Grudge Matches", red_style.with(:size,20))}
      machine.grudge_match.each do |match| 
        target_stack.append do
          para "W: #{match.winner.name} - L: #{match.loser.name}", turquoise_style
        end
      end
    else 
      target_stack.append{para("#{machine.name} Top 5", red_style.with(:size,20))}
      Score.top_five_scores_by_machine_id(machine.id).each do |score| 
        target_stack.append do
          para "#{score.player.name} - #{score.formatWithComma}", turquoise_style
        end
      end
    end
  end

  def overall_score_stack(target_stack)
    time = Time.now
    target_stack.append do
      para("Overall High Scores", red_style.with(:size, 20))
      Player.sorted_overall_scores.each do |player|
        para("#{player.name} - " + "%3d" % player.overall_score + " - " + "%2.1f" % player.ppg + " ppg", turquoise_style)
      end
    end
    debug("TODO: speed this up.  old average is 3.14 seconds for prod data.  New time is: " + (Time.now - time).to_s)
  end

  def method_missing(meth, *args, &block)
    @shoes.send(meth, *args, &block)
  end
end

Shoes.app :width => 400, :height => 400, :title => 'high score'
