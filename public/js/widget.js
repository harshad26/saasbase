window.onload = function () {
  document.getElementById('loading').style.display = "none";
}

  var token = document
    .querySelector('script[data-id="MySaasbase"][data-saasbase-id]')
    .getAttribute('data-saasbase-id');
  var host = document
    .querySelector('script[data-id="MySaasbase"][data-saasbase-host]')
    .getAttribute('data-saasbase-host');
  var x = document.getElementById('saasbase');
  var y = x.getElementsByTagName("p");
  y[0].style.display = "none";

  var script = document.createElement('script');
  script.type  = 'text/javascript';
  script.async = true;
  script.src = document.location.protocol + '//maps.googleapis.com/maps/api/js?key=AIzaSyAFYf2nUJRQ_E53keoY4ujTviB7CQ582Gc&libraries=geometry,places&callback=initAutocomplete';
  var entry = document.getElementsByTagName('script')[0];
  entry.parentNode.insertBefore(script, entry);

  var iwstyle = document.createElement('div')
  iwstyle.style.display = "none";
  iwstyle.innerHTML = '<div id="info-content"><table><tr id="iw-name-row" class="iw_table_row"><td id="iw-name"></td></tr><tr id="iw-address-row" class="iw_table_row"><td id="iw-address"></td></tr><tr id="iw-phone-row" class="iw_table_row"><td id="iw-phone"></td></tr></table></div>'
  x.parentNode.appendChild(iwstyle);
  var sheet = document.createElement('style');
  sheet.innerHTML = "input { width: 90%; padding: 6px 12px; font-size: 14px; line-height: 1.42857143;color: #555555; background-color: #fff; background-image: none; border: 1px solid #ccc; border-radius: 4px;}table { font-size: 12px; }#listing {position: relative; width: auto; height: 417px; overflow: auto; cursor: pointer; overflow-x: hidden; }.placeIcon { width: 20px; height: 34px; margin: 4px; }#resultsTable { border-collapse: collapse; width: 100%; }td {padding-left:20px;}li {padding:2px;list-style:none;}li:first-child{font-weight:bold;padding:2px;}#iw-name-row {font-weight:bold;}#loading {width: 100%;height: 100%;top: 0;left: 0;position: fixed;display: block;background-color: #fff;z-index: 99;text-align: center;}#loading-image {position: absolute;top: 30%;left: 47%;z-index: 100;}";
  x.parentNode.appendChild(sheet);

  var loading = document.createElement('div');
  loading.id = "loading";
  x.parentNode.appendChild(loading);

  var loading_image = document.createElement('img');
  loading_image.id = "loading-image";
  loading_image.src = host+"/load.gif";
  loading_image.alt ="loading...";
  loading.appendChild(loading_image);

  var saasbase_left = document.createElement('div');
  saasbase_left.id = 'saasbase-left';
  x.appendChild(saasbase_left);
  saasbase_left.style.height = "500px";
  saasbase_left.style.width = "33%";
  saasbase_left.style.float = "left";

  var saasbase_right = document.createElement('div');
  saasbase_right.id = 'saasbase-right';
  x.appendChild(saasbase_right);
  saasbase_right.style.height = "500px";
  saasbase_right.style.width = "67%";
  saasbase_right.style.float = "right";

  var saasbase_small = document.createElement('small');
  saasbase_small.style.color = "#666";
  saasbase_small.style.fontSize ="11px";
  saasbase_small.innerText = "Powered by ";
  x.parentNode.appendChild(saasbase_small);

  var saasbase_small_a = document.createElement('a');
  saasbase_small_a.style.color = "#09c";
  saasbase_small_a.style.fontSize ="11px";
  saasbase_small_a.innerText = "Saasbase";
  saasbase_small.appendChild(saasbase_small_a);

  var saasbase_form = document.createElement('div');
  saasbase_form.style.margin = "10px";
  saasbase_left.appendChild(saasbase_form);

  var saasbase_label = document.createElement('label');
  saasbase_label.setAttribute("for","saasbase_zip");
  saasbase_label.innerHTML ="Enter zip code or full address";
  // saasbase_label.style.color = "red";
  saasbase_label.style.lineHeight = "30px";
  saasbase_label.style.fontWeight = "bold";
  saasbase_form.appendChild(saasbase_label);

  var saasbase_zip = document.createElement('input');
  saasbase_zip.placeholder ="Enter your address";
  saasbase_zip.type ="text";
  saasbase_zip.id = 'saasbase_zip';
  saasbase_form.appendChild(saasbase_zip);

  var saasbase_span = document.createElement('span');
  saasbase_span.innerHTML ="No locations found,please try another search.";
  saasbase_span.id = 'saasbase_span';
  saasbase_span.style.color ="red";
  saasbase_span.style.fontSize = '12px';
  saasbase_span.style.margin = '7px';
  saasbase_span.style.display = 'none';
  saasbase_form.appendChild(saasbase_span);

  var listing = document.createElement('div');
  listing.id = 'listing';
  saasbase_left.appendChild(listing);

  var resultsTable = document.createElement('table');
  resultsTable.id = 'resultsTable';
  listing.appendChild(resultsTable);

  var results = document.createElement('tbody');
  results.id = 'results';
  resultsTable.appendChild(results);

  var div_map = document.createElement('div');
  div_map.id = 'map';
  saasbase_right.appendChild(div_map);
  div_map.style.height = "100%";
  div_map.style.width = "100%";

  var saasbase_zip, map, places, infowindow;
  var markers = [];
  var MARKER_PATH = 'https://maps.gstatic.com/intl/en_us/mapfiles/marker_green';
  var hostnameRegexp = new RegExp('^https?://.+?/');
  var latLngA,latLngB;
  var response;

  function initAutocomplete() {
    lat = '23.02';
    lng = '72.57';
    latLngA = new google.maps.LatLng(lat,lng);
    map = new google.maps.Map(document.getElementById('map'), {
      center: latLngA,
      zoom: 12
    });

    var script2 = document.createElement('script');
    script2.src = host+'/mapdata/'+token;
    entry.parentNode.insertBefore(script2, entry);

    infowindow = new google.maps.InfoWindow({
      content: document.getElementById('info-content')
    });

    saasbase_zip = new google.maps.places.Autocomplete((document.getElementById('saasbase_zip')),{types: ['geocode']});
    places = new google.maps.places.PlacesService(map);



    saasbase_zip.addListener('place_changed', function(){
    	 var place = saasbase_zip.getPlace();
        if (place.geometry) {
          map.panTo(place.geometry.location);
          map.setZoom(12);
          var latitude1 = place.geometry.location.lat();
          var longitude1 = place.geometry.location.lng();
          latLngA = new google.maps.LatLng(latitude1,longitude1);
          
          clearResults();
          clearMarkers();
          search();
        } else {
          document.getElementById('saasbase_span').style.display = 'block';
        }

    });
  }

  function eqfeed_callback(results) {
    response = results;
    eqfeed_callback1();

  }
  function eqfeed_callback1() {
    for (var i = 0; i < response.stores.length; i++) {
      var store = response.stores[i];
      latLngB = new google.maps.LatLng(store.lat,store.long);
      var y = caldis();
      markers[i] = new google.maps.Marker({
        position: latLngB,
        map: map
      });

      google.maps.event.addListener(markers[i], 'click', function(){
        my_i = markers.indexOf(this);
        var my_store = response.stores[my_i];
        map.setCenter(markers[my_i].getPosition());
        infowindow.open(map, this);
        document.getElementById('iw-name').textContent = my_store.name;
        document.getElementById('iw-address').textContent = my_store.address;
        document.getElementById('iw-phone').textContent = my_store.phone;
      });
      addResult(response, i,y);
    }
  }

  function search() {
    var count = 0;
    for (var i = 0; i < response.stores.length; i++) {
      var store = response.stores[i];
      latLngB = new google.maps.LatLng(store.lat,store.long);
      var y = caldis();
      markers[i] = new google.maps.Marker({
        position: latLngB,
        animation: google.maps.Animation.DROP
      });
        
      google.maps.event.addListener(markers[i], 'click', function(){
      	my_i = markers.indexOf(this);
      	var my_store = response.stores[my_i];
      	
      	infowindow.open(map, this);
      	document.getElementById('iw-name').textContent = my_store.name;
      	document.getElementById('iw-address').textContent = my_store.address;
      	document.getElementById('iw-phone').textContent = my_store.phone;

      });
      if (y <10) {
        setTimeout(dropMarker(i), i * 100);
        addResult(response, i,y);
        count++;
      }

    }
    if (count == 0) {
      document.getElementById('saasbase_span').style.display = 'block';
    } else {
      document.getElementById('saasbase_span').style.display = 'none';
    }
    
  }

  function caldis() {
  	var x = google.maps.geometry.spherical.computeDistanceBetween (latLngA, latLngB);
  	return (x/1000).toFixed(1);
  }

  function clearMarkers() {
    for (var i = 0; i < markers.length; i++) {
      if (markers[i]) {
        markers[i].setMap(null);
      }
    }
    markers = [];
  }


  function dropMarker(i) {
    return function() {
      markers[i].setMap(map);
    };
  }

  function addResult(result, i,y) {
    var results = document.getElementById('results');

    var tr = document.createElement('tr');
    tr.style.borderBottom = "1px solid #eee";
    
    tr.onclick = function() {
      google.maps.event.trigger(markers[i], 'click');
    };

    var nameTd = document.createElement('td');

    var name = document.createTextNode(result.stores[i].name);
    var address = document.createTextNode(result.stores[i].address);
    var phone = document.createTextNode(result.stores[i].phone);
    var distance = document.createTextNode(y + ' kms away');

    var nameLi = document.createElement('li');
    nameTd.appendChild(nameLi);
    nameLi.appendChild(name);
    var addressLi = document.createElement('li');
    nameTd.appendChild(addressLi);
    addressLi.appendChild(address);
    var phoneLi = document.createElement('li');
    nameTd.appendChild(phoneLi);
    phoneLi.appendChild(phone);
    var disLi = document.createElement('li');
    nameTd.appendChild(disLi);
    disLi.appendChild(distance);

    tr.appendChild(nameTd);
    results.appendChild(tr);
  }

  function clearResults() {
    var results = document.getElementById('results');
    while (results.childNodes[0]) {
      results.removeChild(results.childNodes[0]);
    }
  }
