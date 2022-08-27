/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" accessors="true" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/


	function run(){
		describe(
			title  = "Sysout should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe               = createmock( object = getInstance( "scribeConsole@cfscribe" ) );
					calcTableWidthReturn = randRange( 50, 100 );
					scribe.$( method = "calcTableWidth", returns = calcTableWidthReturn );
					scribe.$( method = "headerLine", returns = [] );
					scribe.$( method = "labelledLine", returns = [] );
					scribe.$( method = "writeToConsole", returns = [] );
					scribe.$( method = "writeSysOutTagContext", returns = [] );
					message  = " **************** yoyo *************************** ";
					severity = "warn";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = { message : message },
						severity  = severity
					);
				} );
				it( "If the extraInfo is empty, run writeToConsole 1x", function(){
					scribe.$( method = "extraInfoEmpty", returns = true );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = {},
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 1 );
				} );
				it( "If the extraInfo is empty, should run calcTableWidth 0x", function(){
					scribe.$( method = "extraInfoEmpty", returns = true );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = {},
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "calcTableWidth" ) ).tobe( 0 );
				} );
				it( "If the extraInfo is Not empty, should run calcTableWidth 1x", function(){
					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = { message : message },
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "calcTableWidth" ) ).tobe( 1 );
				} );
				it( "if the extraInfo is not empty, should run headerLine 1x", function(){
					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = { message : message },
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "headerLine" ) ).tobe( 1 );
				} );
				it( "Should run labelledLine 1x for the logevent.message", function(){
					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = {},
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "labelledLine" ) ).tobe( 1 );
				} );
				it( "If writing a struct, it should call writeToConsole 4x minimum", function(){
					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = {},
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 4 );
				} );
				it( "If writing a struct, it should write to writeToConsole 1x per property that is not tagContext or stackTrace", function(){
					fakeStr = { "a" : "fgdfg", "b" : "xdfdfsgdf" };

					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = fakeStr,
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 4 + fakeStr.keyArray().len() );
				} );
				it( "If writing a struct with a tag context it should run headerLine 1x additional, writetoConsole 1x additional and writeSysOutTagContext 1x", function(){
					fakeStr = { "tagContext" : [ "dfsgdfg" ] };

					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = fakeStr,
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 4 + fakeStr.tagContext.len() );
					expect( scribe.$count( "headerLine" ) ).tobe( 2 );
					expect( scribe.$count( "writeSysOutTagContext" ) ).tobe( 1 );
				} );
				it( "If writing a struct with a stackTrace it should run headerLine 1x additional, writetoConsole 1x additional and writetoConsole 1x additional per line", function(){
					fakeStr = { "stackTrace" : [ "dfsgdfg", "dsfg", "dfgdfg" ] };

					scribe.$( method = "extraInfoEmpty", returns = false );
					var logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = fakeStr,
						severity  = severity
					);
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 4 + 1 + fakeStr.stackTrace.len() );
					expect( scribe.$count( "headerLine" ) ).tobe( 2 );
				} );
			}
		);
	}

}
