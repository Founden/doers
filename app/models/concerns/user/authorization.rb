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
    when /Team|Banner/
      action.to_sym != :write
    when /Image|Logo|Cover|Asset/
      !assets_to(action).where(:id => target).empty?
    when 'Board'
      !boards_to(action).where(:id => target).empty?
    when 'Project'
      !projects_to(action).where(:id => target).empty?
    when /Card/
      !cards_to(action).where(:id => target).empty?
    when /Activity|Endorse/
      !activities_to(action).where(:id => target).empty?
    when 'Comment'
      !comments_to(action).where(:id => target).empty?
    when 'Topic'
      !topics_to(action).where(:id => target).empty?
    when /Membership/
      !memberships_to(action).where(:id => target).empty?
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
        table[:board_id].in(self.created_board_ids).or(
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

    Asset.where(query)
  end

  # Available boards for user, `action` can be :read or :write
  def boards_to(action)
    table = Board.arel_table

    query =
      # User branched a board
      table[:user_id].eq(self.id).or(
        # User project has it
        table[:project_id].in(self.created_project_ids).or(
          # Somebody shared the project
          table[:project_id].in(self.shared_project_ids)
        )
      )

    Board.where(query)
  end

  # Available cards for user, `action` can be :read or :write
  def cards_to(action)
    table = Card.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User branched the board
        table[:board_id].in(self.created_board_ids).or(
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
        table[:board_id].in(self.created_board_ids).or(
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

  # Available comments for user, `action` can be :read or :write
  def comments_to(action)
    table = Comment.arel_table

    # User is the owner
    query = table[:user_id].eq(self.id)

    if action.to_sym != :write
      query = query.or(
        # User created the board
        table[:board_id].in(self.created_board_ids).or(
          # User created the board
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

    Comment.where(query)
  end

  # Available topics for user, `action` can be :read or :write
  def topics_to(action)
    table = Topic.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User created the board
        table[:board_id].in(self.created_board_ids)
      ).or(
        # Somebody shared its board
        table[:board_id].in(self.shared_board_ids)
      )

    Topic.where(query)
  end

  # Available memberships for user, `action` can be :read or :write
  def memberships_to(action)
    table = Membership.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id).or(
        # User is the creator
        table[:creator_id].eq(self.id)
      )

    if action.to_sym != :write
      query = query.or(
        # Somebody shared its board
        table[:board_id].in(self.shared_board_ids)
      ).or(
        # Somebody shared its project
        table[:project_id].in(self.shared_project_ids)
      )
    end

    Membership.where(query)
  end

  # Available projects for user, `action` can be :read or :write
  def projects_to(action)
    table = Project.arel_table

    query =
      # User is the owner
      table[:user_id].eq(self.id)

    if action.to_sym != :write
      query = query.or(
        # Somebody shared its project
        table[:id].in(self.shared_project_ids)
      )
    end

    Project.where(query)
  end
end
