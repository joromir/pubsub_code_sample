class FakeConnection
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def puts(*args); end

  def recv(*)
    params.to_json
  end
end
