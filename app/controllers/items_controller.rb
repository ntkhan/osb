class ItemsController < ApplicationController
  #before_filter :authenticate_user!
  # GET /items
  # GET /items.json
  include ItemsHelper

  def index
    @items = Item.unarchived.page(params[:page]).per(params[:per])

    respond_to do |format|
      format.js
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
    @item = params[:id] ? Item.find_by_id(params[:id]).dup : Item.new
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
    if Item.is_exits?(params[:item][:item_name])
      @item_exists = true
      redirect_to(new_item_path, :alert => "Item with same name already exists") unless params[:quick_create]
      return
    end
    @item = Item.new(params[:item])
    respond_to do |format|
      if @item.save
        format.js
        format.json { render :json => @item, :status => :created, :location => @item }
        new_item_message = new_item(@item.id)
        redirect_to({:action => "edit", :controller => "items", :id => @item.id}, :notice => new_item_message) unless params[:quick_create]
        return
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def duplicate_item
    new_item = Item.find_by_id(params[:item_id]).dup
    redirect_to new_item_path(new_item)
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
    render :text => [item.item_description || "", item.unit_cost.to_f || 1, item.quantity.to_i || 1, item.tax_1 || 0, item.tax_2 || 0]
  end

  def bulk_actions
    ids = params[:item_ids]
    if params[:archive]
      Item.archive_multiple(ids)
      @items = Item.unarchived.page(params[:page]).per(params[:per])
      @action = "archived"
      @message = items_archived(ids) unless ids.blank?
    elsif params[:destroy]
      Item.delete_multiple(ids)
      @items = Item.unarchived.page(params[:page]).per(params[:per])
      @action = "deleted"
      @message = items_deleted(ids) unless ids.blank?
    elsif params[:recover_archived]
      Item.recover_archived(ids)
      @items = Item.archived.page(params[:page]).per(params[:per])
      @action = "recovered from archived"
    elsif params[:recover_deleted]
      Item.recover_deleted(ids)
      @items = Item.only_deleted.page(params[:page]).per(params[:per])
      @action = "recovered from deleted"
    end
    respond_to { |format| format.js }
  end

  def filter_items
    @items = Item.filter(params)
  end

  def undo_actions
    params[:archived] ? Item.recover_archived(params[:ids]) : Item.recover_deleted(params[:ids])
    @items = Item.unarchived.page(params[:page]).per(params[:per])
    respond_to { |format| format.js }
  end
end
