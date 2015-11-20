module TimespanConcern extend ActiveSupport::Concern
  module ClassMethods
    protected
    
      def timespan_field(name)
        define_method("#{name.to_s}=") do |str|
          if str.blank?
            super(str)
          else
            super(Myp.process_duration_timespan(str).to_i)
          end
        end

        define_method("#{name.to_s}") do
          total_seconds = super()
          if total_seconds.nil?
            nil
          else
            seconds = total_seconds % 60
            minutes = (total_seconds / 60) % 60
            hours = (total_seconds / (60 * 60)) % (24)
            days = total_seconds / (60 * 60 * 24)

            format("%d Days, %02d:%02d:%02d", days, hours, minutes, seconds)
          end
        end

        define_method("#{name.to_s}_seconds") do
          read_attribute(name.to_sym)
        end
      end
  end
end
