# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      redirect_to 'https://bitpharma.xyz/confirmation/true'
    else
      redirect_to 'https://bitpharma.xyz/confirmation/false'
    end
  end
end