# Require any additional compass plugins here.

environment     = :production

# Set this to the root of your project when deployed:
http_path       = "/"
sass_dir        = "./"
css_dir         = "../css"
images_dir      = "../img"
javascripts_dir = "../js"
fonts_dir       = "../fonts"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style    = (environment == :production) ? :compressed : :expanded
sourcemap       = (environment == :development)

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
