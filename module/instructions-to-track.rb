require 'wavefile'
include WaveFile
require_relative "../class/samples-op"
require_relative "../class/track-instructions"
require_relative "../class/text-to-notes"


module InstructionsToTrack
# this contains tools accepting a sequence of instructions to track buffer, save the track as wav file
    default_samples_r1 = [ # if pwd is the module folder
        "../audio-samples/sample1.wav",
        "../audio-samples/sample2.wav",
        "../audio-samples/sample3.wav"
    ]

    default_samples_r2 = [ # if pwd is the main folder
        "audio-samples/sample1.wav",
        "audio-samples/sample2.wav",
        "audio-samples/sample3.wav"
    ]

    


    def InstructionsToTrack.instructions_to_track(instructions, filename, frequency = 44100, samples_file = nil)
        # filename is for export, samples_file is the array of names of files of samples to be used.
        unless instructions.is_a?(TrackInstructions)
            raise "1st argument should be valid TrackInstructions instance"
        end


        slice_length_1 = (frequency / (instructions.bpm / 60.0)).to_i # the length of sample for 1 beat
        slice_length_2 = slice_length_1 / 2
        slice_length_3 = slice_length_1 / 4
        slice_length_4 = slice_length_1 / 8
        slice_length_5 = slice_length_1 / 16

        slice_length_tri_1 = slice_length_1 / 3
        slice_length_tri_2 = slice_length_1 / 6
        slice_length_tri_3 = slice_length_1 / 12

        current_slice_length = slice_length_3 # 1/4 beat by default

        default_samples_file = []
        if samples_file == nil
            default_samples_file = [
                "audio-samples/sample1.wav",
                "audio-samples/sample2.wav",
                "audio-samples/sample3.wav"
            ]
        else
            default_samples_file = samples_file
        end

        result = []

        reader_size = 4096
        operations = SamplesOP.new
        
        # cmd = "pwd"
        # cmd_value = %x{ #{cmd} }
        # p default_samples_file[0]
        # cmd = "afplay ../audio-samples/sample1.wav" # file1 is the filename with path
        # cmd_value = %x{ #{cmd} }

        # read buffers from samples_file and save them to a hash
        hash_full_samples = {}
        for i in 0...default_samples_file.length
            reader = Reader.new(default_samples_file[i])
            audio_format_1 = reader.native_format.audio_format
            array_buffers = []
            begin
                while reader.current_sample_frame < reader.total_sample_frames do
                    buffer = reader.read(reader_size)
                    array_buffers.push(buffer)
                    # puts "Read #{buffer.samples.length} sample frames."
                end
            rescue EOFError
                puts "Unexpected EOFError before reading all sample frames"
            ensure
                reader.close
            end
            hash_full_samples[default_samples_file[i]] = operations.array_buffers_join_to_sample(array_buffers)
            # p hash_full_samples[default_samples_file[0]].length
        end

        # prepare for each duration of samples
        # p hash_full_samples[default_samples_file[0]].length
        # p hash_full_samples[default_samples_file[1]].length
        # p hash_full_samples[default_samples_file[2]].length


        # save sliced samples of all durations to a hash
        hash_samples_all_beats = {}
        hash_full_samples.each do |file_name, full_sample|
            hash_samples_all_beats[[file_name, slice_length_1]] = operations.sample_slice(full_sample, slice_length_1)
            hash_samples_all_beats[[file_name, slice_length_2]] = operations.sample_slice(full_sample, slice_length_2)
            hash_samples_all_beats[[file_name, slice_length_3]] = operations.sample_slice(full_sample, slice_length_3)
            hash_samples_all_beats[[file_name, slice_length_4]] = operations.sample_slice(full_sample, slice_length_4)
            hash_samples_all_beats[[file_name, slice_length_5]] = operations.sample_slice(full_sample, slice_length_5)

            hash_samples_all_beats[[file_name, slice_length_tri_1]] = operations.sample_slice(full_sample, slice_length_tri_1)
            hash_samples_all_beats[[file_name, slice_length_tri_2]] = operations.sample_slice(full_sample, slice_length_tri_2)
            hash_samples_all_beats[[file_name, slice_length_tri_3]] = operations.sample_slice(full_sample, slice_length_tri_3)
        end

        # p hash_samples_all_beats.keys

        export = []
        instructions.array_instructions.each do |instruction|
            case instruction
            when :beat_even_1
                current_slice_length = slice_length_1
            when :beat_even_2
                current_slice_length = slice_length_2
            when :beat_even_3
                current_slice_length = slice_length_3
            when :beat_even_4
                current_slice_length = slice_length_4
            when :beat_even_5
                current_slice_length = slice_length_5
            when :beat_tri_1
                current_slice_length = slice_length_tri_1
            when :beat_tri_2
                current_slice_length = slice_length_tri_2
            when :beat_tri_3
                current_slice_length = slice_length_tri_3
            when :rest
                export += [[0,0]] * current_slice_length
            when :sample1
                export += hash_samples_all_beats[[default_samples_file[0], current_slice_length]]
            when :sample2
                export += hash_samples_all_beats[[default_samples_file[1], current_slice_length]]
            when :sample3
                export += hash_samples_all_beats[[default_samples_file[2], current_slice_length]]
            end
        end

        # p export.length
        
        buffer = Buffer.new(export, Format.new(:stereo, :pcm_16, 44100))
        Writer.new(filename, Format.new(:stereo, :pcm_16, 44100)) do |writer|
          writer.write(buffer)
        end

        return export

    end

    


end

# include InstructionsToTrack
# instr1 = TrackInstructions.new(120, ["sample_1","rest"])
# instructions_to_track(instr1, "export1.wav")