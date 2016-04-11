class IdentitiesController < ApplicationController
  before_filter :authorize
  before_action :set_identity, only: [:show, :edit, :update, :destroy]
  
  def index
    userid = session[:user_id]
    option = Option.find_by_user_id(userid) 
    if(option && option.use_only_one_language == 1)
      @identities = Identity.where(["klang = ? and user_id = ?", option.language_id, userid]).all
    else
      @identities = Identity.where(["user_id = ?", userid]).all
    end
  end

  def show
  end

  def new
    @identity = Identity.new
    set_language
  end

  def edit
  end

  def copy
    identity_src = Identity.find(params[:id])
    @identity = Identity.new
    @identity.firstname = identity_src.firstname
    @identity.lastname = identity_src.lastname
    @identity.address = identity_src.address
    @identity.email = identity_src.email
    @identity.web = identity_src.web
    @identity.birthdate = identity_src.birthdate
    @identity.gender = identity_src.gender
    @identity.nationality = identity_src.nationality
    @identity.familystate = identity_src.familystate
    @identity.other = identity_src.other
    @identity.mobile = identity_src.mobile
    set_language

    render :edit
  end

  def create
    @identity = Identity.new(identity_params)
    @identity.user_id = session[:user_id]
    respond_to do |format|
      if @identity.save
        format.html { redirect_to @identity, notice: 'Identity was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @identity.update(identity_params)
        format.html { redirect_to @identity, notice: 'Identity was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @identity.destroy
    respond_to do |format|
      format.html { redirect_to identities_url, notice: 'Identity was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identity
      @identity = Identity.find(params[:id])
      @identity = @identity.user_id == session[:user_id] ? @identity : nil
    end

    def set_language
      option = Option.find_by_user_id(session[:user_id]) 
      @identity.klang = option.language_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_params
      params.require(:identity).permit(:firstname, :lastname, :address, :email, :web, :birthdate, :gender, :nationality, :familystate, :other, :klang, :mobile, :codice_fisc)
    end
end
