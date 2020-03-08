class MusicNote
    attr_accessor :frequency, :notation
    attr_reader :freq_multiplier, :freq_a4, :notes_array, :octaves
    def initialize(notation)
        @octaves = 10
        notes_array_ = []
        notes_alphabet = ['c','c#','d','d#','e','f','f#','g','g#','a','a#','b']
        for i in (0..@octaves)
            notes_alphabet.each do |n|
                notes_array_.push(n + i.to_s)
                
            end
        end
        @notes_array = notes_array_

        unless @notes_array.include?(notation)
            raise "Please input correct note name, ex. \'c#4\'"
        end
        @notation = notation
        @freq_a4 = 440
        multiplier = []
        for i in (0..12)
            multiplier.push(2 ** (i / 12.0))
        end
        @freq_multiplier = multiplier

    end

    def diff_freq_interval(i)
        p 2 ** (i / 12.0)
        return 2 ** (i / 12.0)
    end

    def frequency
        idx = @notes_array.index(@notation)
        diff_idx = idx - 57 # a4 is 440hz, the 57th from c0
        # p diff_idx
        return 440 * diff_freq_interval(diff_idx)
    end

    def index_n(notation) # starts from c0
        if @notes_array.include?(notation)
            idx = @notes_array.index(notation)
            return idx
        end
    end

    def next_note_by_interval(i)
        idx = index_n(@notation)
        new_idx = idx + i
        if (new_idx >= 0) and (new_idx < 12 * @octaves)
            new_note = MusicNote.new(@notes_array[new_idx])
            return new_note
        else
            raise "Note out of range."
        end
    end
end



# test below


# note_a3 = MusicNote.new('a3')
# puts note_a3.index_n('a3')
# puts note_a3.index_n('a4')
# puts note_a3.frequency()
# puts note_a3.next_note_by_interval(3).notation



    
