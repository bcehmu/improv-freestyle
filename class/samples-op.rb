require 'wavefile'
include WaveFile

class SamplesOP # This is the class for manipulating samples of wave buffer.
    
    attr_accessor :sample_format
    def initialize
        @sample_format = Format.new(:stereo, :pcm_16, 44100)
    end

    def array_buffers_join_to_sample(arr)
        # join a array of buffers into one buffer?sample
        samples = []
        arr.each do |buffer|
            buffer.samples.each do |sample|
                samples.push(sample) # here s is the point of amplitude
            end
        end
        # buffers = Buffer.new(samples, arr.Format)
        return samples
    end
    
    def array_samples_join_to_sample(arr)
        # join a array of samples into one buffer?sample
        samples = []
        arr.each do |sample|
            sample.each do |s| # here s is the point of amplitude
                samples.push(s)
            end
        end
        return samples
    end

    def samples_add_from_array(array_samples, amp = 1, len = 441) # add amplitudes of samples from array_samples
        result = []
        max_len = 0
        array_samples.each do |sample| # update max_len
            max_len = sample.length > max_len ? sample.length : max_len
        end
        max_len = max_len > len ? len : max_len
        for i in 0...max_len
            result.push(0)
            array_samples.each do |sample|
                unless sample[i] != nil
                    result[i] += sample[i]
                end
            end
            result[i] = result[i] / amp
        end
    end

end