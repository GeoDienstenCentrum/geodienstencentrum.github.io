#
# Jekyll Generator for CSS from SCSS
#
# (File paths in this description relative to jekyll project root directory)
# Place this file in ./_plugins
# Place .scss files in ./_scss
# Compiles .scss files in ./_scss to .css files in whatever directory you indicated in your config
# Config file placed in ./_sass/config.rb
# 
require 'sass'
require 'pathname'
require 'compass'
require 'compass/exec'

module Jekyll
 
	class CompassGenerator < Generator
		safe true

		def generate(site)
			Dir.chdir File.expand_path('../_sass', File.dirname(__FILE__)) do
				STDERR.puts "\nVariable 'production' is #{site.config["production"].inspect}."
				if site.config["production"]
					Compass::Exec::SubCommandUI.new(%w(compile)).run!
				else
					#Compass::Exec::SubCommandUI.new(['compile','-e','development','-s','expanded','--force','--debug-info']).run!
					Compass::Exec::SubCommandUI.new(%w(compile -e development -s expanded --force --debug-info)).run!
				end
			end
		end

	end

end