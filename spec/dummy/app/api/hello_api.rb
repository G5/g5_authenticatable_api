class HelloAPI < Grape::API
  get :hello do
    { hello: 'get world' }
  end

  post :hello do
    { hello: 'post world' }
  end
end
