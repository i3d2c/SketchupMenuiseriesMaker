require 'test/unit'

class TestOuvertureVide < Test::Unit::TestCase
  def setup
    @epaisseurBois = 50
    @largeurBois = 100
    @epaisseurJoint = 10
    @profondeurJoint = 20
    @epaisseurBatee = 25
    @largeurBatee = 30

    @bois = Bois.new(@epaisseurBois, @largeurBois)
    @joint = Joint.new(@epaisseurJoint, @profondeurJoint)
    @batee = Batee.new(@epaisseurBatee, @largeurBatee)
    @profil = Profil.new(@joint, @batee, @bois)
  end

  # def teardown
  # end

  def test_divisionVerticale_ne_fait_rien_si_largeur_trop_haute()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [0, 0, 0])

    ouverture.divisionVerticale(1500, false)

    assert_nil(ouverture.ouverture1)
    assert_nil(ouverture.ouverture2)
  end

  def test_divisionVerticale_ne_fait_rien_si_largeur_negative()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [0, 0, 0])

    ouverture.divisionVerticale(-500, false)

    assert_nil(ouverture.ouverture1)
    assert_nil(ouverture.ouverture2)
  end

  def test_divisionVerticale_ajoute_ouvertures()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [0, 2, 3])

    ouverture.divisionVerticale(500, false)

    assert_equal(ouverture.ouverture1.hauteur, 2000)
    assert_equal(ouverture.ouverture1.largeur, 500)
    assert_equal(ouverture.ouverture1.position, [250, 2, 3])
    assert_equal(ouverture.ouverture2.hauteur, 2000)
    assert_equal(ouverture.ouverture2.largeur, 460)
    assert_equal(ouverture.ouverture2.position, [-270, 2, 3])
  end

  def test_divisionHorizontale_ne_fait_rien_si_hauteur_trop_haute()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [0, 0, 0])

    ouverture.divisionHorizontale(2500, false)

    assert_nil(ouverture.ouverture1)
    assert_nil(ouverture.ouverture2)
  end

  def test_divisionHorizontale_ne_fait_rien_si_hauteur_negative()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [0, 0, 0])

    ouverture.divisionHorizontale(-500, false)

    assert_nil(ouverture.ouverture1)
    assert_nil(ouverture.ouverture2)
  end

  def test_divisionHorizontale_ajoute_ouvertures()
    ouverture = OuvertureVide.new(@profil, 2000, 1000, [1, 2, 0])

    ouverture.divisionHorizontale(500, false)

    assert_equal(ouverture.ouverture1.hauteur, 500)
    assert_equal(ouverture.ouverture1.largeur, 1000)
    assert_equal(ouverture.ouverture1.position, [1, 2, 750])
    assert_equal(ouverture.ouverture2.hauteur, 1460)
    assert_equal(ouverture.ouverture2.largeur, 1000)
    assert_equal(ouverture.ouverture2.position, [1, 2, -270])
  end

end