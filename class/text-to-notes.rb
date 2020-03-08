class TextToNotes
    attr_accessor :rest, :effective, :letter_map, :effective_simple, :letter_map_simple
    # for a string, keep only the effective letters for mapping to a sequence of valid instructions.
    # note's duration : [1,1/2,1/4,1/8,1/16],[1/3,1/6,1/12]. scheme1: use four keys to adjust, even/triplet and faster/slower, scheme2: assign each option of duration a key.
    # octave adjustment needs two keys 
    def initialize()
        @rest = ["n"] # maps to rest
        @effective = [ # a complex scheme
                    'q', 'w', 'e', 'r', 
                    'a', 's', 'd', 'f',
                    'z', 'x', 'c', 'v',
                    'y', 'u', 'i', 'o',
                    'h', 'j', 'k', 'l',
                    '6', '7', '8', '9',
                    'n'
        ]

        @effective_simple = [ # a simple scheme
            's', 'd', 'f', # reserve 3 keys for simple map to 3 sample, very simple :)
            'y', 'u', 'i', 'o', 'p', # duration of even, 1, 1/2, 1/4, 1/8, 1/16
            'h', 'j', 'k', # duration of triplets, 1/3, 1/6
            'n' # rest
        ]



        @letter_map = {
            # beats adjustment
            '6' => "beats_even",
            '7' => "beats_tri",
            '8' => "beats_faster",
            '9' => "beats_slower",
            # octave adjustment
            'y' => "octave_up",
            'u' => "octave_down",
            # pitch
            'q' => "c",
            'w' => "c#",
            'e' => "d",
            'r' => "d#",

            'a' => "e",
            's' => "f",
            'd' => "f#",
            'f' => "g",

            'z' => "g#",
            'x' => "a",
            'c' => "a#",
            'v' => "b",
            # the rest
            'n' => "rest",
            # to be defined
            'i' => "rest",
            'o' => "rest",
            'h' => "rest",
            'j' => "rest",
            'k' => "rest",
            'l' => "rest",

        }

        @letter_map_simple = {
            # 3 map to 3 samples
            's' => "sample_1",
            'd' => "sample_2",
            'f' => "sample_3",
            # the rest
            'n' => "rest",
            # duration
            'y' => "1",
            'u' => "1/2",
            'i' => "1/4",
            'o' => "1/8",
            'p' => "1/16",

            'h' => "1/3",
            'j' => "1/6",
            'k' => "1/12"
        }
        
    end


    def string_to_effective(str) # keep only the effectve letters, remove the rest
        unless str.is_a?(String)
            raise "Provided data should be String."
        end
        chars = str.chars
        chars.select! {|c| @effective.include?(c)}
        return chars.join()
    end

    def string_to_effective_simple(str) # keep only the effectve letters, remove the rest
        unless str.is_a?(String)
            raise "Provided data should be String."
        end
        chars = str.chars
        chars.select! {|c| @effective_simple.include?(c)}
        return chars.join()
    end

    def effective_map(str) # map string to a series of valid instruction
        result = string_to_effective(str).chars
        result.map!{|c| @letter_map[c]}
        return result
    end

    def effective_simple_map(str) # map string to a series of valid instruction
        result = string_to_effective_simple(str).chars
        result.map!{|c| @letter_map_simple[c]}
        return result
    end

        
    end



    # test below

    str = "qwerasdf asdf zxcv 6789 yuio hjkl nm0 6789m"
    test_class = TextToNotes.new
    t = test_class.string_to_effective(str)
    p t
    s = test_class.effective_map(t)
    p s
    

