class WishlistsController < ApplicationController
  
  def new_auto
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])
    @automakes = Automodels.find(:all, :order => 'make ASC', :select => 'distinct make')
		@automodels = "" #send a blank list when the page is first loaded so it can be replaced by the partial when a Make is selected
    @autocategories = Autocategories.all

    respond_to do |format|
      format.html # new_auto.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end
  
  def new_moto
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])
    @motomakes = Motomakes.find(:all, :order => 'sort_order ASC', :select => 'distinct make')
    @motocategories = Motocategories.all

    respond_to do |format|
      format.html # new_auto.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end
  
  def new_marine
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])
    @marinemakes = Marinemakes.all
    @marinecategories = Marinecategories.find(:all, :order => 'category ASC', :select => 'distinct category')
		@marinesubcategories = ""

    respond_to do |format|
      format.html # new_auto.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end
  
  def new_power
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])
    @powermakes = Powermakes.find(:all, :order => 'sort_order ASC')
    @powercategories = Powercategories.find(:all, :order => 'category ASC', :select => 'distinct category')
		@powersubcategories = ""

    respond_to do |format|
      format.html # new_auto.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end
  
	def get_automodels
		@automodels = Automodels.find_all_by_make(params[:make], :order => "model ASC").map{|m| [m.model, m.model]}
		
		render :update do |page|
			page.replace_html('automodelsdiv', :partial => 'automodels_select', :object => @automodels)
		end
	end

	def get_marinesubcategories
		@marinesubcategories = Marinecategories.find_all_by_category(params[:category], :order => "subcategory ASC").map{|m| [m.subcategory, m.subcategory]}
		
		render :update do |page|
			page.replace_html('marinesubcategoriesdiv', :partial => 'marinesubcategories_select', :object => @marinesubcategories)
		end
	end

	def get_powersubcategories
		@powersubcategories = Powercategories.find_all_by_category(params[:category], :order => "subcategory ASC").map{|m| [m.subcategory, m.subcategory]}
		
		render :update do |page|
			page.replace_html('powersubcategoriesdiv', :partial => 'powersubcategories_select', :object => @powersubcategories)
		end
	end

  # GET /wishlists
  # GET /wishlists.xml
  def index
		@user = current_user
		
		#Show index if user has Wishlist items already, else redirect to "Create Wishlist"
		if @user 
			if @user.wishlists.exists?
				@wishlists = @user.wishlists
			
				respond_to do |format|
					format.html # index.html.erb
					format.xml  { render :xml => @wishlists }
				end
			else
				redirect_to new_wishlist_path
			end
		else
			respond_to do |format|
				format.html # index.html.erb
			end
		end
  end

  # GET /wishlists/1
  # GET /wishlists/1.xml
  def show
    @wishlist = Wishlist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end

  # GET /wishlists/new
  # GET /wishlists/new.xml
  def new
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])
    @autocategories = Autocategories.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wishlist }
    end
  end

  # GET /wishlists/1/edit
  def edit
    @wishlist = Wishlist.find(params[:id])
  end

  # POST /wishlists
  # POST /wishlists.xml
  def create
  	@user = current_user
    @wishlist = @user.wishlists.new(params[:wishlist])

    respond_to do |format|
      if @wishlist.save
        flash[:notice] = 'Wishlist item was successfully created.'
        format.html { redirect_to(wishlists_path) }
        format.xml  { render :xml => @wishlist, :status => :created, :location => @wishlist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wishlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wishlists/1
  # PUT /wishlists/1.xml
  def update
    @wishlist = Wishlist.find(params[:id])

    respond_to do |format|
      if @wishlist.update_attributes(params[:wishlist])
        flash[:notice] = 'Wishlist item was successfully updated.'
        format.html { redirect_to(@wishlist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wishlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlists/1
  # DELETE /wishlists/1.xml
  def destroy
    @wishlist = Wishlist.find(params[:id])
    @wishlist.destroy

    respond_to do |format|
    	flash[:notice] = 'Wishlist item was successfully deleted.'
      format.html { redirect_to(wishlists_url) }
      format.xml  { head :ok }
    end
  end
end
