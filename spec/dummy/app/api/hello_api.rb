class HelloAPI < Grape::API
  helpers G5AuthenticatableApi::GrapeHelpers

  before { authenticate_user! }

  get :hello do
    { hello: 'get world' }
  end

  post :hello do
    { hello: 'post world' }
  end
end
