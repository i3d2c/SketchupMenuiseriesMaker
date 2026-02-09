module I3D
  module MenuiseriesExterieures
    class Structure
      attr_accessor :profil

      def initialize(profil)
        @profil = profil
      end

      def positionner(instance, rotation, position)
        translation_vector = Geom::Point3d.new(position) - instance.bounds.center
        instance.transform!(Geom::Transformation.new(translation_vector))
        point = instance.bounds.center
        axis = [0, 1, 0]
        transformation = Geom::Transformation.rotation(point, axis, rotation.degrees)
        instance.transform!(transformation)
        return instance
      end
    end
  end
end
