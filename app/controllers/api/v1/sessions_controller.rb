module Api
  module V1
    class SessionsController < Api::BaseController
      respond_to :json

      def create
        user = User.find_by(email: params[:email])
        raise InvalidAPIRequest.new('Invalid username or password', 401) unless valid_sign_in?(user)
        sign_in user
        user.generate_authentication_token!
        user.save(validate: false)
        render json: { success: true, data: user.as_json(only: :auth_token) }, status: 200
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        raise InvalidAPIRequest.new('User not found', 401) unless user.present?
        user.generate_authentication_token!
        user.save(validate: false)
        head 204
      end

      def sign_in(resource)
        Devise::Mapping.find_scope!(resource)
      end

      def valid_sign_in?(user)
        user.present? && user.valid_password?(params[:password]) && user.active?
      end
    end
  end
end
