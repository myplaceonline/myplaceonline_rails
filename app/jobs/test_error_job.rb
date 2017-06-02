class TestErrorJob < ApplicationJob
  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.info{"Started TestErrorJob"}
      raise "TestErrorJob Exception"
      Rails.logger.info{"Ended TestJob"}
    end
  end
end
