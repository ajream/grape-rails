module API  
  class Base < Grape::API
    mount V1::Blogs     

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