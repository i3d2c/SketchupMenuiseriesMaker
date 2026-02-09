module I3D
  module MenuiseriesExterieures

    class Remplissage
      attr_accessor :epaisseur, :jeu, :instance

      def initialize(epaisseur, jeu, hauteur, largeur, position)
        @epaisseur = epaisseur
        @jeu = jeu
        @hauteur = hauteur
        @largeur = largeur
        @position = position
        @instance = nil
      end

      def erase()
        unless @instance == nil
          @instance.erase!
        end
      end

      def tracer()
        largeur = @largeur - 2 * @jeu
        hauteur = @hauteur - 2 * @jeu
        model = Sketchup.active_model
        points = [
          Geom::Point3d.new(0, 0, 0),
          Geom::Point3d.new(0, 0, hauteur),
          Geom::Point3d.new(largeur, 0, hauteur),
          Geom::Point3d.new(largeur, 0, 0)
        ]
        instance = model.active_entities.add_group
        self.appliquerTexture(instance)
        face = instance.entities.add_face(points)
        face.pushpull(@epaisseur)
        rotation = 0
        self.positionner(instance, rotation, @position)
        @instance = instance
        return @instance
      end

      def appliquerTexture(instance)
        puts "Méthodes qui ne devrait pas être appelée dans cette classe ci oO. Veuillez utiliser une classe héritante plutôt que celle-ci."
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
    
    class RemplissageVitrage < Remplissage
      def appliquerTexture(instance)
        materials = Sketchup.active_model.materials
        mat = materials["Vitrage"] || materials.add("Vitrage")
        mat.alpha = 0.3
        mat.color = Sketchup::Color.new(180, 220, 255)
        
        instance.material = mat
        instance.name = "Vitrage"
        instance.entities.each { |e| e.material = mat if e.respond_to?(:material=) }
        return instance
      end
    end

    class RemplissageVide < Remplissage
      def initialize(hauteur, largeur, position)
        super(1, 0, hauteur, largeur, position)
        @instance = nil
      end

      def appliquerTexture(instance)
        materials = Sketchup.active_model.materials
        mat = materials["Vide"] || materials.add("Vide")
        mat.alpha = 0.5
        mat.color = Sketchup::Color.new(40, 120, 12)
        
        instance.material = mat
        instance.name = "Vide"
        return instance
      end
    end
  end
end
