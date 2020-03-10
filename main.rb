require 'wavefile'
include WaveFile

require_relative "class/samples-op"
require_relative "class/music-note"
require_relative "class/track-instructions"
require_relative "module/instructions-to-track"


SAMPLES_PER_BUFFER = 4096 


def test1
  op = SamplesOP.new
  test_str = "sdf-s-s-s i ss-s ---s-s-ss-s-s-s-ss-dddfdfdf usdf usdfsdf s-s-s---s-s-s-ssssss-ssss"
  text_to_notes = TextToNotes.new
  eff_str = text_to_notes.string_to_effective_simple(test_str)
  instr_names = text_to_notes.effective_simple_map(test_str)
  # p instr_names
  instr = TrackInstructions.new(150, instr_names)
  # p instr.array_instructions

  InstructionsToTrack.instructions_to_track(instr, "export1.wav")

end

test1()