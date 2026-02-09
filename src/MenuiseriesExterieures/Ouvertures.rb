require_relative './Structure'

module I3D
  module MenuiseriesExterieures

    class Ouverture < Structure
      def initialize(profil, details, hauteur, largeur, position)
        super(profil)
        @details = details
        @hauteur = hauteur
        @largeur = largeur
        @position = position
      end
    end

    class Fixe < Ouverture
      def initialize(profil, details, hauteur, largeur, position)
        super(profil, details, hauteur, largeur, position)
        @remplissage = RemplissageVitrage.new(details.epVitrage, detail.jeuVitrage, hauteur, largeur, position)
      end

      def tracer()
        @remplissage.tracer()
      end
    end

    class Ouvrant < Ouverture
      def initialize(profil, details, hauteur, largeur, position)
        super(profil, details, hauteur, largeur, position)
        @ouverture = OuvertureVide.new(profil, details, self.hauteurVitrage(), self.largeurVitrage(), position)
      end

      def largeurVitrage()
        return @largeur - 2 * @details.jeuOuvrant - 2 * @profil.largeurBoisSans2Batees()
      end

      def hauteurVitrage()
        return @hauteur - 2 * @details.jeuOuvrant - 2 * @profil.largeurBoisSans2Batees()
      end

      def tracer()
        self.tracerMontantGauche()
        self.tracerMontantDroit()
        self.tracerTraverseHaute()
        self.tracerTraverseBasse()
        @ouverture.tracer()
      end
    end


    class OuvrantFenetre < Ouvrant
      def tracerMontantGauche()
        instance = @profil.tracerDoubleBateesOpposees(@hauteur - 2 * @profil.largeurBoisSans2Batees() - 2 * @details.jeuOuvrant)
        rotation = 180
        destination = [
          @position[0] + @largeur / 2 - @profil.bois.largeur / 2 + @profil.batee.largeur - @details.jeuOuvrant,
          @position[1] + (@profil.bois.epaisseur - @profil.batee.epaisseur) + @profil.joint.epaisseurRainure,
          @position[2]
        ]
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerMontantDroit()
        instance = @profil.tracerDoubleBateesOpposees(@hauteur - 2 * @profil.largeurBoisSans2Batees() - 2 * @details.jeuOuvrant)
        rotation = 0
        destination =[
          @position[0] - @largeur / 2 + @profil.bois.largeur / 2  - @profil.batee.largeur + @details.jeuOuvrant,
          @position[1] + (@profil.bois.epaisseur - @profil.batee.epaisseur) + @profil.joint.epaisseurRainure,
          @position[2]
        ]
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerTraverseHaute()
        instance = @profil.tracerDoubleBateesOpposees(@largeur + 2 * @profil.batee.largeur - 2 * @details.jeuOuvrant)
        rotation = 90
        destination =[
          @position[0],
          @position[1] + (@profil.bois.epaisseur - @profil.batee.epaisseur) + @profil.joint.epaisseurRainure,
          @position[2] + @hauteur / 2 - @profil.bois.largeur / 2  + @profil.batee.largeur - @details.jeuOuvrant
        ]
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerTraverseBasse()
        instance = @profil.tracerDoubleBateesOpposees(@largeur + 2 * @profil.batee.largeur - 2 * @details.jeuOuvrant)
        rotation = -90
        destination =[
          @position[0],
          @position[1] + (@profil.bois.epaisseur - @profil.batee.epaisseur) + @profil.joint.epaisseurRainure,
          @position[2] - @hauteur / 2 + @profil.bois.largeur / 2  - @profil.batee.largeur + @details.jeuOuvrant
        ]
        self.positionner(instance, rotation, destination)
        return instance
      end
    end


    class OuvrantPorteFenetre < Ouvrant
    end
  end
end
