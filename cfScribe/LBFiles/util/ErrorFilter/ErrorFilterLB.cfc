/**
 * A extendable module to filter the contents of an error message
 *
 **/
component accessors="true" {

	property name="typeFields"          default="";
	property name="tagContextLines"     default="";
	property name="tagContextFields"    default="";
	property name="errorClasses"        default="";
	property name="filterPhrases"       default="";
	property name="removeAllBlankLines" default="";

/***
* Initiates the component and populates the variables
*
* @properties Structure with keys corresponding with the properties. See moduleConfig.cfc for sample properties
**/
	function init(required struct properties = {} ){
		properties
			.keyArray()
			.each( function( item ){
				variables[ item ] = properties[ item ];
			} );

		return this;
	}

	/**
	 * The main method of the module. Returns the cleaned error for display
	 *
	 * @error The error to be filtered
	 **/
	function run( required error ){
		var processClassName = obtainProcessClass( error );
		var retme = {};
		try {
			retme = createProcessClass(processClassName).doClean( error );
		} catch ( any err ) {
			systemOutput( "ERROR 38" );
			systemOutPut(err.message);
		};
		return retme;
	}

	/***
	*Instantiates the processsClass from the package passed in. Pulled out for testing,
	*
	*@className The package name of the class to instantiate.
	**/
	function createProcessClass(className){
		return new "#processClassName#"({
			typeFields: variables.typeFields,
			tagContextLines: variables.tagContextLines,
			tagContextFields: variables.tagContextFields,
			errorClasses: variables.errorClasses,
			filterPhrases: variables.filterPhrases,
			removeAllBlankLines: variables.removeAllBlankLines
		} )
	}

	/**
	 * Tries to determine which class to use to filter the error based on the type key
	 *
	 * @error The error to be typed
	 **/
	function obtainProcessClass( required error ){
		return error.keyExists( "type" ) && geterrorClasses().keyExists( error.type )
		 ? getErrorClasses()[ error.type ]
		 : getErrorClasses()[ "any" ];
	}

	/**
	 * Attempts to use the tagContext key to return the template and line number
	 *
	 * @tagContext The array of structs corresponding to the tagContext key in the error
	 */
	function addLine( required array tagContext ){
		var returnLine = tagContext.len() && isStruct( tagContext[ 1 ] ) && tagContext[ 1 ].keyExists( "template" ) ? tagContext[
			1
		].template : "";
		return returnline.len() && tagContext[ 1 ].keyExists( "line" ) ? returnLine & " ( " & tagContext[ 1 ].line & " )" : returnLine;
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
			if ( error.keyExists( trim( item ) ) ) {
				if (
					getRemoveAllBlankLines() && isSimpleValue( error[ trim( item ) ] ) && trim(
						toString( error[ trim( item ) ] )
					).len() == 0
				) {
				} else {
					retme[ trim( item ) ] = error[ trim( item ) ];
				}
			}
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

	/***
	*Filters and trims the TagContext
	*
	* @tagContext The Tatg Context array from an error
	**/
	function trimAndFilterTagContext( required array tagContext ){
		return trimTagContext( filterTagContext( arguments.tagContext ) );
	}

	/***
	*Converts the stackTrace to an array split on ##chr( 9 )##at
	*
	*@stackTrace The stacktrace from the error
	**/
	function trimAndFilterStackTrace( required string stackTrace ){
		return stackTrace.listToArray( delimiters = "#chr( 9 )#at ", multiCharacterDelimiter = true );
	}

	/***
	 * Process the error through it's default workings
	 *
	 * @err  The passed in error
	 * @type The type of error
	 **/
	function doClean( required any err, required string type ){
		var retme = addKeys( type, err );

		if ( retme.keyExists( "tagContext" ) && arguments.err.keyExists( "tagContext" ) ) {
			retme[ "tagContext" ] = trimAndFilterTagContext( arguments.err.tagContext );
		}
		if ( retme.keyExists( "StackTrace" ) && arguments.err.keyExists( "StackTrace" ) ) {
			retme[ "StackTrace" ] = trimAndFilterStackTrace( arguments.err.StackTrace );
		}
		retme[ "filterClass" ] = getMetadata( this ).name;

		return retme;
	}

}
