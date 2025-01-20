component extends="org.lucee.cfml.test.LuceeTestCase" labels="markdown" {

	function run( testResults, testBox ){
		describe( title="Testcase for markdownToHTML() safeMode", body=function() {
			
			it( title = "Checking markdownToHTML safeMode=false", body=function( currentSpec ) {
				var md = [
					"<b>safeMode</b>"
				].toList( chr( 10 ) );
				var html = markdownToHtml( md, false );
				expect( html ).toInclude( "<b>safeMode</b>" );
			});

			it( title = "Checking markdownToHTML safeMode=true", body=function( currentSpec ) {
				var md = [
					"<span>safeMode</span>"
				].toList( chr( 10 ) );
				var html = markdownToHtml( md, true );
				expect( html ).toInclude( "&lt;span&gt;safeMode&lt;/span&gt;" );
			});

		});
	}

}