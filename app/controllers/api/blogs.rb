module API
  class Blogs < Grape::API
    default_format :json

    helpers do
      def build_response code: 0, data: nil
        { code: code, data: data }
      end

      params :id_validator do
        requires :id, type: {value: String, message: "id 只能是整数"}
      end
    end

    #别名： namespace, resource, group, segment
    resources :blogs do
      get do
        build_response data: { blogs: [] }
      end

      desc "获得博客详情"
      params do
        # requires :id, type: Integer
        use :id_validator
      end

      get ':id', requirements: { id: /\d+/ } do
        build_response data: "id #{ params[:id] }"
      end

      desc "create a blog"
      params do
        # requires 必须参数
        requires :title, type: String, desc: "博客标题"
        requires :content, type: String, desc: "博客内容", as: :body # as 给 content 起别名
        # optional 可选参数
        optional :tags, type: Array, desc: "博客标签", allow_blank: false
        # default 指当 state 没有传值时，设定一个默认值; values 指值只能是数组里面的
        optional :state, type: Symbol, default: :pending, values: [:pending, :done]
        optional :meta_name, type: {value: String, message: "meta_name 必须为字符串"}, regexp: { value: /^s\-/, message: "meta_name 不合法"}
        optional :cover, type: File
        # given: 如果参数里有 cover 参数则执行下一步（weigth）校验
        given :cover do
          requires :weight, type: Integer, values: { value: ->(v) { v >= -1 }, message: "weight 必须要大于等于-1" }
        end

        optional :comments, type: Array do
          requires :content, type: String, allow_blank: false
        end

        optional :category, type: Hash do
          requires :id, type: Integer
        end
      end

      post do
        build_response data: params
      end

      desc "修改博客"
      params do
        use :id_validator
      end
      put ':id' do
        build_response data: "put #{params[:id]}"
      end

      desc "删除博客"
      params do
        use :id_validator
      end
      delete ':id' do
        build_response data: "delete #{params[:id]}"
      end

      # /blogs/1/comments
      route_param :id do
        resources :comments do
          get do
            build_response data:  "blog #{params[:id]} comments"
          end
        end
      end

      # /blogs/hot/pop/1 
      get 'hot(pop(/:id))' do
        build_response data: "hot #{params[:id]}"
      end

      get 'latest', hidden: true do
        redirect '/api/blogs/popular'
      end

      get 'popular' do
        status 402
        build_response data: 'popular'
      end
    end

    add_swagger_documentation(
      info: {
        title: 'GrapeRails API Documentation',
        contact_email: 'ajream.gd@gmail.com'
      },
      mount_path: '/doc/swagger',
      doc_version: '0.1.0'
    )
  end
end