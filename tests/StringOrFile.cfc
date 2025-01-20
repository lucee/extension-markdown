component extends="org.lucee.cfml.test.LuceeTestCase" labels="markdown" {

	function run( testResults, testBox ){
		describe( title="Testcase for markdownToHTML() source", body=function() {
			
			it( title = "Checking markdownToHTML from string", body=function( currentSpec ) {
				var md = [
					"<b>string</b>"
				].toList( chr( 10 ) );
				var html = markdownToHtml( md );
				expect( html ).toInclude( "<b>string</b>" );
			});

			xit( title = "Checking markdownToHTML from file", body=function( currentSpec ) {
				var md = [
					"***file***"
				];
				var file = getTempFile(getTempDirectory(), "markdown", "md");
				FileWrite(file, md.toList( chr( 10 ) ))
				var html = markdownToHtml( file );
				expect( html ).toInclude( "<strong>file</strong>" );
			});

			xit( title = "Checking markdownToHTML from resource", body=function( currentSpec ) {
				var md = [
					"_resource_"
				];
				var file = getTempFile(getTempDirectory(), "markdown", "md");
				FileWrite(file, md.toList( chr( 10 ) ))
				var html = markdownToHtml( FileOpen(file).toResource() );
				expect( html ).toInclude( "<em>resource</em>" );
			});

			xit( title = "Checking markdownToHTML from missing file", body=function( currentSpec ) {
				var md = [
					"<span>404 file</span>"
				];
				var file = getTempFile(getTempDirectory(), "markdown", "md");
				expect(function(){
					var html = markdownToHtml( file & "_missing" );
					systemOutput(html, true);
				}).toThrow();
			});

			it( title = "Checking markdownToHTML with invalid source type (array)", body=function( currentSpec ) {
				var md = [
					"<span>file</span>"
				];
				expect(function(){
					markdownToHtml( md );
				}).toThrow( "application", "", "complex object" );
			});

		});
	}

}