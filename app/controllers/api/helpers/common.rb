module API
  module Helpers
    module Common
      extend ActiveSupport::Concern

      included do
        helpers do
          def build_response code: 0, data: nil
            { code: code, data: data }
          end

          params :id_validator do
            requires :id, type: {value: String, message: "id 只能是整数"}
          end
        end
      end
      
    end
  end
end