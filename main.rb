require 'wavefile'
include WaveFile

require 'colorize'
require 'colorized_string'

require 'tty-prompt'
require 'tty-font'


require_relative "class/samples-op"
require_relative "class/music-note"
require_relative "class/track-instructions"
require_relative "module/instructions-to-track"

require_relative "module/print-with-pause"

class Main
  attr_reader :default_samples_drum, :default_samples_bass, :default_samples_melodic, :default_samples
  attr_reader :SAMPLES_PER_BUFFER
  attr_reader :default_bpm
  def initialize
    @default_samples_drum = [ # if pwd is the main folder
      "audio-samples/lib-drum/sample1.wav",
      "audio-samples/lib-drum/sample2.wav",
      "audio-samples/lib-drum/sample3.wav"
    ]
    
    @default_samples_bass = [
      "audio-samples/lib-bass/sample1.wav",
      "audio-samples/lib-bass/sample2.wav",
      "audio-samples/lib-bass/sample3.wav"
    ]
  
    @default_samples_melodic = [
      "audio-samples/lib-melodic/sample1.wav",
      "audio-samples/lib-melodic/sample2.wav",
      "audio-samples/lib-melodic/sample3.wav"
    ]

    @default_samples = [@default_samples_drum, @default_samples_bass, @default_samples_melodic]
    @default_bpm = 120

    String.disable_colorization = false
    @SAMPLES_PER_BUFFER = 4096


  end


  def text2track(str, output_filename = "export1.wav", sample_files, bpm) # test for translating text to track

    op = SamplesOP.new
    # test_str = "s--s s-ss fd-- fd-- h-ss j-ddsds-ss"
    # test_str = str
    text_to_notes = TextToNotes.new
    eff_str = text_to_notes.string_to_effective_simple(str)
    instr_names = text_to_notes.effective_simple_map(str)
    # p instr_names
    instr = TrackInstructions.new(bpm, instr_names)
    # p instr.array_instructions
    # p output_filename
    # p sample_files
    
    array_amplitudes = InstructionsToTrack.instructions_to_track(instr, output_filename, 44100, sample_files)
  
    cmd = "afplay #{output_filename}" # 
    cmd_value = %x{ #{cmd} }
    return [instr, array_amplitudes]
  end
  
  def input # test for input while showing the instrucitons result of input
    
    instr1 = []
    eff_str = ""
    counter = 1

    puts "Compose by typing".colorize(:blue) + ", ends when exit-letter \'" + ']'.colorize(:red) + "\' included."
    # loop do
      ARGF.each_line do |line|
  
          # show the instructions of input
          op = SamplesOP.new
          test_str = line
          text_to_notes = TextToNotes.new
          eff_str += text_to_notes.string_to_effective_simple(test_str).chomp
          instr_names = text_to_notes.effective_simple_map(test_str)
          instr1 += instr_names
          
          # p instr_names
    
          if line.include?(']') # '1' is the marking letter for quit
            # print the result
            puts "Well done! Here is what you composed:"
            # p instr1
            break
          end
        end

      # break
    # end
    
    puts "Cool!"
    # next step...
    return eff_str
  end
  
  def tutorial
    str_eff = "Effective keys are:"
    str_eff_1 = "a, s, d".colorize(:green) + " are sample1, sample2, sample3, which are " + "wave files".colorize(:green) + " to be used here."
    str_eff_2 = "dash " + "-".colorize(:red) + " is the " + "rest".colorize(:red) + ", which is emptyness occupying time..."
    str_eff_3 = "time-length, which is the duration of each note, could be specified using keys:"
    str_eff_4 = "y,u,i,o,p".colorize(:yellow) + " are keys for changing duration of following notes, evenly-divided-beats " + "1,1/2,1/4,1/8,1/16".colorize(:yellow) + " respectively."
    str_eff_5 = "h,j,k".colorize(:yellow) + " are keys for changing duration of following notes, the triplets " + "1/3,1/6,1/12".colorize(:yellow) + " respectively."
  
    str_summary = "Easy? That's all! :)".colorize(:light_blue)
  
    # puts str_eff
    # puts str_eff_1
    # puts str_eff_2
    # puts str_eff_3
    # puts str_eff_4
    # puts str_eff_5
    
    # puts str_summary
    print_with_pause(str_eff)
    print_with_pause(str_eff_1)
    print_with_pause(str_eff_2)
    print_with_pause(str_eff_3)
    print_with_pause(str_eff_4)
    print_with_pause(str_eff_5)
    print_with_pause(str_summary)
  
    sleep(5.0)
    menu_main()
  
  end
  
  def menu_main
    font_doom = TTY::Font.new(:doom)
    puts font_doom.write("IMPROVISE BY TYPING", letter_spacing: 0).colorize(:blue)
    # p ARGV[0]
    # p ARGV[1]
    # p ARGV[2]

    pre_input = ""
    pre_track = 0
    bpm = @default_bpm

    # If arguments appended,
    # "ruby main.rb [1|2|3] [bpm] [string to be interpreted as instruction of track 1|2|3]"
    # export a wave file and exit.
    if (ARGV[0] != nil)
      case ARGV[0]
        when '1'
          bpm = ARGV[1].to_i
          pre_input = ARGV[2].to_s
          pre_track = 0
        when '2'
          bpm = ARGV[1].to_i
          pre_input = ARGV[2].to_s
          pre_track = 1
        when '3'
          bpm = ARGV[1].to_i
          pre_input = ARGV[2].to_s
          pre_track = 2
      end
      # p pre_input
      # p pre_track
      # p @default_samples[pre_track]

      text2track(pre_input, "pre-input.wav", @default_samples[pre_track], bpm)
      puts "Check your files :) pre-input.wav"
      exit

    else # if no arguments, go to the main menu
      prompt_main = TTY::Prompt.new
      ans_main = prompt_main.select("Have fun!".colorize(:light_blue)) do |menu|
        menu.choice 'Tutorial', "show tutorial"
        menu.choice 'Listen to sample files', "listen"
        menu.choice 'Choose a tempo (bpm)', "bpm"
        menu.choice 'Improvise by typing', "improvise"
        menu.choice 'Quit', "quit"
      end
  
      case ans_main
      when "show tutorial"
        tutorial()
      when "listen"
        menu_listen()
      when "bpm"
        choose_bpm()
      when "improvise"
        improvise({})
      when "quit"
        exit
      end
  
    end

  end

  def choose_bpm
    prompt_bpm = TTY::Prompt.new
      ans_bpm = prompt_bpm.select("Choose a tempo:".colorize(:light_blue)) do |menu|
        menu.choice '60', 60
        menu.choice '80', 80
        menu.choice '100', 100
        menu.choice '120', 120
        menu.choice '150', 150
        menu.choice '180', 180
        menu.choice '200', 200
      end

    @default_bpm = ans_bpm
    menu_main()
  end
  
  def menu_listen
  #   default_samples_drum = [ # if pwd is the main folder
  #     "audio-samples/lib-drum/sample1.wav",
  #     "audio-samples/lib-drum/sample2.wav",
  #     "audio-samples/lib-drum/sample3.wav"
  #   ]
  
  # default_samples_bass = [
  #     "audio-samples/lib-bass/sample1.wav",
  #     "audio-samples/lib-bass/sample2.wav",
  #     "audio-samples/lib-bass/sample3.wav"
  #   ]
  
  # default_samples_melodic = [
  #     "audio-samples/lib-melodic/sample1.wav",
  #     "audio-samples/lib-melodic/sample2.wav",
  #     "audio-samples/lib-melodic/sample3.wav"
  #   ]
  
  
    prompt_sample_select = TTY::Prompt.new
    ans_sample = prompt_sample_select.select("Choose a sample file to listen:") do |menu|
        menu.choice @default_samples_drum[0], @default_samples_drum[0]
        menu.choice @default_samples_drum[1], @default_samples_drum[1]
        menu.choice @default_samples_drum[2], @default_samples_drum[2]
  
        menu.choice @default_samples_bass[0], @default_samples_bass[0]
        menu.choice @default_samples_bass[1], @default_samples_bass[1]
        menu.choice @default_samples_bass[2], @default_samples_bass[2]
  
        menu.choice @default_samples_melodic[0], @default_samples_melodic[0]
        menu.choice @default_samples_melodic[1], @default_samples_melodic[1]
        menu.choice @default_samples_melodic[2], @default_samples_melodic[2]
  
        menu.choice "Back", "back"
      end
    
    case ans_sample
    when "back"
      menu_main()
    else 
      cmd = "afplay #{ans_sample}" # 
      cmd_value = %x{ #{cmd} }
      menu_listen()
    end
  
  end
  
  
  def improvise(saved_hash_amplitudes)
  
  #   default_samples_drum = [ # if pwd is the main folder
  #     "audio-samples/lib-drum/sample1.wav",
  #     "audio-samples/lib-drum/sample2.wav",
  #     "audio-samples/lib-drum/sample3.wav"
  #   ]
  
  # default_samples_bass = [
  #     "audio-samples/lib-bass/sample1.wav",
  #     "audio-samples/lib-bass/sample2.wav",
  #     "audio-samples/lib-bass/sample3.wav"
  #   ]
  
  # default_samples_melodic = [
  #     "audio-samples/lib-melodic/sample1.wav",
  #     "audio-samples/lib-melodic/sample2.wav",
  #     "audio-samples/lib-melodic/sample3.wav"
  #   ]
  
    prompt_track_select = TTY::Prompt.new
    ans_track = prompt_track_select.select("Choose a Track to work on:") do |menu|
        menu.choice 'Drum', "track1"
        menu.choice 'Bass', "track2"
        menu.choice 'Melodic', "track3"
        menu.choice 'Synth!', "add"
        menu.choice 'Back', "back"
      end
    
    arrays_amplitudes = saved_hash_amplitudes # this hash save arrays of amplitudes for later synth
    track_folder = ""
    case ans_track
    when "track1"
      # track_folder = "audio-samples/lib-drum/"
      str = input()
      arrays_amplitudes[:track1] = text2track(str, "track-drum.wav", @default_samples_drum, @default_bpm)[1]
      improvise(arrays_amplitudes)
  
    when "track2"
      # track_folder = "audio-samples/lib-bass/"
      str = input()
      arrays_amplitudes[:track2] = text2track(str, "track-bass.wav", @default_samples_bass, @default_bpm)[1]
      improvise(arrays_amplitudes)
  
    when "track3"
      # track_folder = "audio-samples/lib-melodic/"
      str = input()
      arrays_amplitudes[:track3] = text2track(str, "track-melodic.wav", @default_samples_melodic, @default_bpm)[1]
      improvise(arrays_amplitudes)
    
    when "add"
      if arrays_amplitudes.length == 0
        puts "not composed yet."
        menu_main()
      end
      arr = []
      operation = SamplesOP.new
      arrays_amplitudes.each do |track_name, array_amplitudes|
        arr.push(array_amplitudes)
        # p array_amplitudes
      end
      # p arr.length
      syn = operation.samples_add_from_array(arr, arr.length, 44100 * 5) # limit to short length
      # p syn
      buffer = Buffer.new(syn, Format.new(:stereo, :pcm_16, 44100))
      Writer.new("syn-export.wav", Format.new(:stereo, :pcm_16, 44100)) do |writer|
        writer.write(buffer)
      end
  
      puts "Check files :)"
      menu_main()
  
  
    when "back"
      menu_main()
    end
  
  end

end





main_entr = Main.new
main_entr.menu_main()


# print_with_pause("asdf-asdzxcv -sdfa".colorize(:blue), 0.1)
