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
require 'MenuiseriesExterieures/Details'


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
        "Hauteur Tableau:" 
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
        tableauHaut.to_mm.round()
      ]

      results = UI.inputbox(prompts, defaults, "Dimensions des profils bois")
      
      return results
    end

    def self.creerFenetre()
      dimensions = self.prompt()
      self.tracerMenuiserie(dimensions[0].mm, dimensions[1].mm, dimensions[2].mm, dimensions[3].mm, dimensions[4].mm,
      dimensions[5].mm, dimensions[6].mm, dimensions[7].mm, dimensions[8].mm, dimensions[9].mm, dimensions[10].mm, dimensions[11],
      dimensions[12].mm, dimensions[13].mm, false)
    end

    def self.creerPorteFenetre()
      dimensions = self.prompt()
      self.tracerMenuiserie(dimensions[0].mm, dimensions[1].mm, dimensions[2].mm, dimensions[3].mm, dimensions[4].mm,
      dimensions[5].mm, dimensions[6].mm, dimensions[7].mm, dimensions[8].mm, dimensions[9].mm, dimensions[10].mm, dimensions[11],
      dimensions[12].mm, dimensions[13].mm, true)
    end

    def self.tracerMenuiserie(cochonnet, boisEp, boisLarg, boisBatiLarg, bateeEp, bateeLarg,
      jointRainEp, jointRainProf, jeu, epVerre, jeuVerre, ref, tableauLarg, tableauHaut, isPorteFenetre)

      tableau = Tableau.new(tableauLarg, tableauHaut)
      pose = Pose.new(tableau, cochonnet)
      profilBati = Profil.new(jointRainEp, jointRainProf, bateeEp, bateeLarg, boisEp, boisLarg)
      details = Details.new(jeuVerre, epVerre, jeu)
      seuil = Seuil.new()

      if isPorteFenetre then
        @bati = BatiPorteFenetre.new(profilBati, pose, details, seuil)
      else
        @bati = BatiFenetre.new(profilBati, pose, details)
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
          if attribute_dictionary && attribute_dictionary["estUneOuvertureVide"] then
            ouvertureVide = attribute_dictionary["ouvertureVide"]
            hauteur = attribute_dictionary["hauteur"]
            largeur = attribute_dictionary["largeur"]
            position = attribute_dictionary["position"]

            profil = Profil.new(
              attribute_dictionary["jointRainEp"],
              attribute_dictionary["jointRainProf"],
              attribute_dictionary["bateeEpaisseur"],
              attribute_dictionary["bateeLargeur"],
              attribute_dictionary["boisEpaisseur"],
              attribute_dictionary["boisLargeur"]
            )
            details = Details.new(
              attribute_dictionary["jeuVitrage"],
              attribute_dictionary["epVitrage"],
              attribute_dictionary["jeuOuvrant"]
            )
            
            view.model.selection.clear
            view.model.selection.add(entity)

            ouvertureVide = OuvertureVide.new(profil, details, hauteur, largeur, position, entity)

            menu.add_item("Division verticale") {
              result = promptDivision(ouvertureVide.largeurMaxDeDecoupe(), "partie gauche")
              if result > 0
                ouvertureVide.divisionVerticale(result)
              end
            }
            menu.add_item("Division horizontale") {
              result = promptDivision(ouvertureVide.hauteurMaxDeDecoupe(), "partie haute")
              if result > 0
                ouvertureVide.divisionHorizontale(result)
              end
            }
            menu.add_item("Remplir avec fenêtre simple ouvrant") {
              ouvertureVide.remplirAvecOuvrantFenetre()
            }
            menu.add_item("Remplir avec vitrage fixe") {
              ouvertureVide.remplirAvecVitrageFixe()
            }
          end
        end
      end

      def promptDivision(valeurMax, texte)
        valeurDefaut = valeurMax.to_mm / 2
        prompts = [ "Dimension #{texte} (max #{valeurMax.to_mm.round().to_s}mm) :" ]
        defaults = [ valeurDefaut.round() ]
        results = UI.inputbox(prompts, defaults, "Dimension de la division")
        if results == false then
          return 0
        end
        return results[0].mm
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
