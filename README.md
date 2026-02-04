# SketchupMenuiseriesMaker

## Tests unitaires

Pour lancer les tests unitaires, lancer la commande suivante dans un terminal :
```bash
ruby tests/runner
```

## Installation pour le développement

Les infos suivantes viennent de là : https://github.com/SketchUp/sketchup-ruby-api-tutorials/wiki/Development-Setup

Dans le dossier `C:\Users\<monUtilisateur>\AppData\Roaming\SketchUp\SketchUp 2023\SketchUp\Plugins`, ajouter le fichier `!external.rb` qui va permettre de dire à Sketchup "Hey, importe tout ça comme si c'était une extension s'teuplait".

Dans ce fichier, voilà le contenu à y mettre :
```ruby !external.rb

paths = [
  "C:/<CheminVersLeDossier>/SketchupMenuiseriesMaker/src"
]

paths.each { |path|
  $LOAD_PATH << path
  Dir.glob("#{path}/*.{rb,rbs,rbe}") { |file|
    Sketchup.require(file)
  }
}
```

Normalement, là, en lançant Sketchup, l'extension devrait être chargée.

## Recharger l'extension

Si vous faites des modifications du code, vous n'avez pas envie de relancer Sketchup. Donc, si vous n'avez pas changé la structure des classes, il suffit d'ouvrir la console ruby et de lancer `I3D::MenuiseriesExterieures.reload` et c'est parti.