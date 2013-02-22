/*!
 * jQuery cryptoSeed
 * Original author: Andy Shora, @andyshora
 * Licensed under the MIT license
 */

;(function ( $, window, document, undefined ) {

    // defaults
    var cryptoSeed = 'cryptoSeed',
        defaults = {
            format: "bytes",
			length: 8,
			output: '#key',
			byteValueCallback: null
        };

    // plugin constructor
    function CryptoSeed( element, options ) {
        this.element = element;

        this.options = $.extend( {}, defaults, options) ;

        this._defaults = defaults;
        this._name = cryptoSeed;
		this.output = $(this.options.output)[0];
		this.arr = [];
		var _self = this;
		
		// init array
		for (var i=0; i<this.options.length; i++)
			this.arr.push(i);
			
		this.output.value = this.arr.join(',');
		
		$(this.element).mousemove(function(event) {
			
			var n = Math.floor(Math.random()*_self.arr.length);
			var n2 = Math.floor(Math.random()*_self.arr.length);
			var n3 = Math.floor(Math.random()*_self.arr.length);
			
			
			// these are not the current values at the indexes above, but random values in the array
			var c = _self.arr[Math.floor(Math.random()*_self.arr.length)];
			var c2 = _self.arr[Math.floor(Math.random()*_self.arr.length)];
			var c3 = _self.arr[Math.floor(Math.random()*_self.arr.length)];

			_self.arr[n] = _self.alter(c, event.pageX, event.pageY);
			_self.arr[n2] = _self.alter(c2, event.pageX + 13, event.pageY - 13);
			_self.arr[n3] = _self.alter(c3, event.pageX + 101, event.pageY - 101);

			// temp - should be seperated into callbacks
			if ((typeof _self.options.byteValueCallback === 'function') || (typeof _self.options.byteValueCallback === 'object')) {
				_self.options.byteValueCallback(_self.arr[n]);
				_self.options.byteValueCallback(_self.arr[n2]);
				_self.options.byteValueCallback(_self.arr[n3]);
			}
			
			
			_self.output.value = _self.arr.join(',');
			
			// TODO - make box turn from red to green to signal enough randomness
			
		});

        
    }

	CryptoSeed.prototype.alter = function (current, x, y) {
		
		var b = (Math.random() < 0.5) ? (2*x*y) : x*y;
		var c = (Math.random() < 0.5) ? -(x+y) : x+y;
		var d = (Math.random() < 0.5) ? y*1.0/x : y*1.41/x;
		
    // modified this line (reduced value from 255 to 60) - ugly?
		var a = (current == 0) ? ((b/d) + c) % 60 : ((current * (b/d)) + c) % 60;	
		return Math.round(a);
    };

	CryptoSeed.prototype.getRandByte = function () {
        return Math.floor(Math.random()*256);
    };
	

    // A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
    $.fn[cryptoSeed] = function ( options ) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + cryptoSeed)) {
                $.data(this, 'plugin_' + cryptoSeed,
                new CryptoSeed( this, options ));
            }
        });
    }

})( jQuery, window, document );