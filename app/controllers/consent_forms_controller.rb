
class ConsentFormsController < ApplicationController
  # GET /consent_forms
  # GET /consent_forms.json
  def index
    @consent_forms = ConsentForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consent_forms }
    end
  end

  # GET /consent_forms/1
  # GET /consent_forms/1.json
  def show
    @consent_form = ConsentForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consent_form }
    end
  end

  # GET /consent_forms/new
  # GET /consent_forms/new.json
  def new
    @consent_form = ConsentForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consent_form }
    end
  end

  # GET /consent_forms/1/edit
  def edit
    @consent_form = ConsentForm.find(params[:id])
  end

  # POST /consent_forms
  # POST /consent_forms.json
  def create
    @consent_form = ConsentForm.new(params[:consent_form])

    respond_to do |format|
      if @consent_form.save
        format.html { redirect_to @consent_form, notice: 'Consent form was successfully created.' }
        format.json { render json: @consent_form, status: :created, location: @consent_form }
      else
        format.html { render action: "new" }
        format.json { render json: @consent_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /consent_forms/1
  # PUT /consent_forms/1.json
  def update
    @consent_form = ConsentForm.find(params[:id])

    respond_to do |format|
      if @consent_form.update_attributes(params[:consent_form])
        format.html { redirect_to @consent_form, notice: 'Consent form was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consent_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consent_forms/1
  # DELETE /consent_forms/1.json
  def destroy
    @consent_form = ConsentForm.find(params[:id])
    @consent_form.destroy

    respond_to do |format|
      format.html { redirect_to consent_forms_url }
      format.json { head :no_content }
    end
  end
end