require 'spec_helper'

describe PagesController do

  describe 'routing' do

    it 'for dashboard' do
      get('/dashboard').should route_to('pages#dashboard')
    end

    it 'for waiting page' do
      get('/waiting').should route_to('pages#waiting')
    end

    it 'for waiting page (PATCH)' do
      patch('/waiting').should route_to('pages#waiting')
    end

    it 'for promo code page' do
      get('/promo_code').should route_to('pages#promo_code')
    end

    it 'for promo code page (PATCH)' do
      patch('/promo_code').should route_to('pages#promo_code')
    end

  end
end

