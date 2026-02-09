module I3D
  module MenuiseriesExterieures
    class Profil
      attr_accessor :joint, :batee, :bois

      def initialize(joint, batee, bois)
        @joint = joint
        @batee = batee
        @bois = bois
      end

      def initialize(jointRainEp, jointRainProf, bateeEp, bateeLarg, boisEp, boisLarg)
        @joint = Joint.new(jointRainEp, jointRainProf)
        @batee = Batee.new(bateeEp, bateeLarg)
        @bois = Bois.new(boisEp, boisLarg)
      end

      def largeurBoisSansBatee()
        return @bois.largeur - @batee.largeur
      end

      def largeurBoisSans2Batees()
        return @bois.largeur - 2 * @batee.largeur
      end

      def tracerSimplebatee(longueur)
        model = Sketchup.active_model
        definition = model.definitions.add("Profil 1")
        points = [
          Geom::Point3d.new(0, 0, 0),
          Geom::Point3d.new(0, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, 0, 0),
          Geom::Point3d.new(0, 0, 0)
        ]
        face = definition.entities.add_face(points)
        face.pushpull(longueur)
        instance = model.entities.add_instance(definition, Geom::Transformation.new)
        instance.make_unique
        return instance
      end

      def tracerDoubleBateesOpposees(longueur)
        model = Sketchup.active_model
        definition = model.definitions.add("Profil 2")
        points = [
          Geom::Point3d.new(@batee.largeur, 0, 0),
          Geom::Point3d.new(@batee.largeur, @batee.epaisseur - @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@batee.largeur + @joint.profondeurRainure, @batee.epaisseur - @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@batee.largeur + @joint.profondeurRainure, @batee.epaisseur, 0),
          Geom::Point3d.new(0, @batee.epaisseur, 0),
          Geom::Point3d.new(0, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, 0, 0)
        ]
        face = definition.entities.add_face(points)
        face.pushpull(longueur)
        instance = model.entities.add_instance(definition, Geom::Transformation.new)
        instance.make_unique
        return instance
      end

      def tracerDoubleBateesSymetriques(longueur)
        model = Sketchup.active_model
        definition = model.definitions.add("Profil 3")
        points = [
          Geom::Point3d.new(0, 0, 0),
          Geom::Point3d.new(0, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@batee.largeur + @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@batee.largeur + @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@batee.largeur, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@batee.largeur, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur + @joint.epaisseurRainure, 0),
          Geom::Point3d.new(@bois.largeur - @batee.largeur - @joint.profondeurRainure, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, @bois.epaisseur - @batee.epaisseur, 0),
          Geom::Point3d.new(@bois.largeur, 0, 0)
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
