class PlacesController < ApplicationController

	def index
		@places = Place.all.order('name')
	end

	def search
		@places = []
		@data = []
		@search = ''
	end

	def search_result
		@search = params[:search]
		# Search in database
		@places = Place.where("lower(name) like ? or lower(address) like ?", "%#{@search.downcase}%", "%#{@search.downcase}%")
		# Search with google maps API
		@data = search_geocoding @search
		
		if @places.empty? && @data.empty?
			@place = Place.new
			@visit = Visit.new
			render :new
		elsif @places.count == 1 && @data.empty?
			# If only one result from existing place, show the place to create a visit
			@place = @places[0]
			@visit = Visit.new
			render :show
		elsif (@places.empty? && @data.length == 1)
			# If one result from Google API, prefill data to create new place
			flash[:info] = "Here is a proposition for your place. Feel free to modify the information."
  			@place = Place.new
  			@place.name = @search
  			@place.address = @data[0]['formatted_address']
  			@place.lat = @data[0]['geometry']['location']['lat']
  			@place.lng = @data[0]['geometry']['location']['lng']
  			@visit = Visit.new
  			render :new
		else
			# If several results, let the user choose which one
			render :search
		end
	end

	def new
		@place = Place.new
		@place.name = params[:name] if params[:name]
		@place.address = params[:address] if params[:address]
		@place.lat = params[:lat] if params[:lat]
		@place.lng = params[:lng] if params[:lng]
	end

	def create
		@place = Place.new(place_params)
		if @place.save
			flash[:success] = "Your place has been created."
			redirect_to new_place_visit_path(@place)
		else
			render :new
		end
	end

	def edit
		@place = Place.find(params[:id])
	end

	def update
		@place = Place.find(params[:id])
		if @place.update place_params
			flash[:success] = "Your place has been updated."
			redirect_to places_path
		else
			render :edit
		end
	end

	def destroy
		@place = Place.find(params[:id])
		@place.destroy
		flash[:success] = "Your place has been deleted."
		redirect_to places_path
	end

	def show
		@place = Place.find(params[:id])
		ids = []
		current_user.friendships.each do |friendship|
			ids << friendship.friend_id
		end
		@visits = Visit.where(place_id: params[:id], user_id: ids).order('date DESC')
	end

	private

	def place_params
		params.require(:place).permit(:name, :address, :gender, :price, :lat, :lng, :picture)
	end

	def search_geocoding(criteria)
		if criteria == ''
			return []
		end
		address = criteria.gsub(' ','%20')
		data = Typhoeus.get("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyBMjQW_pHVa_SJleQQX2BC51pJ4UyhVbK0")
		# puts data
		data = JSON.parse(data.body)
		if data['status'] == 'OK'
			return data['results']
		else
			return []
		end
	end

end
