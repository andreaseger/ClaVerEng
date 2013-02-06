require_relative 'config/environment'
require_relative 'lib/runner/batch'

def unwrap_filename name
  name.match %r{^(?<id>\d+)_
                              (?<trainer>[a-z_]+)_
                              (?<classification>[a-z]+)_
                              (?<selector>[a-z]+)_
                              (?<preprocessor>[a-z]+)_
                              (?<dict_size>\d+)_
                              (?<samplesize>\d+)_
                              (?<timestamp>\d+_\d+)
                              }x
end
def create_gnuplot_scripts files, time
  basepath = "tmp/plots_batch_#{time}"
  FileUtils.mkdir basepath
  files.each_slice(2).each do |grid, other|
    setting = unwrap_filename grid
    setting_other = unwrap_filename other
    filename = [setting[:classification], setting[:selector], setting[:samplesize], setting[:dict_size], setting[:timestamp]].join '_'

    IO.write "#{basepath}/#{filename}", <<-EOF.gsub(/^ {4}/, '')
    set autoscale

    set xlabel "cost"
    set ylabel "gamma"
    set zlabel "accuracy"

    set pm3d
    splot "tmp/#{grid}" title "#{setting[:trainer]}|#{setting[:id]}" with lines pal, \\
            "tmp/#{other}" title "#{setting_other[:trainer]}|#{setting_other[:id]}" with points linecolor rgb "green"
    EOF
  end
end


runner = Runner::Batch.new preprocessor: :simple,
                                          selectors: [:simple, :ngram],
                                          trainers: [:grid, :nelder_mead],
                                          classifications: [:function, :career_level, :industry],
                                          dictionary_sizes: 600,
                                          samplesizes: 800

time = Time.now.strftime '%Y%m%d_%H%M'
meh = runner.batch

create_gnuplot_scripts meh, time