component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="cleanErrors"      default="false";
	property name="typeFields"       default="";
	property name="tagContextLines"  default="10";
	property name="tagContextFields" default="codePrintPlain,line,template";
	property name="errorClasses"     default="";
	property name="filterPhrases"    default="";
	property name="environment" inject="coldbox:setting:environment";

	// Place your content here
	function cleanError( type = "general", err ){
		var retme = addKeys( type, err );
		if ( retme.keyExists( "tagContext" ) && arguments.err.keyExists( "tagContext" ) ) {
			retme[ "tagContext" ] = trimAndFilterTagContext( arguments.err.tagContext );
		}

		if ( retme.keyExists( "StackTrace" ) && arguments.err.keyExists( "StackTrace" ) ) {
			retme[ "StackTrace" ] = trimAndFilterStackTrace( arguments.err.StackTrace );
		}

		return retme;
	}

	/**
	 * Adds the default fields for the error type to a structure to be returned
	 *
	 * @type The
	 **/
	function addKeys( required string type, required error ){
		var retme     = {};
		var fieldList = gettypeFields().keyExists( arguments.type ) ? gettypeFields()[ arguments.type ].listToArray() : [];
		fieldList.each( function( item ){
			retme[ trim( item ) ] = error.keyExists( trim( item ) ) ? error[ trim( item ) ] : "NA";
		} );
		return retme;
	}


	/**
	 * Filters out elements of the tagContext based on search strings defined in the moduleConfig
	 *
	 * @tagContext
	 **/
	function filterTagContext( required array tagContext = [] ){
		return arguments.tagcontext.filter( function( e ){
			var findings = getfilterPhrases().map( function( item ){
				return e.template.replace( "\", "/", "all" ).findNoCase( item );
			} );

			return findings.sum() == 0;
		} );
	}

	/**
	 * Trims the tagContext array of structs to the limit defined in the moduleSettings tagContextLines property
	 * Each tagContext item will include the fields in the moduleSettings.tagContextFields property
	 *
	 * @tagContext - The array of structs corresponding to the tag context. Note: Should have already passed through filterTagContext()
	 */

	function trimTagContext( required array tagContext = [] ){
		return tagContext.len()
		 ? tagContext
			.slice(
				1,
				( arguments.tagContext.len() >= gettagContextLines() ) ? gettagContextLines() : arguments.tagContext.len()
			)
			.map( function( e ){
				var retme = {};
				gettagContextFields().each( function( item ){
					retme[ item ] = e.keyExists( item ) ? e[ item ] : "";
				} );
				return retme;
			} )
		 : [];
	}

	function trimAndFilterTagContext( required array tagContext ){
		return trimTagContext( filterTagContext( arguments.tagContext ) );
	}

	function trimAndFilterStackTrace( required string stackTrace ){
		return stackTrace.listToArray( delimiters = "#chr( 9 )#at ", multiCharacterDelimiter = true );
		//    return trimTagContext( filterTagContext( arguments.tagContext ) );
	}

	void function doDump( required any item ){
		writeDump( item );
	}
	void function doAbort(){
		abort;
	}

}
