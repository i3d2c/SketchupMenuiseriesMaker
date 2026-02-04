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
    @nombreOuvrant = 1
    @porteFenetre = "Oui"

    def self.creer_fenetre
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
        "Porte Fenetre? :"
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
        @porteFenetre
      ]
      listes = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "0|1|2", "Oui|Non"]

      results = UI.inputbox(prompts, defaults, listes, "Dimensions des profils bois")
      
      return if results == nil || results == false

      self.tracerMenuiserie(results[0].mm, results[1].mm, results[2].mm, results[3].mm, results[4].mm,
      results[5].mm, results[6].mm, results[7].mm, results[8].mm, results[9].mm, results[10].mm, results[11],
      results[12].mm, results[13].mm, results[14].mm, results[15].mm, results[16], results[17] == "Oui")
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
        bati = BatiPorteFenetre.new(profilBati, vitrage, imposteHauteur, seuil)
      else
        ouvrant = OuvrantFenetre.new(profilOuvrant, vitrage, allegeHauteur)
        bati = BatiFenetre.new(profilBati, vitrage, pose, imposteHauteur)
      end
      
      menuiserie = Menuiserie.new(bati, ouvrant, jeu)

      menuiserie.tracer()
    end

    unless file_loaded?(__FILE__)
      menu = UI.menu('Plugins')
      menu.add_item('01 Créer une fenêtre') {
        self.creer_fenetre
      }
      file_loaded(__FILE__)
    end
  end
end