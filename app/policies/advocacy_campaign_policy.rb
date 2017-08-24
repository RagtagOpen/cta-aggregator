class AdvocacyCampaignPolicy < ApplicationPolicy

  # Current policy is that users can only update records they create
  # Pundit expects users to be able to update objects that the main resource
  # has_many of.
  # This methods is a way to sidestep Pundit's expectation and allow targets
  # to be assocaited with AdvocacyCampaigns. For details, see Pundit's
  # DefaultPunditAuthorizer#create method
  def create_with_targets?(records)
    true
  end

end
