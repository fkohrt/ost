class BasicFeedbackCondition < FeedbackCondition
  
  require 'enum'
  
  store_accessor       :settings, :label_regex
  store_accessor       :settings, :is_feedback_required_for_credit
  store_typed_accessor :settings, :integer, :availability_opens_option
  store_typed_accessor :settings, :integer, :availability_opens_delay_days
  store_typed_accessor :settings, :integer, :availability_closes_option
  store_typed_accessor :settings, :integer, :availability_closes_delay_days
  store_typed_accessor :settings, :integer, :availability_event

  # store_typed_accessor :settings, :integer, :test
    
  attr_accessible :label_regex, :is_feedback_required_for_credit, 
                  :availability_opens_option, :availability_opens_delay_days, 
                  :availability_closes_option, :availability_closes_delay_days,
                  :availability_event
                  
  before_validation :init, :on => :create
  before_validation :nil_out_blank_regex

  validates :availability_opens_delay_days, numericality: { only_integer: true,
                                      greater_than: 0 }

  validate :delay_days_specified_if_delay_chosen
  
  class AvailabilityOpensOption < Enum
    NEVER = 0
    IMMEDIATELY_AFTER_EVENT = 1 
    DELAY_AFTER_EVENT = 2
  end
  
  class AvailabilityClosesOption < Enum
    NEVER = 0
    DELAY_AFTER_OPEN = 1
  end
  
  class AvailabilityEvent < Enum
    NOT_APPLICABLE = 0
    ASSIGNMENT_DUE = 1
    EXERCISE_COMPLETE = 2
    ASSIGNMENT_COMPLETE = 3
  end
  
protected

  def init
    self.is_feedback_required_for_credit ||= false
    self.availability_opens_option ||= AvailabilityOpensOption::NEVER
    self.availability_closes_option ||= AvailabilityClosesOption::NEVER
  end
  
  def nil_out_blank_regex
    self.label_regex = nil if label_regex.blank?
  end
  
  def delay_days_specified_if_delay_chosen
    errors.add(:availability_opens_delay_days, "must be specified") \
      if AvailabilityOpensOption::DELAY_AFTER_EVENT == availability_opens_option &&
         availability_opens_delay_days.nil?
         
    errors.add(:availability_closes_delay_days, "must be specified") \
      if AvailabilityClosesOption::DELAY_AFTER_OPEN == availability_closes_option &&
         availability_closes_delay_days.nil?
         
    errors.none?
  end
  
end