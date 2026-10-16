Rails.logger.debug{"Loading active_record_query_trace.rb"}
if Rails.env.development?
  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.ignore_cached_queries = true
  ActiveRecordQueryTrace.lines = 5
  ActiveRecordQueryTrace.colorize = :blue
  ActiveRecordQueryTrace.level = :app # :full
end
