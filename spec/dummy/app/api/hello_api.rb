class HelloAPI < Grape::API
  get :hello do
    { hello: "world" }
  end
end
