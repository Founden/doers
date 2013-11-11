class AddMembershipToDelayedJobs < ActiveRecord::Migration
  def change
    add_reference :delayed_jobs, :membership, index: true
  end
end
