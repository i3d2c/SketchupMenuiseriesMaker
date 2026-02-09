require_relative './Structure'

module I3D
  module MenuiseriesExterieures
    class OuvertureVide < Structure
      attr_accessor :ouverture0, :ouverture1, :hauteur, :largeur, :position

      def initialize(profil, hauteur, largeur, position, remplissage=nil)
        super(profil)
        @hauteur = hauteur
        @largeur = largeur
        @position = position
        @remplissage = remplissage
        if @remplissage == nil then
          @remplissage = RemplissageVide.new()
        end
        puts "remplissage :"
        puts @remplissage
      end

      def hauteurMaxDeDecoupe()
        return @hauteur - @profil.bois.largeur
      end

      def largeurMaxDeDecoupe()
        return @largeur - @profil.bois.largeur
      end

      def dimensionMinDeDecoupe()
        return 2 * @profil.batee.largeur
      end

      def tracer()
        @remplissage.tracer(@largeur, @hauteur, @position)
        @remplissage.instance.set_attribute "I3DMenuiseries", "estUneOuvertureVide", true
        @remplissage.instance.set_attribute "I3DMenuiseries", "hauteur", @hauteur
        @remplissage.instance.set_attribute "I3DMenuiseries", "largeur", @largeur
        @remplissage.instance.set_attribute "I3DMenuiseries", "boisLargeur", @profil.bois.largeur
        @remplissage.instance.set_attribute "I3DMenuiseries", "boisEpaisseur", @profil.bois.epaisseur
        @remplissage.instance.set_attribute "I3DMenuiseries", "bateeLargeur", @profil.batee.largeur
        @remplissage.instance.set_attribute "I3DMenuiseries", "bateeEpaisseur", @profil.batee.epaisseur
        @remplissage.instance.set_attribute "I3DMenuiseries", "jointRainProf", @profil.joint.profondeurRainure
        @remplissage.instance.set_attribute "I3DMenuiseries", "jointRainEp", @profil.joint.epaisseurRainure
        @remplissage.instance.set_attribute "I3DMenuiseries", "position", @position
      end

      def divisionVerticale(distanceAGauche, tracer=true)
        if distanceAGauche < self.dimensionMinDeDecoupe() || distanceAGauche > self.largeurMaxDeDecoupe() then
          puts "distanceAGauche"
          puts distanceAGauche
          puts "largeurMaxDeDecoupe()"
          puts self.largeurMaxDeDecoupe()
          return
        end

        largeur0 = @largeur
        largeur1 = distanceAGauche
        largeur2 = largeur0 - largeur1 - @profil.largeurBoisSans2Batees()
        x0 = @position[0]
        x1 = x0 + largeur0/2 - largeur1/2
        x2 = x0 + largeur0/2 - largeur1 - @profil.largeurBoisSans2Batees() - largeur2/2
        ouverture1 = OuvertureVide.new(@profil, @hauteur, largeur1, Geom::Point3d.new(x1, @position[1], @position[2]))
        ouverture2 = OuvertureVide.new(@profil, @hauteur, largeur2, Geom::Point3d.new(x2, @position[1], @position[2]))

        if tracer then
          @remplissage.erase!()
          self.tracerTraverseVerticale(distanceAGauche)
          ouverture1.tracer()
          ouverture2.tracer()
        end
      end

      def divisionHorizontale(distanceDuHaut, tracer=true)
        if distanceDuHaut < self.dimensionMinDeDecoupe() || distanceDuHaut > self.hauteurMaxDeDecoupe() then
          puts "Dimensions invalides "
          return
        end

        hauteur0 = @hauteur
        hauteur1 = distanceDuHaut
        hauteur2 = hauteur0 - hauteur1 - @profil.largeurBoisSans2Batees()
        z0 = @position[2]
        z1 = z0 + hauteur0/2 - hauteur1/2
        z2 = z0 + hauteur0/2 - hauteur1 - @profil.largeurBoisSans2Batees() - hauteur2/2
        ouverture1 = OuvertureVide.new(@profil, hauteur1, @largeur, Geom::Point3d.new(@position[0], @position[1], z1))
        ouverture2 = OuvertureVide.new(@profil, hauteur2, @largeur, Geom::Point3d.new(@position[0], @position[1], z2))

        if tracer then
          @remplissage.erase!()
          self.tracerTraverseHorizontale(distanceDuHaut)
          ouverture1.tracer()
          ouverture2.tracer()
        end
      end

      def tracerTraverseHorizontale(distanceDuHaut)
        instance = @profil.tracerDoubleBateesSymetriques(@largeur)
        rotation = -90
        destination = @position + [0, 0, @hauteur / 2 - distanceDuHaut - @profil.largeurBoisSans2Batees() / 2]
        self.positionner(instance, rotation, destination)
      end

      def tracerTraverseVerticale(distanceAGauche)
        instance = @profil.tracerDoubleBateesSymetriques(@hauteur)
        rotation = 0
        destination = @position + [@largeur / 2 - distanceAGauche - @profil.largeurBoisSans2Batees() / 2, 0, 0]
        self.positionner(instance, rotation, destination)
      end
    end
  end
end
