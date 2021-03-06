class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  layout "form_layout", except: :index

  respond_to :html, :json
  layout "form_layout", except: :index

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
    respond_to do |format|
      format.html
      format.pdf do
        @user_info = UserInformation.first
        @case_info = UserCaseInfo.all
        pdf = DocumentListPdf.new(@user_info,@case_info)
        send_data pdf.render, :filename => 'document.pdf', :type => "application/pdf", :disposition => 'inline'
      end
    end
    #@existing_user_info = UserInformation.where(user_id: current_user.id)
   # @existing_argument = UserArgument.where(user_id: current_user.id, document_id: 1) || nil

   # @documents = Document.all
    #each new document will need to be placed here
   # @expungement_form = @documents.where(name: 'Expungement Motion')
   # @existing_expungement_argument = UserArgument.where(user_id: current_user.id, document_id: @expungement_form.first.id) || nil
   #  @existing_user_document = UserDocument.where(user_id: current_user, document_id: @expungement_form.first.id)
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    #Prawn for PDF
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "hello world"
        send_data pdf.render, :filename => "document_#{@document.name}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def expungement_form
    respond_to do |format|
      format.html
      format.pdf do
        @user_info = current_user.user_information
        pdf = Prawn::Document.new(@user_info)
        pdf.text "hello world"
        send_data pdf.render, :filename => "document.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end



  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)


    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:name)
    end
end
