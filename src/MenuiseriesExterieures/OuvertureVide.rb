require_relative './Structure'

module I3D
  module MenuiseriesExterieures
    class OuvertureVide < Structure
      attr_accessor :ouverture0, :ouverture1, :hauteur, :largeur, :position

      def initialize(profil, hauteur, largeur, position)
        super(profil)
        @hauteur = hauteur
        @largeur = largeur
        @position = position
        puts @hauteur
        puts @largeur
        @remplissage = RemplissageVide.new()
        @ouverture0 = nil
        @ouverture1 = nil
      end

      def tracer()
        @remplissage.tracer(@largeur, @hauteur, @position)
      end

      def divisionVerticale(distanceAGauche, tracer=true)
        if distanceAGauche < 0 || distanceAGauche > @largeur then
          return
        end

        largeur0 = @largeur
        largeur1 = distanceAGauche
        largeur2 = largeur0 - largeur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur)
        x0 = @position[0]
        x1 = x0 - largeur0/2 + largeur1/2
        x2 = x0 - largeur0/2 + largeur1 + (@profil.bois.largeur - 2 * @profil.batee.largeur) + largeur2/2
        @ouverture0 = OuvertureVide.new(@profil, @hauteur, largeur1, Geom::Point3d.new(x1, @position[1], @position[2]))
        @ouverture1 = OuvertureVide.new(@profil, @hauteur, largeur2, Geom::Point3d.new(x2, @position[1], @position[2]))

        if tracer then
          @remplissage.erase()
          self.tracerTraverseVerticale(distanceAGauche)
          @ouverture0.tracer()
          @ouverture1.tracer()
        end
      end

      def divisionHorizontale(distanceDuHaut, tracer=true)
        if distanceDuHaut < 0 || distanceDuHaut > @hauteur then
          puts "Dimensions invalides "
          puts @hauteur
          puts distanceDuHaut
          return
        end

        hauteur0 = @hauteur
        hauteur1 = distanceDuHaut
        hauteur2 = hauteur0 - hauteur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur)
        z0 = @position[2]
        z1 = z0 + hauteur0/2 - hauteur1/2
        z2 = z0 + hauteur0/2 - hauteur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur) - hauteur2/2
        @ouverture0 = OuvertureVide.new(@profil, hauteur1, @largeur, Geom::Point3d.new(@position[0], @position[1], z1))
        @ouverture1 = OuvertureVide.new(@profil, hauteur2, @largeur, Geom::Point3d.new(@position[0], @position[1], z2))

        if tracer then
          @remplissage.erase()
          self.tracerTraverseHorizontale(distanceDuHaut)
          @ouverture0.tracer()
          @ouverture1.tracer()
        end
      end

      def tracerTraverseHorizontale(distanceDuHaut)
        instance = @profil.tracerDoubleBateesSymetriques(@largeur)
        rotation = -90
        destination = @position + [0, 0, @hauteur / 2 - distanceDuHaut - (@profil.bois.largeur - 2 * @profil.batee.largeur) / 2]
        self.positionner(instance, rotation, destination)
      end

      def tracerTraverseVerticale(distanceAGauche)
        instance = @profil.tracerDoubleBateesSymetriques(@hauteur)
        rotation = 0
        destination = @position + [- @largeur / 2 + distanceAGauche + (@profil.bois.largeur - 2 * @profil.batee.largeur) / 2, 0, 0]
        self.positionner(instance, rotation, destination)
      end
    end
  end
end
