if Rails.env.development?
  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.ignore_cached_queries = true
  ActiveRecordQueryTrace.lines = 5
  ActiveRecordQueryTrace.colorize = :blue
  ActiveRecordQueryTrace.level = :app
end
