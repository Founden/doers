require 'spec_helper'

describe ProfilesController do

  describe '#show' do
    before do
      get(:show, :id => 1)
    end

    it { should render_template(:show) }
  end

end
