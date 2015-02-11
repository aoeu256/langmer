var dicts = {'heisig':true, 'kanjidic':false, 'KIC':false};
var options = {'Enable-Keys':true};
for(var k in dicts) {
	options['Enable-'+k] = dicts[k];
}

$(document).ready(function() {
	
	for(var i=0; i<options.length; i++) {
		var store = localStorage['wsap-'+options[i]] || chrome.extension.getBackgroundPage().Main.options[options[i]];
	
		if(store == 'true' || store == 'false') {
			var elt = $('<input type="checkbox" checked="'+store+'" name="'+options[i]+'"/>');
			elt.appendto('#options');
		} else
			alert('not allowed');
			//document.optform[k].value = JSON.parse(store);
	}
});

function formv(k) {
	return $('#input[name="'+k+'"]').value;
}

$('#submit').click(function() {
	main = chrome.extension.getBackgroundPage().Main;
	for(var k in options)
		localStorage['wsap-'+k] = main.options[k] = formv(k);
});