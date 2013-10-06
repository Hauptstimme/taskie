class Task < ActiveRecord::Base
  belongs_to :assignee, class_name: "User"
  belongs_to :project
  has_many :comments, dependent: :destroy

  scope :active, -> { where "status = ?", false }
  scope :completed, -> { where "status = ?", true }
  scope :without_project, -> { where "project_id = ?", nil }

  after_save :notify_assignee, if: ->{ assignee_id_changed? and assignee_id.present? }

  def name_with_id
    [ "##{id}", name ].compact.join(" ")
  end

  private

  def notify_assignee
    TaskMailer.task_assigned(self).deliver
  end
end
