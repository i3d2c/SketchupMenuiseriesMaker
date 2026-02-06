module I3D
  module MenuiseriesExterieures
    class Pose
      attr_accessor :tableau, :cochonnet

      def initialize(tableau, cochonnet)
        @tableau = tableau
        @cochonnet = cochonnet
      end
    end
  end
end
