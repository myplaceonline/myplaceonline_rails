class CustomDeviseFailure < Devise::FailureApp
  def respond
    super()
    self.status = 200
  end
end
