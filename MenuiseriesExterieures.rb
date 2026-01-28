module Menuiseries

  @boisCouleur = "Bois de bambou moyen"
  @prixUnit = 18
  @prixMlSeuil = 34
  @tarifBois = 8
  @tarifVitrage = 70
  @tarifCremone = 90
  @tarifCharnieres = 30
  @tarifSeuilAlu = 25
  @tarifJetDEau = 15

  @cochonnet = 3.cm
  @boisEp = 6.3.cm
  @boisLarg = 8.6.cm
  @boisBatiLarg = 8.6.cm
  @bateeLong = 4.5.cm
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


  def self.dimension_Profil_bois

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
    if results == nil || results == false then
      return false
    end

    # Conversion inverse (mm → unités SketchUp)
    @cochonnet = results[0].mm
    @boisEp = results[1].mm
    @boisLarg = results[2].mm
    @boisBatiLarg = results[3].mm
    @bateeLong = results[4].mm
    @bateeLarg = results[5].mm
    @jointRainEp = results[6].mm
    @jointRainProf = results[7].mm
    @jeu = results[8].mm
    @EpVerre = results[9].mm
    @jeuVerre = results[10].mm
    @ref = results[11]
    @tableauLarg = results[12].mm
    @tableauHaut = results[13].mm
    @imposteHauteur = results[14].mm
    @allegeHauteur = results[15].mm
    @nombreOuvrant = results[16].to_i
    @porteFenetre = results[17]

    @hauteurSeuilAlu = 27.mm
    @decalageSeuilAlu = @hauteurSeuilAlu - @bateeLarg + @jeu #1.4.cm
  end

  def self.calcul_dimension
      # calcul des dimensions de longueurs des differentes pieces
      @hautExt = @tableauHaut + @boisBatiLarg - @cochonnet
      @largExt = @tableauLarg + ((@boisBatiLarg - @cochonnet)  *  2)
      @batiTraverseIntermediaireDistCentreDuHaut = (@boisBatiLarg - @cochonnet) + @imposteHauteur
      #test = @tableauLarg + ((@boisBatiLarg - @cochonnet)  *  2)
      if @porteFenetre == "Oui" then
        if @imposteHauteur > 0  # pas PF avec imposte 
          @ouvrantHaut = @hautExt - @batiTraverseIntermediaireDistCentreDuHaut - @boisBatiLarg / 2 + @bateeLarg + @bateeLarg - @jeu - @decalageSeuilAlu
        else # si PF sans imposte 1 ouvrant
          @ouvrantHaut = @hautExt - @boisBatiLarg + @bateeLarg + @bateeLarg - @jeu - @decalageSeuilAlu
        end
      else # pas PF
        if @imposteHauteur > 0  # pas PF avec imposte 
          @ouvrantHaut = @hautExt - @batiTraverseIntermediaireDistCentreDuHaut - @boisBatiLarg + @bateeLarg + @bateeLarg - @boisLarg / 2 + @bateeLarg + @bateeLarg - @jeu - @jeu             
        else # pas PF sans imposte 1 ouvrant       
          @ouvrantHaut = @hautExt - @boisBatiLarg - @boisBatiLarg + @bateeLarg + @bateeLarg + @bateeLarg + @bateeLarg - @jeu - @jeu 
        end 
      end

      @distEntre2Ouvrants = @boisLarg - (@bateeLarg * 4) + @jeu

      if @nombreOuvrant.to_f > 1 then
        @ouvrantLarg = ((@largExt - @boisBatiLarg - @boisBatiLarg + @bateeLarg + @bateeLarg + @bateeLarg + @bateeLarg - @jeu - @jeu)  - @distEntre2Ouvrants) / 2 
        @longMeneau = @ouvrantHaut - @bateeLarg * 4
        #UI.messagebox(2)
      else
        @ouvrantLarg = (@largExt - @boisBatiLarg - @boisBatiLarg + @bateeLarg + @bateeLarg + @bateeLarg + @bateeLarg - @jeu - @jeu) 
      end   

      @batiTraverseHautelong = @largExt # - (@boisBatiLarg - @bateeLarg) * 2
      @batiTraverseIntermediaire = @largExt - (@boisBatiLarg - @bateeLarg) * 2
      @batiMontantlongSiPF = @hautExt - (@boisBatiLarg - @bateeLarg)
      @batiMontantlongSiPasPF = @hautExt - (@boisBatiLarg - @bateeLarg) * 2
      @OuvrantTraverseLong = @ouvrantLarg# -  2  *  (@boisLarg - @bateeLarg)
      @OuvrantTraverseIntermediaireLong = @ouvrantLarg - @boisLarg - @boisLarg + @bateeLarg + @bateeLarg
      @OuvrantMontantLong = @ouvrantHaut - (@boisLarg - @bateeLarg) * 2
      @OuvrantMontantLongSiPF = @ouvrantHaut - (@boisLarg - @bateeLarg) * 2
      @decalageOuvrantExtBati = @boisBatiLarg - @bateeLarg - @bateeLarg + @jeu + (@boisLarg / 2)    
      @decalageOuvrantRapplique = @boisEp - @bateeLong + @jeu
  end

  def self.afficher_dimensions
   UI.messagebox("Largeur tableau = #{@tableauLarg}\n, Hauteur tableau = #{@tableauHaut}\n, Hauteur Imposte = #{@data[:@imposteHauteur]}\n, Nombre ouvrant = #{@nombreOuvrant}\n, Porte fenetre = #{@porteFenetre}")
  end

  # Fonction pour modifier les dimensions du tableau via une boîte de dialogue
  def self.tarification
    prompts = ["Tarif bois 63x86 :", "Tarif vitrage :", "Tarif cremone :", "Tarif charnieres :", "Tarif seil alu :""Tarif jet d'eau :"]
    #UI.messagebox(@data[:@tableauHaut])
    if @data[:@tarifBois] == 0 then
      defaults = [@tarifBois, @tarifVitrage, @tarifCremone, @tarifCharnieres, @tarifSeuilAlu, @tarifJetDEau]
    else
      defaults = [@data[:@tarifBois], @data[:@tarifVitrage], @data[:@tarifCremone], @data[:@tarifCharnieres], @data[:@tarifSeuilAlu], @data[:@tarifJetDEau]]
    end

    listes = ["Sapin|Bois exotique|Chataigner|chêne", "4 - 6 - 4|4 - 16 - 4|4 - 4 - 16 - 4", "", "", "", ""]
    results = UI.inputbox(prompts, defaults, listes, "Tarification")
    # @porteFenetre = results[4].to_s.strip
    #UI.messagebox(results)
    if results == nil || results == false then
      return false
    else
      #@data = {} # stockage persistant dans le module
      @data[:@tarifBois] = results[0]
      @data[:@tarifVitrage] = results[1]
      @data[:@tarifCremone] = results[2]
      @data[:@tarifCharnieres] = results[3]
      @data[:@tarifSeuilAlu] = results[4]
      @data[:@tarifJetDEau] = results[5]
    end # if
   #  return unless results # si annulation
   ##  @tableauHaut, @tableauLarg, @imposteHauteur, @nombreOuvrant, @porteFenetre = results.map(&:to_f)
  end #dimension_tableau
  
  def self .info_composant(refComposant, typeDeProfil, prixUnit, unite, longDuProfil)
    # Réveiller le composant dynamique# Réveille le moteur DC (indispensable)
    refComposant.set_attribute("dynamic_attributes", "lenx_formula", " = LenX")
    refComposant.set_attribute("dynamic_attributes", "_lenx_access", "VIEW")
    # Création d’un attribut numérique
    refComposant.set_attribute("dynamic_attributes", "prix_ml", prixUnit)
    refComposant.set_attribute("dynamic_attributes", "_prix_ml_formula", "")
    refComposant.set_attribute("dynamic_attributes", "_prix_ml_access", "TEXTBOX")
    refComposant.set_attribute("dynamic_attributes", "_prix_ml_label", "Prix Unitaire")
    # Création d’un attribut numérique
    refComposant.set_attribute("dynamic_attributes", "longueur", longDuProfil / 100  *  2.54)
    refComposant.set_attribute("dynamic_attributes", "_longueur_formula", "")
    refComposant.set_attribute("dynamic_attributes", "_longueur_access", "TEXTBOX")
    refComposant.set_attribute("dynamic_attributes", "_longueur_label", "Longueur")
    # Création d’un attribut numérique
    refComposant.set_attribute("dynamic_attributes", "prix_total", ((longDuProfil / 100  *  2.54)  *  prixUnit).round(2))
    refComposant.set_attribute("dynamic_attributes", "_prix_total_formula", "")
    refComposant.set_attribute("dynamic_attributes", "_prix_total_access", "TEXTBOX")
    refComposant.set_attribute("dynamic_attributes", "_prix_total_label", "Prix total")
    # Création d’un attribut texte
    refComposant.set_attribute("dynamic_attributes", "unite", unite)
    refComposant.set_attribute("dynamic_attributes", "_unite_formula", "")
    refComposant.set_attribute("dynamic_attributes", "_unite_access", "TEXTBOX")
    refComposant.set_attribute("dynamic_attributes", "_unite_label", "Unité")
    # Création d’un attribut texte
    refComposant.set_attribute("dynamic_attributes", "type_de_profil", typeDeProfil)
    refComposant.set_attribute("dynamic_attributes", "_type_de_profil_formula", "")
    refComposant.set_attribute("dynamic_attributes", "_type_de_profil_access", "TEXTBOX")
    refComposant.set_attribute("dynamic_attributes", "_type_de_profil_label", "Type De Profil")

    refComposant.set_attribute("dynamic_attributes", "_lastmodified", Time.now.to_i)
    Sketchup.send_action("showComponentOptions:")
  end #info_composant
  
  def self.profilUneBatee(nom, lg, nom2, angleRotation, destination_point)
    model = Sketchup.active_model
    definition = model.definitions.add(nom)
    # Points du profil"Bati : 1 batée
    pts = []
    pts[0] = Geom::Point3d.new(0, 0, 0)
    pts[1] = Geom::Point3d.new(0, @boisEp, 0)
    pts[2] = Geom::Point3d.new(@boisBatiLarg - @bateeLarg, @boisEp, 0)
    pts[3] = Geom::Point3d.new(@boisBatiLarg - @bateeLarg, @boisEp - @bateeLong + @jointRainEp, )
    pts[4] = Geom::Point3d.new(@boisBatiLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong + @jointRainEp, 0)
    pts[5] = Geom::Point3d.new(@boisBatiLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong, 0)
    pts[6] = Geom::Point3d.new(@boisBatiLarg, @boisEp - @bateeLong, )
    pts[7] = Geom::Point3d.new(@boisBatiLarg, 0, 0)
    pts[8] = Geom::Point3d.new(0, 0, 0)
    # pts = [[0, 0, 0], [100, 0, 0], [100, 100, 0], [0, 100, 0]]
    face = definition.entities.add_face(pts)
    face.pushpull(lg)

    instance = model.entities.add_instance(definition, Geom::Transformation.new)
    instance.make_unique
    instance.name = (nom2)
    mat = model.materials["Bois de bambou moyen"]
    instance.material = mat
    info_composant(instance, "Type 1", @prixUnit, "ml", lg)
    # Translation du profil
    translation_vector = destination_point - instance.bounds.center # Calculer la translation n écessaire 
    instance.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
    # Rotation du profil
    point = instance.bounds.center# Définir le point de rotation (ici, l'origine du groupe)
    axis = [0, 1, 0]  # Définir l’axe de rotation (ici, l’axe y)
    angle_degrees = angleRotation# Définir l’angle de rotation en radians
    angle_radians = angle_degrees.degrees  # Convertir en radians
    transformation = Geom::Transformation.rotation(point, axis, angle_radians)# Créer la transformation de rotation
    instance.transform!(transformation)# Appliquer la transformation au groupe      
  end  # profilUneBatee
      
  def self.profilDeuxBateeOpposees(nom, lg, nom2, angleRotation, destination_point)
    model = Sketchup.active_model
    definition = model.definitions.add(nom)
    # Points du profil"Bati : 2 batée opposées
    pts = []
    pts[0] = Geom::Point3d.new(@bateeLarg, 0, 0)
    pts[1] = Geom::Point3d.new(@bateeLarg, @bateeLong - @jointRainEp, 0)
    pts[2] = Geom::Point3d.new(@bateeLarg + @jointRainProf, @bateeLong - @jointRainEp, 0)
    pts[3] = Geom::Point3d.new(@bateeLarg + @jointRainProf, @bateeLong, 0)
    pts[4] = Geom::Point3d.new(0, @bateeLong, 0) 
    pts[5] = Geom::Point3d.new(0, @boisEp, 0)
    pts[6] = Geom::Point3d.new(@boisLarg - @bateeLarg, @boisEp, 0)
    pts[7] = Geom::Point3d.new(@boisLarg - @bateeLarg, @boisEp - @bateeLong + @jointRainEp, )
    pts[8] = Geom::Point3d.new(@boisLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong + @jointRainEp, 0)
    pts[9] = Geom::Point3d.new(@boisLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong, 0)
    pts[10] = Geom::Point3d.new(@boisLarg, @boisEp - @bateeLong, )
    pts[11] = Geom::Point3d.new(@boisLarg, 0, 0)
    face = definition.entities.add_face(pts)
    face.pushpull(lg)
    instance = model.entities.add_instance(definition, Geom::Transformation.new)
    instance.make_unique
    instance.name = (nom2)
    info_composant(instance, "Type 2", @prixUnit, "ml", lg)
    # Translation du profil
    #destination_point = Geom::Point3d.new( - (@largExt / 2 - @boisLarg / 2), 0, 0)  # point de destination
    translation_vector = destination_point - instance.bounds.center # Calculer la translation n écessaire 
    instance.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
    # Rotation du profil
    point = instance.bounds.center# Définir le point de rotation (ici, l'origine du groupe)
    axis = [0, 1, 0]  # Définir l’axe de rotation (ici, l’axe y)
    angle_degrees = angleRotation# Définir l’angle de rotation en radians
    angle_radians = angle_degrees.degrees  # Convertir en radians
    transformation = Geom::Transformation.rotation(point, axis, angle_radians)# Créer la transformation de rotation
    instance.transform!(transformation)# Appliquer la transformation au groupe
    # 🔹 Forcer la valeur de retour
    # return instance
  end  # fin de profilDeuxBateeOpposees
      
  def self.profilDeuxBateeSymetrique(nom, lg, nom2, angleRotation, destination_point)
    model = Sketchup.active_model
    definition = model.definitions.add(nom)
    # Points du profil"traverse haute bati : 2 batées symetrique
    pts = []
    pts[0] = Geom::Point3d.new(0, 0, 0)
    pts[1] = Geom::Point3d.new(0, @boisEp - @bateeLong, 0)
    pts[2] = Geom::Point3d.new(@bateeLarg + @jointRainProf, @boisEp - @bateeLong, 0)
    pts[3] = Geom::Point3d.new(@bateeLarg + @jointRainProf, @boisEp - @bateeLong + @jointRainEp, 0)
    pts[4] = Geom::Point3d.new(@bateeLarg, @boisEp - @bateeLong + @jointRainEp, 0) 
    pts[5] = Geom::Point3d.new(@bateeLarg, @boisEp, 0)
    pts[6] = Geom::Point3d.new(@boisLarg - @bateeLarg, @boisEp, 0)
    pts[7] = Geom::Point3d.new(@boisLarg - @bateeLarg, @boisEp - @bateeLong + @jointRainEp, )
    pts[8] = Geom::Point3d.new(@boisLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong + @jointRainEp, 0)
    pts[9] = Geom::Point3d.new(@boisLarg - @bateeLarg - @jointRainProf, @boisEp - @bateeLong, 0)
    pts[10] = Geom::Point3d.new(@boisLarg, @boisEp - @bateeLong, )
    pts[11] = Geom::Point3d.new(@boisLarg, 0, 0)
    face = definition.entities.add_face(pts)
    face.pushpull(lg)
    instance = model.entities.add_instance(definition, Geom::Transformation.new)
    instance.make_unique
    instance.name = (nom2)       
    #information composant
    info_composant(instance, "type_3", @prixUnit, "ml", lg)
    # Translation du profil
    #destination_point = Geom::Point3d.new( - (@largExt / 2 - @boisLarg / 2), 0, 0)  # point de destination
    translation_vector = destination_point - instance.bounds.center # Calculer la translation n écessaire 
    instance.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
    # Rotation du profil
    point = instance.bounds.center# Définir le point de rotation (ici, l'origine du groupe)
    axis = [0, 1, 0]  # Définir l’axe de rotation (ici, l’axe y)
    angle_degrees = angleRotation# Définir l’angle de rotation en radians
    angle_radians = angle_degrees.degrees  # Convertir en radians
    transformation = Geom::Transformation.rotation(point, axis, angle_radians)# Créer la transformation de rotation
    instance.transform!(transformation)# Appliquer la transformation au groupe
  end  # fin de profilDeuxBateeOpposees

  def self.creer_Seuil(nom, lg, nom2, angleRotation, destination_point)
    model = Sketchup.active_model
    definition = model.definitions.add(nom)
    # Pts profil seuil 27 x 56
    pts = []
    pts[0] = Geom::Point3d.new(0, 0, 0)
    pts[1] = Geom::Point3d.new(0, 0, 0.2.cm)
    pts[2] = Geom::Point3d.new(0, 5.3.cm, 1.1.cm)
    pts[3] = Geom::Point3d.new(0, 5.3.cm, 2.7.cm)
    pts[4] = Geom::Point3d.new(0, 5.6.cm, 2.7.cm) 
    pts[5] = Geom::Point3d.new(0, 5.6.cm, 0)
    face = definition.entities.add_face(pts)
    face.pushpull(lg)
    instance = model.entities.add_instance(definition, Geom::Transformation.new)
    instance.make_unique
    instance.name = (nom2)
    #information composant
    info_composant(instance, "seuil alu", @prixMlSeuil, "ml", lg)
    # Translation du profil
    #destination_point = Geom::Point3d.new( - (@largExt / 2 - @boisLarg / 2), 0, 0)  # point de destination
    translation_vector = destination_point - instance.bounds.center # Calculer la translation n écessaire 
    instance.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
    # Rotation du profil
    point = instance.bounds.center# Définir le point de rotation (ici, l'origine du groupe)
    axis = [0, 1, 0]  # Définir l’axe de rotation (ici, l’axe y)
    angle_degrees = angleRotation# Définir l’angle de rotation en radians
    angle_radians = angle_degrees.degrees  # Convertir en radians
    transformation = Geom::Transformation.rotation(point, axis, angle_radians)# Créer la transformation de rotation
    instance.transform!(transformation)# Appliquer la transformation au groupe      
  end  #Creation du seuil 

  def self.inserer_vitrage_entre_deux_traverses(travHaute, travBasse, ep_Verre, bateeLarg, jeuVerre, largBois) 
    model = Sketchup.active_model
    ents = model.active_entities
    def_name = "Vitrage"
    definition_verre = model.definitions[def_name] || model.definitions.add(def_name)
    definition_verre.entities.clear! if definition_verre.entities.count > 0

    nom_vitrage  = "Vitrage"
    # defini le centre du volume entre les 2 traverses
    bb = travHaute.bounds
    x_min1, _, z_min1 = bb.min.to_a
    x_max1, _, _ = bb.max.to_a
    bb = travBasse.bounds
    x_min2, _, _ = bb.min.to_a
    x_max2, _, z_max2 = bb.max.to_a  
    # dimmension du verre
    # verifis la longeur des traverses afin de prendre la plus grand dimension
    if x_max1 >= x_max2 then x_max = x_max1 end
    if x_max2 >= x_max1 then x_max = x_max2 end
    if x_min1 >= x_min2 then x_min = x_min1 end
    if x_min2 >= x_min1 then x_min = x_min2 end
    # UI.messagebox("x_max '#{x_max}, x_min '#{x_min}, travHaute '#{travHaute}, travBasse '#{travBasse}")
    largeurDuVerre = (x_max - x_min ) - (largBois - bateeLarg + jeuVerre) *  2 
    hauteurDuVerre = (z_min1 - z_max2) + (bateeLarg - jeuVerre) * 2
    # 💡 Coordonnées du rectangle autour du centre (dans le repère local)
    x1 =- largeurDuVerre / 2.0
    x2 = largeurDuVerre / 2.0
    z1 =- hauteurDuVerre / 2.0
    z2 = hauteurDuVerre / 2.0
    # - - - Création du vitrage (volume) - -  - 
    grp_vitrage = ents.add_group
    grp_vitrage.name = nom_vitrage
    # rectangle de base
    pts = [
      Geom::Point3d.new(x1, 0, z1), 
      Geom::Point3d.new(x2, 0, z1), 
      Geom::Point3d.new(x2, 0, z2), 
      Geom::Point3d.new(x1, 0, z2)
    ]
    face = grp_vitrage.entities.add_face(pts)
    face.reverse! if face.normal.z < 0
    # extrusion selon l'épaisseur du verre
    face.pushpull(ep_Verre)
    # - - - Application matière transparente - -  - 
    materials = model.materials
    mat = materials["Vitrage"] || materials.add("Vitrage")
    mat.alpha = 0.3  # transparence (1.0 opaque → 0.0 invisible)
    mat.color = Sketchup::Color.new(180, 220, 255) # bleu clair vitre
    grp_vitrage.material = mat
    grp_vitrage.entities.each { |e| e.material = mat if e.respond_to?(:material=) }
    # - - - Boîtes englobantes - -  - 
    bb_bas = travBasse.bounds
    bb_haut = travHaute.bounds
    # - - - Calcul du centre du "rectangle formé par les deux traverses" - -  - 
    x_centre = ( [bb_bas.min.x, bb_haut.min.x].min + [bb_bas.max.x, bb_haut.max.x].max ) / 2.0
    y_centre = ( [bb_bas.min.y, bb_haut.min.y].min + [bb_bas.max.y, bb_haut.max.y].max ) / 2.0
    z_centre = (bb_bas.max.z + bb_haut.min.z) / 2.0
    centre_traverses = Geom::Point3d.new(x_centre, y_centre, z_centre)
    # - - - Centre actuel du vitrage - -  - 
    bb = grp_vitrage.bounds
    centre_vitre = Geom::Point3d.new(
      (bb.min.x + bb.max.x) / 2.0, 
      (bb.min.y + bb.max.y) / 2.0, 
      (bb.min.z + bb.max.z) / 2.0
    )
    # - - - Calcul de la translation - -  - 
    vecteur = centre_traverses - centre_vitre
    tr = Geom::Transformation.translation(vecteur)
    grp_vitrage.transform!(tr)
  end #inserer_vitrage_entre_deux_traverses(travHaute, travBasse) 
     
  def self.inserer_vitrage_dans_cadre(nom_groupe, ep_Verre)
    model = Sketchup.active_model
    groupe = model.entities.grep(Sketchup::Group).find { |g| g.name == nom_groupe }

    unless groupe
      UI.messagebox("❌ Groupe '#{nom_groupe}' introuvable.")
      return
    end

    bb = groupe.bounds
    x_min, y_min, z_min = bb.min.to_a
    x_max, y_max, z_max = bb.max.to_a

    # ⚙️ Paramètres
    # epaisseur_verre = 6.mm
    retrait = 5.mm

    # 🧮 Calculs centraux
    #x_centre = (x_min + x_max) / 2.0
    #z_centre = (z_min + z_max) / 2.0

    largeur = (x_max - x_min) - (retrait  *  2) - (@boisLarg -  @bateeLarg) * 2
    hauteur = (z_max - z_min) - (retrait  *  2) - (@boisLarg -  @bateeLarg) * 2

    # 💡 Coordonnées du rectangle autour du centre (dans le repère local)
    x1 =- largeur / 2.0
    x2 = largeur / 2.0
    z1 =- hauteur / 2.0
    z2 = hauteur / 2.0

    # ⚙️ Position en profondeur (centré dans le cadre)
    epaisseur_cadre = y_max - y_min
    y_centre = (epaisseur_cadre / 2.0)
    y_face = y_centre - (ep_Verre / 2.0)

    # 🔹 Création de la définition pour le vitrage
    def_name = "Vitrage #{nom_groupe}"
    definition_verre = model.definitions[def_name] || model.definitions.add(def_name)
    definition_verre.entities.clear! if definition_verre.entities.count > 0

    # 🔹 Création du rectangle autour de l’origine
    pts = [
      Geom::Point3d.new(x1, 0, z1), 
      Geom::Point3d.new(x2, 0, z1), 
      Geom::Point3d.new(x2, 0, z2), 
      Geom::Point3d.new(x1, 0, z2)
    ]
    face = definition_verre.entities.add_face(pts)
    face.reverse! if face.normal.y < 0
    face.pushpull(ep_Verre)

    # 🔹 Matériau verre
    mat_name = "Verre et Miroir"
    mat = model.materials[mat_name] || model.materials.add(mat_name)
    mat.color = Sketchup::Color.new(180, 220, 255)
    mat.alpha = 0.4
    face.material = mat
    face.back_material = mat

    # 🔹 Calcul du centre du cadre dans le repère global
    cadre_centre_global = bb.center
    # Conversion du centre global → local au groupe
    cadre_centre_local = cadre_centre_global.transform(groupe.transformation.inverse)

    # 🔹 Transformation finale (position locale correcte)
    translation = Geom::Transformation.new([cadre_centre_local.x, y_face, cadre_centre_local.z])
    instance_verre = groupe.entities.add_instance(definition_verre, translation)
    instance_verre.name = "Vitrage"

    puts "✅ Vitrage centré et aligné dans '#{nom_groupe}'."
    return instance_verre
  end
      
  def self.defini_le_centre_entre_deux_pieces(piece1, piece2)
    bb = piece1.bounds
    x_min1, y_min1, z_min1 = bb.min.to_a
    #x_max1, y_max1, z_max1 = bb.max.to_a
      bb = piece2.bounds
    #x_min2, y_min2, z_min2 = bb.min.to_a
    x_max2, y_max2, z_max2 = bb.max.to_a  
    # 🧮 Calculs centraux
    @x_centre = (x_min1 + x_max2) / 2.0
    @y_centre = (y_min1 + y_max2) / 2.0
    @z_centre = (z_min1 + z_max2) / 2.0
  end # defini_le_centre_entre_deux_pieces(piece1, piece2)
      
      
  def self.etiquette_info     
    model = Sketchup.active_model
    ents = model.active_entities
    # - - - Paramètres - - -      
    model = Sketchup.active_model
    ents = model.active_entities
    # - - - Paramètres - -  - 
    texte = "Fenetre - #{@ref}  - \n, 
        Largeur tableau = #{@tableauLarg}\n, 
        Hauteur tableau = #{@tableauHaut}\n, 
        Hauteur Imposte = #{@imposteHauteur}\n, 
        Nombre ouvrant = #{@nombreOuvrant}\n, 
        Porte fenetre = #{@porteFenetre}\n, 
        Hauteur ouvrant = #{@ouvrantHaut.to_cm.round(1)} \n, 
        Largeur ouvrant = #{@ouvrantLarg.to_cm.round(1)}\
        "
    police = "Arial"
    taille = 20.mm
    extrusion = 2.mm
    couleur = Sketchup::Color.new(255, 0, 0)
    position = Geom::Point3d.new( - 10, - 2, 0)
    espacement = 1.2
    # - - - Groupe principal - -  - 
    outer_group = ents.add_group
    gents = outer_group.entities
    # - - - Créer les lignes de texte - -  - 
    lignes = texte.split("\n")
    y_offset = 0
    lignes.each do |ligne|
    line_group = gents.add_group
    line_group.entities.add_3d_text(ligne, 0, police, true, false, taille, 0.1, 0.0, true, extrusion)
    line_group.transform!(Geom::Transformation.new([0, y_offset, 0]))
    line_group.material = couleur
    line_group.entities.each { |e| e.material = couleur if e.respond_to?(:material=) }
    y_offset -= taille  *  espacement
    end
    # - - - Position + rotation - -  - 
    tr_pos = Geom::Transformation.new(position)
    tr_rot = Geom::Transformation.rotation(position, X_AXIS, 90.degrees) # ← rotation verticale ici
    outer_group.transform!(tr_rot  *  tr_pos)
  end #etiquette_info

  def self.creer_Menuiserie(dimensionPrompt = true)    

    if (dimensionPrompt == true) 
      reponse = dimension_Profil_bois()
      if (!reponse)
        return
      end
    end

    calcul_dimension

    # Creation du bati

    destination_point = destination_point = Geom::Point3d.new(0, 0, @hautExt / 2 - @boisBatiLarg / 2)#point de destination
    angleRotation = 90
    batiTH = profilUneBatee("Profil 1", @batiTraverseHautelong, "Bati - Traverse haute", angleRotation, destination_point)

    if @porteFenetre == "Non" then
      # bati montant 1
      destination_point = Geom::Point3d.new( - (@largExt / 2 - @boisBatiLarg / 2), 0, 0)  # point de destination
      angleRotation = 0
      batiMD = profilUneBatee("Profil 1", @batiMontantlongSiPasPF, "Bati - Montant droit", angleRotation, destination_point)

      # bati montant 2
      destination_point = Geom::Point3d.new(@largExt / 2 - (@boisBatiLarg / 2), 0, 0)  # point de destination
      angleRotation = 180
      batiMG = profilUneBatee("Profil 1", @batiMontantlongSiPasPF, "Bati - Montant gauche", angleRotation, destination_point)
      # bati Traverse haute
      # bati Traverse basse
      destination_point = Geom::Point3d.new(0, 0, - (@hautExt / 2 - @boisBatiLarg / 2))
      angleRotation =- 90
      batiTB = profilUneBatee("Profil 1", @batiTraverseHautelong, "Bati - Traverse basse", angleRotation, destination_point)

    else # si PF
      # bati montant 1
      destination_point = Geom::Point3d.new( - (@largExt / 2 - @boisBatiLarg / 2), 0, - (@boisBatiLarg - @bateeLarg) / 2 )  # point de destination
      angleRotation = 0
      batiMD = profilUneBatee("Profil 1", @batiMontantlongSiPF, "Bati - Montant droit", angleRotation, destination_point)

      # bati montant 2
      destination_point = Geom::Point3d.new(@largExt / 2 - (@boisBatiLarg / 2), 0, - (@boisBatiLarg - @bateeLarg) / 2)  # point de destination
      angleRotation = 180
      batiMG = profilUneBatee("Profil 1", @batiMontantlongSiPF, "Bati - Montant gauche", angleRotation, destination_point)
      # bati Traverse haute
      destination_point = Geom::Point3d.new(0, (@boisEp - 5.6.cm) / 2, - ((@hautExt / 2) - 1.35.cm))#point de destination
      batiTB = creer_Seuil("Profil seuil Alu", @largExt, "Bati - Seuil", 0, destination_point) 

    end #si pas pf  

    #creation de la traverse de l'imposte
    if @imposteHauteur > 0 then # avec imposte
      destination_point = Geom::Point3d.new(0, 0, @hautExt / 2  - @batiTraverseIntermediaireDistCentreDuHaut)#point de destination
      batiTI = profilDeuxBateeSymetrique("Profil 3", @batiTraverseIntermediaire, "Bati - Traverse imposte", 90, destination_point)      
      # duplique les traverse pour creer le verre entre deux et les supprimes apres  
      batiTH1 = batiTH.copy
      batiTI1 = batiTI.copy      
      verre = inserer_vitrage_entre_deux_traverses(batiTH1, batiTI1, @EpVerre, @bateeLarg, @jeuVerre, @boisBatiLarg)
      batiTH1.erase!
      batiTI1.erase!

      if @nombreOuvrant == 0 then # si fixe sans ouvrant
        if @porteFenetre == "Oui" then
          grp = Sketchup.active_model.entities.add_group
          bati = grp.entities.add_group batiMD, batiMG, batiTH, batiTB, batiTI, verre
          #UI.messagebox("Dormant - Porte Fenetre - Avec imposte - avec seuil alu( vitrage en fixe non realisable)")
          return
        end

        batiTH1 = batiTI.copy
        batiTI1 = batiTB.copy      
        verre2 = inserer_vitrage_entre_deux_traverses(batiTH1, batiTI1, @EpVerre, @bateeLarg, @jeuVerre, @boisBatiLarg)
        batiTH1.erase!
        batiTI1.erase!
        # groupe les 5 pieces du bati
        grp = Sketchup.active_model.entities.add_group
        bati = grp.entities.add_group batiMD, batiMG, batiTH, batiTB, batiTI, verre, verre2
        return
      else# si 1 ou 2 ouvrants
        # groupe les 5 pieces du bati
        grp = Sketchup.active_model.entities.add_group
        bati = grp.entities.add_group batiMD, batiMG, batiTH, batiTB, batiTI, verre
        bati.name = "Dormant"      
      end # si fixe sans ouvrant

    else # sans imposte
      if @nombreOuvrant == 0 then # si fixe sans ouvrant
        if @porteFenetre == "Oui" then # s PF avec imposte sans ouvrant
          UI.messagebox("Dormant - Porte Fenetre - Sans imposte - avec seuil alu( vitrage en fixe non realisable)")
          # groupe les 4 pieces du bati
          grp3 = Sketchup.active_model.entities.add_group
          bati = grp3.entities.add_group batiMD, batiMG, batiTH, batiTB
          bati.name = "Dormant"
          return
        end
        # dessine le verre dans l'imposte      
        batiTH1 = batiTH.copy
        batiTI1 = batiTB.copy      
        verre1 = inserer_vitrage_entre_deux_traverses(batiTH1, batiTI1, @EpVerre, @bateeLarg, @jeuVerre, @boisBatiLarg)
        batiTH1.erase!
        batiTI1.erase!
        # groupe les 5 pieces du bati
        grp3 = Sketchup.active_model.entities.add_group
        bati = grp3.entities.add_group batiMD, batiMG, batiTH, batiTB, verre1
        bati.name = "Dormant" 
        return
      else # si avec 1 ou 2 ouvrants
        # groupe les 4 pieces du bati
        grp = Sketchup.active_model.entities.add_group
        bati = grp.entities.add_group batiMD, batiMG, batiTH, batiTB
        bati.name = "Dormant"
      end# si fixe sans ouvrant
    end# if # @imposteHauteur > 0

    #creation de l'ouvrant 

    if @porteFenetre == "Non" then # si pas PF
      #destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, (@hautExt / 2 - @decalageOuvrantExtBati) - (@batiTraverseIntermediaireDistCentreDuHaut ))
      if @imposteHauteur > 0  # pas PF avec imposte 
        destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, (@hautExt / 2 - @batiTraverseIntermediaireDistCentreDuHaut - @boisLarg + @bateeLarg + @bateeLarg - @jeu))
      else # pas PF sans imposte 
        destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, (@hautExt / 2 - @boisBatiLarg - @boisBatiLarg / 2 + @bateeLarg + @bateeLarg - @jeu))
      end      
      angleRotation = 90
      ouvTH = profilDeuxBateeOpposees("Profil 2", @OuvrantTraverseLong, "Ouvrant - Traverse haute", angleRotation, destination_point)
      # ouvrant Traverse basse si pas pf
      destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, - (@hautExt / 2 - @decalageOuvrantExtBati))
      angleRotation =- 90
      ouvTB = profilDeuxBateeOpposees("Profil 2", @OuvrantTraverseLong, "Ouvrant - Traverse basse", angleRotation, destination_point)
      # ouvrant montant 1 si pas pf
      defini_le_centre_entre_deux_pieces(ouvTH, ouvTB)
      destination_point = Geom::Point3d.new( - (@OuvrantTraverseLong / 2 - @boisLarg / 2) , @decalageOuvrantRapplique , @z_centre)      
      angleRotation = 0 
      ouvMD = profilDeuxBateeOpposees("Profil 2", @OuvrantMontantLong, "Ouvrant - Montant droit", angleRotation, destination_point)
      # ouvrant montant 2 si pas pf
      destination_point = Geom::Point3d.new((@OuvrantTraverseLong / 2 - @boisLarg / 2) , @decalageOuvrantRapplique , @z_centre)
      angleRotation = 180
      ouvMG = profilDeuxBateeOpposees("Profil 2", @OuvrantMontantLong, "Ouvrant - Montant gauche", angleRotation, destination_point)

    else # si, pf = oui
      # ouvrant Traverse haute si  pf
      if @imposteHauteur > 0  #  PF avec imposte 
        destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, (@hautExt / 2 - @batiTraverseIntermediaireDistCentreDuHaut - @boisLarg + @bateeLarg + @bateeLarg - @jeu))
      else # pas PF sans imposte 
        destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, (@hautExt / 2 - @boisBatiLarg - @boisBatiLarg / 2 + @bateeLarg + @bateeLarg - @jeu))
      end      
      angleRotation = 90
      ouvTH = profilDeuxBateeOpposees("Profil 2", @OuvrantTraverseLong, "Ouvrant - Traverse haute", angleRotation, destination_point)
      # ouvrant Traverse basse si  pf
      destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, - (@hautExt / 2) + @boisLarg / 2 +  @decalageSeuilAlu)
      angleRotation =- 90
      ouvTB = profilDeuxBateeOpposees("Profil 2", @OuvrantTraverseLong, "Ouvrant - Traverse basse", angleRotation, destination_point)

      # ouvrant montant 1 si pf
      defini_le_centre_entre_deux_pieces(ouvTH, ouvTB)
      destination_point = Geom::Point3d.new( - (@OuvrantTraverseLong / 2 - @boisLarg / 2) , @decalageOuvrantRapplique , @z_centre)      
      angleRotation = 0 
      ouvMD = profilDeuxBateeOpposees("Profil 2", @OuvrantMontantLongSiPF, "Ouvrant - Montant droit", angleRotation, destination_point)
      # ouvrant montant 2 si pas pf
      destination_point = Geom::Point3d.new((@OuvrantTraverseLong / 2 - @boisLarg / 2) , @decalageOuvrantRapplique , @z_centre)
      angleRotation = 180
      ouvMG = profilDeuxBateeOpposees("Profil 2", @OuvrantMontantLongSiPF, "Ouvrant - Montant gauche", angleRotation, destination_point)
    end # if @porteFenetre == "Non" then


    if @allegeHauteur > 0
      # creation de la traverse Intermediaire si pf
      destination_point = Geom::Point3d.new(0, @decalageOuvrantRapplique, - (@hautExt / 2) + @boisLarg + @allegeHauteur)
      angleRotation =- 90
      ouvTI = profilDeuxBateeSymetrique("Profil 3", @OuvrantTraverseIntermediaireLong, "Ouvrant - Traverse Intermediaire", angleRotation, destination_point)
      # duplique les traverse pour creer le verre entre traverse Haute et Intermediaire et les suppriment apres
      ouvTH1 = ouvTH.copy
      ouvTI2 = ouvTI.copy
      ouvrantV2 = inserer_vitrage_entre_deux_traverses(ouvTH1, ouvTI2, @EpVerre, @bateeLarg, @jeuVerre, @boisLarg)
      ouvTH1.erase!
      ouvTI2.erase!
      # groupe les 6 elements
      grp4 = Sketchup.active_model.entities.add_group
      ouvrant1 = grp4.entities.add_group ouvMD, ouvMG, ouvTB, ouvrantV2, ouvTH, ouvTI
    else  # si Pas d'Allege
      # groupe les 4 cotés d'ouvrant 
      ouvTH1 = ouvTH.copy
      ouvTI2 = ouvTB.copy
      #UI.messagebox("Pas d'allege)")
      ouvrantV2 = inserer_vitrage_entre_deux_traverses(ouvTH1, ouvTI2, @EpVerre, @bateeLarg, @jeuVerre, @boisLarg)
      ouvTH1.erase!
      ouvTI2.erase!
      grp = Sketchup.active_model.entities.add_group
      ouvrant1 = grp.entities.add_group ouvMD, ouvMG, ouvTH, ouvTB, ouvrantV2     
      ouvrant1.name = "Ouvrant 1"     
    end

    if @nombreOuvrant.to_f > 1 then  # si 2 ouvrants
      # Repositionner le 1er ouvrant 
      z1 = ouvrant1.bounds.center.z
      destination_point = Geom::Point3d.new((@ouvrantLarg + @distEntre2Ouvrants) / 2, @decalageOuvrantRapplique, z1)
      
      translation_vector = destination_point - ouvrant1.bounds.center # Calculer la translation n écessaire 
      ouvrant1.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
      # creer et positionner le 2eme ouvrant 
      ouvrant2 = ouvrant1.copy
      ouvrant2.name = "Ouvrant 2"
      z1 = ouvrant1.bounds.center.z
      if @porteFenetre == "Non"
        destination_point = Geom::Point3d.new( - (@ouvrantLarg + @distEntre2Ouvrants) / 2, @decalageOuvrantRapplique, z1)
      else
        destination_point = Geom::Point3d.new( - (@ouvrantLarg + @distEntre2Ouvrants) / 2, @decalageOuvrantRapplique, z1)
      end 
      translation_vector = destination_point - ouvrant2.bounds.center # Calculer la translation n écessaire 
      ouvrant2.transform!(Geom::Transformation.new(translation_vector))# Appliquer la translation au groupe
      # Creation du Meneau
      destination_point = Geom::Point3d.new(0, 0, - (@imposteHauteur / 2))#point de destination
      meneau = profilDeuxBateeSymetrique("Profil 3", @longMeneau, "Meneau", 0, destination_point)
      grp = Sketchup.active_model.entities.add_group
      ouvrants = grp.entities.add_group ouvrant1, ouvrant2, meneau
      ouvrants.name = "Ouvrants" 
      menuiserie = grp.entities.add_group bati, ouvrants
      menuiserie.name = @ref
    else   #si 1 ouvrant = > copie l'ouvrant et le supprime pour le grouper avec le bati
      ouvrant2 = ouvrant1.copy
      bati2 = bati.copy
      grp2 = Sketchup.active_model.entities.add_group
      menuiserie = grp2.entities.add_group bati, ouvrant1
      menuiserie.name = @ref
      ouvrant2.erase!
      bati2.erase!
    end #if @nombreOuvrant > 1 fin de si 2 ouvrants
    
    grp3 = Sketchup.active_model.entities.add_group
    texte = etiquette_info
    menuiserie2 = grp3.entities.add_group menuiserie, texte
    menuiserie2.name = @ref
  end # creer_Menuiserie  
 
  # creer_Menuiserie
  Sketchup.send_action("showComponentOptions:")
 
  def self.testBase()
    self.creer_Menuiserie(true)
  end
  testBase()
end # module