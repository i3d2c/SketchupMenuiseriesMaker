require 'sketchup.rb'
require 'MenuiseriesExterieures/debug'
require 'MenuiseriesExterieures/Menuiseries'

module I3D
  module MenuiseriesExterieures
    def self.creer_fenetre
      prompts = [
        "cochonnet :", 
        "Epaisseur bois :", 
        "Largeur bois (ouvrant) :", 
        "Largeur bois (dormant) :", 
        "Longueur batée :", 
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
        @cochonnet.to_mm, 
        @boisEp.to_mm, 
        @boisLarg.to_mm, 
        @boisBatiLarg.to_mm, 
        @bateeLong.to_mm, 
        @bateeLarg.to_mm, 
        @jointRainEp.to_mm, 
        @jointRainProf.to_mm, 
        @jeu.to_mm, 
        @EpVerre.to_mm, 
        @jeuVerre.to_mm, 
        @ref, 
        @tableauLarg.to_mm, 
        @tableauHaut.to_mm, 
        @imposteHauteur.to_mm, 
        @allegeHauteur.to_mm, 
        @nombreOuvrant.to_i, 
        @porteFenetre
      ]
      listes = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "0|1|2", "Oui|Non"]

      results = UI.inputbox(prompts, defaults, listes, "Dimensions des profils bois")
      
      return if results == nil || results == false

      tableau = Tableau.new(results[12].mm, results[13].mm)
      pose = Pose.new(tableau, results[0].mm)
      batee = Batee.new(results[4].mm, results[5].mm)
      joint = Joint.new(results[6].mm, results[7].mm)
      boisBati = Bois.new(results[1].mm, results[3].mm)
      boisOuvrant = Bois.new(results[1].mm, results[2].mm)
      profilBati = Profil.new(joint, batee, boisBati)
      profilOuvrant = Profil.new(joint, batee, boisOuvrant)
      vitrage = Vitrage.new(results[9].mm, results[10])
      seuil = Seuil.new()

      if results[17] == "Oui" then
        ouvrant = OuvrantPorteFenetre.new(profilOuvrant, vitrage, results[15].mm)
        bati = BatiPorteFenetre.new(profilBati, vitrage, results[14].mm, seuil)
      else
        ouvrant = OuvrantFenetre.new(profilOuvrant, vitrage, results[15].mm)
        bati = BatiFenetre.new(profilBati, vitrage, results[14].mm)
      end
      
      menuiserie = Menuiserie.new(pose, bati, ouvrant, results[8].mm)

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