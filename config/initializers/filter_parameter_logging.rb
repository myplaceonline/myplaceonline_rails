Rails.logger.debug{"Loading filter_parameter_logging.rb"}
# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password]
