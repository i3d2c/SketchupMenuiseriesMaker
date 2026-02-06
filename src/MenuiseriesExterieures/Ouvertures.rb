require_relative './Structure'

module I3D
  module MenuiseriesExterieures
    class Ouvrant < Structure

      def initialize(profil, remplissage)
        super(profil)
        @remplissage = remplissage
      end

      def tracer(hauteur, largeur)
        self.tracerMontantGauche(hauteur, largeur)
        self.tracerMontantDroit(hauteur, largeur)
        self.tracerTraverseHaute(hauteur, largeur)
        self.tracerTraverseBasse(hauteur, largeur)
      end

      def tracerMontantGauche(hauteur, largeur)
        instance = @profil.tracerDoubleBateesOpposees(hauteur - 2 * @profil.bois.largeur)
        rotation = 180
        destination = Geom::Point3d.new(largeur / 2 - @profil.bois.largeur / 2 + @profil.batee.largeur, 0, 0)
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerMontantDroit(hauteur, largeur)
        instance = @profil.tracerDoubleBateesOpposees(hauteur - 2 * @profil.bois.largeur)
        rotation = 0
        destination = Geom::Point3d.new(-largeur / 2 + @profil.bois.largeur / 2 - @profil.batee.largeur, 0, 0)
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerTraverseHaute(hauteur, largeur)
        instance = @profil.tracerDoubleBateesOpposees(largeur + 2 * @profil.batee.largeur)
        rotation = 90
        destination = Geom::Point3d.new(0, 0, hauteur / 2 - @profil.bois.largeur / 2 - @profil.batee.largeur)
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerTraverseBasse(hauteur, largeur)
        instance = @profil.tracerDoubleBateesOpposees(largeur + 2 * @profil.batee.largeur)
        rotation = -90
        destination = Geom::Point3d.new(0, 0, - hauteur / 2 + @profil.bois.largeur / 2 + @profil.batee.largeur)
        self.positionner(instance, rotation, destination)
        return instance
      end
    end


    class OuvrantFenetre < Ouvrant
    end


    class OuvrantPorteFenetre < Ouvrant
    end
  end
end
