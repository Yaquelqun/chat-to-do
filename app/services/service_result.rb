class ServiceResult
    attr_reader :result, :errors

    def initialize(result: nil, errors: [])
      @result = result
      @errors = errors
    end

    def success?
      errors.empty?
    end

    def failure?
      !success?
    end
end
