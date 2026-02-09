module I3D
  module MenuiseriesExterieures
    class Details
      attr_accessor :jeuVitrage, :epVitrage, :jeuOuvrant

      def initialize(jeuVitrage, epVitrage, jeuOuvrant)
        @jeuVitrage = jeuVitrage
        @epVitrage = epVitrage
        @jeuOuvrant = jeuOuvrant
      end
    end
  end
end
