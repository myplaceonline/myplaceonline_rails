Rails.application.config.after_initialize do
  Rails.logger.debug{"Initializing ElasticSearch classes"}
  Zeitwerk::Loader.eager_load_all
  ElasticWrapper.initialize()
end
