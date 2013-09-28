require 'erb'
require 'zip'
require 'pathname'

# Data export job
class ExportJob < Struct.new(:user)
  attr_accessor :user_dir, :boards, :template_path, :template

  def markdown_template
    @template ||= ERB.new(template_path.read())
  end

  # Job starts here
  def perform
    @boards = []
    @template_path =
      Rails.root.join('app', 'views', 'jobs', 'export_board.text.erb')
    @user_dir = Pathname.new(Dir.tmpdir).join(user.id.to_s)
    @user_dir.unlink if @user_dir.exist?
    @user_dir.mkpath

    unless user.boards.empty?
      prepare_boards
      generate_json
      generate_markdown
      archive
      send_email
    end
  end

  def prepare_boards
    user.boards.each do |board|
      board_data = board.attributes.slice('id', 'title', 'description')
      board_data['project'] = board.project.title if board.project

      board_data['cards'] = []
      board.cards.each do |card|
        card_data = card.attributes.except(
          'id', 'user_id', 'project_id', 'board_id', 'type')
        card_data['type'] = card.type.demodulize
        card_data['author'] = card.user.nicename

        board_data['cards'].push(card_data)
      end

      boards.push(board_data)
    end
  end

  def generate_json
    boards.each do |board|
      board_path = user_dir.join(board['id'].to_s + '.json')
      File.write(board_path, board.to_json)
    end
  end

  def generate_markdown
    boards.each do |board|
      board_path = user_dir.join(board['id'].to_s + '.markdown')
      file_data = markdown_template.result(binding)
      File.write(board_path, file_data)
    end
  end

  def archive
    file_path = user_dir + '.zip'
    file_path.unlink if file_path.exist?

    prefix = user_dir + '/'
    files = Dir[File.join(user_dir, '**', '**')]
    Zip::ZipFile.open(file_path, Zip::ZipFile::CREATE) do |zipfile|
      files.each do |file|
        zipfile.add(file.sub(prefix.to_s, ''), file)
      end
    end
  end

  def send_email
  end

end
