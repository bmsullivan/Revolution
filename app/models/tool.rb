class Tool < ActiveRecord::Base
  
  RANGES = ["All","Year To Date", "This Month", "Last 30 Days", "This Week", "Last 7 Days", "Last 14 Days"]
  
  def self.range_condition(range_name,model,field_name)
    unless range_name == "All"
      if range_name == "This Month"
        start_range = Time.now.beginning_of_month
        end_range = Time.now
      elsif range_name == "Last 7 Days"
          start_range = (Time.now - 7.days)
          end_range = Time.now
      elsif range_name == "This Week"
          start_range = Time.now.beginning_of_week
          end_range = Time.now
      elsif range_name == "Last 14 Days"
          start_range = (Time.now - 14.days)
          end_range = Time.now
      elsif range_name == "Last 30 Days"
        start_range = (Time.now - 30.days)
        end_range = Time.now
      elsif range_name == "Year To Date"
        start_range = (Time.now.beginning_of_year)
        end_range = Time.zone.now
      end
      range_condition = EZ::Where::Condition.new model.to_sym do
        eval(field_name) <=> (start_range..end_range)
      end
    end
    range_condition || false
  end
  
  def self.range_condition_hash(range_name)
    unless range_name == "All"
      if range_name == "This Month"
        start_range = Time.now.beginning_of_month
        end_range = Time.now
      elsif range_name == "Last 7 Days"
          start_range = (Time.now - 7.days)
          end_range = Time.now
      elsif range_name == "This Week"
          start_range = Time.zone.now.beginning_of_week
          end_range = Time.zone.now
      elsif range_name == "Last 14 Days"
          start_range = (Time.now - 14.days)
          end_range = Time.now
      elsif range_name == "Last 30 Days"
        start_range = (Time.now - 30.days)
        end_range = Time.now
      elsif range_name == "Year To Date"
        start_range = (Time.now.beginning_of_year)
        end_range = Time.now
      end
    end
    {:start_date => start_range, :end_date => end_range} || false
  end

  
    def self.array_to_hash(an_array) #takes an array and gives back an indexed hash
      Hash[*an_array.collect {|v| [an_array.index(v),v]}.flatten]
    end
    
    def self.articlyze(word)
      @result = "a"
      vowels = ["A", "E", "I", "O", "U", "Y"]
      if vowels.include?(word.first)
        @result = "an"
      end
      @result
    end
    
    def self.average_age_of_these_contacts(contacts)
      ages = contacts.collect {|c| c.age_in_days.floor}
      ages.sum/ages.length
    end
    
    def self.multi_tags(tag_ids)
      Person.find(:all,
                  #:select => "people.id,people.first_name,count(*) as c FROM people",
                  :joins => ['INNER JOIN taggings on taggings.person_id = people.id'],
                  #:include => [:tags]#,
                  :conditions => ['taggings.tag_id IN (?)', tag_ids],
                  :group => "people.id"
                  )
    end
    
    def self.multi_tags_two
      Person.find(:all,
                  :include => [:tags],
                  :conditions => ['tags.name (LIKE ?) (OR ?)','Group Level', 'Inactive Advance']
                  )
    end
    
    def self.multi_tags_three
      Person.find(:all, :include => [:tags],
                  :conditions => ["1=1) HAVING (tags.name = ('Group Level')"])
    end
end


#def to_hash_values(&block)
#   Hash[*self.collect { |v|
#     [block.call(v), v]
#   }.flatten]
# end

#h = Hash[ *a.collect { |v| [a.index(v), v ] }.flatten ]