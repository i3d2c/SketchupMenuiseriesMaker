require 'test/unit'

require_relative '../src/MenuiseriesExterieures/Menuiseries'

Tableau = I3D::MenuiseriesExterieures::Tableau
Pose = I3D::MenuiseriesExterieures::Pose
Bois = I3D::MenuiseriesExterieures::Bois
Vitrage = I3D::MenuiseriesExterieures::Vitrage
Joint = I3D::MenuiseriesExterieures::Joint
Batee = I3D::MenuiseriesExterieures::Batee
Profil = I3D::MenuiseriesExterieures::Profil
Seuil = I3D::MenuiseriesExterieures::Seuil
Bati = I3D::MenuiseriesExterieures::Bati
BatiFenetre = I3D::MenuiseriesExterieures::BatiFenetre
BatiPorteFenetre = I3D::MenuiseriesExterieures::BatiPorteFenetre

class TestBati < Test::Unit::TestCase
  def setup
    @hauteurTableau = 2500
    @largeurTableau = 1200
    @epaisseurBois = 63
    @largeurBois = 86
    @epaisseurVitrage = 18
    @jeuVerre = 3
    @epaisseurJoint = 3
    @profondeurJoint = 4
    @epaisseurBatee = 10
    @largeurBatee = 20
    @hauteurImposte = 2200
    @cochonnet = 12

    @tableau = Tableau.new(@largeurTableau, @hauteurTableau)
    @pose = Pose.new(@tableau, @cochonnet)
    @bois = Bois.new(@largeurBois, @epaisseurBois)
    @vitrage = Vitrage.new(@epaisseurVitrage, @jeuVerre)
    @joint = Joint.new(@epaisseurJoint, @profondeurJoint)
    @batee = Batee.new(@epaisseurBatee, @largeurBatee)
    @profil = Profil.new(@joint, @batee, @bois)
    @bati = Bati.new(@profil, @vitrage, @hauteurImposte)
  end

  # def teardown
  # end

  def test_hauteurExterieure
    result = @bati.hauteurExterieure(@pose)

    assert_equal(@hauteurTableau + @largeurBois - @cochonnet, result)
  end

  def test_largeurExterieure
    result = @bati.largeurExterieure(@pose)

    assert_equal(@largeurTableau + ((@largeurBois - @cochonnet) * 2), result)
  end
end

class TestBatiFenetre < TestBati
  def setup
    super()
    @bati = BatiFenetre.new(@profil, @vitrage, @hauteurImposte)
  end

  def test_longueurMontant
    result = @bati.longueurMontant(@pose)

    assert_equal(@bati.hauteurExterieure(@pose) - (@largeurBois - @largeurBatee) * 2, result)
  end
end

class TestBatiPorteFenetre < TestBati
  def setup
    super()
    @seuil = Seuil.new()
    @bati = BatiPorteFenetre.new(@profil, @vitrage, @hauteurImposte, @seuil)
  end

  def test_longueurMontant
    result = @bati.longueurMontant(@pose)

    assert_equal(@bati.hauteurExterieure(@pose) - (@largeurBois - @largeurBatee), result)
  end
end