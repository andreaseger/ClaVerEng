require 'erb'
require 'pry'
require 'fileutils'

def load_templates
  templates = DATA.read
  @templates = Hash[templates.scan(/@@ (?<name>\w+)\n(?<content>[^@@]+)/m).map{|n,e|  [n.to_sym, ERB.new(e)] }]
end

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
def create_compare_plot files, svg=false
  datapath = 'tmp'
  plot_path = "#{datapath}/plots_#{@time}"
  # FileUtils.mkdir plot_path
  files.each_slice(2).each do |meh|
    grid, other = meh.map { |e| File.basename(e) }
    setting = unwrap_filename grid
    setting_other = unwrap_filename other
    filename = [setting[:classification], 'compare', setting[:selector], setting[:samplesize], setting[:dict_size], setting[:timestamp]].join '_'

    title, other_title = [setting,setting_other].map{|e| e[:trainer].gsub('_',' ') + "##{e[:id]}" }

    # IO.write "#{plot_path}/#{filename}", templates[:compare].result(binding)
    puts @templates[:compare].result(binding)
  end
end

def create_plot files, template, svg=false
  datapath = 'tmp'
  plot_path = "#{datapath}/plots_#{@time}"
  # FileUtils.mkdir plot_path
  files.each do |file|
    name = File.basename(file)
    setting = unwrap_filename File.basename(name)
    filename = [setting[:classification], 'map', setting[:selector], setting[:samplesize], setting[:dict_size], setting[:timestamp]].join '_'

    title = setting[:trainer].gsub('_',' ') + "##{setting[:id]}"

    # IO.write "#{plot_path}/#{filename}", templates[:compare].result(binding)
    puts @templates[template].result(binding)
  end
end

# filenames = if ARGV.empty?
#                     $stdin.each_line.to_a
#                   else
#                     ARGV
#                   end


load_templates
@time = Time.now.strftime '%Y%m%d_%H%M'
create_compare_plot ARGV

create_plot(ARGV, :map)
create_plot(ARGV, :single)

__END__
@@ single
<%='set term svg enhanced size 600,400' if svg %>
set autoscale

set xlabel "cost"
set ylabel "gamma"
set zlabel "accuracy"

set pm3d
splot "<%= datapath %>/<%=name %>" title "<%= title %>" with points linecolor rgb "green"
@@ map
<%='set term svg enhanced size 600,400' if svg %>
set autoscale

set xlabel "cost"
set ylabel "gamma"
set zlabel "accuracy"

set pm3d
splot "<%= datapath %>/<%=name %>" title "<%= title %>" with lines pal
@@ compare
<%='set term svg enhanced size 600,400' if svg %>
set autoscale

set xlabel "cost"
set ylabel "gamma"
set zlabel "accuracy"

set pm3d
splot "<%= datapath %>/<%=grid %>" title "<%= title %>" with lines pal, \
        "<%= datapath %>/<%=other %>" title "<%= other_title %>" with points linecolor rgb "green"