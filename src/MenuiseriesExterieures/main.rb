require 'sketchup.rb'
require 'MenuiseriesExterieures/debug'
require 'MenuiseriesExterieures/Menuiseries'

module I3D
  module MenuiseriesExterieures
    @cochonnet = 3.cm
    @boisEp = 6.3.cm
    @boisLarg = 8.6.cm
    @boisBatiLarg = 8.6.cm
    @bateeEp = 4.5.cm
    @bateeLarg = 1.8.cm
    @jointRainEp = 0.3.cm
    @jointRainProf = 0.6.cm
    @jeu = 0.3.cm
    @EpVerre = 2.4.cm
    @jeuVerre = 0.5.cm
    @ref = ""
    @tableauLarg = 85.cm
    @tableauHaut = 200.cm
    @imposteHauteur = 50.cm
    @allegeHauteur = 50.cm
    @nombreOuvrant = 0

    def self.prompt
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
        @cochonnet.to_mm.round(), 
        @boisEp.to_mm.round(),
        @boisLarg.to_mm.round(),
        @boisBatiLarg.to_mm.round(),
        @bateeEp.to_mm.round(),
        @bateeLarg.to_mm.round(),
        @jointRainEp.to_mm.round(),
        @jointRainProf.to_mm.round(),
        @jeu.to_mm.round(),
        @EpVerre.to_mm.round(),
        @jeuVerre.to_mm.round(),
        @ref, 
        @tableauLarg.to_mm.round(),
        @tableauHaut.to_mm.round(),
        @imposteHauteur.to_mm.round(),
        @allegeHauteur.to_mm.round(),
        @nombreOuvrant.to_i, 
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
      boisOuvrant = Bois.new(boisEp, boisLarg)
      profilBati = Profil.new(joint, batee, boisBati)
      profilOuvrant = Profil.new(joint, batee, boisOuvrant)
      vitrage = Vitrage.new(epVerre, jeuVerre)
      seuil = Seuil.new()

      if isPorteFenetre then
        ouvrant = OuvrantPorteFenetre.new(profilOuvrant, vitrage, allegeHauteur)
        bati = BatiPorteFenetre.new(profilBati, vitrage, pose, imposteHauteur, seuil)
      else
        if nombreOuvrant == 0 then
          ouvrant = nil
          bati = BatiFenetreFixe.new(profilBati, vitrage, pose, imposteHauteur)          
        else
          ouvrant = OuvrantFenetre.new(profilOuvrant, vitrage, allegeHauteur)
          bati = BatiFenetre.new(profilBati, vitrage, pose, imposteHauteur)
        end
      end
      
      menuiserie = Menuiserie.new(bati, ouvrant, jeu)

      menuiserie.tracer()
    end

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