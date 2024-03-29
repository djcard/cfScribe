component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="coldbox" inject="coldbox";
	property name="cfmlEngine" default="";
	property name="environment" inject="coldbox:setting:environment";

	function init( string name = "scribeConsole", struct properties = {} ){
		if ( !getCfmlEngine().len() ) {
			setCfmlEngine( application.cbController.getCFMLEngine().getEngine() );
		}
		super.init( name );
		return this;
	}

	function onDiComplete(){
		setCfmlEngine( getColdBox().getCFMLEngine().getEngine() );
		return this;
	}

	/**
	 * Handles outputting the error to the systemOutput in a formatted table
	 *
	 * @logEvent an instance of coldbox.system.logging.LogEvent
	 **/
	void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		if ( extraInfoEmpty( logEvent.getExtraInfo() ) ) {
			writeToConsole( [
				dateTimeFormat( logevent.getTimeStamp(), "yyyy-mm-dd HH:nn:ss" ) & " | " & arguments.logEvent.getMessage()
			] );
		} else {
			try {
				var finalErr = logEvent.getExtraInfo();

				var contentWidth = calcTableWidth( logEvent );
				var labelWidth   = 20;
				var totalWidth   = contentWidth + labelWidth;
				var rowLine      = "|" & charSpacing( "-", contentWidth + labelWidth - 2 ) & "|";

				writeToConsole( headerLine( "Error Dump", contentWidth + labelWidth ) );
				writeToConsole(
					labelledLine(
						"Message",
						labelWidth,
						arguments.logEvent.getMessage(),
						totalWidth + 1
					)
				);
				writeToConsole( [ rowLine ] );

				finalErr.each( function( item ){
					if ( item.lcase() == "tagcontext" ) {
						writeToConsole( headerLine( "Tag Context", contentWidth + labelWidth ) );
						finalErr[ "tagContext" ].each( function( line ){
							writeSysOutTagContext( line, labelWidth, totalWidth );
						} );
					} else if ( item.lcase() == "stacktrace" ) {
						writeToConsole( headerLine( "Stack Trace", contentWidth + labelWidth ) );
						finalErr[ "stackTrace" ].each( function( line ){
							writeToConsole( [
								line,
								charSpacing( "-", contentWidth + labelWidth )
							] );
						} );
					} else if ( item.lcase() == "sql" ) {
						writeToConsole( headerLine( "SQL", contentWidth + labelWidth ) );
						for ( var x = 0; x <= ceiling( finalErr[ "sql" ].len() / totalWidth ); x = x + 1 ) {
							var startNumber = ( ( totalWidth * x ) - ( 2 * x ) + 1 );
							writeToConsole(
								headerLine( finalErr[ "sql" ].mid( startNumber, totalWidth - 2 ), totalWidth )
							);
						}
					} else {
						if (
							isStruct( finalErr ) &&
							finalErr.keyExists( item )
						) {
							writeToConsole(
								labelledLine(
									item,
									labelWidth,
									finalErr[ item ],
									totalWidth + 1
								)
							);
						}
					}
				} );
				writeToConsole( [ rowLine ] );
			} catch ( arny err ) {
				writeDump( err );
				abort;
			}
		}
	}


	/***
	 * Determines if the submitted struct is empty or not
	 *
	 * @extraInfo the stuct to determine if empty
	 **/
	function extraInfoEmpty( required any extraInfo ){
		var skipFields = [ "message", "filterClass" ];
		if ( isSimpleValue( arguments.extraInfo ) ) {
			return true;
		} else if ( isStruct( arguments.extraInfo ) ){
				if(arguments.extraInfo.keyArray().len() == 0 ) {
					return true;
				} else {
					systemOutput("It is a struct but not empty");
					return false;
				}
		} else if ( isArray( arguments.extraInfo ) ) {
			return true;
		} else {
			var summer = arguments.extraInfo
				.keyArray()
				.reduce( function( sum, item ){
					var additive = !isSimpleValue( extraInfo[ item ] ) ? 1 : toString( extraInfo[ item ] ).len();

					return skipFields.findnocase( item ) > 0 ? sum : sum + additive;
				}, 0 );

			return summer == 0;
		}
	}

	/**
	 * Handles the formatting for the tagContext portion of the error. Currently outputs the template, line and codePlainPrint keys
	 *
	 * @line       The text to be displayed
	 * @labelWidth The width of the label cell
	 * @totalWidth The total width of the display (whole table)
	 **/
	void function writeSysOutTagContext(
		any line,
		required numeric labelWidth,
		required numeric totalWidth
	){
		if ( isSimpleValue( arguments.line ) ) {
			writeToConsole( headerLine( arguments.line, arguments.totalWidth + 1 ) );
		} else if ( isStruct( arguments.line ) ) {
			if ( arguments.line.keyExists( "template" ) ) {
				writeToConsole(
					labelledLine(
						"Template",
						arguments.labelWidth,
						arguments.line.template,
						arguments.totalWidth + 1
					)
				);
			};
			if ( arguments.line.keyExists( "line" ) ) {
				writeToConsole(
					labelledLine(
						"Line",
						arguments.labelWidth,
						arguments.line.line.toString().listFirst( "." ),
						arguments.totalWidth + 1
					)
				);
			};
			if ( arguments.line.keyExists( "codePrintPlain" ) ) {
				arguments.line.codePrintPlain
					.listToArray( chr( 10 ) )
					.each( function( codeline, idx ){
						writeToConsole(
							labelledLine(
								idx == 1 ? "codePrint" : "",
								labelWidth,
								arguments.codeLine.replace( chr( 9 ), "", "all" ),
								totalWidth + 1
							)
						);
					} );
			}
			writeToConsole( [ "|" & charSpacing( ".", arguments.totalWidth - 2 ) & "|" ] );
		}
	}

	/**
	 * Used by sysOut to display a section header for the display in the console
	 *
	 * @message The text of the header which will be centered
	 * @width   The width of the total display. This has typically been calculated by the calcTableWidth method based on the length of the messages to be displayed.
	 * @offset  The number of other characters besides the text, to be taken into consideration (i.e. vertical lines on the outside of the display to mimic a table
	 **/
	array function headerLine(
		required string message,
		required numeric width,
		numeric offset = 2
	){
		var totalSpace = width - 2 - message.len();
		var spacing    = floor( totalSpace / 2 );

		return [
			"|" & charSpacing( "-", arguments.width - 2 ) & "|",
			"|" & charSpacing( " ", spacing ) & message & charSpacing( " ", spacing + ( totalSpace mod 2 ) ) & "|",
			"|" & charSpacing( "-", arguments.width - 2 ) & "|"
		];
	}


	/**
	 * Writes to the console using systemOutput (lucee) or dump(output='console') (Adobe)
	 *
	 **/
	void function writeToConsole( required array content ){
		content.each( function( item ){
			if ( CfmlEngine eq "lucee" ) {
				systemOutput( item );
			} else {
				writeDump( var = item, output = "console" );
			};
		} );
	}

	/**
	 * returns a array with len of 1 which is split into two "cells" the label and the actual message. Meant to help simulate a table in the sysOutput
	 *
	 * @label        - The text of the label
	 * @labelWidth   - The width of the label "cell"
	 * @message      - The content of the second cell
	 * @messageWidth - The width of the second cell
	 **/
	array function labelledLine( label, labelWidth, message, totalWidth ){
		var messageWidth = arguments.totalWidth - arguments.labelWidth;
		return (
			isSimpleValue( message )
			 ? [
				"| "
				& label & charSpacing( " ", arguments.labelWidth - label.len() - 2 )
				& "| "
				& message.toString() & charSpacing( " ", messageWidth - message.toString().len() - 3 )
				& "|"
			]
			 : []
		);
	}

	/**
	 * Calculates the required width of the sysout display based on the length of the submitted message, error message and the tagcontext content
	 *
	 * @logEvent a populated instance of coldbox.system.logging.LogEvent
	 **/
	numeric function calcTableWidth( required coldbox.system.logging.LogEvent logEvent ){
		var length = logEvent.getmessage().len();
		length     = isSimpleValue( arguments.logEvent.getextraInfo() )
		 ? arguments.logEvent.getextraInfo().len()
		 : isStruct( arguments.logEvent.getextraInfo() )
		 ? arguments.logEvent.getextraInfo().keyExists( "message" ) && arguments.logEvent
			.getextraInfo()
			.message
			.len() > length
		 ? arguments.logEvent.getextraInfo().message.len()
		 : length
		 : length;

		if (
			isStruct( arguments.logEvent.getextraInfo() ) &&
			arguments.logEvent.getExtraInfo().keyExists( "tagContext" ) &&
			isArray( arguments.logEvent.getExtraInfo().tagContext )
		) {
			arguments.logEvent
				.getExtraInfo()
				.tagContext
				.each( function( item ){
					length = item.keyExists( "template" ) && item.template.len() > length ? item.template.len() : length;
					if ( item.keyExists( "codePrintPlain" ) ) {
						item.codePrintPlain
							.listToArray( chr( 10 ) )
							.each( function( codeLine ){
								length = codeLine.len() > length ? codeline.len() : length;
							} );
					}
				} );
		};
		if (
			isStruct( arguments.logEvent.getextraInfo() ) &&
			arguments.logEvent.getExtraInfo().keyExists( "sql" )
		) {
			length = arguments.logEvent.getExtraInfo().sql.len() < length ? arguments.logEvent
				.getExtraInfo()
				.sql
				.len() : 80;
		}
		return length;
	}

	/***
	 * Returns a string consisting the submitted number of the submitted characters
	 *
	 * @char The character to return
	 * @num  How many of the submitted character to return
	 **/
	function charSpacing( required string char, required numeric num ){
		var retme = "";
		for ( var x = 1; x <= arguments.num; x = x + 1 ) {
			retme = retme & char;
		};
		return retme;
	}

}
