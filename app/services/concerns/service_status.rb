# frozen_string_literal: true

module ServiceStatus
  def success?
    errors.empty?
  end

  def errors
    @errors ||= []
  end
end
