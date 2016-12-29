module ApipieDocs
  module Api
    module V1
      module OrganizationDoc
        extend BaseResource

        def self.superclass
          Api::V1::OrganizationsController
        end

        def_param_group :organization do
          param :email, String, desc: 'Email', required: true, action_aware: true
          param :name, String, desc: 'Name of the organization', required: true, action_aware: true
          param :asignee, String, desc: 'Name of the responsable person', required: true, action_aware: true
          param :phone_number, String, desc: 'Must be a valid phone number', required: true, action_aware: true
          param :city, String, desc: 'City of the organization', required: true, action_aware: true
          param :description, String, desc: 'organization description', required: true, action_aware: true
          param :password, String, desc: 'Password for login', required: true, action_aware: true
          param :password_confirmation, String, desc: 'Password confirmation', required: true, action_aware: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :index do
          api :GET, '/organizations', 'Retrevie a list of organizations'
          param :filter, %w(limit offset),
                'The filtering query:
                - url example for filtering by limit and offset:
                    .../api/organizations?limit=10&offset=2
              '
        end

        doc_for :show do
          api :GET, '/organizations/:id', 'Retrevie a specific organization'
          error 404, 'Not Found'
        end

        doc_for :create do
          api :POST, '/organizations', 'Create a organization'
          param_group :organization, as: :create
        end

        doc_for :update do
          api :PUT, '/organizations/:id', 'Update a specific organization'
          param_group :organization, as: :update
          error 404, 'Not Found'
        end

        doc_for :destroy do
          api :DELETE, '/organizations/:id', 'Delete a specific organization'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end
      end
    end
  end
end
