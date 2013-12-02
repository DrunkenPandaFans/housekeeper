require File.expand_path(File.dirname(__FILE__) + '/app/boot')

require 'sprockets'

styles = Sprockets::Environment.new
styles.append_path 'app/frontend/styles'

scripts = Sprockets::Environment.new
scripts.append_path 'app/frontend/scripts'

map('/css') { run styles }

map('/js')  { run scripts }

map('/')    { run Housekeeper::App }