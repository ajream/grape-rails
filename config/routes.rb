Rails.application.routes.draw do
  mount API::Blogs => '/api'
  mount GrapeSwaggerRails::Engine => '/api/doc'
end
