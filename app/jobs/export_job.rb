require 'erb'
require 'zip'
require 'pathname'

# Data export job
class ExportJob < Struct.new(:user)
  attr_accessor :user_dir, :boards, :template_path, :template

  # Sort of memoization to cache a bit ERB template
  def markdown_template
    @template ||= ERB.new(template_path.read())
  end

  # Job starts here
  def perform
    @boards = []
    @template_path =
      Rails.root.join('app', 'views', 'jobs', 'export_board.text.erb')
    @user_dir = Pathname.new(Dir.tmpdir).join(user.id.to_s)
    FileUtils.rm_rf(user_dir) if @user_dir.exist?
    @user_dir.mkpath

    unless user.boards.empty?
      prepare_boards
      send_email
    end
  end

  # Extracts data from boards
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

  # Generates json files out of boards data
  def generate_json
    jsons = []
    boards.each do |board|
      board_path = user_dir.join(board['id'].to_s + '.json')
      File.write(board_path, board.to_json)
      jsons.push(board_path)
    end
    jsons
  end

  # Generates markdown files out of boards data
  def generate_markdown
    mkdns = []
    boards.each do |board|
      board_path = user_dir.join(board['id'].to_s + '.markdown')
      file_data = markdown_template.result(binding)
      File.write(board_path, file_data)
      mkdns.push(board_path)
    end
    mkdns
  end

  # Creates an archive with json and markdown files
  def archive
    prefix = user_dir.to_s + '/'
    file_path = user_dir + '.zip'
    file_path.unlink if file_path.exist?
    files = generate_json + generate_markdown

    Zip::ZipFile.open(file_path, Zip::ZipFile::CREATE) do |zipfile|
      files.each do |file|
        zipfile.add(file.sub(prefix, ''), file)
      end
    end
    file_path
  end

  # Sends the data to user
  def send_email
    zip_path = archive
    UserMailer.export_data(user, zip_path).deliver
    zip_path.unlink if zip_path.exist?
    FileUtils.rm_rf(user_dir)
  end

end
