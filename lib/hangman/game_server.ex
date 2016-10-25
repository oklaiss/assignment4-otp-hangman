defmodule Hangman.GameServer do

	use GenServer

	@me :game_server

	alias Hangman.Game, as: Game
	alias Hangman.Dictionary, as: Dictionary

	def start_link do
		GenServer.start_link(__MODULE__, Game.new_game, name: @me)
	end

	def start_link(word) do
		GenServer.start_link(__MODULE__, Game.new_game(word), name: @me)
	end


	# Game Server API Implementation (as defined in Game.ex)

	# def new_game(word \\ Dictionary.random_word) do
	# 	GenServer.cast @me, { :newGame, word }
	# end

	def make_move(guess) do
		GenServer.call(@me, { :make_move, guess })
	end

	def word_length do
		GenServer.call(@me, { :word_length })
	end

	def letters_used_so_far do
		GenServer.call(@me, { :letters_used })
	end

	def turns_left do
		GenServer.call(@me, { :turns_left }
	end

	def word_as_string(reveal \\ false) do
		GenServer.call(@me, { :word_as_string, reveal })
	end

	def crash(exit_code) do
		GenServer.cast(@me, { :crash, exit_code })
	end


	# Server Implementation

	def init(word) do
		{:ok, Game.new_game(word)}
	end

	def handle_call({ :make_move, guess }, _from, state) do
		{:reply, Game.word_as_string(state, reveal), state}
	end

	def handle_call({ :word_length }, _from, state) do
		{:reply, Game.word_length(state), state}
	end

	def handle_call({ :letters_used }, _from, state) do
		{:reply, Game.letters_used_so_far(state), state}
	end

	def handle_call({ :word_as_string, reveal }, _from, state) do
		{:reply, Game.word_as_string(state, reveal), state}
	end

	def handle_cast({ :crash, exit_code }, _from, state) do
		{:stop, exit_code, state}
	end

end