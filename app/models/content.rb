class Content < ActiveRecord::Base

  #validates_with GoodnessValidator

    validates :url, presence: true                                #URL
    validates :url, length: {minimum: 12,
     too_short: "%{count} charters is the minimum allowed" }
    validate :url, format: { with: /^https?:\/\/.+\..+/, 
     message: "The string should be start with http://  or https://" }
    validate :url, on: :create, on: :save, on: :update
    
    validates :filter1, presence: true                             #TEG
    validates :filter1, length:  {minimum: 1,
     too_short: "%{count} charters is the minimum allowed" }
    validate :filter1, format: { with: /'\w+\d+'/, 
     message: "Please input real tag name!" }
    validate :filter1, on: :create, on: :save, on: :update
    validates :filter1, inclusion: { in: %w(body div title span p i b table tr td th dd dt h1 
      h2 h3 h4 h5 h6 strong font form li ul a)}

    #validates :filter2, presence: true                             #ATTR
    validates :filter2, length:  {minimum: 0,
     :too_short => "%{count} charters is the minimum allowed" }
    validate :filter2, format: { with: /'\w*'/, 
     message: "Please input real attr name!" }
    validate :filter2, on: :create, on: :save, on: :update
    #validates :filter2, inclusion: { in: %w(text id class href img alt name style )}
    
    validates :filter3, length:  { minimum: 0,                     #ID || CLASS
      :too_short => "%{count} charters is the minimum allowed"}
    validate :filter3, format: { with: /[0-9A-Za-z]*\s*[0-9A-Za-z]*/,
      message: "Your id or class name is not real!" }
    validate :filter3, on: :create, on: :update, on: :save
    
    validates :description, presence: true                         #Description
    validates :description, length: {minimum: 2, 
      :too_short => "%{count} charters is the minimum allowed" }
    validate :description, format: { with: /[0-9A-Za-z]+\s*[0-9A-Za-z]*/,
       message: "Empty description field. Probably you wrote wrong in attr or attr name." }
    validate :description, on: :create
                                 
    validate :number, format: { with: /\d*/,                         #Number      
      message: "Your input value is incorrect. Please input integer number." }
    validate :number, on: :create
    validate :number, only_integer: true
    
    validates :timeout, presence: true                               #Timeout
    validates :timeout, length: { minimum: 1,                      
      :too_short => "%{count} charters is the minimum allowed"}
    validate :timeout, format: { with: /\d*/, 
      message: "Your input value is incorrect. Please input integer number." }
    validate :timeout, on: :create
    validate :timeout, only_integer: true
    
    validate :metainfo, presence: true                                #metainfo
    validates :metainfo, inclusion: { in: %w(URL Title Location Education Experience Salary Type Description Ref_ID Caregory Contact_Name Contact_Phone Contact_E-mail Street_Address Pub_Date Pub_Time) }     
    
  def add_desc url, filter1, filter2, filter3, timeout, number, encod, reg_filter_1  
    #valid--timeout------------------------------------------
    if timeout.empty? || timeout.nil?
      self.timeout = 0
    end
    
    #Timeout-------------------------------------------------
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = self.timeout*60
    http.read_timeout = self.timeout*60
    
    #NOKO-----------------------------------------------------
    begin
      doc = Nokogiri::HTML(open(url))
      doc.encoding = encod
      if  filter2 == 'class'
        if number.empty?
          self.description = doc.css(filter1+'.'+filter3).text
        else
          self.description = doc.css(filter1+'.'+filter3)[number.to_i].text
        end
      elsif filter2 == 'id'
        self.description = doc.css(filter1+'#'+filter3).text  
      else
        if number.empty?
          if filter2.empty? || filter2 == 'text'
            self.description = doc.css(filter1).text
            self.filter2 = 'text'
          else
            self.description = doc.css(filter1)[filter2]
          end
        else
          if filter2.empty? || filter2 == 'text'
            self.description = doc.css(filter1)[number.to_i].text
            self.filter2 = 'text'
          else
            self.description = doc.css(filter1)[number.to_i][filter2]
          end
        end
      end
    rescue OpenURI::HTTPError
        puts "Error open URL #{url}"
        self.errors << "Error open URL #{url}" 
        return 0
    rescue Timeout::Error
        puts "Error timeout URL #{url}"
        self.errors << "Error timeout URL #{url}" 
        return 0
    rescue Exception => e
        puts "Something went wrong"
        puts e 
        self.errors.add(:base, e.message) 
        return 0
    end
    self.description = self.description.delete("\n")
    self.description = self.description.delete("\t")

    
    if number.empty? || number.nil?
      self.number = 0
    end
    p "-------------------------------------desc" + self.description
    #--------------filter_reg_exp
    unless reg_filter_1.empty?
      reg_filter_1 = /#{reg_filter_1}/
      self.description = self.description.scan(reg_filter_1)
      self.description = self.description.to_s
      self.description = self.description.delete("[[\"")
      self.description = self.description.delete("\"]]")
    end
  end
  
end


  class GoodnessValidator < ActiveModel::Validator
  
    def validate(record)
      if record.url == "http://www.test.com/"
        record.errors[:base] << "Wrong URL"
      end
    end
  
  end