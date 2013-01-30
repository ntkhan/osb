class ItemsController < ApplicationController
  #before_filter :authenticate_user!
  # GET /items
  # GET /items.json
  def index
    @items = Item.unarchived.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item }
    end

  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        #format.html { redirect_to @item, notice: 'Your item has been created successfully.' }
        format.json { render :json => @item, :status => :created, :location => @item }
        redirect_to({:action => "edit", :controller => "items", :id => @item.id}, :notice => 'Your item has been created successfully.')
        return
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to({:action => "edit", :controller => "items", :id => @item.id}, :notice => 'Your item has been updated successfully.') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

#  # Load invoice line items data when an item is selected from drop down list
  def load_item_data
    item = Item.find(params[:id])
    render :text => [item.item_description || "", item.unit_cost || 1, item.quantity || 1, item.tax_1 || 0, item.tax_2 || 0]
  end

  def bulk_actions
    if params[:archive]
      Item.archive_multiple(params[:item_ids])
      @items = Item.unarchived.page(params[:page])
      @action = "archived"
    elsif params[:destroy]
      Item.delete_multiple(params[:item_ids])
      @items = Item.unarchived.page(params[:page])
      @action = "deleted"
    elsif params[:recover_archived]
      Item.recover_archived(params[:item_ids])
      @items = Item.archived.page(params[:page])
      @action = "recovered from archived"
    elsif params[:recover_deleted]
      Item.recover_deleted(params[:item_ids])
      @items = Item.only_deleted.page(params[:page])
      @action = "recovered from deleted"
    end
    respond_to { |format| format.js }
  end

  def filter_items
    @items = Item.filter(params)
  end
end
