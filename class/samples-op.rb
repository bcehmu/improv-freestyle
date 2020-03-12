require 'wavefile'
include WaveFile

class SamplesOP # This is the class for manipulating samples of wave buffer.
    
    attr_accessor :sample_format, :sample_frequency
    def initialize
        @sample_format = Format.new(:stereo, :pcm_16, 44100)
        @sample_frequency = 44100
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

    def samples_add_from_array(array_samples, amp = 1, len = 44100 * 300) # add amplitudes of samples from array_samples
        result = []
        max_len = len
        # check_sum = 0
        array_samples.each do |sample| # update max_len
            max_len = sample.length > max_len ? sample.length : max_len
        end
        max_len = max_len > len ? len : max_len
        for i in 0...max_len
            result.push([0,0])
            array_samples.each do |sample|
                unless sample[i] == nil
                    result[i][0] += sample[i][0]
                    result[i][1] += sample[i][1]
                    # check_sum += result[i][0] + result[i][1]
                end
            end
            result[i][0] = result[i][0] / amp
            result[i][1] = result[i][1] / amp
        end
        # p check_sum
        return result
    end

    def sample_slice(sample, len)
        unless len.is_a?(Integer)
            raise "length to slice should be integer"
        end

        result = []
        if len <= sample.length and len >= 0 # subarray sample[0...len]
            result = sample[0...len]
            return result
        elsif len >=0 # if greater than sample.length, pad with [0,0]
            result = sample.dup
            for i in (sample.length)...len
                result.push([0,0])
            end
            return result
        else
            raise "length to slice should be an integer not less than 0"
        end
    end


    

end