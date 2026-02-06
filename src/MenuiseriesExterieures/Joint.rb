module I3D
  module MenuiseriesExterieures
    class Joint
      attr_accessor :epaisseurRainure, :profondeurRainure

      def initialize(epaisseurRainure, profondeurRainure)
        @epaisseurRainure = epaisseurRainure
        @profondeurRainure = profondeurRainure
      end
    end
  end
end
