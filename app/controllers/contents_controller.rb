class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  #програмний аналізатор веб контенту  системи пошуку ваканцій
  # заг структура (призначення, осн функц, визначення)12
  # аналіз завдання та способо вирішення вибір засобів 8
  # проектування 30
  # експеремент (скріншоти) 5
  # економіка ?
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'timeout'
  require 'net/http'
  require 'net/https'
  #require 'restclient'
  
  
  # GET /contents
  # GET /contents.json
  def index
    #@contents = Content.all
    @contents = Content.all.paginate page: params[:page], order: 'created_at desc',
    per_page: 5
    
    respond_to do |format|
      format.html 
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)
    count = 0
    valid_id_class = 'test_string'
    #---------------------------validation-----------------URL
    
    
    #url = content_params[:url]
    reg_url = /^https?:\/\/.+\..*/
    test_url = /#{reg_url}/
    valid_url = content_params[:url].scan(reg_url).to_s
    p "----------------------------------------test----->"+valid_url
    p "----------------------------------------@url------>"+content_params[:url]
    #---------------------------validation-----------------TEG(filter1)
    
    
    #tag = content_params[:filter1]
    fil1_bool = false
    tag_name = ['body', 'div', 'title', 'span', 'p', 'i', 'b', 'table',
       'tr', 'td', 'th', 'dd', 'dt', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
       'strong', 'font', 'form', 'li', 'ul', 'a']
    tag_name.each{ |tag_name| 
      if tag_name == content_params[:filter1]
        fil1_bool = true
      end
      }
    #---------------------------validation-----------------ATTR ID || CLASS(filter2 || filter3)
    

    attr_name = ['id', 'class', 'href', 'img', 'alt', 'name', 'style', 'text', '', 'title']
    attr_name.each{ |attr_name| 
      if content_params[:filter2] == attr_name
        count+=1
      end
    }
    if content_params[:filter2] == 'id' || content_params[:filter2] == 'class' || content_params[:filter2] == 'name'
      reg_id_class = /[0-9A-Za-z]+\s*[0-9A-Za-z]*/
      test_id_class = /#{reg_id_class}/
      valid_id_class = content_params[:filter3].scan(reg_id_class).to_s
    end
    #---------------------------GO_TO_NOKOGIRI_PARSER------
    
    
    if ( valid_url != '[]' && fil1_bool == true && valid_id_class != '[]' && count != 0)
      @content.add_desc(content_params[:url], content_params[:filter1], content_params[:filter2], 
      content_params[:filter3], content_params[:timeout], content_params[:number],
      content_params[:encoding], content_params[:reg_exp_filter_1])
      respond_to do |format|
        if @content.save
          format.html { redirect_to @content, notice: 'Content was successfully created.' }
          format.json { render action: 'show', status: :created, location: @content }
        else
          format.html { render action: 'new', :flash => { :error => "Message" }}
          format.json { render json: @content.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash.alert = "Please check your input value. Some fields is incorrect."
        format.html { render action: 'new'}
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end 
    end
 
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:url, :filter1, :filter2, :filter3, :timeout, :number,
      :encoding, :metainfo, :reg_exp_filter_1)
    end
end
