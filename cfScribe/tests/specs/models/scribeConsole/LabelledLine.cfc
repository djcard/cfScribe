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
			title  = "LabelledLine should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe     = getInstance( "scribeConsole@cfscribe" );
					labelWidth = 15;
					label      = mockData( $num = 1, $type = "words:1" )[ 1 ];
					message    = mockData( $num = 1, $type = "words:5" )[ 1 ];
					width      = randRange( 50, 80 );
				} );
				it( "The entire width should be the submitted totalWidth", function(){
					testme = scribe.labelledLine( label, labelWidth, message, width );
					expect( testme[ 1 ].len() ).tobe( width );
				} );
				it( "There should be | at the first, last and labelwidth position", function(){
					testme = scribe.labelledLine( label, labelWidth, message, width );

					expect( testme[ 1 ].left( 1 ) ).tobe( "|" );
					expect( testme[ 1 ].right( 1 ) ).tobe( "|" );
					expect( testme[ 1 ].mid( labelWidth, 1 ) ).tobe( "|" );
				} );
			}
		);
	}

}
