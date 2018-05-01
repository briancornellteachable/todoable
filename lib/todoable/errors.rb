module Todoable
  class UnprocessableEntityError < StandardError
  end

  class RecordNotFoundError < StandardError
  end

  class UnauthorizedError < StandardError
  end
end
