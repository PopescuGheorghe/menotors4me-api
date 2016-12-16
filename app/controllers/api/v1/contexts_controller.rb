module Api
  module V1
    class ContextsController < Api::BaseController
      before_action :authenticate
      before_action :set_context, only: [:show, :update, :destroy, :accept]

      before_action :set_limit, :validate_limit, :validate_profile_id,
                    :validate_start_date, :validate_end_date, :validate_accepted,
                    :validate_organization_id, :validate_offset, only: :index

      has_scope :profile_id, :organization_id, :start_date, :end_date, :accepted, :offset, :limit
      has_scope :date_interval, using: [:start_date, :end_date], type: :hash

      respond_to :json
      load_and_authorize_resource :context, parent: false

      include Filters

      def show
        respond_with build_data_object(@context)
      end

      def index
        respond_with build_data_object(apply_scopes(Context))
      end

      def accept
        @context.update(accepted: true)
        if @context.save!
          render json: build_data_object(@context), status: 200
        else
          render json: build_error_object(@context), status: 422
        end
      end

      def create
        User.find_by!(profile_id: params[:profile_id])
        User.find_by!(organization_id: params[:organization_id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('profile or organization is invalid', 422)
      else
        raise InvalidAPIRequest.new('Context already exists', 422) if Context.where(
          profile_id: params[:profile_id],
          organization_id: params[:organization_id]
        ).any?
        context = Context.new(context_params)
        if context.save
          render json: build_data_object(context), status: 200
        else
          render json: build_error_object(context), status: 422
        end
      end

      private

      def set_context
        @context = Context.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        raise InvalidAPIRequest.new('context not found', 404)
      end

      def context_params
        params.permit(:profile_id, :organization_id, :description)
      end

      def validate_numericality(field, error_message)
        Integer(field) if field.present?
      rescue ArgumentError
        raise InvalidAPIRequest.new(error_message, 422)
      end

      def validate_profile_id
        validate_numericality(params[:profile_id], 'profile_id must be a number')
      end

      def validate_organization_id
        validate_numericality(params[:organization_id], 'organization_id must be a number')
      end

      def validate_limit
        validate_numericality(params[:limit], 'limit must be a number')
      end

      def validate_offset
        validate_numericality(params[:offset], 'offset must be a number')
      end

      def set_limit
        params[:limit] = Context.count if params[:limit].blank?
      end

      def validate_accepted
        return unless params[:accepted].present?
        raise InvalidAPIRequest.new('accepted must be a boolean true/false', 422)
      end

      def validate_start_date
        return unless params[:start_date]
        begin
          valid_date?(params[:start_date])
        rescue ArgumentError
          raise InvalidAPIRequest.new('start date has invalid format', 422)
        end
      end

      def validate_end_date
        return unless params[:end_date]
        begin
          valid_date?(params[:end_date])
        rescue ArgumentError
          raise InvalidAPIRequest.new('end date has invalid format', 422)
        end
        end
      end
    end
end
