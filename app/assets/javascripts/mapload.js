  window.onload = function() {
    var myKey = window.mapKey;
    var script = document.createElement('script');
    script.type  = 'text/javascript';
    script.async = true;
    script.src = 'https://maps.googleapis.com/maps/api/js?key='+myKey+'&libraries=places&callback=initAutocomplete';
    var entry = document.getElementsByTagName('script')[0];
    entry.parentNode.insertBefore(script, entry);
  }

  function initAutocomplete() {
    newstoreAutoload();
    editstoreAutoload();
  }

  function newstoreAutoload() {
    var autocomplete;

    var input =document.getElementById('autocomplete');
    autocomplete = new google.maps.places.Autocomplete(input,{types: ['geocode']});

    autocomplete.addListener('place_changed', function(){
      var place = autocomplete.getPlace();

      var geocoder = new google.maps.Geocoder();
      var address = place.formatted_address;
      geocoder.geocode( { 'address': address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          position = results[0].geometry.location;
          $('#store_latitude').val(position.lat().toFixed(5));
          $('#store_longitude').val(position.lng().toFixed(5));
        } 
      });
    });
  }

  function editstoreAutoload() {
    var autoaddress, map;
    var lat = $('#store_latitude').val();
    var lng = $('#store_longitude').val();
    var myLatLng = new google.maps.LatLng(lat,lng);
    var myOptions = {
        zoom: 18,
        center: myLatLng,
        scrollwheel: false,
        panControl: true,
        zoomControl: true,
        mapTypeControl: true,
        scaleControl: true,
        streetViewControl: true,
        overviewMapControl: true,
        disableDoubleClickZoom: true,
        mapTypeId: google.maps.MapTypeId.SATELLITE,
        tilt: 0
    }
    map = new google.maps.Map(document.getElementById('map'), myOptions);

    marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        draggable: true,
        animation: google.maps.Animation.DROP
    });

    map.addListener('dblclick', function(event) {
      marker.setPosition(event.latLng);
      $('#store_latitude').val(event.latLng.lat().toFixed(5));
      $('#store_longitude').val(event.latLng.lng().toFixed(5));
    });

    marker.addListener('dragend', function(event) {
      position = marker.getPosition();
      $('#store_latitude').val(position.lat().toFixed(5));
      $('#store_longitude').val(position.lng().toFixed(5));
    });

    input = $('#map_address')[0];

    map_address = new google.maps.places.Autocomplete(input);

    autoaddress = new google.maps.places.Autocomplete((document.getElementById('autoaddress')),{types: ['geocode']});


    // When the user selects an address from the dropdown, populate the address
    // fields in the form.
    autoaddress.addListener('place_changed', function(){
      var place = autoaddress.getPlace();

      var geocoder = new google.maps.Geocoder();
      var address = place.formatted_address;
      geocoder.geocode( { 'address': address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            position = results[0].geometry.location;
            $('#store_latitude').val(position.lat().toFixed(2));
            $('#store_longitude').val(position.lng().toFixed(2));
        } 
      });
    });
    map_address.addListener('place_changed', function(){
      var place = map_address.getPlace();
      map.setCenter(place.geometry.location);
    });
  }