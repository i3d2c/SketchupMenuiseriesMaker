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
        @ouverture0 = nil
        @ouverture1 = nil
      end

      def tracer(hauteur, largeur)

      end

      def divisionVerticale(distanceAGauche, tracer=true)
        if distanceAGauche < 0 || distanceAGauche > @largeur then
          return
        end

        largeur0 = @largeur
        largeur1 = distanceAGauche
        largeur2 = largeur0 - largeur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur)
        origine0 = @position[0]
        origine1 = origine0 - largeur0/2 + largeur1/2
        origine2 = origine0 - largeur0/2 + largeur1 + (@profil.bois.largeur - 2 * @profil.batee.largeur) + largeur2/2
        @ouverture0 = OuvertureVide.new(@profil, @hauteur, largeur1, [origine1, @position[1], @position[2]])
        @ouverture1 = OuvertureVide.new(@profil, @hauteur, largeur2, [origine2, @position[1], @position[2]])

        if tracer then
          self.tracerTraverseVerticale(distanceAGauche)
        end
      end

      def divisionHorizontale(distanceDuHaut, tracer=true)
        if distanceDuHaut < 0 || distanceDuHaut > @hauteur then
          return
        end

        hauteur0 = @hauteur
        hauteur1 = distanceDuHaut
        hauteur2 = hauteur0 - hauteur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur)
        origine0 = @position[1]
        origine1 = origine0 + hauteur0/2 - hauteur1/2
        origine2 = origine0 + hauteur0/2 - hauteur1 - (@profil.bois.largeur - 2 * @profil.batee.largeur) - hauteur2/2
        @ouverture0 = OuvertureVide.new(@profil, hauteur1, @largeur, [@position[0], origine1, @position[2]])
        @ouverture1 = OuvertureVide.new(@profil, hauteur2, @largeur, [@position[0], origine2, @position[2]])

        if tracer then
          self.tracerTraverseHorizontale(distanceDuHaut)
        end
      end

      def tracerTraverseHorizontale(distanceDuHaut)
                
      end

      def tracerTraverseVerticale(distanceAGauche)
                
      end
    end
  end
end
