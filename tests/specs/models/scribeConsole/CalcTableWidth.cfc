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
		// super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/


	function run(){
		describe(
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe    = getInstance( "scribeConsole@cfscribe" );
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity = "WARN";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);
				} );
				it( "If there is only a message sent, return the length of that message", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {};
					severity  = "WARN";
					logEvent  = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getMessage().len() );
				} );
				it( "If there is a message in the extrainfo but it is shorter than the message key, return the length of the message key", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = { "message" : "" };
					severity  = "WARN";
					logEvent  = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getMessage().len() );
				} );
				it( "If there is a message in the extrainfo and  it is longer than the message key, return the length of the extrainfo message key", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = { "message" : "#message# #mockData( $type = "words:2", $num = 1 )[ 1 ]#" };
					severity  = "WARN";
					logEvent  = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getExtrainfo().Message.len() );
				} );
				it( "If there is a tag context but all template lengths are shorter, use the longer of the message or extrainfo.message", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						"message"    : "#message# #mockData( $type = "words:2", $num = 1 )[ 1 ]#",
						"taxcontext" : [
							{ "template" : "" },
							{ "template" : "" },
							{ "template" : "" }
						]
					};
					severity = "WARN";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getExtrainfo().Message.len() );
				} );
				it( "If there is a tag context and if one template is longer, use that length", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						"message"    : "#message# #mockData( $type = "words:2", $num = 1 )[ 1 ]#",
						"tagcontext" : [
							{ "template" : "#message# #message#" },
							{ "template" : "" },
							{ "template" : "" }
						]
					};
					severity = "WARN";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getExtrainfo().tagcontext[ 1 ].template.len() );
				} );
				it( "If there is a tag context and if one template is longer, use that length test 2", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						"message"    : "#message# #mockData( $type = "words:2", $num = 1 )[ 1 ]#",
						"tagcontext" : [
							{ "template" : "#message# #message#" },
							{ "template" : "" },
							{ "template" : "#message# #message# #message#" }
						]
					};
					severity = "WARN";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( logevent.getExtrainfo().tagcontext[ 3 ].template.len() );
				} );
				it( "If there is a tag context check the codePrintPlain lines (split on line endings) for the longest", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						"message"    : "#message# #mockData( $type = "words:2", $num = 1 )[ 1 ]#",
						"tagcontext" : [
							{
								"template"       : "#message# #message#",
								"codePrintPlain" : "#message# #message# #message# #message# #chr( 10 )# #message# #message# #message#"
							},
							{ "template" : "" },
							{ "template" : "#message# #message# #message#" }
						]
					};
					severity = "WARN";
					logEvent = new coldbox.system.logging.LogEvent(
						message   = message,
						extraInfo = extraInfo,
						severity  = severity
					);

					testme = scribe.calcTableWidth( logevent );
					expect( testme ).tobe( ( message.len() * 4 ) + 4 );
				} );
			}
		);
	}

}
