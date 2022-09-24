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
			title  = "initPusher should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					mockSettings = {
						"pusher" : {
							"key"       : "abcdefg",
							"cluster"   : "us2",
							"appId"     : "1234567",
							"apiSecret" : "sjdgfoeswgbofhgrp"
						}
					};

					scribe = createMock( object = getInstance( "Pusher@cfscribe" ) );
				} );
				it( "Application should have the key 'pusher'", function(){
					application.pusher = "";
					testme             = scribe.initPusher();
					expect( application ).tohavekey( "pusher" );
				} );
				/*it( "application.pusher be of type com.pusher.rest.Pusher", function(){
					application.pusher = "";
					testme             = scribe.initPusher();
					expect( getMetadata( application.pusher ).name ).tobe( "com.pusher.rest.Pusher" );
				} );*/
			}
		);
	}

}
