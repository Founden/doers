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
      it do
        job.should_receive(:prepare_boards).and_call_original
        job.should_receive(:generate_json).and_call_original
        job.should_receive(:generate_markdown).and_call_original
        job.should_receive(:archive).and_call_original
        job.should_receive(:send_email).and_call_original
        UserMailer.should_receive(:export_data).and_call_original
        expect{
          job.perform
        }.to_not raise_error
      end
    end
  end

  context '#prepare_boards' do
    before do
      job.should_receive(:prepare_boards).and_call_original
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
      job.should_receive(:prepare_boards).and_call_original
      job.should_receive(:send_email)
      job.perform
    end

    subject { job.generate_json }

    its(:size) { should eq(user.boards.count) }

    it 'generates json files' do
      job.generate_json
      job.boards.each do |b|
        json = File.read(job.user_dir.join(b['id'].to_s + '.json'))
        json.should eq(b.to_json)
      end
    end
  end

  context '#generate_markdown' do
    before do
      job.should_receive(:prepare_boards).and_call_original
      job.should_receive(:send_email)
      job.perform
    end

    subject { job.generate_markdown }

    its(:size) { should eq(user.boards.count) }

    it 'generates markdown files' do
      job.generate_markdown
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
      job.should_receive(:prepare_boards).and_call_original
      job.should_receive(:send_email)
      job.perform
    end

    subject { job.archive }

    it { should exist }
    its(:size) { should_not eq(0) }
  end

  context '#send_email' do
    before do
      tmp_path = Pathname.new(Dir.tmpdir).join(rand(100).to_s)
      File.write(tmp_path, rand(100))
      job.should_receive(:archive).and_return(tmp_path)
      tmp_path.should_receive(:unlink)

      UserMailer.should_receive(:export_data).and_call_original
      FileUtils.should_receive(:rm_rf).with(job.user_dir)
    end

    it do
      expect{
        job.send_email
      }.to_not raise_error
    end
  end
end
