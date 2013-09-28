require 'spec_helper'

describe ExportJob do
  let(:board) { Fabricate(:board_with_cards) }
  let(:user) { board.user }
  let(:job) { ExportJob.new(user) }

  subject{ job }

  context '#perform' do
    context 'when user has no boards' do
      let(:user) { Fabricate(:user) }

      before do
        job.perform
      end

      its('user_dir.to_s') { should match(user.id.to_s) }
      its(:boards) { should be_empty }
      its(:template) { should be_nil }
      its(:template_path) { should eq(
        Rails.root.join('app', 'views', 'jobs', 'export_board.text.erb')) }
    end

    context 'when user has boards' do
      before do
        job.should_receive(:prepare_boards)
        job.should_receive(:generate_json)
        job.should_receive(:generate_markdown)
        job.should_receive(:archive)
        job.should_receive(:send_email)
        job.perform
      end

      its(:boards) { should be_empty }
    end
  end

  context '#prepare_boards' do
    before do
      job.should_receive(:prepare_boards).and_call_original
      job.should_receive(:generate_json)
      job.should_receive(:generate_markdown)
      job.should_receive(:archive)
      job.should_receive(:send_email)
      job.perform
    end

    its('boards.count') { should eq(user.boards.count) }

    context '#boards.first' do
      subject(:first_board){ job.boards.first }

      its('keys.sort') { should eq(%w(cards description id project title)) }

      context 'cards' do
        subject{ first_board['cards'] }

        it { should_not be_empty }
      end

      context 'cards.first' do
        subject{ first_board['cards'].first }

        its('keys.sort') { should eq(%w(author content created_at data help
          parent_card_id position question style title type updated_at)) }
      end
    end

  end

  context '#generate_json' do
    before do
      job.should_receive(:generate_json).and_call_original
      job.should_receive(:generate_markdown)
      job.should_receive(:archive)
      job.should_receive(:send_email)
      job.perform
    end

    it 'generates json files' do
      job.boards.each do |b|
        json = File.read(job.user_dir.join(b['id'].to_s + '.json'))
        json.should eq(b.to_json)
      end
    end
  end

  context '#generate_markdown' do
    before do
      job.should_receive(:generate_markdown).and_call_original
      job.should_receive(:archive)
      job.should_receive(:send_email)
      job.perform
    end

    it 'generates markdown files' do
      job.boards.each do |b|
        mkdn = File.read(job.user_dir.join(b['id'].to_s + '.markdown'))
        mkdn.should include(b['title'])
        mkdn.should include(b['project'])
        mkdn.should include(b['description'])
        b['cards'].each do |c|
          mkdn.should include(c['title'])
          mkdn.should include(c['question'])
          mkdn.should include(c['content'].to_s)
          mkdn.should include(c['type'])
          c['data'].each do |k, v|
            mkdn.should include(k.humanize + ': ' + v)
          end
        end
      end
    end
  end

  context '#archive' do
    before do
      job.should_receive(:archive).and_call_original
      job.should_receive(:send_email)
      job.perform
    end

    subject{ Pathname.new(job.user_dir + '.zip') }

    it { should exist }
    its(:size) { should_not eq(0) }
  end

  context '#send_email' do
  end
end
