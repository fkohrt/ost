# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :basic_feedback_condition do
    label_regex '.*'
    is_feedback_required_for_credit false
    can_automatically_show_feedback true
    availability_opens_option BasicFeedbackCondition::AvailabilityOpensOption::IMMEDIATELY_AFTER_EVENT
    availability_opens_delay_days nil
    availability_closes_option BasicFeedbackCondition::AvailabilityClosesOption::NEVER
    availability_closes_delay_days nil
    availability_event BasicFeedbackCondition::AvailabilityEvent::EXERCISE_COMPLETE
    learning_condition
  end
end


