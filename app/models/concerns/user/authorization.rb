# [User] authorization support
module User::Authorization
  # Authorizes current user with `action` on `target`, where
  # @param action [String] has one of the `read` or `writes` values
  # @param target [Object] is a model or an array of models to apply `action`
  # @return true if action is doable or false if not
  def can?(action, target, options=nil)
    options ||= { :raise_error => true }

    return true if !target or (target.respond_to?(:empty?) and target.empty?)

    klass = target.respond_to?(:model) ? target.model : target.class

    can = case klass.to_s
    when /Asset|Image|Logo/
      !assets_to(action).where(:id => target).empty?
    when 'Board'
      !boards_to(action).where(:id => target).empty?
    when /Card/
      !cards_to(action).where(:id => target).empty?
    when 'Activity'
      !activities_to(action).where(:id => target).empty?
    else
      # Just check if we are the owners
      target.respond_to?(:user_id) and target.user_id == self.id
    end

    if !can and options[:raise_error]
      raise ActiveRecord::RecordNotFound
    else
      can
    end
  end

  # Available assets for user, `action` can be :read or :write
  def assets_to(action)
    table = Asset.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User branched the board
        table[:board_id].in(self.branched_board_ids).or(
          # User created its board
          table[:board_id].in(self.authored_board_ids)
        ).or(
          # Somebody shared its board
          table[:board_id].in(self.shared_board_ids)
        )
      ).or(
        # User project has it
        table[:project_id].in(self.created_project_ids).or(
          # Somebody shared the project
          table[:project_id].in(self.shared_project_ids)
        )
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:board_id].in(Board.public.pluck('id'))
      )
    end

    Asset.where(query)
  end

  # Available boards for user, `action` can be :read or :write
  def boards_to(action)
    table = Board.arel_table

    query =
      # User is the author
      table[:author_id].eq(self.id).or(
        # User branched a board
        table[:user_id].eq(self.id)
      ).or(
        # User project has it
        table[:project_id].in(self.created_project_ids).or(
          # Somebody shared the project
          table[:project_id].in(self.shared_project_ids)
        )
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:status].eq(Board::STATES.last)
      )
    end

    Board.where(query)
  end

  # Available cards for user, `action` can be :read or :write
  def cards_to(action)
    table = Card.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User branched the board
        table[:board_id].in(self.branched_board_ids).or(
          # User created the board
          table[:board_id].in(self.authored_board_ids)
        ).or(
          # Somebody shared its board
          table[:board_id].in(self.shared_board_ids)
        )
      ).or(
        # User project has it
        table[:project_id].in(self.created_project_ids).or(
          # Somebody shared the project
          table[:project_id].in(self.shared_project_ids)
        )
      )

    if action.to_sym != :write
      query = query.or(
        # Status is `public`
        table[:board_id].in(Board.public.pluck('id'))
      )
    end

    Card.where(query)
  end

  # Available activities for user, `action` can be :read or :write
  def activities_to(action)
    table = Activity.arel_table

    # User is the owner
    query = table[:user_id].eq(self.id)

    if action.to_sym != :write
      query = query.or(
        # User branched the board
        table[:board_id].in(self.branched_board_ids).or(
          # User created the board
          table[:board_id].in(self.authored_board_ids)
        ).or(
          # Somebody shared its board
          table[:board_id].in(self.shared_board_ids)
        )
      ).or(
        # User project has it
        table[:project_id].in(self.created_project_ids).or(
          # Somebody shared the project
          table[:project_id].in(self.shared_project_ids)
        )
      )
    end

    Activity.where(query)
  end
end
