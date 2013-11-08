# [Stats] serializer
class StatsSerializer < ActiveModel::Serializer
  root false
  attributes :users, :projects, :boards, :topics
  attributes :suggestions, :comments, :activities

  attr_accessor :empty_data

  # Serializes users
  def users
    results = User.limit(limit).where(:created_at => interval).
      where("data -> 'confirmed' <> 'true'").
      select(:created_at).reverse.group_by{ |u| u.created_at.to_date}

    results_active = User.limit(limit).where(:created_at => interval).
      where("data -> 'confirmed' = 'true'").
      select(:created_at).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)
    stats_active = prepare_data(results_active)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_redish),
        {:data => stats_active.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes projects
  def projects
    results = Project.limit(limit).where(:created_at => interval).
      where(:external_id => nil).
      select(:created_at, :status).reverse.group_by{ |u| u.created_at.to_date}

    results_angelco = Project.limit(limit).where(:created_at => interval).
      where.not(:external_id => nil).
      select(:created_at, :status).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)
    stats_angelco = prepare_data(results_angelco)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_redish),
        {:data => stats_angelco.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes boards
  def boards
    results = Board.limit(limit).where(:created_at => interval).
      select(:created_at, :status).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes topics
  def topics
    results = Topic.limit(limit).where(:created_at => interval).
      where(:aligned_card_id => nil).
      select(:created_at, :position).reverse.group_by{ |u| u.created_at.to_date}

    results_aligned = Topic.limit(limit).where(:created_at => interval).
      where.not(:aligned_card_id => nil).
      select(:created_at, :position).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)
    stats_aligned = prepare_data(results_aligned)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_redish),
        {:data => stats_aligned.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes suggestions
  def suggestions
    results = Card.limit(limit).where(:created_at => interval).
      select(:created_at, :position, :style).
      reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes comments
  def comments
    results = Comment.limit(limit).where(:created_at => interval).
      select(:created_at).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_greenish)
      ]
    }
  end

  # Serializes activities
  def activities
    results = Activity.limit(limit).where(:created_at => interval).
      where(:type => nil).
      select(:created_at).reverse.group_by{ |u| u.created_at.to_date}

    results_endorses = Activity.limit(limit).where(:created_at => interval).
      where(:type => Endorse.name).
      select(:created_at).reverse.group_by{ |u| u.created_at.to_date}

    stats = prepare_data(results)
    stats_endorses = prepare_data(results_endorses)

    {
      :labels => stats.keys, :datasets => [
        {:data => stats.values}.merge(colors_redish),
        {:data => stats_endorses.values}.merge(colors_greenish)
      ]
    }
  end

  private

  # How many days to query
  def limit
    7
  end

  # Returns a time interval based on set days limit
  def interval
    (Date.current - limit.days) .. Date.tomorrow
  end

  # Pretty much an empty data
  def data
    return @empty_data if @empty_data

    @empty_data = {}
    interval.each do |day|
      @empty_data[day.to_s(:short)] = 0
    end
    @empty_data
  end

  # Prepares the data
  def prepare_data(results)
    db_data = {}
    results.each do |day, values|
      db_data[day.to_s(:short)] = values ? values.count : 0
    end

    data.merge(db_data)
  end

  # Colors with more green
  def colors_greenish
    {
      :fillColor => '#47a718',
      :strokeColor => '#365470',
      :pointColor => '#f7f7f1',
      :pointStrokeColor => '#fff'
    }
  end

  # Colors with more red
  def colors_redish
    {
      :fillColor => '#ff4949',
      :strokeColor => '#365470',
      :pointColor => '#f7f7f1',
      :pointStrokeColor => '#fff'
    }
  end
end
