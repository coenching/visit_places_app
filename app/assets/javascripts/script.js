
function initialize() {

  	var place_lat = parseFloat($('#place_lat').val());
  	var place_lng = parseFloat($('#place_lng').val());

  	// Create the map center on the location or on SF by default
  	if (place_lat && place_lng){
  		center = { lat: place_lat, lng: place_lng}
  	} else {
  		center = { lat: 37.7597727, lng: -122.427063}
  	}
  	var mapOptions = {
  		center: center,
  		zoom: 12
  	};
  	var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  	var marker;

    // Create the pin of the place if the location is determine when display page
    if (place_lat && place_lng){
    	createPin(place_lat, place_lng, true)
    }

    function clearPin(){
		if(marker){
    		marker.setMap(null);
    	}
    }

    function createPin(lat, lng, recenter){
    	var myLatlng = new google.maps.LatLng(lat, lng);
    	marker = new google.maps.Marker({
    		position: myLatlng,
    		map: map,
    		// title: "Hello"
    		title: $('#place_name').val()
    	});
      if (recenter){map.setCenter(myLatlng);}
    }

    if($('#map-canvas').data('map') === 'enable') {
    	// Add an event when click on the map to update the address
    	google.maps.event.addListener(map, 'click', function(event) {
    		var click_lat = event.latLng.k;
    		var click_lng = event.latLng.B;
        
    		clearPin();
    		createPin(click_lat, click_lng, false);
    		$('#place_lat').val(click_lat);
    		$('#place_lng').val(click_lng);
    	});

    	// Update the pin on the map when entering an address
    	$('#pin_map').click(function(e){
    		e.preventDefault();
    	  	var address = $('#place_address').val();
    	  	var geo_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + gon.googleMapApiKey;
    	  	
          var request = $.ajax({
    	  		url: geo_url,
    	  		type: "GET",
    	  		dataType: "json"
    	  	});

    	  	request.done(function(data){
    	  		if(data.results.length == 0){
    	  			alert("INVALID ADDRESS")
    	  		} else {
    	  			var geo_lat = data.results[0].geometry.location.lat;
    	  			var geo_lng = data.results[0].geometry.location.lng;
    	  			clearPin();
    	  			createPin(geo_lat, geo_lng, true);
              $('#place_lat').val(geo_lat);
              $('#place_lng').val(geo_lng);
    	  		}
    	  	});
    	});
    }
}

function initializeVisitsMap(){

  var mapOptions = {
      center: { lat: 37.7597727, lng: -122.427063},
      zoom: 12
    };

    var map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

      var request = $.ajax({
        url: "/users/"+$('#user_id').val()+"/visits",
        type: "GET",
        dataType: "json",
        cache: false
      });

    request.done(function(data){
      var latlngbounds = new google.maps.LatLngBounds( );
      for(var i = 0; i < data.length; i++){
        var myLatlng = new google.maps.LatLng(data[i].place.lat, data[i].place.lng);
        createPin(myLatlng, data[i].place.name);
        latlngbounds.extend(myLatlng);
      }
      //Recenter and resize the map
      map.fitBounds( latlngbounds );
    });

    function createPin(myLatlng, title){
      new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: title
      });
    }
}

function initializeRecommendationsMap(){

  var mapOptions = {
      center: { lat: 37.7597727, lng: -122.427063},
      zoom: 12
    };

    var map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

      var request = $.ajax({
        url: "/users/"+$('#user_id').val()+"/recommendations",
        type: "GET",
        dataType: "json",
        cache: false
      });

    request.done(function(data){
      var latlngbounds = new google.maps.LatLngBounds( );
      for(var i = 0; i < data.length; i++){
        var myLatlng = new google.maps.LatLng(data[i].visit.place.lat, data[i].visit.place.lng);
        createPin(myLatlng, data[i].visit.place.name);
        latlngbounds.extend(myLatlng);
      }
      //Recenter and resize the map
      map.fitBounds( latlngbounds );
    });

    function createPin(myLatlng, title){
      new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: title
      });
    }
}

function initializeFavoritesMap(){

  var mapOptions = {
      center: { lat: 37.7597727, lng: -122.427063},
      zoom: 12
    };

    var map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

      var request = $.ajax({
        url: "/favorites",
        type: "GET",
        dataType: "json",
        cache: false
      });

    request.done(function(data){
      var latlngbounds = new google.maps.LatLngBounds( );
      for(var i = 0; i < data.length; i++){
        var myLatlng = new google.maps.LatLng(data[i].place.lat, data[i].place.lng);
        createPin(myLatlng, data[i].place.name);
        latlngbounds.extend(myLatlng);
      }
      //Recenter and resize the map
      map.fitBounds( latlngbounds );
    });

    function createPin(myLatlng, title){
      new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: title
      });
    }
}

// Add place to favorites
function addToFavorites(e){
    e.preventDefault();
    var id = $(e.target).data("id");

    data_hash = { favorite: {place_id: id } }

    var request = $.ajax({
      url: "/favorites/",
      type: "POST", 
      data: data_hash,
      dataType: "json"
    });

    request.done(function(data){
      $(e.target).addClass("glyphicon-heart");
      $(e.target).removeClass("glyphicon-heart-empty");
      $(e.target).unbind("click");
      $(e.target).click(removeFromFavorites);
    });
}

// Remove from favorites
function removeFromFavorites(e){

    e.preventDefault();
    var id = $(e.target).data("id");
    data_hash = {place_id: id}

    var request = $.ajax({

      url: "/place_favorites/",
      data: data_hash,
      type: "DELETE", 
      dataType: "json"
    });

    request.done(function(data){
      $(e.target).removeClass("glyphicon-heart");
      $(e.target).addClass("glyphicon-heart-empty");
      $(e.target).unbind("click");
      $(e.target).click(addToFavorites);
    });
}

