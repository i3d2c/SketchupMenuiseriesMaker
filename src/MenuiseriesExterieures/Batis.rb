require_relative './Structure'

module I3D
  module MenuiseriesExterieures
    class Bati < Structure
      attr_accessor :pose

      def initialize(profil, pose)
        super(profil)
        @pose = pose
      end

      def tracer()
        self.tracerMontantGauche()
        self.tracerMontantDroit()
        self.tracerTraverseHaute()
        self.tracerTraverseBasse()
      end

      def hauteurExterieure()
        return @pose.tableau.hauteur + @profil.bois.largeur - @pose.cochonnet
      end

      def largeurExterieure()
        return @pose.tableau.largeur + 2 * (@profil.bois.largeur - @pose.cochonnet)
      end

      def tracerTraverseHaute()
        instance = self.profil.tracerSimplebatee(self.largeurExterieure())
        rotation = 90
        destination = Geom::Point3d.new(0, 0, self.hauteurExterieure() / 2 - @profil.bois.largeur / 2)
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerMontantDroit()
        instance = self.profil.tracerSimplebatee(self.longueurMontant())
        rotation = 0
        destination = Geom::Point3d.new(-(self.largeurExterieure() / 2 - @profil.bois.largeur / 2), 0, 0)
        self.positionner(instance, rotation, destination)
        return instance
      end

      def tracerMontantGauche()
        instance = self.profil.tracerSimplebatee(self.longueurMontant())
        rotation = 180
        destination = Geom::Point3d.new(self.largeurExterieure() / 2 - @profil.bois.largeur / 2, 0, 0)
        self.positionner(instance, rotation, destination)
        return instance
      end
    end


    class BatiFenetre < Bati
      def longueurMontant()
        return self.hauteurExterieure() - 2 * (@profil.bois.largeur - @profil.batee.largeur)
      end

      def tracerTraverseBasse()
        instance = self.profil.tracerSimplebatee(self.largeurExterieure())
        rotation = -90
        destination = Geom::Point3d.new(0, 0, -(self.hauteurExterieure() / 2 - @profil.bois.largeur / 2))
        self.positionner(instance, rotation, destination)
        return instance
      end
    end


    class BatiPorteFenetre < Bati
      def initialize(profil, pose, seuil)
        super(profil, pose)
        @seuil = seuil
      end

      def longueurMontant()
        return self.hauteurExterieure() - (@profil.bois.largeur - @profil.batee.largeur)
      end

      def tracerTraverseBasse()
        return self.tracerSeuil()
      end

      def tracerSeuil()
        instance = @seuil.tracer(self.largeurExterieure())
        rotation = 0
        destination = Geom::Point3d.new(0, (@profil.bois.epaisseur - 5.6.cm) / 2, 1.35.cm - self.longueurMontant() / 2)
        self.positionner(instance, rotation, destination)
        return instance
      end
    end
  end
end
