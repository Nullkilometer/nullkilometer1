$(function(){
	//TODO: only if point of sales/interests and not market stall
	var parameters = window.location.pathname;
	if (parameters.toLowerCase().indexOf("point_of_sales") >= 0 || parameters.toLowerCase().indexOf("point_of_production") < 0)
	{
		//$("#formPosMap").show();
		form = new Form();
		form.initializeMap(parameters);
		form.setFormListeners();
		form.setValidator(new FormValidator());
	}
});

var Form = function(){
	var
	map = new FormMap(),
	mapPlaceholderId = 'formPosMap',
	buttonSelector = $('#addressLookupContainer #locationSubmit'),
  inputSelector = $('#addressLookupContainer #locationInput'),
  addressPlaceholderInTheForm = $('#point_of_sale_address'),
  addressResultsPlaceholder =  $('#locationSearchResults'),
  TEXT_ADDRESS_SELECTION = I18n.t("map.messages.select_one_address"),

  initializeMap = function(parameters){
  	var isEditMode = (parameters.toLowerCase().indexOf("edit") >= 0) ? true : false;
  	if (isEditMode) { //IF EDIT - get coordinates of the pos
			var
			posId = parameters.split('/')[parameters.split('/').length-2].split('.')[0],
			onSuccessReadPosInformation = function(response){
	        var posInformation = response.string;
	        map.initMap(posInformation.lat, posInformation.lon, posInformation.address, ZOOMONMARKERLEVEL-3, mapPlaceholderId);
	    };
			callAjax("/point_of_sales/"+posId, null, onSuccessReadPosInformation);
		}
		else {
		  map.initMap(getInitialLat(), getInitialLon(), '', 9, mapPlaceholderId);
			map.locateUser(12);
		}

		map.setLocationSearchPlaceholders(addressPlaceholderInTheForm, addressResultsPlaceholder);
	  setLocationSearchListners(buttonSelector, inputSelector, addressResultsPlaceholder, getOSMAddress);
  },
	setFormListeners = function(){

		// if market selected, unhide the button with "continue" option
		// if eating place selected, disable the product categories options
		$("select#point_of_sale_posTypeId").change(function(){
			var selectedPosTypeId = $(this).find("option:selected").val();
			$("#submitButton_continue").addClass("hidden");
			$("#firstStepIndicator").addClass("hidden");


			$("label[name='point_of_sale[productCategoryIds]']").removeClass("grayedOut");
			$(".point_of_sale_productCategoryIds input[name='point_of_sale[productCategoryIds][]']").attr("disabled", false);
			$("#point_of_sale_place_feature_ids_1").attr("disabled", false);
			$("label[for='point_of_sale_place_feature_ids_1'").removeClass("grayedOut");

			if(selectedPosTypeId === "0"){
				$("#submitButton_continue").removeClass("hidden");
				$("#firstStepIndicator").removeClass("hidden");
			} else if (selectedPosTypeId === "5"){ // if eating place selected
					// disable feature repesenting eating place and most of the product categories, except "other"
					$("label[for='point_of_sale_place_feature_ids_1'").addClass("grayedOut");
					$("#point_of_sale_place_feature_ids_1").attr("disabled", true);
					$("#point_of_sale_place_feature_ids_1").prop('checked', false);

					$(".point_of_sale_productCategoryIds input[name='point_of_sale[productCategoryIds][]']").each(function(){
						if(this.value != 9){
							this.disabled=true;
							this.checked=false;
							$("label[for='point_of_sale_productCategoryIds_"+this.value+"']").addClass("grayedOut");
						} else {
							this.checked=true;
						}
					});
			}
		}).change();

		//(Only for edit page) If one of the time values (we take "from") is not empty, the checkbox for the openingDay is selected
		$(".openingDayContainer").find(".point_of_sale_opening_times_from").each(function(){
			var value = $(this).find("select option:selected").val();
			if( value != ""){
				var
				id = $(this).find("label").attr("for"),
				checkboxToCheck = $(this).parent().find(".point_of_sale_opening_times_day input[type='checkbox']#"+id);
//				checkboxToCheck.prop("checked",true).trigger("change"); // does not work!!!!
				checkboxToCheck.prop("checked",true);
				checkboxToCheck.parents().eq(3).removeClass("grayedOut");
				checkboxToCheck.parents().eq(3).find(".point_of_sale_opening_times_from, .point_of_sale_opening_times_to").removeClass("hidden");
			}
		});
		//changing style on OpeningTimes checkbox change
		$(".openingDayContainer input[type='checkbox']").change(function() {
	  	$(this).parents().eq(3).toggleClass("grayedOut");
	  	if (!$(this).parents().eq(3).hasClass("grayedOut")){
	  		$(this).parents().eq(3).find(".point_of_sale_opening_times_from, .point_of_sale_opening_times_to").removeClass("hidden");
	  		$(this).parents().eq(3).find(".error").removeClass("hidden");
	  	} else {
	  		$(this).parents().eq(3).find(".point_of_sale_opening_times_from, .point_of_sale_opening_times_to").addClass("hidden");
	  		$(this).parents().eq(3).find(".error").addClass("hidden");
	  	}
		});

		$(".openingDayContainer .point_of_sale_opening_times_from select").change(function(){
	    var $selected = $(this).find('option:selected');
	    $(this).parents().eq(2).find(".point_of_sale_opening_times_to select")
        .find('option')
        .prop('disabled', true)
        .eq($selected.index())
        .nextAll()
        .prop('disabled', false);
		});

		// setting opening times on monday the first time sets them everywhere
		var alreadyClicked_from = false, alreadyClicked_to = false;
		$("select[name='point_of_sale[opening_times_attributes][0][from]']").change(function(){
			if (!alreadyClicked_from){
				var openingFrom = $(this).val();
				$("select.timeTextInput").each(function(){
					if($(this).prop("name").indexOf('[from]') !== -1 )
						$(this).val(openingFrom);
				});
				alreadyClicked_from = true;
			}
		});
		$("select[name='point_of_sale[opening_times_attributes][0][to]']").change(function(){
			if (!alreadyClicked_to){
				var openingTo = $(this).val();
				$("select.timeTextInput").each(function(){
					if($(this).prop("name").indexOf('[to]') !== -1 )
					    $(this).val(openingTo);
				});
				alreadyClicked_to = true;
			}
		});
		// end

	},
	setValidator = function(formValidator){
		formValidator.addCustomValidateMethods();
		$('#new_point_of_sale').validate(formValidator.validateOptions);
		$('.edit_point_of_sale').validate(formValidator.validateOptions);
	},
	//PRIVATE METHODS
	getOSMAddress = function(data, textStatus, jqXHR){
	  if(data.length > 1){
	    addressResultsPlaceholder.html(TEXT_ADDRESS_SELECTION+'<ul></ul>');
	    var
	    validAddressResultArray = new Array(),
			previousAddress = "";
	    for(var i = 0; i < data.length; i++){
	      //if place's class is NOT in one of the listed
	      if($.inArray(data[i].class, [ "highway", "place", "shop", "building"]) == -1
	        //or if it's type is one of the listed, skip the rest of the block and go to the next address
	        || $.inArray(data[i].type, [ "bus_stop", "platform", "tertiary", "city", "county"]) > -1) continue;
	      validAddressResultArray.push(data[i]);
	      var
	      currentArrayIndex = validAddressResultArray.length -1,
	      detailed_address = data[i].display_name;
	      if(detailed_address != previousAddress){
	        addressResultsPlaceholder.find("ul").append("<li title='"+currentArrayIndex+"'><a href='#' class='ordinaryLink'>"+detailed_address+"</a></li>");
	      }
	      previousAddress = detailed_address;
	    }
	    addressResultsPlaceholder.show();
	    addressResultsPlaceholder.find("li").click(function(){
	      var index = this.title;
	      map.handleLocation(validAddressResultArray[index], true); //ifPlaceMarker set to true
	    });
	  }
	  else if(data.length == 1){
	    console.log("recieved one Search Result from OSM");
	    map.handleLocation(data[0], true);
	  }
	  else {
	    addressResultsPlaceholder.html('<div>'+I18n.t("map.messages.no_results")+'</div>');
	    console.warn("recieved no Search Results from OSM or something went wrong");
	  }
	};
  return {
  	initializeMap: initializeMap,
  	setFormListeners: setFormListeners,
  	setValidator: setValidator
  }
};
