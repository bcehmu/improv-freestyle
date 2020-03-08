require 'wavefile'
include WaveFile

require_relative "class/samples-op"
require_relative "class/music-note"


SAMPLES_PER_BUFFER = 4096 # * 10
file_name_1 = "kickdrum1.wav"




# test below
counter = 0
reader = Reader.new(file_name_1)
audio_format_1 = reader.native_format.audio_format
array_buffers = []
begin
  while reader.current_sample_frame < reader.total_sample_frames do
    buffer = reader.read(SAMPLES_PER_BUFFER)
    array_buffers.push(buffer)
    # puts "Read #{buffer.samples.length} sample frames."
    counter += 1
  end
rescue EOFError
  puts "Unexpected EOFError before reading all sample frames"
ensure
  reader.close
end

p buffer.class
p audio_format_1
p buffer.samples.length
p array_buffers.length
p counter



# test examples below...

# square_cycle = ([0.3] * 100) + ([-0.3] * 100)
# buffer1 = Buffer.new(square_cycle, Format.new(:mono, :float, 44100))
# Writer.new("square_cycle_100.wav", Format.new(:mono, :pcm_16, 44100)) do |writer|
#   441.times { writer.write(buffer1) }
# end

samp2 = ([[2000, 2000]] * 50) + ([[-2000, -2000]] * 50)
samp2_441 = samp2
for i in 1...441
    samp2_441 += samp2
end
# puts "samp2_441.length: #{samp2_441.length}"
# p samp2_441[0]


operations = SamplesOP.new
samp_join = operations.array_buffers_join_to_sample(array_buffers)
samp_join_2_times = [samp_join, samp_join]
samp_join_2 = operations.array_samples_join_to_sample(samp_join_2_times)
# buffer2 = Buffer.new(samp_join_2, Format.new(:stereo, :pcm_16, 44100))
# Writer.new("output_from_input.wav", Format.new(:stereo, :pcm_16, 44100)) do |writer|
#   1.times { writer.write(buffer2) }
# end

# p samp_join_2


# p samp_join.length
# p samp_join_2.length

samp_add = operations.samples_add_from_array([samp_join, samp2_441])
# buffer3 = Buffer.new(samp_add, Format.new(:stereo, :pcm_16, 44100))
# Writer.new("try_add.wav", Format.new(:stereo, :pcm_16, 44100)) do |writer|
#   1.times { writer.write(buffer3) }
# end
# p samp_add
# p buffer3