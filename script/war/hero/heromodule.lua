heromodule = {}

require "script.war.hero.goldenhero"
require "script.war.hero.woodhero"
require "script.war.hero.waterhero"
require "script.war.hero.firehero"
require "script.war.hero.soilhero"

heromodule[cgoldenhero.race] = cgoldenhero
heromodule[cwoodhero.race] = cwoodhero
heromodule[cwaterhero.race] = cwaterhero
heromodule[cfirehero.race] = cfirehero
heromodule[csoilhero.race] = csoilhero

return heromodule
