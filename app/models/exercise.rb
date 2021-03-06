# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'open-uri'
require 'json'

class Exercise < ActiveRecord::Base
  include Ost::Utilities
  
  has_many :topic_exercises, :dependent => :destroy
  
  before_validation :store_cleaned_up_url
  
  validates :url, :presence => true,
                  :uniqueness => true,
                  :url_format => true,
                  :url_existence => true
                  
  validate :can_get_content?
  
  validate :check_is_simple_question
  validate :check_has_simple_question_answer_choices
  
  attr_accessible :content_cache, :is_dynamic, :url
  
  def self.new_or_existing(url)
    url = Exercise.cleanup_url(url)
    existing = Exercise.find_by_url(url)
    existing.nil? ? Exercise.new(:url => url) : existing
  end
  
  # Check to see if this exercise is an orphan.  If so, delete
  def destroy_if_orphan!
    self.destroy if topic_exercises(true).empty?    
  end
  
  def clear_content_cache!
    self.update_attribute(:content_cache, nil)
  end
  
  def content
    if json_cache.nil?
      if self.content_cache.nil?
        self.update_attribute(:content_cache, open(url+".json").read) 
      end
      self.json_cache = JSON.parse(content_cache)
    end
    json_cache
  end
  
  def solutions_content
    JSON.parse(open(url+"/solutions.json").read)
  end
  
  def get_credit(choice_index)
    begin
      content["simple_question"]["answer_choices"][choice_index]["credit"].to_f
    rescue
      0.0
    end
  end
  
  def correct_choice_index
    content["simple_question"]["answer_choices"].index{|ac| ac["credit"].to_f == 1}
  end
  
  def num_choices
    content["simple_question"]["answer_choices"].count
  end
  
  def quadbase_id
    url.split("/").last
  end
  
  def is_simple_question?
    content.present? && content["simple_question"].present?
  end

  def has_simple_question_answer_choices?
    is_simple_question? && content["simple_question"]["answer_choices"].present?
  end

protected

  attr_accessor :json_cache

  def self.cleanup_url(url)
    url.sub(/(\/)+$/,'').sub(/^https/,'http')
  end

  def store_cleaned_up_url
    self.url = Exercise.cleanup_url(url)
  end

  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This exercise cannot be deleted because it has been assigned (except by admin override).") \
      if topic_exercises.any?{|te| te.assigned?}
    errors.empty?
  end

  def can_get_content?
    begin
      content
    rescue Exception
      errors.add(:url, "does not point to anything we can retrieve.")
    end
    errors.empty?
  end
  
  def check_is_simple_question
    return if content.nil?
    self.errors.add(:base,"This exercise is not a simple question " +
                           "(multi-part questions are not supported at this time).") \
      if content["simple_question"].nil?
  end

  def check_has_simple_question_answer_choices
    return if !is_simple_question?
    self.errors.add(:base,"This exercise is missing answer choices.") \
      if content["simple_question"]["answer_choices"].nil?
  end

end
