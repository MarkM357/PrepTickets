#= require md5
#= require easyXDM
#= require ender
#= require_self

throw "Can't use jQuery plugin without BWL module loaded" unless BWL?
BWL.$ = BWL.jQuery = window.jQuery = jQuery.noConflict(true);
