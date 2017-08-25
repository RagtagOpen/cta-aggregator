class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    readable?
  end

  def show?
    readable?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && ((user.id == record.user_id) || user.admin)
  end

  def destroy?
    user.present? && user.admin
  end

  def readable?
    true
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
