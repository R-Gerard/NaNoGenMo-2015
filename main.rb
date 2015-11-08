require 'tlearn'

# Number of possible char values
N_CLASS_ENCODINGS = 256

# Encode a char's ASCII value in a vector using 1-of-k encoding
def char2vec(char)
  raise ArgumentError.new('Input must be a char but was ' + char.class.name) if !char.is_a?(String)

  vals = Array.new(N_CLASS_ENCODINGS, 0)
  vals[char.ord] = 1

  vals
end

# Decode a char's ASCII value from a vector using 1-of-k encoding
def vec2char(vector)
  raise ArgumentError.new('Input must be an instance of Matrix but was ' + vector.class.name) if !vector.kind_of?(Array)
  raise ArgumentError.new('Input must be a 1-of-k vector') if vector.length != N_CLASS_ENCODINGS

  vector.index(vector.max)
end

def build_rnn(layers, nodes_per_layer)
  raise ArgumentError.new('layers must be > 1 but was ' + layers) if layers < 2
  raise ArgumentError.new('nodes_per_layer must be > 0 but was ' + nodes_per_layer) if nodes_per_layer < 1
  total_nodes = layers * nodes_per_layer + N_CLASS_ENCODINGS

  connections = []

  # Connect the inputs to the first hidden layer
  layer_0 = Range.new(1, nodes_per_layer)
  input_nodes = Range.new(:i1, ('i' + N_CLASS_ENCODINGS.to_s).to_sym)
  connections << { layer_0 => input_nodes }

  # Build the hidden layers
  0.upto(layers - 2) do |layer|
    src_nodes = Range.new((layer + 0) * nodes_per_layer + 1, (layer + 1) * nodes_per_layer)
    dst_nodes = Range.new((layer + 1) * nodes_per_layer + 1, (layer + 2) * nodes_per_layer)

    connections << {dst_nodes => src_nodes}
  end

  puts connections.to_s

  output_nodes = Range.new(layers * nodes_per_layer + 1, total_nodes)

  TLearn::Run.new(
    :number_of_nodes => total_nodes,
    :output_nodes    => output_nodes,
    :no_of_inputs    => N_CLASS_ENCODINGS,
    :input_nodes     => input_nodes,
    :linear          => Range.new(1, nodes_per_layer),
    :weight_limit    => 1.00,
    :connections     => connections)
end

rnn = build_rnn(2, 96)

# Build a training set from pangrams
sample = ''
sample += 'The quick brown fox jumps over the lazy dog. '
sample += 'The five boxing wizards jump quickly. '
sample += 'Sympathizing would fix Quaker objectives. '
sample += 'Many-wived Jack laughs at probes of sex quiz. '
sample += 'Playing jazz vibe chords quickly excites my wife. '
sample += 'Jack amazed a few girls by dropping the antique onyx vase. '

training_sets = []
0.upto(sample.length() -2) do |i|
  key_vec = char2vec(sample[i])
  val_vec = char2vec(sample[i + 1])
  training_sets << [ { key_vec => val_vec } ]
end

training_start = Time.now
rnn.train(training_sets, sweeps = 200, working_dir = '/tmp/test1')
training_end = Time.now

generated_text = ''
last_char = 'T'
input_vec = char2vec(last_char)

fitness_start = Time.new
0.upto(50) do |i|
  generated_text << last_char
  input_vec = rnn.fitness(input_vec, sweeps = 200, working_dir = '/tmp/test1')
  #puts input_vec.to_s
  last_char = vec2char(input_vec)
end
fitness_end = Time.now

puts "Training elapsed in #{(training_end - training_start).to_i} seconds"
puts "Fitness elapsed in #{(fitness_end - fitness_start).to_i} seconds"

puts generated_text
