require 'sketchup.rb'
require 'MenuiseriesExterieures/debug'
require 'MenuiseriesExterieures/Menuiseries'
require 'MenuiseriesExterieures/Pose'
require 'MenuiseriesExterieures/Tableau'
require 'MenuiseriesExterieures/Seuil'
require 'MenuiseriesExterieures/Joint'
require 'MenuiseriesExterieures/Batee'
require 'MenuiseriesExterieures/Bois'
require 'MenuiseriesExterieures/Profil'
require 'MenuiseriesExterieures/Batis'
require 'MenuiseriesExterieures/Ouvertures'
require 'MenuiseriesExterieures/OuvertureVide'
require 'MenuiseriesExterieures/Remplissages'


module I3D
  module MenuiseriesExterieures

    def self.prompt()
      cochonnet = 3.cm
      boisEp = 6.3.cm
      boisLarg = 8.6.cm
      boisBatiLarg = 8.6.cm
      bateeEp = 4.5.cm
      bateeLarg = 1.8.cm
      jointRainEp = 0.3.cm
      jointRainProf = 0.6.cm
      jeu = 0.3.cm
      epVerre = 2.4.cm
      jeuVerre = 0.5.cm
      ref = ""
      tableauLarg = 85.cm
      tableauHaut = 200.cm
      imposteHauteur = 50.cm
      allegeHauteur = 50.cm
      nombreOuvrant = 1

      prompts = [
        "Cochonnet :", 
        "Epaisseur bois :", 
        "Largeur bois (ouvrant) :", 
        "Largeur bois (dormant) :", 
        "Epaisseur batée :", 
        "Largeur batée :", 
        "Epaisseur rainure joint :", 
        "Profondeur rainure joint :", 
        "Jeu ouvrant/dormant :", 
        "Epaisseur vitrage :", 
        "Jeu vitrage/bois :", 
        "Reference:", 
        "Largeur Tableau:", 
        "Hauteur Tableau:", 
        "Hauteur imposte:", 
        "Hauteur allege:", 
        "Nombre d'Ouvrant:", 
      ]

      # Conversion pour affichage (en mm)
      defaults = [
        cochonnet.to_mm.round(), 
        boisEp.to_mm.round(),
        boisLarg.to_mm.round(),
        boisBatiLarg.to_mm.round(),
        bateeEp.to_mm.round(),
        bateeLarg.to_mm.round(),
        jointRainEp.to_mm.round(),
        jointRainProf.to_mm.round(),
        jeu.to_mm.round(),
        epVerre.to_mm.round(),
        jeuVerre.to_mm.round(),
        ref, 
        tableauLarg.to_mm.round(),
        tableauHaut.to_mm.round(),
        imposteHauteur.to_mm.round(),
        allegeHauteur.to_mm.round(),
        nombreOuvrant.to_i, 
      ]
      listes = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "0|1|2"]

      results = UI.inputbox(prompts, defaults, listes, "Dimensions des profils bois")
      
      return results
    end

    def self.creerFenetre()
      dimensions = self.prompt()
      self.tracerMenuiserie(dimensions[0].mm, dimensions[1].mm, dimensions[2].mm, dimensions[3].mm, dimensions[4].mm,
      dimensions[5].mm, dimensions[6].mm, dimensions[7].mm, dimensions[8].mm, dimensions[9].mm, dimensions[10].mm, dimensions[11],
      dimensions[12].mm, dimensions[13].mm, dimensions[14].mm, dimensions[15].mm, dimensions[16], false)
    end

    def self.creerPorteFenetre()
      dimensions = self.prompt()
      self.tracerMenuiserie(dimensions[0].mm, dimensions[1].mm, dimensions[2].mm, dimensions[3].mm, dimensions[4].mm,
      dimensions[5].mm, dimensions[6].mm, dimensions[7].mm, dimensions[8].mm, dimensions[9].mm, dimensions[10].mm, dimensions[11],
      dimensions[12].mm, dimensions[13].mm, dimensions[14].mm, dimensions[15].mm, dimensions[16], true)
    end

    def self.tracerMenuiserie(cochonnet, boisEp, boisLarg, boisBatiLarg, bateeEp, bateeLarg,
      jointRainEp, jointRainProf, jeu, epVerre, jeuVerre, ref, tableauLarg, tableauHaut,
      imposteHauteur, allegeHauteur, nombreOuvrant, isPorteFenetre)

      tableau = Tableau.new(tableauLarg, tableauHaut)
      pose = Pose.new(tableau, cochonnet)
      batee = Batee.new(bateeEp, bateeLarg)
      joint = Joint.new(jointRainEp, jointRainProf)
      boisBati = Bois.new(boisEp, boisBatiLarg)
      # boisOuvrant = Bois.new(boisEp, boisLarg)
      profilBati = Profil.new(joint, batee, boisBati)
      # profilOuvrant = Profil.new(joint, batee, boisOuvrant)
      # vitrage = RemplissageVitrage.new(epVerre, jeuVerre)
      seuil = Seuil.new()

      if isPorteFenetre then
        @bati = BatiPorteFenetre.new(profilBati, pose, seuil)
      else
        @bati = BatiFenetre.new(profilBati, pose)
      end
      
      @bati.tracer()
    end

    def self.splitVertical(x)
      return @bati.ouverture.divisionVerticale(x)
    end

    def self.splitHorizontal(x)
      return @bati.ouverture.divisionHorizontale(x)
    end

    class MenuiserieTool
      def getMenu(menu, flags, x, y, view)
        ph = view.pick_helper(x, y)
        entity = ph.best_picked        
        
        if entity then
          attribute_dictionary = entity.attribute_dictionaries["I3DMenuiseries"]
          puts attribute_dictionary
          if attribute_dictionary && attribute_dictionary["estUneOuvertureVide"] then
            ouvertureVide = attribute_dictionary["ouvertureVide"]
            hauteur = attribute_dictionary["hauteur"]
            largeur = attribute_dictionary["largeur"]
            position = attribute_dictionary["position"]
            boisLargeur = attribute_dictionary["boisLargeur"]
            boisEpaisseur = attribute_dictionary["boisEpaisseur"]
            bateeLargeur = attribute_dictionary["bateeLargeur"]
            bateeEpaisseur = attribute_dictionary["bateeEpaisseur"]
            jointRainProf = attribute_dictionary["jointRainProf"]
            jointRainEp = attribute_dictionary["jointRainEp"]
            bois = Bois.new(boisEpaisseur, boisLargeur)
            batee = Batee.new(bateeEpaisseur, bateeLargeur)
            joint = Joint.new(jointRainEp, jointRainProf)
            profil = Profil.new(joint, batee, bois)
            
            view.model.selection.clear
            view.model.selection.add(entity)

            ouvertureVide = OuvertureVide.new(profil, hauteur, largeur, position)

            menu.add_item("Division verticale") {
              entity.erase!
              ouvertureVide.divisionVerticale(250.mm)
            }
            menu.add_item("Division horizontale") {
              entity.erase!
              ouvertureVide.divisionHorizontale(1200.mm)
            }
          end
        end
      end
    end
    Sketchup.active_model.select_tool(MenuiserieTool.new)

    unless file_loaded?(__FILE__)
      menu = UI.menu('Plugins')
      menu.add_item('Créer une FENÊTRE') {
        self.creerFenetre
      }
      menu.add_item('Créer une PORTE FENÊTRE') {
        self.creerPorteFenetre
      }
      file_loaded(__FILE__)
    end
  end
end
