require 'spec_helper'

describe PagesController do

  describe '#dashboard' do
    before do
      get(:dashboard)
    end

    it { should render_template(:dashboard) }
  end

end
