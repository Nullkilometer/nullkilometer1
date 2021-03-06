var FormMap = function(){
  var
  map,
  posMarker,
  newPosPlotlayers=[],
  zoomLevel,
  TEXT_ADDRESS_SELECTION = I18n.t("map.messages.select_one_address"),
  posLat,
  posLon,
  newPosAddress,
  addressPlaceholderInTheForm,
  addressResultsPlaceholder,

  //PUBLIC METHODS
  initMap = function(lat, lon, address, zoomLevel, mapPlaceholderId) {
    var
    mapOptions = {center : new L.LatLng(lat, lon), zoom : zoomLevel },
    mapLayer = new L.TileLayer(osmTilesUrl);
    map = new L.Map(mapPlaceholderId, mapOptions);
    map.addLayer(mapLayer);
    map.whenReady(function () {
      window.setTimeout(function () {
        placeMarker(lat, lon, address, this.zoomLevel, true);
      }.bind(this), 2000);
    }, this);
    locationSearchResults
  },
  locateUser = function(zoomLevel){
      this.zoomLevel = zoomLevel;
      map.locate({setView : true, maxZoom:  this.zoomLevel});
  },
  setLocationSearchPlaceholders = function(formPlaceholder, resultsPlaceholder){
    addressPlaceholderInTheForm = formPlaceholder;
    addressResultsPlaceholder = resultsPlaceholder;
    addressResultsPlaceholder.append(I18n.t("map.messages.use_map"));
  },
  //PRIVATE METHODS
  placeMarker = function(lat, lon, address, zoomLevel, defaultLocation){
    var coordinates = new L.LatLng(lat, lon, true);
    if(typeof(posMarker)=="undefined"){ // if no marker is on the map
        posMarker = new L.Marker(coordinates, {draggable:true});
        posMarker.data="";
        posMarker.addTo(map);        //OR:  map.addLayer(posMarker);
        newPosPlotlayers.push(posMarker);
        setMarkerListener();
    } else { // if a marker is already on the map
        posMarker.setLatLng(coordinates);
    }
    map.panTo(coordinates);
    map.setZoom(zoomLevel);
    if(!defaultLocation){
        posLat = lat;
        posLon = lon;
        displayAddress(address);
    }
  },
  handleLocation = function(locationData, ifPlaceMarker){
    var
    address_data = locationData.address,
    short_address,
    road = typeof address_data.road != "undefined" ? address_data.road : "",
    house_number = typeof address_data.house_number != "undefined" ? address_data.house_number : "",
    postcode = typeof address_data.postcode != "undefined" ? address_data.postcode : "",
    city = typeof address_data.city != "undefined" ? address_data.city : "",
    state = typeof address_data.state != "undefined" ? address_data.state : "",
    country = typeof address_data.country != "undefined" ? address_data.country : "";
    if($.inArray(locationData.class, [ "highway", "place"]) > -1){
      short_address = road+" "+house_number+" "+postcode+" "+city+" "+state+" "+country;
    } else { //building, shop
      short_address = I18n.t("map.messages.cannot_parse");//"can not parse the address, insert it manually";
    }
    addressPlaceholderInTheForm.val(short_address);
    if (ifPlaceMarker) {
      var lon = locationData.lon,
          lat = locationData.lat;
      placeMarker(lat, lon, locationData.display_name, ZOOMONMARKERLEVEL, false);
    }
  },
  setMarkerListener = function(){
    posMarker.on('dragend', function (e) {
      var
      coords = e.target.getLatLng();
      posLat= coords.lat;
      posLon = coords.lng,
      dataToSend = {
        format: 'json',
        q: "["+posLat +","+ posLon +"]",
        polygon: 0,
        addressdetails: 1
      };
      ajaxCallOSM(geocodingUrl, dataToSend, function(response){
        handleLocation(response[0], false);
        displayAddress(response[0].display_name);
      });
    });
  },
  displayAddress = function(address){
    addressResultsPlaceholder.html("<div>"+I18n.t("map.messages.drag_marker")+"</div>"+
                                    "<div style='color: #999'>"+address+"</div>");
    //TODO: add info about dragging
    newPosAddress = address;
  };
  return{
    initMap: initMap,
    //getOSMAddress: getOSMAddress,
    setLocationSearchPlaceholders: setLocationSearchPlaceholders,
    handleLocation: handleLocation,
    locateUser: locateUser
  }
}
