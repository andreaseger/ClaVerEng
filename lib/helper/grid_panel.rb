require_relative "jmathplot"
java_import "org.math.plot.Plot3DPanel"

class GridPanel < javax.swing.JFrame
  attr_accessor :plot
  def initialize(args={})
    super(args.fetch(:frame_header,"Cross-Validation Performance"))
    framesize = args.fetch(:frame_size,[800, 600])
    self.setSize(*framesize)
    # create your PlotPanel (you can use it as a JPanel) with a legend at SOUTH
    self.plot = Plot3DPanel.new("SOUTH");
    add plot
    self.setDefaultCloseOperation(javax.swing.WindowConstants::DISPOSE_ON_CLOSE)
    self.visible = true
  end

  def add_plot args={}
    xs = args[:xs]
    ys = args[:ys]
    zs = args[:zs]

    jxs,jys,jzs = to_java_array xs,ys,zs
    # add grid plot to the PlotPanel
    self.plot.addGridPlot(args.fetch(:plot_name,""), jxs, jys, jzs);
  end

  # convert RubyArrays to Jave double arrays
  def to_java_array xs,ys,zs
    jxs = Java::double[xs.size].new
    xs.each_with_index{|e,i| jxs[i]=e}
    jys = Java::double[ys.size].new
    ys.each_with_index{|e,i| jys[i]=e}
    jzs = Java::double[][ys.size].new
    ys.size.times do |i|
      jzs[i] = Java::double[xs.size].new
      xs.size.times do |j|
        jzs[i][j] = zs[i][j]
      end
    end
    [jxs,jys,jzs]
  end
end