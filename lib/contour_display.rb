require_relative "PlotPackage"
java_import "jahuwaldt.plot.ContourPlot"
java_import "jahuwaldt.plot.DiamondSymbol"
java_import "jahuwaldt.plot.PlotDatum"
java_import "jahuwaldt.plot.PlotPanel"
java_import "jahuwaldt.plot.PlotRun"

class ContourDisplay < javax.swing.JFrame
  def initialize(xs, ys, zs)
    super("Cross-Validation Performance")
    self.setSize(500, 400)

    cxs = Java::double[][ys.size].new
    cys = Java::double[][ys.size].new
    ys.size.times do |i|
      cxs[i] = Java::double[xs.size].new
      cys[i] = Java::double[xs.size].new
      xs.size.times do |j|
        cxs[i][j] = xs[j]
        cys[i][j] = ys[i]
      end
    end

    czs = Java::double[][ys.size].new
    ys.size.times do |i|
      czs[i] = Java::double[xs.size].new
      xs.size.times do |j|
        czs[i][j] = zs[i][j]
      end
    end

    plot = ContourPlot.new(
      cxs,
      cys,
      czs,
      10,
      false,
      "",
      "Cost (log-scale)",
      "Gamma (log-scale)",
      nil,
      nil
    )
    plot.colorizeContours(java.awt::Color.green, java.awt::Color.red)

    symbol = DiamondSymbol.new
    symbol.border_color = java.awt::Color.blue
    symbol.fill_color = java.awt::Color.blue
    symbol.size = 4

    run = PlotRun.new
    ys.size.times do |i|
      xs.size.times do |j|
        run.add(PlotDatum.new(cxs[i][j], cys[i][j], false, symbol))
      end
    end

    plot.runs << run

    panel = PlotPanel.new(plot)
    panel.background = java.awt::Color.white
    add panel

    self.setDefaultCloseOperation(javax.swing.WindowConstants::DISPOSE_ON_CLOSE)
    self.visible = true
  end
end