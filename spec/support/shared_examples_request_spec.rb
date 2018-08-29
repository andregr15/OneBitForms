shared_examples_for :deny_without_authorization do |method_type, action, params = {}|
  it 'should returns unauthorized(401) request' do
    case method_type
    when :get
      get action,
        params: params,
        headers: header_without_authentication
    when :post
      post action,
        params: params,
        headers: header_without_authentication
    when :put
      put action,
        params: params,
        headers: header_without_authentication
    when :delete
      delete action,
        params: params,
        headers: header_without_authentication
    end

    expect(response.status).to eql(401)
  end
end