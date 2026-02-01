# Copyright 2026 i3D
# Licensed under the MIT license

require 'sketchup.rb'
require 'extensions.rb'

module I3D
  module MenuiseriesExterieures

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Menuiseries exterieures', 'MenuiseriesExterieures/main')
      ex.description = 'Un outil pour générer des menuiseries extérieures à fabriquer soi-même avec seulement des outils éléctro-portatifs.'
      ex.version     = '0.1.0'
      ex.copyright   = 'I3D © 2026'
      ex.creator     = 'Eric'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end
end