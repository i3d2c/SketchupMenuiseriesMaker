module I3D
  module MenuiseriesExterieures
    class Seuil
      def tracer(longueur)
        model = Sketchup.active_model
        definition = model.definitions.add("Profil seuil Alu")
        points = [
          Geom::Point3d.new(0, 0, 0),
          Geom::Point3d.new(0, 0, 0.2.cm),
          Geom::Point3d.new(0, 5.3.cm, 1.1.cm),
          Geom::Point3d.new(0, 5.3.cm, 2.7.cm),
          Geom::Point3d.new(0, 5.6.cm, 2.7.cm),
          Geom::Point3d.new(0, 5.6.cm, 0)
        ]
        face = definition.entities.add_face(points)
        face.pushpull(longueur)
        instance = model.entities.add_instance(definition, Geom::Transformation.new)
        instance.make_unique
        return instance
      end
    end
  end
end
