if Rails.env.development?
  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.ignore_cached_queries = true
  ActiveRecordQueryTrace.lines = 5
  ActiveRecordQueryTrace.colorize = true
  ActiveRecordQueryTrace.level = :app
end
