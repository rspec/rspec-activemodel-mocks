# frozen_string_literal: true
# Docs suggest I don't need this, but ...
YARD::Server::Commands::StaticFileCommand::STATIC_PATHS << File.expand_path("../../../fulldoc/html/", __FILE__)

def stylesheets
  super + ['css/rspec.css']
end
