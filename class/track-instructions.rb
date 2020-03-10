class TrackInstructions
    # a class interprets instructions(string such as "rest") to simple track score
    attr_accessor :instructions_hash_simple, :count_samples, :bpm, :array_instructions
    def initialize(bpm, array_instructions_input)
        if bpm < 60 or bpm > 250
            raise "bpm should be within range 60 to 250"
        end
        @instructions_hash_simple = {
            :sample1 => "sample_1",
            :sample2 => "sample_2",
            :sample3 => "sample_3",

            :rest => "rest",

            :beat_even_1 => "1",
            :beat_even_2 => "1/2",
            :beat_even_3 => "1/4",
            :beat_even_4 => "1/8",
            :beat_even_5 => "1/16",
            :beat_tri_1 => "1/3",
            :beat_tri_2 => "1/6",
            :beat_tri_3 => "1/12"

        }
        @count_samples = 3
        @bpm = bpm
        @array_instructions = []
        array_instructions_input.each do |str_instr|
            @array_instructions.push(@instructions_hash_simple.key(str_instr))
        end


    end


end