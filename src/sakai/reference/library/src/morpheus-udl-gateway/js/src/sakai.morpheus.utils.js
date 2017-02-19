/**
 * Miscellaneous Utils
 */

function f_scrollTop(){
    // Mantengo la función porque es llamada por el velocity
}

function f_filterResults(n_win, n_docel, n_body){
    var n_result = n_win ? n_win : 0;
    if (n_docel && (!n_result || (n_result > n_docel))) 
        n_result = n_docel;
    return n_body && (!n_result || (n_result > n_body)) ? n_body : n_result;
}

$PBJQ(document).ready(function(){
	$PBJQ('input, textarea', '#content').each( function(){
		if( $PBJQ(this).prop('disabled') ){
			$PBJQ(this).parent('label').addClass('disabled');
		}
	});
	
// SAK-29494: Escape key maps to keycode `27`
	$PBJQ(document).keyup(function(e) {
		if (e.keyCode == 27) {
			
			//Close More Sites
			if (!$PBJQ('#selectSiteModal').hasClass('outscreen') ){
				$PBJQ('#otherSitesMenu .otherSitesMenuClose').trigger('click');
			}
			
			//Close DirectUrl dialogs
			$PBJQ('.Mrphs-directUrl__dropDown').each(function(){
				if($PBJQ(this).hasClass('active')){
					$PBJQ(this).find('.dropDown_close').trigger('click');
				}
			});
			
			//Close Icon Selector in customization of Web Contents
			$PBJQ('.fip-icon-up-dir').trigger('click');				
			
			//Close All sites dialog in Resources
			$PBJQ('.navigatePanelControls .close').trigger('click');
		}
	});
});

smoothScroll.init();