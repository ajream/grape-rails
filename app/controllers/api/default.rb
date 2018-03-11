module API
  module Default
    extend ActiveSupport::Concern

    included do
      include Helpers::Common

      version 'v1', using: :path

      # grape 数据默认支持一下四种格式, 只要声明，默认的形式就会被覆盖
      # content_type :json, 'application/json'
      # content_type :xml, 'application/xml'
      # content_type :txt, 'application/plain'
      # content_type :binary, 'application/octet-stream'

      default_format :json

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ code: 1, message: 'not found' }, 404)
      end

      rescue_from NoMethodError do |e|
        error!({ code: 1, message: 'system error' }, 422)
      end

      # rescue_from :all
    end
  end
end