function ProfileMap(){
    var map,
        ajaxRequest,
        pos,
        plotlayers=[],
        initProfileMap = function(lat, lon, zoomLevel, placeHolderName){
            var options = {center : new L.LatLng(lat, lon), zoom : zoomLevel };    
            var osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                osmAttribution = 'Map data &copy; 2012 OpenStreetMap contributors',
                osm = new L.TileLayer(osmUrl, {maxZoom: 18, attribution: osmAttribution});    
            var mapLayer = new L.TileLayer(osmUrl);    
            this.map = new L.Map(placeHolderName, options).addLayer(mapLayer);
            map.on('locationfound', onLocationFound);
            map.on('locationerror', onLocationError);
        },
        markerIcon = L.icon({
            iconUrl: shopTypeIconImageLocation+shopTypeIconImageUrlDefault,
            iconSize:     [24, 40], // size of the icon
            shadowSize:   [50, 64], // size of the shadow
            iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
            shadowAnchor: [4, 62],  // the same for the shadow
            popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
        }),
        onLocationFound = function (e) {
            var marker = new L.Marker(e.latlng);
            map.addLayer(marker);
        },
        onLocationError = function(e) {
            console.log(e.message);
        },
        loadMarker = function(data){
            var shopTypeId = data.shopTypeId;
            markerIcon.options.iconUrl = shopTypeIconImageLocation+shopTypeIconImageUrls[shopTypeId];
            var latlon = new L.LatLng(data.lat,data.lon, true);
            var marker = new L.Marker(latlon, {icon: markerIcon});
            marker.data=data;
            map.addLayer(marker);
            // bindListeners(marker);
            plotlayers.push(marker);
        };
         return{
            initProfileMap:initProfileMap,
            loadMarker:loadMarker
         }   
}

