# DOERS [Activity] class
class Activity < ActiveRecord::Base
  # Some dynamic attributes
  store_accessor :data, :user_name, :project_name, :board_name
  store_accessor :data, :trackable_name

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :user
  belongs_to :trackable, :polymorphic => true

  # Validations
  validates_presence_of :user
  validates_presence_of :trackable_id
  validates_presence_of :trackable_type
  validates_presence_of :slug
end
